//
//  UserListNavigator.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 6/6/25.
//

import UIKit
import Foundation

protocol UserListNavigator {
    func showUserDetail(username: String)
}

struct UserListNavigatorImpl: UserListNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showUserDetail(username: String) {
        let service: UserService = ServiceContainer.get()
        let navigator = UserDetailNavigatorImpl(navigationController: navigationController)
        let viewModel = UserDetailViewModel(userService: service, navigator: navigator, username: username)
        let userDetailVC = UserDetailVC(vm: viewModel)
        navigationController.pushViewController(userDetailVC, animated: true)
    }
}
