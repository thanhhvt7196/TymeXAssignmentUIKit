//
//  APIRouter.swift
//  TymeXAssignment
//
//  Created by thanh tien on 2/6/25.
//

import Foundation
import Alamofire
import Moya

enum APIRouter: TargetType {
    case getGithubUsersList(itemPerPage: Int, since: Int)
    case getUserDetails(username: String)
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var baseURL: URL {
        return URL(string: Constants.githubAPIURL)!
    }
    
    var path: String {
        switch self {
        case .getGithubUsersList:
            return Constants.APIPath.users
        case .getUserDetails(let username):
            return Constants.APIPath.users + "/\(username)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getGithubUsersList:
            return .get
        case .getUserDetails:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getGithubUsersList(let itemPerPage, let since):
            return .requestParameters(
                parameters: [
                    Constants.APIParamKey.perPage: itemPerPage,
                    Constants.APIParamKey.since: since
                ],
                encoding: URLEncoding.default
            )
        case .getUserDetails:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [Constants.APIHeaderKey.contentType: Constants.APIHeaderValue.applicationJson]
    }
}
