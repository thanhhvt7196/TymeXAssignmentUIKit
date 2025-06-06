//
//  UserServiceImpl.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 4/6/25.
//

import RxSwift
import RxCocoa

struct UserServiceImpl: UserService {
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getUserList(page: Int, itemPerPage: Int) -> Single<[GitHubUser]> {
        return apiClient.request(router: .getGithubUsersList(itemPerPage: itemPerPage, since: page * itemPerPage), type: [GitHubUser].self)
    }
    
    func getUserDetail(username: String) -> Single<GithubUserDetail> {
        return apiClient.request(router: .getUserDetails(username: username), type: GithubUserDetail.self)
    }
}
