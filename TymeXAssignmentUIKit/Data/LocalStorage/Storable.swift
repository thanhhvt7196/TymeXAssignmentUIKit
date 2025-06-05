//
//  Storable.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 5/6/25.
//

import Foundation
import RxSwift

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

    func query(_ conditions: [NSPredicate]?, sort usingDescriptors: [NSSortDescriptor]?) -> Observable<[Model]>
    func objects(_ conditions: [NSPredicate]?, sort usingDescriptors: [NSSortDescriptor]?) -> [Model]
    func model(by primaryKey: PrimaryKeyType) -> Model?
    func object(_ conditions: [NSPredicate]?, sort usingDescriptors: [NSSortDescriptor]?) -> Model?
    func add(_ model: Model, update isUpdate: Bool)
    func add<S: Sequence>(_ objects: S, update level: StoreWriteLevel) where S.Iterator.Element == Model
    func delete(_ ids: [PrimaryKeyType])
    func deletes(_ filter: NSPredicate)
    func count(_ conditions: [NSPredicate]?) -> Int
    func from(object id: PrimaryKeyType) -> Observable<Model>
}

extension Storeable {
    func all(sorted sortDescription: [NSSortDescriptor]) -> Observable<[Model]> {
        return query(nil, sort: sortDescription)
    }

    func update(_ model: Model) {
        add(model, update: true)
    }

    func add(_ model: Model) {
        add(model, update: false)
    }

    func query(filter predicate: NSPredicate, sorted byDesc: [NSSortDescriptor]) -> Observable<[Model]> {
        return query([predicate], sort: byDesc)
    }

    func object(by predicate: NSPredicate) -> Model? {
        return object([predicate], sort: nil)
    }

    func objects(by predicate: NSPredicate) -> [Model] {
        return objects([predicate], sort: nil)
    }

    func update<S: Sequence>(_ objects: S) where S.Iterator.Element == Model {
        add(objects, update: .update)
    }

    func count(with predicate: NSPredicate) -> Int {
        return count([predicate])
    }

    func clean() {
        add([], update: .cleanOnUpdate)
    }

    func count(with predicate: [NSPredicate]) -> Int {
        return count(predicate)
    }
}

