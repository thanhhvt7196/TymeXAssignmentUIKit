//
//  UserListVC.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 5/6/25.
//

import UIKit
import RxSwift
import RxCocoa
import UIScrollView_InfiniteScroll

class UserListVC: Controller<UserListViewModel> {
    @IBOutlet private var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    override func setup() {
        super.setup()
        setupUI()
        setupBinding()
    }
    
    private func setupTexts() {
        title = L10n.userListScreenTitle
    }
    
    private func setupUI() {
        setupTexts()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.sectionHeaderTopPadding = .zero
        tableView.register(UINib(nibName: "UserListItemCell", bundle: nil), forCellReuseIdentifier: "UserListItemCell")
        tableView.refreshControl = refreshControl
        tableView.rowHeight = UITableView.automaticDimension
        tableView.addInfiniteScroll { [weak self] tableView in
            self?.vm.inputs.rx.loadMoreTrigger.onNext(())
            tableView.finishInfiniteScroll()
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        tableView.contentInset.bottom = view.safeAreaInsets.bottom + 10
    }
    
    private func setupBinding() {
        bindRefreshTrigger()
        bindTableView()
    }
    
    private func bindRefreshTrigger() {
        let refreshControlAction = refreshControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .do(onNext: { vc, _ in
                vc.refreshControl.endRefreshing()
            })
            .mapToVoid()
        
        let viewWillAppearEvent = rx.viewWillAppear
            .take(1)
            .mapToVoid()
        
        Observable.merge(refreshControlAction, viewWillAppearEvent)
            .bind(to: vm.inputs.rx.refreshTrigger)
            .disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        tableView.rx.modelSelected(GitHubUser.self)
            .bind(to: vm.inputs.rx.selectedUserAction)
            .disposed(by: disposeBag)
        
        vm.outputs.rx.userList
            .distinctUntilChanged()
            .drive(tableView.rx.items) { tableView, row, user in
                let indexPath = IndexPath(row: row, section: 0)
                guard let cell = tableView.dequeueReusableCell(withIdentifier: UserListItemCell.cellIdentifier, for: indexPath) as? UserListItemCell else {
                    return UITableViewCell()
                }
                cell.bindData(user: user)
                cell.rx.linkTapped
                    .subscribe(onNext: {
                        guard let htmlURL = user.htmlUrl, let url = URL(string: htmlURL) else {
                            return
                        }
                        UIApplication.shared.open(url)
                    })
                    .disposed(by: cell.disposeBag)
                return cell
            }
            .disposed(by: disposeBag)
    }
}
