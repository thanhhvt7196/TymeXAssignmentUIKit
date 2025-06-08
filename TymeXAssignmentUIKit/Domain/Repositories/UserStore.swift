//
//  UserStore.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 4/6/25.
//

protocol UserStore {
    func getAllUsers() -> [GitHubUser]
    func clean()
    func add(users: [GitHubUser])
}
