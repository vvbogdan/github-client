//
//  GLFollowersController.swift
//  GithubClient
//
//  Created by Vitalii Bogdan on 7/28/16.
//  Copyright © 2016 vbogdan. All rights reserved.
//

import Foundation

class GLFollowersController: GLUsersController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Followers", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(backAction))
        
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}