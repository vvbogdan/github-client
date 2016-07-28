//
// Created by Vitalii Bogdan on 7/26/16.
// Copyright (c) 2016 vbogdan. All rights reserved.
//

import Foundation
import NimbusSwift

class GLUserCell: GLBaseTableCell {

    var avatarImageView: UIImageView!
    var loginLabel: UILabel!
    var openProfileButton: UIButton!

    override class func heightForObject(object: AnyObject,
                               atIndexPath indexPath: NSIndexPath,
                               tableView table: UITableView) -> CGFloat {
        return 120
    }

    override func createUI() {
        avatarImageView = UIImageView()
        avatarImageView.image = UIImage(named: "default-avatar")
        avatarImageView.width = 100
        avatarImageView.height = 100
        addSubview(avatarImageView)

        loginLabel = UILabel()
        addSubview(loginLabel)

        openProfileButton = UIButton()
        GLStyles.styleButton(openProfileButton)
        openProfileButton.setTitle(NSLocalizedString("Open profile", comment: ""), forState: UIControlState.Normal)
        openProfileButton.addTarget(self, action: #selector(openProfile), forControlEvents: UIControlEvents.TouchUpInside )
        addSubview(openProfileButton)

    }


    override func layoutSubviews() {
        super.layoutSubviews()

        let padding: CGFloat = 10

        avatarImageView.left = padding
        avatarImageView.top = ceil(height / 2 - avatarImageView.height / 2)

        loginLabel.sizeToFit()
        loginLabel.left = avatarImageView.right + 20
        loginLabel.top = avatarImageView.top + 10

        openProfileButton.size = CGSize(width: 100, height: 30)
        openProfileButton.left = avatarImageView.right + 20
        openProfileButton.top = loginLabel.bottom + 10

    }


    override func updateCellWithObject(object: TableCellObject) {
        super.updateCellWithObject(object)

        if let item = object as? GLItemObject<GLUserProtocol> {
            loginLabel?.text = item.object.login

            if let avatarURL = item.object.avatarURL {
                avatarImageView
                .sd_setImageWithURL(NSURL(string:avatarURL),
                        placeholderImage: UIImage(named: "default-avatar"),
                        completed: { _ in
                            //self?.avatarImageView.addTextFadeAnimation()
                        })
            }
        }

    }


    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.sd_cancelCurrentImageLoad()
        avatarImageView.image = UIImage(named: "default-avatar")

        loginLabel.text = nil;
    }


    func openProfile() {
        guard let item = object as? GLItemObject<GLUserProtocol>,
            let path = item.object.profileURL,
            let url = NSURL(string: path) else {
                return;
            }

        UIApplication.sharedApplication().openURL(url)
    }
}
