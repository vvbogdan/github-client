//
//  GLActions.swift
//  GithubClient
//
//  Created by Vitalii Bogdan on 7/26/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation
import NimbusSwift

class GLActions: Actions {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let object = self.objectForTableView(tableView, atIndexPath: indexPath) as? TableCellObject {
            let cellClass = object.tableCellClass()
            
            if cellClass is GLBaseTableCell.Type {
                let clazz = (cellClass as! GLBaseTableCell.Type) // swiftlint:disable:this force_cast
                return clazz.heightForObject(object, atIndexPath: indexPath, tableView: tableView)
            }
        }
        
        return tableView.rowHeight
    }

}

// Private
extension GLActions {
    
    private func objectForTableView(tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> NSObject? {
        if let model = tableView.dataSource as? TableModel {
            if let object = model.objectAtPath(indexPath) as? NSObject {
                return object
            }
        }
        return nil
    }
}
