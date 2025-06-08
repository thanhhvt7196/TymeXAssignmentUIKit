//
//  UserListViewModel.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 4/6/25.
//

import Foundation
import RxSwift
import RxCocoa

class UserListViewModel: ViewModel {
    private let useCase: UserListUsecase
    private let navigator: UserListNavigator
    
    fileprivate let userList = BehaviorRelay<[GitHubUser]>(value: [])
    fileprivate let selectedUserAction = PublishRelay<GitHubUser>()
    fileprivate let loadMoreTrigger = PublishRelay<Void>()
    fileprivate let refreshTrigger = PublishRelay<Void>()
    
    private var page = 0
    private var itemPerPage = 20
    
    private var isLoadMore = false
    
    init(useCase: UserListUsecase, navigator: UserListNavigator) {
        self.useCase = useCase
        self.navigator = navigator
        super.init()
        setupBinding()
        let cachedData = useCase.getAllUsersFromCache()
        userList.accept(cachedData)
    }
    
    private func setupBinding() {
        refreshTrigger
            .withUnretained(self)
            .flatMapLatest { vm, _ in
                vm.isLoading.accept(true)
                vm.page = 0
                return vm.useCase.fetchUsers(perPage: vm.itemPerPage, since: vm.page)
                    .asObservable()
                    .materialize()
            }
            .subscribe(with: self, onNext: { vm, event in
                vm.isLoading.accept(false)
                
                switch event {
                case .next(let userList):
                    vm.userList.accept(userList)
                    vm.page += 1
                    vm.useCase.cleanCache()
                    vm.useCase.saveCache(users: userList)
                case .error(let error):
                    let errorMessage = (error as? APIError)?.message ?? error.localizedDescription
                    vm.errorMessage.accept(errorMessage)
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        loadMoreTrigger
            .withUnretained(self)
            .filter { vm, _ in
                return !vm.isLoadMore && vm.page > 0
            }
            .flatMapLatest { vm, _ in
                vm.isLoadMore = true
                return vm.useCase.fetchUsers(perPage: vm.itemPerPage, since: vm.page)
                    .catchAndReturn([])
            }
            .subscribe(with: self, onNext: { vm, userList in
                guard !userList.isEmpty else {
                    return
                }
                // github API return some duplicated users, so we need to check if they already existed
                var newUserList = vm.userList.value
                userList.forEach { user in
                    if !newUserList.map({ $0.id }).contains(user.id) {
                        newUserList.append(user)
                    }
                    vm.userList.accept(newUserList)
                }
                vm.isLoadMore = false
                vm.page += 1
            })
            .disposed(by: disposeBag)
        
        selectedUserAction
            .compactMap { $0.login }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { vm, username in
                vm.navigator.showUserDetail(username: username)
            })
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: Inputs<UserListViewModel> {
    var selectedUserAction: AnyObserver<GitHubUser> {
        return base.vm.selectedUserAction.asObserver()
    }
    
    var refreshTrigger: AnyObserver<Void> {
        return base.vm.refreshTrigger.asObserver()
    }
    
    var loadMoreTrigger: AnyObserver<Void> {
        return base.vm.loadMoreTrigger.asObserver()
    }
}

extension Reactive where Base: Outputs<UserListViewModel> {
    var userList: Driver<[GitHubUser]> {
        return base.vm.userList.asDriver()
    }
    
    var isLoading: Driver<Bool> {
        return base.vm.isLoading.asDriver()
    }
    
    var errorMessage: Signal<String> {
        return base.vm.errorMessage.asSignal()
    }
}
