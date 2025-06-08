//
//  UserDetailUseCaseTests.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//

import XCTest
import RxSwift
import RxBlocking
@testable import TymeXAssignmentUIKit

final class UserDetailUseCaseTests: XCTestCase {
    var mockUserService: MockUserService!
    var useCase: UserDetailUseCase!
    var mockAPIClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        mockUserService = MockUserService(apiClient: mockAPIClient)
        useCase = UserDetailUsecaseImpl(service: mockUserService)
    }
    
    override func tearDown() {
        mockAPIClient = nil
        mockUserService = nil
        useCase = nil
        super.tearDown()
    }
    
    func testFetchUserDetail_ShouldReturnUserFromServer() {
        let mockUser = GithubUserDetailDTO.mock()
        mockAPIClient.mockResult = .success(mockUser)
        
        let user = try? useCase.fetchUserDetail(username: "mojombo").toBlocking().single()
        
        XCTAssertEqual(user?.id, mockUser.id?.value)
        XCTAssertEqual(user?.login, mockUser.login?.value)
        XCTAssertEqual(user?.name, mockUser.name?.value)
        XCTAssertEqual(user?.location, mockUser.location?.value)
        XCTAssertEqual(user?.publicRepos, mockUser.publicRepos?.value)
        XCTAssertEqual(user?.followers, mockUser.followers?.value)
        XCTAssertEqual(user?.following, mockUser.following?.value)
    }
    
    func testFetchUserDetail_WhenAPIFails_ShouldThrowError() {
        let error = APIError(message: "User detail API error")
        mockAPIClient.mockResult = .failure(error)
        
        XCTAssertThrowsError(
            try useCase.fetchUserDetail(username: "fake username").toBlocking().single()
        ) { thrown in
            let apiError = thrown as? APIError
            XCTAssertEqual(apiError?.message, error.message)
        }
    }
    
    func testFetchUsers_ShouldUseCorrectRouter() {
        let mockUser = GithubUserDetailDTO.mock()
        mockAPIClient.mockResult = .success(mockUser)
        
        _ = try? useCase.fetchUserDetail(username: mockUser.login!.value!).toBlocking().single()
        
        if case .getUserDetails(let username) = mockAPIClient.lastRouter {
            XCTAssertEqual(username, mockUser.login!.value!)
        } else {
            XCTFail("Wrong router called")
        }
    }
}
