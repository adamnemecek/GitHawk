//
//  IssueCommentDetailCell.swift
//  Freetime
//
//  Created by Ryan Nystrom on 5/19/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit
import SDWebImage

protocol IssueCommentDetailCellDelegate: class {
    func didTapMore(cell: IssueCommentDetailCell)
    func didTapProfile(cell: IssueCommentDetailCell)
}

final class IssueCommentDetailCell: UICollectionViewCell, ListBindable {

    weak var delegate: IssueCommentDetailCellDelegate? = nil

    private let imageView = UIImageView()
    private let loginLabel = UILabel()
    private let dateLabel = ShowMoreDetailsLabel()
    private let moreButton = UIButton()
    private var login = ""

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .white

        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Styles.Colors.Gray.lighter.color
        imageView.layer.cornerRadius = Styles.Sizes.avatarCornerRadius
        imageView.layer.borderColor = Styles.Colors.Gray.light.color.cgColor
        imageView.layer.borderWidth = 1.0 / UIScreen.main.scale
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(IssueCommentDetailCell.onTapAvatar))
        )
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.equalTo(Styles.Sizes.avatar)
            make.left.equalTo(Styles.Sizes.gutter)
            make.top.equalTo(Styles.Sizes.gutter)
        }

        loginLabel.font = Styles.Fonts.title
        loginLabel.textColor = Styles.Colors.Gray.dark.color
        loginLabel.isUserInteractionEnabled = true
        loginLabel.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(IssueCommentDetailCell.onTapLoginLabel))
        )
        contentView.addSubview(loginLabel)
        loginLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.centerY)
            make.left.equalTo(imageView.snp.right).offset(Styles.Sizes.columnSpacing)
        }

        dateLabel.font = Styles.Fonts.secondary
        dateLabel.textColor = Styles.Colors.Gray.light.color
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(loginLabel)
            make.top.equalTo(loginLabel.snp.bottom).offset(2)
        }

        moreButton.isHidden = true
        moreButton.setImage(UIImage(named: "bullets")?.withRenderingMode(.alwaysTemplate), for: .normal)
        moreButton.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        moreButton.tintColor = Styles.Colors.Gray.light.color
        moreButton.addTarget(self, action: #selector(IssueCommentDetailCell.onMore), for: .touchUpInside)
        moreButton.accessibilityLabel = NSLocalizedString("More options", comment: "")
        contentView.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.size.equalTo(Styles.Sizes.icon)
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-Styles.Sizes.gutter)
        }

        contentView.addBorder(bottom: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private API

    func onMore() {
        delegate?.didTapMore(cell: self)
    }

    func onTapAvatar() {
        delegate?.didTapProfile(cell: self)
    }

    func onTapLoginLabel() {
        delegate?.didTapProfile(cell: self)
    }

    // MARK: ListBindable

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? IssueCommentDetailsViewModel else { return }
        imageView.sd_setImage(with: viewModel.avatarURL)
        dateLabel.setText(date: viewModel.date)
        loginLabel.text = viewModel.login
    }

}
