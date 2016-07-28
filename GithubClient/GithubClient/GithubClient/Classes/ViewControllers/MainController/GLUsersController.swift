//
//  GLUsersController.swift
//  GithubClient
//
//  Created by Vitalii Bogdan on 7/25/16.
//  Copyright © 2016 vbogdan. All rights reserved.
//

import UIKit

class GLUsersController: GLLoadMoreTableViewController {

    override func setupTableActions(tableViewActions: GLActions) {
        super.setupTableActions(tableViewActions)
        tableViewActions.attachToClass(GLItemObject<GLUserProtocol>.self,
                tap: {[weak self] (object, indexPath) -> Bool in

                    if let item = object as? GLItemObject<GLUserProtocol> {
                        self?.openFollowers(item.object)
                    }

                    return false
                })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControlEnabled = true
        edgesForExtendedLayout = .None

        self.title = NSLocalizedString("Users", comment: "")

        refreshControl?.tintColor = GLStyles.DefaultDarkBackgroundColor

        view.backgroundColor = GLStyles.DefaultLightBackgroundColor

        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)

        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()

        reloadData()
    }


    func openFollowers(user: GLUserProtocol) {
        let controller = GLFollowersController(model: GLFollowersModel(user: user))
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

