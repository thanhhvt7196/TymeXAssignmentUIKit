//
//  UserListVC.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 5/6/25.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView
import UIScrollView_InfiniteScroll
import SnapKit

class UserListVC: Controller<UserListViewModel> {
    @IBOutlet private var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var skeletonView: UIView = {
        let containerView = UIView()
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fill
        
        for i in 0...2 {
            let itemView = UIView()
            itemView.isSkeletonable = true
            itemView.layer.cornerRadius = 12
            itemView.clipsToBounds = true
            stackView.addArrangedSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(160)
            }
            itemView.showAnimatedGradientSkeleton()
        }
        
        stackView.addArrangedSubview(UIView())
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.leading.equalToSuperview().inset(16)
        }
        return containerView
    }()
    
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
        tableView.isSkeletonable = true
        tableView.backgroundView = skeletonView
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
        
        let userList = vm.outputs.rx.userList
            .distinctUntilChanged()
        
        userList
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
        
        Driver.combineLatest(userList, vm.outputs.rx.isLoading)
            .drive(with: self, onNext: { vc, args in
                let (userList, isLoading) = args
                vc.skeletonView.isHidden = !(isLoading && userList.isEmpty)
            })
            .disposed(by: disposeBag)
    }
}
