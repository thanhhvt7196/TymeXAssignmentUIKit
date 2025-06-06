//
//  UserService.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 4/6/25.
//

import Foundation
import RxSwift

protocol UserService {
    func getUserList(page: Int, itemPerPage: Int) -> Single<[GitHubUser]>
}
