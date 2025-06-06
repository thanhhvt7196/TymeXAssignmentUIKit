//
//  UserListItemCell.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 5/6/25.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class UserListItemCell: UITableViewCell {
    @IBOutlet fileprivate var linkButton: UIButton!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var containerView: UIView!
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        avatarImageView.clipsToBounds = true
        
        nameLabel.font = FontFamily.TTNormsPro.bold.font(size: 30)
        nameLabel.textColor = .baseText
        nameLabel.numberOfLines = 0
        
        linkButton.titleLabel?.numberOfLines = 0
        
        containerView.layer.cornerRadius = 12
        containerView.layer.applySketchShadow(color: .baseShadow, alpha: 1, x: 0, y: 4, blur: 12, spread: 0)
    }
    
    func bindData(user: GitHubUser) {
        nameLabel.text = user.login
        
        if let avatarUrl = user.avatarUrl, let url = URL(string: avatarUrl) {
            avatarImageView.kf.setImage(
                with: url,
                placeholder: Asset.Assets.avatarDefault.image,
                options: [.transition(.fade(0.2))]
            )
        } else {
            avatarImageView.image = Asset.Assets.avatarDefault.image
        }
        
        if let htmlUrl = user.htmlUrl {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.link,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            let attributedLink = NSAttributedString(string: htmlUrl, attributes: attributes)
            linkButton.setAttributedTitle(attributedLink, for: .normal)
            linkButton.isHidden = false
        } else {
            linkButton.setTitle(nil, for: .normal)
            linkButton.isHidden = true
        }
    }
}

extension Reactive where Base: UserListItemCell {
    var linkTapped: ControlEvent<Void> {
        return base.linkButton.rx.tap
    }
}

extension UserListItemCell {
    static var cellIdentifier: String {
        return "UserListItemCell"
    }
}
