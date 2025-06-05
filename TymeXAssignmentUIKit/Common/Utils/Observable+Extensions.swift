//
//  Observable+Extensions.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 5/6/25.
//

import RxSwift
import RxCocoa

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

extension PublishRelay {
    func asObserver() -> AnyObserver<Element> {
        return .init { [weak self] event in
            guard let element = event.element else {
                return
            }
            self?.accept(element)
        }
    }
}

extension BehaviorRelay {
    func asObserver() -> AnyObserver<Element> {
        return .init { [weak self] event in
            guard let element = event.element else {
                return
            }
            self?.accept(element)
        }
    }
}

extension AnyObserver {
    typealias NextHandler = (Element) -> Void

    static func onNext(_ nextHandler: @escaping NextHandler) -> AnyObserver {
        return AnyObserver(eventHandler: { event in
            if case let .next(element) = event {
                return nextHandler(element)
            }
        })
    }
}
