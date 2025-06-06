//
//  UserDetailViewModel.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 6/6/25.
//

import RxSwift
import RxCocoa

class UserDetailViewModel: ViewModel {
    private let userService: UserService
    fileprivate let userDetail = BehaviorRelay<GithubUserDetail?>(value: nil)
    private let navigator: UserDetailNavigator
    
    private let username: String
    
    init(userService: UserService, navigator: UserDetailNavigator, username: String) {
        self.userService = userService
        self.navigator = navigator
        self.username = username
        super.init()
        setupBinding()
    }
    
    private func setupBinding() {
        lifeCycle
            .filter { $0 == .willAppear }
            .take(1)
            .withUnretained(self)
            .flatMapLatest { vm, _ in
                vm.isLoading.accept(true)
                return vm.userService.getUserDetail(username: vm.username)
                    .asObservable()
                    .materialize()
            }
            .subscribe(with: self, onNext: { vm, event in
                vm.isLoading.accept(false)
                
                switch event {
                case .next(let userDetail):
                    vm.userDetail.accept(userDetail)
                case .error(let error):
                    let errorMessage = (error as? APIError)?.message ?? error.localizedDescription
                    vm.errorMessage.accept(errorMessage)
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: Outputs<UserDetailViewModel> {
    var userDetail: Driver<GithubUserDetail?> {
        return base.vm.userDetail.asDriver()
    }
    
    var isLoading: Driver<Bool> {
        return base.vm.isLoading.asDriver()
    }
    
    var errorMessage: Signal<String> {
        return base.vm.errorMessage.asSignal()
    }
}
