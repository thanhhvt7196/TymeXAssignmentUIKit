//
//  UserDetailUsecaseImpl.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//

import RxSwift

struct UserDetailUsecaseImpl: UserDetailUseCase {
    private let service: UserService
    
    init(service: UserService) {
        self.service = service
    }
    
    func fetchUserDetail(username: String) -> Single<GithubUserDetail> {
        return service.getUserDetail(username: username)
    }
}
