//
//  APIClient.swift
//  TymeXAssignment
//
//  Created by thanh tien on 2/6/25.
//

import Foundation
import Alamofire
import Moya

struct APISession {
    static let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        return Session(configuration: configuration)
    }()
}

protocol APIClient {
    func request<T: Codable>(router: APIRouter, type: T.Type) async throws -> T
}

class APIClientImpl: APIClient {
    func request<T>(router: APIRouter, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        return try await withCheckedThrowingContinuation { continuation in
            MoyaProvider<APIRouter>(session: APISession.session)
                .request(router, completion: { result in
                    switch result {
                    case .success(let response):
                        let statusCode = response.response?.statusCode ?? 0
                        if statusCode == HTTPStatusCodes.OK.rawValue || statusCode == HTTPStatusCodes.Created.rawValue {
                            do {
                                let object = try JSONDecoder().decode(T.self, from: response.data)
                                continuation.resume(returning: object)
                            } catch {
                                continuation.resume(throwing: APIError(message: "Decode response error = \(error)"))
                            }
                        } else {
                            continuation.resume(throwing: APIError(message: "Error status code = \(statusCode.string)"))
                        }
                    case .failure(let error):
                        if let data = error.response?.data {
                            do {
                                let apiError = try JSONDecoder().decode(APIError.self, from: data)
                                continuation.resume(throwing: apiError)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        } else {
                            continuation.resume(throwing: error)
                        }
                    }
                })
        }
    }
}
