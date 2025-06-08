//
//  UserDetailUsecaseImpl.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//

import RxSwift

struct UserDetailUsecaseImpl: UserDetailUseCase {
    private let useCase: UserDetailUseCase
    
    init(useCase: UserDetailUseCase) {
        self.useCase = useCase
    }
    
    func fetchUserDetail(username: String) -> Single<GithubUserDetail> {
        return useCase.fetchUserDetail(username: username)
    }
}
