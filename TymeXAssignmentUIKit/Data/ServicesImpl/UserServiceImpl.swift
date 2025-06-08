//
//  UserServiceImpl.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//

import Foundation
import RxSwift

struct UserServiceImpl: UserService {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getUserList(page: Int, itemPerPage: Int) -> Single<[GitHubUser]> {
        return apiClient.request(router: .getGithubUsersList(itemPerPage: itemPerPage, since: page), type: [GitHubUserDTO].self).map { $0.map { $0.toDomain() }}
    }
    
    func getUserDetail(username: String) -> Single<GithubUserDetail> {
        return apiClient.request(router: .getUserDetails(username: username), type: GithubUserDetailDTO.self).map { $0.toDomain() }
    }
}
