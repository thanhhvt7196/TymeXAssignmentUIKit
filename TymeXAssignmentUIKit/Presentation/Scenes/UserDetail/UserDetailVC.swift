//
//  UserDetailVC.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 6/6/25.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

class UserDetailVC: Controller<UserDetailViewModel> {
    @IBOutlet private var blogView: UserDetailBlogView!
    @IBOutlet private var followingView: UserDetailFollowView!
    @IBOutlet private var followerView: UserDetailFollowView!
    @IBOutlet private var detailCardView: UserDetailCardView!
    @IBOutlet private var scrollView: UIScrollView!
    
    override func setup() {
        super.setup()
        setupUI()
        setupBinding()
    }
    
    private func setupUI() {
        setupTexts()
        setupScrollView()
        setupFollowViews()
    }
    
    private func setupTexts() {
        title = L10n.userDetailScreenTitle
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupFollowViews() {
        followerView.config(title: L10n.followerTitle, icon: Asset.Assets.followers.image)
        followingView.config(title: L10n.followingTitle, icon: Asset.Assets.following.image)
    }
    
    private func setupBinding() {
        bindInputs()
        bindOutputs()
    }
    
    private func bindInputs() {
        blogView.rx.linkTap
            .withLatestFrom(vm.outputs.rx.userDetail)
            .compactMap { URL(string: $0?.htmlUrl ?? "") }
            .subscribe(onNext: { url in
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutputs() {
        vm.outputs.rx.userDetail
            .compactMap { $0 }
            .drive(detailCardView.rx.userDetail)
            .disposed(by: disposeBag)
        
        vm.outputs.rx.isLoading
            .drive(detailCardView.rx.isLoading, followerView.rx.isHidden, followingView.rx.isHidden, blogView.rx.isHidden)
            .disposed(by: disposeBag)
        
        vm.outputs.rx.errorMessage
            .emit(with: self, onNext: { vc, errorMessage in
                vc.showErrorAlert(message: errorMessage) {
                    vc.vm.inputs.rx.popAction.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        vm.outputs.rx.userDetail
            .compactMap { $0?.followers?.string }
            .drive(followerView.rx.value)
            .disposed(by: disposeBag)
        
        vm.outputs.rx.userDetail
            .compactMap { $0?.following?.string }
            .drive(followingView.rx.value)
            .disposed(by: disposeBag)
        
        vm.outputs.rx.userDetail
            .map { $0?.htmlUrl }
            .drive(blogView.rx.link)
            .disposed(by: disposeBag)
    }
}
