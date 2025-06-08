//
//  UserStoreImpl.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 4/6/25.
//

import RealmSwift
import Foundation

struct UserStoreImpl<C: Storeable>: UserStore where C.Model == GitHubUser {
    private let collection: C
    
    init(collection: C) {
        self.collection = collection
    }
    
    func getAllUsers() -> [GitHubUser] {
        let sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        return collection.objects(nil, sort: sortDescriptors)
    }
    
    func clean() {
        collection.add([], update: .cleanOnUpdate)
    }
    
    func add(users: [GitHubUser]) {
        collection.add(users, update: .update)
    }
}
