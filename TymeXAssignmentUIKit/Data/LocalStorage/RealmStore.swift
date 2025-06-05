//
//  RealmStore.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 4/6/25.
//

import RealmSwift
import Foundation

struct RealmStore<T>: Storeable where T: Object, T: DomainConvertible, T.DomainType: RealmRepresentable {
    typealias Model = T.DomainType

    private let config: Realm.Configuration
    
    init(config: Realm.Configuration) {
        self.config = config
    }

    func objects(_ conditions: [NSPredicate]?, sort usingDescriptors: [NSSortDescriptor]?) -> [Model] {
        guard let realm = try? Realm(configuration: config) else {
            return []
        }
        var result = realm.objects(T.self)
        if let conditions = conditions {
            for predicate in conditions {
                result = result.filter(predicate)
            }
        }
        let sortDesciption = usingDescriptors?.compactMap({ sort -> RealmSwift.SortDescriptor? in
            guard let key = sort.key else { return nil }
            return SortDescriptor(keyPath: key, ascending: sort.ascending)
        }) ?? []
        if !sortDesciption.isEmpty {
            result = result.sorted(by: sortDesciption)
        }
        return result.map { $0.toDomain() }
    }

    func model(by primaryKey: PrimaryKeyType) -> Model? {
        guard let realm = try? Realm(configuration: config) else {
            return nil
        }
        return realm.object(ofType: T.self, forPrimaryKey: primaryKey)?.toDomain()
    }

    func object(_ conditions: [NSPredicate]?, sort usingDescriptors: [NSSortDescriptor]?) -> Model? {
        guard let realm = try? Realm(configuration: config) else {
            return nil
        }
        var result = realm.objects(T.self)
        if let conditions = conditions {
            for predicate in conditions {
                result = result.filter(predicate)
            }
        }
        let sortDesciption = usingDescriptors?.compactMap({ sort -> RealmSwift.SortDescriptor? in
            guard let key = sort.key else { return nil }
            return SortDescriptor(keyPath: key, ascending: sort.ascending)
        }) ?? []
        if !sortDesciption.isEmpty {
            result = result.sorted(by: sortDesciption)
        }
        return result.first?.toDomain()
    }

    func add(_ model: Model, update isUpdate: Bool) {
        let writeBlock = { (realm: Realm) -> Void in
            if isUpdate {
                realm.add(model.toRealm(), update: .modified)
            } else {
                realm.add(model.toRealm())
            }
        }

        guard let realm = try? Realm(configuration: config) else {
            return
        }
        if realm.isInWriteTransaction {
            writeBlock(realm)
        } else {
            realm.beginWrite()
            writeBlock(realm)
            do {
                try realm.commitWrite()
            } catch let error {
                print(error)
            }
        }
    }

    func add<S: Sequence>(_ objects: S, update level: StoreWriteLevel) where S.Iterator.Element == Model {
        let writeBlock = { (realm: Realm) -> Void in
            switch level {
            case .addNew:
                realm.add(objects.map { $0.toRealm() })
            case .update:
                realm.add(objects.map { $0.toRealm() }, update: .all)
            case .cleanOnUpdate:
                realm.delete(realm.objects(T.self))
                realm.add(objects.map { $0.toRealm() }, update: .all)
            }
        }

        guard let realm = try? Realm(configuration: config) else {
            return
        }
        do {
            if realm.isInWriteTransaction {
                writeBlock(realm)
            } else {
                realm.beginWrite()
                writeBlock(realm)
                do {
                    try realm.commitWrite()
                } catch let error {
                    print(error)
                }
            }
        }
    }

    func delete(_ ids: [PrimaryKeyType]) {
        guard !ids.isEmpty, let primaryKey = T.primaryKey() else {
            return
        }
        do {
            let writeBlock = { (realm: Realm) -> Void in
                let toDelete = realm.objects(T.self).filter("\(primaryKey) IN %@", ids)
                realm.delete(toDelete)
            }

            let realm = try Realm(configuration: config)

            if realm.isInWriteTransaction {
                writeBlock(realm)
            } else {
                realm.beginWrite()
                writeBlock(realm)
                try realm.commitWrite()
            }

        } catch {
            debugPrint("RealmStore: \(error.localizedDescription)")
        }
    }

    func deletes(_ filter: NSPredicate) {
        do {

            let writeBlock = { (realm: Realm) -> Void in
                realm.delete(realm.objects(T.self).filter(filter))
            }

            let realm = try Realm(configuration: config)

            if realm.isInWriteTransaction {
                writeBlock(realm)
            } else {
                realm.beginWrite()
                writeBlock(realm)
                try realm.commitWrite()
            }
        } catch {
            debugPrint("RealmStore: \(error.localizedDescription)")
        }
    }

    func count(_ conditions: [NSPredicate]?) -> Int {
        guard let realm = try? Realm(configuration: config) else {
            return 0
        }
        var result = realm.objects(T.self)
        guard let conditions = conditions else {
            return result.count
        }
        for predicate in conditions {
            result = result.filter(predicate)
        }
        return result.count
    }
}
