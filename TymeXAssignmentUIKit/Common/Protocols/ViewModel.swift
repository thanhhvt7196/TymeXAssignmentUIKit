//
//  ViewModel.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 2/6/25.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel: NSObject {
    enum LifeCycle {
        case didAppear
        case willAppear
        case didLoad
        case willDisappear
        case didDisappear
        case didLayoutSubviews
    }

    // handle view controller's state in viewmodel
    let lifeCycle = PublishRelay<LifeCycle>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()

    let disposeBag = DisposeBag()
    
    deinit {
        print("\(String(describing: self)) deinit")
    }
}
