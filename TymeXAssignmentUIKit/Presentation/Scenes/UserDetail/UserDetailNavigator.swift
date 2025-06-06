//
//  UserDetailNavigator.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 6/6/25.
//

import UIKit
import Foundation

protocol UserDetailNavigator {
    func pop()
}

struct UserDetailNavigatorImpl: UserDetailNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
}
