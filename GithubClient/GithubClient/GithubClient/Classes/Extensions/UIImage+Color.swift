//
//  UIImage+Color.swift
//  GithubClient
//
//  Created by Vitalii Bogdan on 7/26/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
