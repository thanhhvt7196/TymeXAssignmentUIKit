//
//  UserStoreTests.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//


import XCTest
import RealmSwift
@testable import TymeXAssignmentUIKit

@MainActor
final class UserStoreTests: XCTestCase {
    var config: Realm.Configuration!
    var userStore: UserStoreImpl<RealmStore<GithubUserRealm>>!
    
    override func setUp() {
        config = {
            var config = Realm.Configuration.defaultConfiguration
            config.schemaVersion = 1
            config.deleteRealmIfMigrationNeeded = false
            if let url = config.fileURL {
                let fileUrl = url.deletingLastPathComponent().appendingPathComponent("github_user_test.realm")
                config.fileURL = fileUrl
            }
            return config
        }()
        userStore = UserStoreImpl(collection: RealmStore<GithubUserRealm>(config: config))
    }
    
    override func tearDown() {
        userStore.clean()
        if let url = config.fileURL {
            try? FileManager.default.removeItem(at: url)
        }
        userStore = nil
        config = nil
        super.tearDown()
    }
    
    func testAddUsers_ShouldSaveToStore() {
        let users = GitHubUser.mockList()
        
        userStore.add(users: users)
        
        let storedUsers = userStore.getAllUsers()
        XCTAssertEqual(storedUsers.count, users.count)
        XCTAssertEqual(storedUsers[0].login, GitHubUser.mock().login)
        XCTAssertEqual(storedUsers[0].id, GitHubUser.mock().id)
        XCTAssertEqual(storedUsers[1].login, GitHubUser.mock2().login)
        XCTAssertEqual(storedUsers[1].id, GitHubUser.mock2().id)
    }
    
    func testGetAllUsers_WhenEmpty_ShouldReturnEmptyArray() {
        let users = userStore.getAllUsers()
        
        XCTAssertTrue(users.isEmpty)
    }
    
    func testGetAllUsers_ShouldReturnSortedById() {
        let users = [
            GitHubUser.mock3(),
            GitHubUser.mock(),
            GitHubUser.mock2()
        ]
        userStore.add(users: users)
        
        let storedUsers = userStore.getAllUsers()
        
        XCTAssertEqual(storedUsers.count, users.count)
        XCTAssertEqual(storedUsers[0].id, GitHubUser.mock().id)
        XCTAssertEqual(storedUsers[0].login, GitHubUser.mock().login)
        XCTAssertEqual(storedUsers[1].id, GitHubUser.mock2().id)
        XCTAssertEqual(storedUsers[1].login, GitHubUser.mock2().login)
        XCTAssertEqual(storedUsers[2].id, GitHubUser.mock3().id)
        XCTAssertEqual(storedUsers[2].login, GitHubUser.mock3().login)
    }
    
    func testClean_ShouldRemoveAllUsers() {
        let users = GitHubUser.mockList()

        userStore.add(users: users)
        XCTAssertEqual(userStore.getAllUsers().count, users.count)
        
        userStore.clean()
        XCTAssertTrue(userStore.getAllUsers().isEmpty)
    }
    
    func testAddUsers_WithAllFields_ShouldPreserveData() {
        let user = GitHubUser.mock()
        
        userStore.add(users: [user])
        
        let storedUser = userStore.getAllUsers().first
        XCTAssertNotNil(storedUser)
        XCTAssertEqual(storedUser?.login, GitHubUser.mock().login)
        XCTAssertEqual(storedUser?.id, GitHubUser.mock().id)
        XCTAssertEqual(storedUser?.nodeId, GitHubUser.mock().nodeId)
        XCTAssertEqual(storedUser?.avatarUrl, GitHubUser.mock().avatarUrl)
        XCTAssertEqual(storedUser?.gravatarId, GitHubUser.mock().gravatarId)
        XCTAssertEqual(storedUser?.url, GitHubUser.mock().url)
        XCTAssertEqual(storedUser?.htmlUrl,GitHubUser.mock().htmlUrl)
        XCTAssertEqual(storedUser?.followersUrl, GitHubUser.mock().followersUrl)
        XCTAssertEqual(storedUser?.followingUrl, GitHubUser.mock().followingUrl)
        XCTAssertEqual(storedUser?.gistsUrl, GitHubUser.mock().gistsUrl)
        XCTAssertEqual(storedUser?.starredUrl, GitHubUser.mock().starredUrl)
        XCTAssertEqual(storedUser?.subscriptionsUrl, GitHubUser.mock().subscriptionsUrl)
        XCTAssertEqual(storedUser?.organizationsUrl, GitHubUser.mock().organizationsUrl)
        XCTAssertEqual(storedUser?.reposUrl, GitHubUser.mock().reposUrl)
        XCTAssertEqual(storedUser?.eventsUrl, GitHubUser.mock().eventsUrl)
        XCTAssertEqual(storedUser?.receivedEventsUrl, GitHubUser.mock().receivedEventsUrl)
        XCTAssertEqual(storedUser?.type, GitHubUser.mock().type)
        XCTAssertEqual(storedUser?.userViewType, GitHubUser.mock().userViewType)
        XCTAssertEqual(storedUser?.siteAdmin, GitHubUser.mock().siteAdmin)
    }
} 
