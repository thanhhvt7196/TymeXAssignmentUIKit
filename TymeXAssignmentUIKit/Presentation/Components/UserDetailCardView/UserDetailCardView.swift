//
//  UserDetailCardView.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 4/6/25.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

class UserDetailCardView: CustomViewWithXib {
    @IBOutlet fileprivate var containerView: UIView!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var locationStackView: UIStackView!
    @IBOutlet private var divider: UIView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var avatarImageView: UIImageView!
    
    override func setup() {
        super.setup()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.shadowColor = UIColor.baseShadow.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 12
        containerView.layer.shadowPath = UIBezierPath(
            roundedRect: containerView.bounds,
            cornerRadius: containerView.layer.cornerRadius
        ).cgPath
    }
    
    private func setupUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        avatarImageView.clipsToBounds = true
        
        nameLabel.font = FontFamily.TTNormsPro.bold.font(size: 30)
        nameLabel.textColor = .baseText
        nameLabel.numberOfLines = 0
        
        locationLabel.font = FontFamily.TTNormsPro.medium.font(size: 16)
        locationLabel.textColor = .baseText
                
        containerView.layer.cornerRadius = 12
        containerView.isSkeletonable = true
        containerView.skeletonCornerRadius = 12
    }
    
    fileprivate func bindData(userDetail: GithubUserDetail) {
        nameLabel.text = userDetail.name
        
        if let avatarUrl = userDetail.avatarUrl, let url = URL(string: avatarUrl) {
            avatarImageView.kf.setImage(
                with: url,
                placeholder: Asset.Assets.avatarDefault.image,
                options: [.transition(.fade(0.2))]
            )
        } else {
            avatarImageView.image = Asset.Assets.avatarDefault.image
        }
        
        if let location = userDetail.location {
            locationLabel.text = location
            locationStackView.isHidden = false
            divider.isHidden = false
        } else {
            locationStackView.isHidden = true
            locationLabel.text = nil
            divider.isHidden = true
        }
    }
}

extension Reactive where Base: UserDetailCardView {
    var userDetail: Binder<GithubUserDetail> {
        return Binder(base) { view, userDetail in
            view.bindData(userDetail: userDetail)
        }
    }
    
    var isLoading: Binder<Bool> {
        return Binder(base) { view, isLoading in
            isLoading ? view.containerView.showAnimatedGradientSkeleton() : view.containerView.hideSkeleton()
        }
    }
}
