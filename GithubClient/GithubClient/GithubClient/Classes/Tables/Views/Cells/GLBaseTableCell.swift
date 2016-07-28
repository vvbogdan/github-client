//
//  GLBaseTableCell.swift
//  GithubClient
//
//  Created by Vitalii Bogdan on 7/26/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation
import NimbusSwift

class GLBaseTableCell: UITableViewCell, TableCell {
    
    var object: TableCellObject?
    
    class func heightForObject(object: AnyObject,
        atIndexPath indexPath: NSIndexPath,
        tableView table: UITableView) -> CGFloat {
            //calculate height size depending on its content
            return 44
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createUI()
    }

    required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func createUI() {
        //TODO
    }
    
    
    func updateCellWithObject(object: TableCellObject) {
        self.object = object
    }

}
