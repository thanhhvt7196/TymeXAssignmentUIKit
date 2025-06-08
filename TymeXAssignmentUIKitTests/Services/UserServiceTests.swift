//
//  UserServiceTests.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//


import XCTest
import RxSwift
import RxBlocking
@testable import TymeXAssignmentUIKit

final class UserServiceTests: XCTestCase {
    var mockAPIClient: MockAPIClient!
    var userService: UserService!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        userService = UserServiceImpl(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        mockAPIClient = nil
        userService = nil
        super.tearDown()
    }
    
    func testFetchUsers_WhenAPISucceeds_ShouldReturnUsers() async throws {
        let mockUsers = GitHubUserDTO.mockList()
        mockAPIClient.mockResult = .success(mockUsers)
        
        let result = try? userService.getUserList(page: 0, itemPerPage: 20).toBlocking().single()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 5)
        XCTAssertEqual(result?.first?.login, "mojombo")
        
        if case .getGithubUsersList(let itemPerPage, let since) = mockAPIClient.lastRouter {
            XCTAssertEqual(itemPerPage, 20)
            XCTAssertEqual(since, 0)
        } else {
            XCTFail("Wrong router called")
        }
    }
    
    func testFetchUsers_WhenAPIFails_ShouldThrowError() async {
        let error = APIError.mock()
        mockAPIClient.mockResult = .failure(error)
        
        XCTAssertThrowsError(
            try userService.getUserList(page: 0, itemPerPage: 20).toBlocking().single()
        ) { thrown in
            let apiError = thrown as? APIError
            XCTAssertEqual(apiError?.message, error.message)
        }
    }

    func testFetchUserDetail_WhenAPISucceeds_ShouldReturnUserDetail() async throws {
        let mockUserDetail = GithubUserDetailDTO.mock()
        mockAPIClient.mockResult = .success(mockUserDetail)
        
        let result = try? userService.getUserDetail(username: "mojombo").toBlocking().single()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, 1)
        XCTAssertEqual(result?.login, "mojombo")
        XCTAssertEqual(result?.name, "Tom Preston-Werner")

        if case .getUserDetails(let username) = mockAPIClient.lastRouter {
            XCTAssertEqual(username, "mojombo")
        } else {
            XCTFail("Wrong router called")
        }
        
    }
    
    func testFetchUserDetail_WhenAPIFails_ShouldThrowError() async {
        let error = APIError(message: "User not found")
        mockAPIClient.mockResult = .failure(error)
        
        XCTAssertThrowsError(
            try userService.getUserDetail(username: "fake user name").toBlocking().single()
        ) { thrown in
            let apiError = thrown as? APIError
            XCTAssertEqual(apiError?.message, "User not found")
        }
    }
} 
