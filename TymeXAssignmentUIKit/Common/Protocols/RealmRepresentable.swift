//
//  RealmRepresentable.swift
//  TymeXAssignment
//
//  Created by thanh tien on 2/6/25.
//

import Foundation
import RealmSwift

protocol RealmRepresentable {
    associatedtype RealmType: Object
    
    func toSwiftData() -> RealmType
}

protocol DomainConvertible {
    associatedtype DomainType
    
    func toDomain() -> DomainType
}
