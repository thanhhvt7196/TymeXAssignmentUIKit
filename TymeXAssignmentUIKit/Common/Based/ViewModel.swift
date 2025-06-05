//
//  ViewModel.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 2/6/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol InputCompatible {
    associatedtype InputCompatibleType: ViewModel
    var inputs: Inputs<InputCompatibleType> { get }
}

protocol OutputCompatible {
    associatedtype OutputCompatibleType
    var outputs: Outputs<OutputCompatibleType> { get }
}

class ViewModel: NSObject {
    let lifeCycle = PublishRelay<LifeCycle>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()
    
    let disposeBag = DisposeBag()
    
    deinit {
        print("\(String(describing: self)) deinit")
    }
}

class Inputs<Base>: ReactiveCompatible {
    let vm: Base

    init(_ vm: Base) {
        self.vm = vm
    }
}

extension ViewModel: InputCompatible {
    typealias InputCompatibleType = ViewModel
}

extension InputCompatible where Self: ViewModel {
    var inputs: Inputs<Self> { return Inputs(self) }
}

class Outputs<Base>: ReactiveCompatible {
    let vm: Base

    init(_ vm: Base) {
        self.vm = vm
    }
}

extension ViewModel: OutputCompatible {
    typealias OutputCompatibleType = ViewModel
}

extension OutputCompatible {
    var outputs: Outputs<Self> { return Outputs(self) }
}

extension Reactive where Base: Outputs<ViewModel> {
    var isLoading: Driver<Bool> {
        return base.vm.isLoading.asDriver()
    }
    
    var errorMessage: Signal<String> {
        return base.vm.errorMessage.asSignal()
    }
}
