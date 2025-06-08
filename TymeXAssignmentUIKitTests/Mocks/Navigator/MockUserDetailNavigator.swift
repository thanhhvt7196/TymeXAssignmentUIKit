//
//  MockUserDetailNavigator.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//

import Foundation
@testable import TymeXAssignmentUIKit

class MockUserDetailNavigator: UserDetailNavigator {
    var popCalled = false
    
    func pop() {
        popCalled = true
    }
}
