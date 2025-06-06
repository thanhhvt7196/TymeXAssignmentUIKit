//
//  StoreContainer.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 6/6/25.
//

import Swinject
import RealmSwift

struct StoreContainer: DIContainer {
    static var container: Container {
        let container = Container()
        
        container.register(Realm.Configuration.self) { _ in
            AppDelegate.sharedRealmConfig
        }
        .inObjectScope(.container)
        
        container.register(GithubUserStore.self) { _ in
            GithubUserStoreImpl(collection: RealmStore<GithubUserRealm>(config: container.resolve(Realm.Configuration.self)!))
        }
        .inObjectScope(.transient)
        
        return container
    }
}
