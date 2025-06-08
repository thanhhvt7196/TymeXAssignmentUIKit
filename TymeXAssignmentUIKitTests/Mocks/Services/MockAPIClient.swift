//
//  MockAPIClient.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//

import Foundation
import RxSwift
@testable import TymeXAssignmentUIKit

class MockAPIClient: APIClient {
    var mockResult: Result<Any, Error>?
    var lastRouter: APIRouter?

    func request<T: Codable>(router: APIRouter, type: T.Type) -> Single<T> {
        lastRouter = router
        return Single.create { observer in
            guard let mockResult = self.mockResult else {
                observer(.failure(APIError(message: "No mock result set")))
                return Disposables.create()
            }
            switch mockResult {
            case .success(let value):
                if let result = value as? T {
                    observer(.success(result))
                } else {
                    observer(.failure(APIError(message: "Mock result type mismatch")))
                }
            case .failure(let error):
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
}
