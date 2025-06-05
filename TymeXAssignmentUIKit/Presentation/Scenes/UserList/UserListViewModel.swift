//
//  UserListViewModel.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 4/6/25.
//

import Foundation
import RxSwift
import RxCocoa

class UserListViewModel: ViewModel {
    private let userService: UserService
    private let store: GithubUserStore
    
    init(userService: UserService, store: GithubUserStore) {
        self.userService = userService
        self.store = store
    }
    
}

extension Reactive where Base: Inputs<UserListViewModel> {
    
}

extension Reactive where Base: Outputs<UserListViewModel> {
    
}
