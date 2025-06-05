//
//  UserDetailBlogView.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 6/6/25.
//

import UIKit
import RxSwift
import RxCocoa

class UserDetailBlogView: CustomViewWithXib {
    @IBOutlet fileprivate var linkButton: UIButton!
    @IBOutlet private var headerLabel: UILabel!
    
    override func setup() {
        super.setup()
        setupUI()
    }
    
    private func setupUI() {
        headerLabel.font = FontFamily.TTNormsPro.bold.font(size: 24)
        headerLabel.textColor = .baseText
        headerLabel.text = L10n.blogTitle
        
        linkButton.setTitleColor(.link, for: .normal)
        linkButton.titleLabel?.font = FontFamily.TTNormsPro.medium.font(size: 16)
        linkButton.setTitleColor(.link, for: .normal)
    }
}

extension Reactive where Base: UserDetailBlogView {
    var link: Binder<String?> {
        return Binder(base) { view, link in
            view.linkButton.setTitle(link, for: .normal)
        }
    }
    
    var linkTap: ControlEvent<Void> {
        return base.linkButton.rx.tap
    }
}
