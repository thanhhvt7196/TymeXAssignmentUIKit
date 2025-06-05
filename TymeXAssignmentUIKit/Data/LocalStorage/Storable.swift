//
//  Storable.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 5/6/25.
//

import Foundation

public protocol PrimaryKeyType {}

extension Int: PrimaryKeyType {}
extension String: PrimaryKeyType {}

public enum StoreWriteLevel: Int {
    case addNew
    case update
    case cleanOnUpdate
}

public protocol Storeable {
    associatedtype Model

    func objects(_ conditions: [NSPredicate]?, sort usingDescriptors: [NSSortDescriptor]?) -> [Model]
    func model(by primaryKey: PrimaryKeyType) -> Model?
    func object(_ conditions: [NSPredicate]?, sort usingDescriptors: [NSSortDescriptor]?) -> Model?
    func add(_ model: Model, update isUpdate: Bool)
    func add<S: Sequence>(_ objects: S, update level: StoreWriteLevel) where S.Iterator.Element == Model
    func delete(_ ids: [PrimaryKeyType])
    func deletes(_ filter: NSPredicate)
    func count(_ conditions: [NSPredicate]?) -> Int
}

