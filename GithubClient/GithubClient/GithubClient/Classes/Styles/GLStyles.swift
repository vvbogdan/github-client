//
// Created by Vitalii Bogdan on 7/26/16.
// Copyright (c) 2016. All rights reserved.
//

import Foundation
import UIKit
import HexColors

class GLStyles {

// MARK: - Fonts

    class func defaultFont(size: CGFloat) -> UIFont {
        return UIFont.systemFontOfSize(size)
    }

    class func defaultFontLight(size: CGFloat) -> UIFont {
        return UIFont.italicSystemFontOfSize(size)
    }

    class func defaultFontBold(size: CGFloat) -> UIFont {
        return UIFont.boldSystemFontOfSize(size)
    }

    
// MARK: - Colors

    static let DefaultDarkBackgroundColor = UIColor.hx_colorWithHexRGBAString("#EFEFF4")
    static let DefaultLightBackgroundColor = UIColor.whiteColor()
    
    static let DefaultSeparatorColor = UIColor.grayColor()
    
    static let DefaultColorWhite = UIColor.whiteColor()
    static let DefaultColorWhiteHighlighted = UIColor.whiteColor()
    
    static let DefaultColorLightGrayText = UIColor.lightGrayColor()
    static let DefaultColorGrayText = UIColor.grayColor()

    // Navigation bar
    static let navigationBarTitleFont = GLStyles.defaultFont(17)
    static let navigationBarTextColor = UIColor.darkTextColor()

    /** Configure default appearence for application. For example navigation bar. */
    class func styleAppearence() {

        // Navigation bar appearence
        let nav = UINavigationBar.appearance()
        nav.tintColor = self.DefaultDarkBackgroundColor
        nav.barTintColor = self.DefaultDarkBackgroundColor
        nav.translucent = false
        nav.titleTextAttributes = [NSForegroundColorAttributeName: navigationBarTextColor,
                                   NSFontAttributeName: navigationBarTitleFont]

        nav.shadowImage = UIImage.imageWithColor(UIColor.clearColor(), size: CGSize(width: 1, height: 1))
        nav.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        nav.backgroundColor = self.DefaultDarkBackgroundColor

        UIBarButtonItem.appearance().tintColor = self.DefaultDarkBackgroundColor
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: navigationBarTextColor,
            NSFontAttributeName: defaultFont(17)], forState: .Normal)

    }

// MARK: - Labels

    class func styleNoDataStateLabel(label: UILabel) -> Void {
        label.backgroundColor = UIColor.clearColor()
        label.textColor = self.DefaultColorLightGrayText
        label.font = self.defaultFont(16)
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.textAlignment = .Center
    }
    
    
    class func styleLoadMoreErrorLabel(label: UILabel) -> Void {
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.redColor()
        label.font = self.defaultFont(13)
        label.numberOfLines = 2
        label.lineBreakMode = .ByTruncatingTail
        label.textAlignment = .Center
    }
    
    class func styleButton(button: UIButton) -> Void {
        button.setTitleColor(self.DefaultColorWhite, forState: .Normal)
        button.setTitleColor(self.DefaultColorWhiteHighlighted, forState: .Highlighted)
        
        button.titleLabel?.font = self.defaultFont(16)
        button.titleLabel?.textAlignment = .Center
        button.titleLabel?.numberOfLines = 1
        let image = UIImage.imageWithColor(self.navigationBarTextColor, size: CGSize(width: 10, height: 10))
        button.setBackgroundImage(image, forState: .Normal)
        let highlightedImage = UIImage.imageWithColor(
            self.DefaultColorLightGrayText,
            size: CGSize(width: 10, height: 10))
        button.setBackgroundImage(highlightedImage, forState: .Highlighted)
        
        button.exclusiveTouch = true
    }
    
    
}
