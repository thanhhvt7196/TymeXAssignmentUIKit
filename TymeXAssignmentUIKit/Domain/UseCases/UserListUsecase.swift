//
//  UserListUsecase.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//

import RxSwift

protocol UserListUsecase {
    func fetchUsers(perPage: Int, since: Int) -> Single<[GitHubUser]>
    func getAllUsersFromCache() -> [GitHubUser]
    func cleanCache()
    func saveCache(users: [GitHubUser])
}
