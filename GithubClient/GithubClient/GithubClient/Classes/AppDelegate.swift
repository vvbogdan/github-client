//
//  AppDelegate.swift
//  GithubClient
//
//  Created by Vitalii Bogdan on 7/25/16.
//  Copyright © 2016 vbogdan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = UINavigationController(rootViewController: GLUsersController(model: GLUsersModel()))
        window?.makeKeyAndVisible()

        GLStyles.styleAppearence()

        return true
    }
}

