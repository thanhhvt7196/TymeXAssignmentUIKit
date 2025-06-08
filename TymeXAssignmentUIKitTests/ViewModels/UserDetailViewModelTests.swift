//
//  UserDetailViewModelTests.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//

import RxSwift
import RxTest
import XCTest
@testable import TymeXAssignmentUIKit

@MainActor
final class UserDetailViewModelTests: XCTestCase {
    private var viewModel: UserDetailViewModel!
    private var mockUseCase: MockUserDetailUseCase!
    private var mockUserService: MockUserService!
    private var mockAPIClient: MockAPIClient!
    private var mockNavigator: MockUserDetailNavigator!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private let testUsername = "mojombo"

    override func setUp() async throws {
        mockAPIClient = MockAPIClient()
        mockUserService = MockUserService(apiClient: mockAPIClient)
        mockUseCase = MockUserDetailUseCase(userService: mockUserService)
        mockNavigator = MockUserDetailNavigator()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        viewModel = UserDetailViewModel(userService: mockUserService, navigator: mockNavigator, username: testUsername)
    }
    
    override func tearDown() async throws {
        mockAPIClient = nil
        mockUserService = nil
        mockUseCase = nil
        mockNavigator = nil
        disposeBag = nil
        scheduler = nil
        viewModel = nil
    }
    
    func test_init_shouldLoadUserDetail() async throws {
        let mockUser = GithubUserDetailDTO.mock()
        mockAPIClient.mockResult = .success(mockUser)
        
        let userDetailObserver = scheduler.createObserver(GithubUserDetail?.self)
        let isLoadingObserver = scheduler.createObserver(Bool.self)
        
        viewModel.outputs.rx.userDetail
            .drive(userDetailObserver)
            .disposed(by: disposeBag)
        
        viewModel.outputs.rx.isLoading
            .drive(isLoadingObserver)
            .disposed(by: disposeBag)
        
        scheduler.scheduleAt(10) {
            self.viewModel.lifeCycle.accept(.willAppear)
        }
        scheduler.start()
        
        let result = userDetailObserver.events.last?.value.element
        XCTAssertEqual(result??.id, mockUser.id?.value)
        XCTAssertEqual(result??.login, mockUser.login?.value)
        XCTAssertEqual(isLoadingObserver.events.last?.value.element, false)
    }
    
    func test_loadUserDetail_whenError_shouldUpdateErrorState() async {
        let error = APIError.mock()
        mockAPIClient.mockResult = .failure(error)

        let userDetailObserver = scheduler.createObserver(GithubUserDetail?.self)
        let errorObserver = scheduler.createObserver(String.self)
        let isLoadingObserver = scheduler.createObserver(Bool.self)
        
        viewModel.outputs.rx.userDetail
            .drive(userDetailObserver)
            .disposed(by: disposeBag)
        
        viewModel.outputs.rx.isLoading
            .drive(isLoadingObserver)
            .disposed(by: disposeBag)
        
        viewModel.outputs.rx.errorMessage
            .emit(to: errorObserver)
            .disposed(by: disposeBag)
        
        scheduler.scheduleAt(10) {
            self.viewModel.lifeCycle.accept(.willAppear)
        }
        scheduler.start()
        
        XCTAssertEqual(errorObserver.events.last?.value.element, error.message)
        XCTAssertEqual(isLoadingObserver.events.last?.value.element, false)
    }
} 
