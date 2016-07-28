//
//  SCLoadMoreObject.swift
//  GithubClient
//
//  Created by Vitalii Bogdan on 7/26/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation
import NimbusSwift


class GLLoadMoreTableCell: GLBaseTableCell {
    
    let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    
    override class func heightForObject(object: AnyObject,
        atIndexPath indexPath: NSIndexPath,
        tableView table: UITableView) -> CGFloat {
            return 44
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        backgroundColor = UIColor.clearColor()
        
        activity.hidesWhenStopped = true
        activity.activityIndicatorViewStyle = .Gray
        activity.sizeToFit()
        addSubview(activity)
        
        textLabel?.text = NSLocalizedString("Oops, there was a server error. Try again", comment: "")
        textLabel?.hidden = true
        GLStyles.styleLoadMoreErrorLabel(textLabel!)
        textLabel?.sizeToFit()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activity.left = width / 2 - activity.width / 2
        activity.top = height / 2 - activity.height / 2
        
        if let label = textLabel {
            label.left = 20
            let size = label.sizeThatFits(CGSize(width: width - 2 * label.left, height: CGFloat.max))
            label.width = width - 2 * label.left
            label.height = size.height
            label.left = width / 2 - label.width / 2
            label.top = height / 2 - label.height / 2
        }

    }
    
    
    override func updateCellWithObject(object: TableCellObject) {
        super.updateCellWithObject(object)
        
        var fail = false
        
        if let loadmore = object as? GLLoadMoreObject {
            if loadmore.fail {
                activity.stopAnimating()
            } else {
                activity.startAnimating()
            }
            
            fail = loadmore.fail
        } else {
            activity.stopAnimating()
        }
        
        
        textLabel?.hidden = !fail
        
        self.setNeedsLayout()        
    }
    
}


class GLLoadMoreObject: NSObject, TableCellObject {

    var fail: Bool = false
    var loading: Bool = false

    @objc func tableCellClass() -> UITableViewCell.Type {
        return GLLoadMoreTableCell.self
    }
}
