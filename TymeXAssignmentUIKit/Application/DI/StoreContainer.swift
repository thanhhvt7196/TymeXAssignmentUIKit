//
//  StoreContainer.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 6/6/25.
//

import Swinject
import RealmSwift

struct StoreContainer: DIContainer {
    private static let sharedRealmConfig: Realm.Configuration = {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 1
        config.deleteRealmIfMigrationNeeded = false
        if let url = config.fileURL {
            let fileUrl = url.deletingLastPathComponent().appendingPathComponent("github_user.realm")
            config.fileURL = fileUrl
        }
        return config
    }()
    
    static var container: Container {
        let container = Container()
        
        container.register(UserStore.self) { _ in
            UserStoreImpl(collection: RealmStore<GithubUserRealm>(config: sharedRealmConfig))
        }
        .inObjectScope(.transient)
        
        return container
    }
}
