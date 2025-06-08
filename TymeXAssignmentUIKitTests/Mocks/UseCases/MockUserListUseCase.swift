//
//  MockUserListUseCase.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//

import Foundation
import RxSwift
@testable import TymeXAssignmentUIKit

final class MockUserListUseCase: UserListUsecase {
    private let userService: MockUserService
    private let userStore: MockUserStore
    
    
    init(userService: MockUserService, userStore: MockUserStore) {
        self.userService = userService
        self.userStore = userStore
    }
    
    func fetchUsers(perPage: Int, since: Int) -> Single<[GitHubUser]> {
        return userService.getUserList(page: since, itemPerPage: perPage)
    }
    
    func getAllUsersFromCache() -> [GitHubUser] {
        return userStore.getAllUsers()
    }
    
    func cleanCache() {
        return userStore.clean()
    }
    
    func saveCache(users: [GitHubUser]) {
        return userStore.add(users: users)
    }
}
