//
//  ServiceContainer.swift
//  TymeXAssignment
//
//  Created by thanh tien on 2/6/25.
//

import Swinject

struct ServiceContainer: DIContainer {
    static var container: Container {
        let container = Container()
        
        container.register(APIClient.self) { _ in
            APIClientImpl()
        }
        .inObjectScope(.transient)
        
        container.register(UserService.self) { _ in
            UserServiceImpl(apiClient: container.resolve(APIClient.self)!)
        }
        .inObjectScope(.transient)
        
        return container
    }
}
