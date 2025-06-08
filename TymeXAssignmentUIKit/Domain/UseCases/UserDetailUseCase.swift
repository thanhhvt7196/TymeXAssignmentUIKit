//
//  UserDetailUseCase.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//

import RxSwift

protocol UserDetailUseCase {
    func fetchUserDetail(username: String) -> Single<GithubUserDetail>
}
