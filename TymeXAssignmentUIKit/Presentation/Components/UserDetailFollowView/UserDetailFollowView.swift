//
//  UserDetailFollowView.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 6/6/25.
//

import UIKit
import RxSwift
import RxCocoa

class UserDetailFollowView: CustomViewWithXib {
    @IBOutlet fileprivate var titleLabel: UILabel!
    @IBOutlet fileprivate var valueLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet fileprivate var iconBackgroundView: UIView!
    
    override func setup() {
        super.setup()
        setupUI()
    }
    
    private func setupUI() {
        iconBackgroundView.layer.cornerRadius = iconBackgroundView.bounds.height / 2
        iconBackgroundView.clipsToBounds = true
        
        valueLabel.font = FontFamily.TTNormsPro.bold.font(size: 14)
        valueLabel.textColor = .baseText
        
        titleLabel.font = FontFamily.TTNormsPro.regular.font(size: 14)
        titleLabel.textColor = .baseText
        
        iconImageView.tintColor = .baseText
        iconImageView.contentMode = .scaleAspectFit
    }
    
    func config(title: String, icon: UIImage) {
        titleLabel.text = title
        iconImageView.image = icon
    }
}

extension Reactive where Base: UserDetailFollowView {
    var value: Binder<String> {
        return Binder(base) { view, value in
            view.valueLabel.text = value
        }
    }
}
