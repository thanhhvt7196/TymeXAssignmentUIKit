# iOS Development Guidelines

## 1. Language & Framework

### 1.1 Swift

We use **[Swift](https://developer.apple.com/swift/)** and **[Xcode 16.4](https://developer.apple.com/xcode/)** as our primary development environment, leveraging modern Apple frameworks and technologies for building robust iOS applications.

- [Swift](https://developer.apple.com/swift/)  
- [Swift.org - Welcome to Swift](https://swift.org/)  
- [Xcode - Apple Developer](https://developer.apple.com/xcode/)  
### 1.2 Reactive Programming

In addition to Swift we are using reactive programming. It is heavily supported by community and really easy to use with the **[MVVM](https://medium.com/flawless-app-stories/how-to-use-a-model-view-viewmodel-architecture-for-ios-46963c67be1b)** architecture. There are a few libraries to choose from when implementing reactive programming in Swift. We chose the **[RxSwift](https://github.com/ReactiveX/RxSwift)**. Below are a few links to related articles and libraries that we use.

- [ReactiveX - Docs](http://reactivex.io/)  
- [RxMarbles](http://rxmarbles.com/)  
- [RxSwift & RxCocoa & RxTest](https://github.com/ReactiveX/RxSwift)  
- [RxDataSources: UITableView and and UICollectionView Data Sources](https://github.com/RxSwiftCommunity/RxDataSources)  
- [RxKeyboard: Reactive Keyboard in iOS](https://github.com/RxSwiftCommunity/RxKeyboard)  
- [RxFlow: Navigation framework based on a Flow Coordinator pattern](https://github.com/RxSwiftCommunity/RxFlow)  
- [Moya/RxSwift - Networking](https://github.com/Moya/Moya/blob/master/docs/RxSwift.md)  

---

## 2. Architecture

As architecture we are using **[MVVM](https://medium.com/flawless-app-stories/how-to-use-a-model-view-viewmodel-architecture-for-ios-46963c67be1b)**, and dependency injection enabled via [Swinject](https://github.com/Swinject/Swinject).


### 2.1 Overview
![](/images/image1.png)
- **ViewController (VC):** Presents UI, binds UI events and state to/from the ViewModel via RxSwift. Avoid business logic here.
- **ViewModel (VM):** Holds business logic and state, exposes `Observable`/`Driver`/`Relay` outputs and handles user input via reactive streams. ViewModel is stateless whenever possible.
- **Model:** Application data structure, decoupled from persistence/networking as much as possible.
- **Services:** Networking, persistence, or business logic helpers injected into ViewModels.
- **Navigator:** Manages navigation and screen orchestration.


### 2.2 Dependency Injection

All business logic and data dependencies should be injected. Use [Swinject](https://github.com/Swinject/Swinject) for flexible DI setup, especially for larger projects.

---

## 3. Project Structure

```
GithubUserUIKit/
├── Application/         # AppDelegate, app entry, dependency setup
├── Presentation/        # UI Layer: Scenes (screens), Components (reusable UI)
│   ├── Scenes/
│   │   └── UserList/
│   │       ├── UserListVC.swift
│   │       ├── UserListViewModel.swift
│   │       ├── UserListNavigator.swift
│   │       └── UserListVC.xib
│   └── Components/
├── Domain/              # Business logic, entities, use-cases
├── Data/                # Data providers, repositories, persistence
├── Infrastructure/      # Networking, API config
├── Common/              # Extensions, shared utilities, architecture helpers
├── Resources/           # Assets, localizations, SwiftGen outputs
└── SupportingFiles/     # Assets, LaunchScreen, Info.plist, config files
```

- **Screen structure:** All files for a screen are grouped together, including VM, VC, Navigator, and XIBs.  
- **Common:** All helpers, generic controllers, extensions, services used across modules.
- **Data:** Responsible for networking, caching, persistence. Implements Repository pattern for scalable data access.

---

## 4. Third-party libraries
The project uses the following libraries:

### Reactive Programming
- **[RxSwift](https://github.com/ReactiveX/RxSwift)**: Reactive programming for Swift
- **[RxCocoa](https://github.com/ReactiveX/RxSwift/tree/main/RxCocoa)**: Reactive extensions for UIKit
- **[RxTest](https://github.com/ReactiveX/RxSwift/tree/main/RxTest)**: Testing utilities for RxSwift
- **[RxBlocking](https://github.com/ReactiveX/RxSwift/tree/main/RxBlocking)**: Utilities for synchronously testing RxSwift code

### Database
- **[Realm](https://github.com/realm/realm-cocoa)**: Modern mobile database/persistence layer for local storage

### Dependency Injection
- **[Swinject](https://github.com/Swinject/Swinject)**: A lightweight dependency injection framework for Swift

### Networking
- **[Alamofire](https://github.com/Alamofire/Alamofire)**: Elegant HTTP networking library
- **[Moya](https://github.com/Moya/Moya)**: Networking abstraction layer built on top of Alamofire, works with RxSwift

### Image Loader
- **[Kingfisher](https://github.com/onevcat/Kingfisher)**: Powerful image downloading and caching library

### Development Tools
- **[SwiftGen](https://github.com/SwiftGen/SwiftGen)**: A tool that auto-generates Swift code for resources (images, strings, fonts, etc.)
- **[Pulse](https://github.com/kean/Pulse)**: Network and console logging inspector for iOS apps. Access by shaking device or using Cmd + Ctrl + Z in Simulator
# GithubUserUIKit
