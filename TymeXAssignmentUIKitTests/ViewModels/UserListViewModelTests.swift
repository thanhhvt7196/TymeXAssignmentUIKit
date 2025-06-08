//
//  UserListViewModelTests.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 9/6/25.
//


import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import TymeXAssignmentUIKit

@MainActor
final class UserListViewModelTests: XCTestCase {
    private var viewModel: UserListViewModel!
    private var mockUseCase: MockUserListUseCase!
    private var mockUserService: MockUserService!
    private var mockUserStore: MockUserStore!
    private var mockAPIClient: MockAPIClient!
    private var mockNavigator: MockUserListNavigator!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    
    override func setUp() async throws {
        mockAPIClient = MockAPIClient()
        mockUserStore = MockUserStore()
        mockUserService = MockUserService(apiClient: mockAPIClient)
        mockUseCase = MockUserListUseCase(userService: mockUserService, userStore: mockUserStore)
        mockNavigator = MockUserListNavigator()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        viewModel = UserListViewModel(useCase: mockUseCase, navigator: mockNavigator)
    }
    
    override func tearDown() async throws {
        mockAPIClient = nil
        mockUserService = nil
        mockUserStore = nil
        mockUseCase = nil
        mockNavigator = nil
        disposeBag = nil
        scheduler = nil
        viewModel = nil
    }
    
    func test_refreshTrigger_success_shouldUpdateUserListAndCache() {
        let mockUsers = GitHubUserDTO.mockList()
        mockAPIClient.mockResult = .success(mockUsers)
        
        let userListObserver = scheduler.createObserver([GitHubUser].self)
        let isLoadingObserver = scheduler.createObserver(Bool.self)
        
        viewModel.outputs.rx.userList
            .drive(userListObserver)
            .disposed(by: disposeBag)
        
        viewModel.outputs.rx.isLoading
            .drive(isLoadingObserver)
            .disposed(by: disposeBag)
        
        scheduler.scheduleAt(10) {
            self.viewModel.inputs.rx.refreshTrigger.onNext(())
        }
        scheduler.start()
        
        XCTAssertEqual(userListObserver.events.last?.value.element?.count, mockUsers.count)
        
        XCTAssertEqual(mockUseCase.getAllUsersFromCache().count, mockUsers.count)
        XCTAssertEqual(isLoadingObserver.events.last?.value.element, false)
    }
    
    func test_refreshTrigger_failure_shouldEmitErrorMessage() {
        let error = APIError.mock()
        mockAPIClient.mockResult = .failure(error)

        let errorMessageObserver = scheduler.createObserver(String.self)
        viewModel.outputs.rx.errorMessage
            .emit(to: errorMessageObserver)
            .disposed(by: disposeBag)
        
        scheduler.scheduleAt(10) {
            self.viewModel.inputs.rx.refreshTrigger.onNext(())
        }
        scheduler.start()
        
        XCTAssertEqual(errorMessageObserver.events.last?.value.element, error.message)
    }
   
    func test_loadMore_whenSuccess_shouldAppendUsers() async {
        let mockUsers = [GitHubUserDTO.mock(), GitHubUserDTO.mock2()]
        mockAPIClient.mockResult = .success(mockUsers)
        
        let userListObserver = scheduler.createObserver([GitHubUser].self)

        viewModel.outputs.rx.userList
            .drive(userListObserver)
            .disposed(by: disposeBag)
        
        scheduler.scheduleAt(10) {
            self.viewModel.inputs.rx.refreshTrigger.onNext(())
        }
        
        scheduler.scheduleAt(15) {
            let mockResult = GitHubUserDTO.mock3()
            
            self.mockAPIClient.mockResult = .success([mockResult])
            self.viewModel.inputs.rx.loadMoreTrigger.onNext(())
        }
        scheduler.start()
        
        XCTAssertEqual(userListObserver.events.last?.value.element?.count, 3)
    }
    
    func test_loadMore_whenDuplicateUsers_shouldNotAppend() async {
        let mockUsers = [GitHubUserDTO.mock(), GitHubUserDTO.mock2()]
        mockAPIClient.mockResult = .success(mockUsers)
        
        let userListObserver = scheduler.createObserver([GitHubUser].self)

        viewModel.outputs.rx.userList
            .drive(userListObserver)
            .disposed(by: disposeBag)
        
        scheduler.scheduleAt(10) {
            self.viewModel.inputs.rx.refreshTrigger.onNext(())
        }
        
        scheduler.scheduleAt(15) {
            let mockResult = GitHubUserDTO.mock2()
            
            self.mockAPIClient.mockResult = .success([mockResult])
            self.viewModel.inputs.rx.loadMoreTrigger.onNext(())
        }
        scheduler.start()
        
        XCTAssertEqual(userListObserver.events.last?.value.element?.count, 2)
    }
    
    func test_loadMore_whenError_shouldNotUpdateState() async {
        let mockUsers = [GitHubUserDTO.mock(), GitHubUserDTO.mock2()]
        mockAPIClient.mockResult = .success(mockUsers)
        

        let userListObserver = scheduler.createObserver([GitHubUser].self)
        let errorObserver = scheduler.createObserver(String.self)

        viewModel.outputs.rx.userList
            .drive(userListObserver)
            .disposed(by: disposeBag)
        
        viewModel.outputs.rx.errorMessage
            .emit(to: errorObserver)
            .disposed(by: disposeBag)
        
        scheduler.scheduleAt(10) {
            self.viewModel.inputs.rx.refreshTrigger.onNext(())
        }
        
        scheduler.scheduleAt(15) {
            let error = APIError.mock()
            self.mockAPIClient.mockResult = .failure(error)
            self.viewModel.inputs.rx.loadMoreTrigger.onNext(())
        }
        scheduler.start()
        
        XCTAssertEqual(userListObserver.events.last?.value.element?.count, 2)
        XCTAssertNil(errorObserver.events.last?.value.element)
    }
    
    func test_selectedUserAction_shouldTriggerNavigator() {
        let user = GitHubUser.mock()
        viewModel.inputs.rx.selectedUserAction.onNext(user)
        XCTAssertTrue(mockNavigator.showUserDetailCalled)
    }
}
