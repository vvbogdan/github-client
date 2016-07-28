//
//  GLLoadMoreTableModel.swift
//  GithubClient
//
//  Created by Vitalii Bogdan on 7/26/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation
import NimbusSwift

protocol GLLoadMoreTableModelDelegate {
    func tableViewModelDidLoadData(model: GLLoadMoreTableModel, items: [AnyObject], more: Bool)
    func tableViewModelDidFail(model: GLLoadMoreTableModel, error: NSError, more: Bool)
    func tableViewModelWillLoadData(model: GLLoadMoreTableModel, more: Bool)
}

class GLLoadMoreTableModel: AnyObject {
    var mutableTableModel: MutableTableModel?
    private var modelDelegate: GLLoadMoreTableModelDelegate?

    func setup(tableDelegate: TableModelDelegate,
               modelDelegate: GLLoadMoreTableModelDelegate) {

        mutableTableModel = MutableTableModel(delegate: tableDelegate)
        self.modelDelegate = modelDelegate

    }



    func items() -> [AnyObject]? {

        let sections = mutableTableModel?.numberOfSections()

        var items: [AnyObject] = [AnyObject]()

        if let sections = sections {
            if sections > 0 {
                for index in 0...(sections - 1) {
                    if let mutableTableModel = self.mutableTableModel {
                        items.appendContentsOf(mutableTableModel.objects(index))
                    }
                }
            }
        }

        return items
    }

    
    var offset: Int {
        get {
            if let items = items() {
                var count = items.count
                if let _ = self.tableHasLoadMoreObject() {
                    count = max(count - 1, 0)
                }
                
                return count
            }
            
            return 0
        }
    }
    
    var numberOfPage: Int = 30

    private func model() -> GLLoadMoreTableModelDelegate? {
        return modelDelegate
    }
    
    func load(more: Bool) {
        model()?.tableViewModelWillLoadData(self, more: more)
        
        
        //call request
    }
    
    func load() {
        load(false)
    }
    
    func reset() {
        mutableTableModel?.removeSectionAtIndex(0)
        mutableTableModel?.addSectionWithHeader("")
    }
    

    // Mark: - Response -
    
    func responseSuccess(objects: [AnyObject]?, more: Bool) {
        if !more {
            reset()
        }
        
        var newLoadedItems = [AnyObject]()
        
        if let items = objects {
            for item in items {
                newLoadedItems.append(item)
            }
        }
        
        if let loadmoreObject = tableHasLoadMoreObject() {
            let indexPath = mutableTableModel?.pathForObject(loadmoreObject)
            if let index = indexPath {
                mutableTableModel?.removeObjectAtIndexPath(index)
            }
        }
        
        
        if ( newLoadedItems.count > 0 ) {
            if ( newLoadedItems.count >= numberOfPage ) {
                newLoadedItems.append(loadMoreObject())
            }
        }
        
        self.mutableTableModel?.addObjects(newLoadedItems)
        
        model()?.tableViewModelDidLoadData(self, items: newLoadedItems, more: more)
        
    }
    
    
    func responseError(error: NSError, more: Bool) {
        tableHasLoadMoreObject()?.fail = true
        tableHasLoadMoreObject()?.loading = false
        
        model()?.tableViewModelDidFail(self, error: error, more: more)
        
    }
    
}


extension GLLoadMoreTableModel {
    
    func loadMoreObject() -> GLLoadMoreObject {
        return GLLoadMoreObject()
    }
    
    func tableHasLoadMoreObject() -> GLLoadMoreObject? {
        return self.items()?.last as? GLLoadMoreObject
    }

}


class GLItemObject<T>: NSObject, TableCellObject {
    var object: T
    var cell: UITableViewCell.Type

    init(object: T, cell: UITableViewCell.Type) {
        self.object = object
        self.cell = cell
    }

    @objc func tableCellClass() -> UITableViewCell.Type {
        return cell
    }
}
