//
//  MockUserListNavigator.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//

import Foundation
@testable import TymeXAssignmentUIKit

class MockUserListNavigator: UserListNavigator {
    var showUserDetailCalled = false
    
    func showUserDetail(username: String) {
        showUserDetailCalled = true
    }
}
