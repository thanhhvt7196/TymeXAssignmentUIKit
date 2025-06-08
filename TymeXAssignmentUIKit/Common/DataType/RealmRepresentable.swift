//
//  RealmRepresentable.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 2/6/25.
//

import Foundation
import RealmSwift

protocol RealmRepresentable {
    associatedtype RealmType: Object
    
    func toRealm() -> RealmType
}

protocol DomainConvertible {
    associatedtype DomainType
    
    func toDomain() -> DomainType
}
