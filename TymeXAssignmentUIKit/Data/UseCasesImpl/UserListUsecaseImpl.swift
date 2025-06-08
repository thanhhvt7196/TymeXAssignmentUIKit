//
//  UserListUsecaseImpl.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//

import RxSwift

struct UserListUsecaseImpl: UserListUsecase {
    private let store: UserStore
    private let service: UserService
    
    init(store: UserStore, service: UserService) {
        self.store = store
        self.service = service
    }
    
    func fetchUsers(perPage: Int, since: Int) -> Single<[GitHubUser]> {
        return service.getUserList(page: since, itemPerPage: perPage)
    }
    
    func getAllUsersFromCache() -> [GitHubUser] {
        return store.getAllUsers()
    }
    
    func cleanCache() {
        store.clean()
    }
    
    func saveCache(users: [GitHubUser]) {
        store.add(users: users)
    }
}
