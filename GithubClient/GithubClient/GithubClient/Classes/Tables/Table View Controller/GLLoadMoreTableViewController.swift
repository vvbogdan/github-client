//
//  GLLoadMoreTableViewController.swift
//  GithubClient
//
//  Created by Vitalii Bogdan on 7/26/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation
import NimbusSwift
import ReactiveCocoa
import SVProgressHUD

class GLLoadMoreTableViewController: UITableViewController, GLLoadMoreTableModelDelegate {

    var cellFactory: TableCellFactory = TableCellFactory()
    var tableViewModel: GLLoadMoreTableModel?
    private var tableViewActions: GLActions!
    var actionsFactory: GLActionsFactoryProtocol!

    /** Refresh control status. */
    var refreshControlEnabled: Bool = false {
        didSet {
            if (refreshControlEnabled) {
                if (refreshControl == nil) {
                    refreshControl = UIRefreshControl()

                    refreshControl!.addTarget(self, action: #selector(reloadData),
                            forControlEvents: UIControlEvents.ValueChanged)
                }
            } else {
                if let rc = refreshControl {
                    rc.removeTarget(self, action: #selector(reloadData), forControlEvents: UIControlEvents.ValueChanged)
                    rc.removeFromSuperview()
                }
            }
        }
    }

    init(model: GLLoadMoreTableModel) {
        super.init(style: .Plain)
        self.tableViewModel = model;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    Must be implement in subclass with super
    */

    func setupActionsFactory() {
        self.actionsFactory = GLLoadMoreTableActionFactory(controller: self,
            autoload: {[weak self] (cell, object) -> Void in
            if let loadMoreTableModel = self?.tableViewModel {
                loadMoreTableModel.load(true)
            }
        })
    }
    
    func setupTableActions(tableViewActions: GLActions) {
        tableViewActions.attachToClass(GLLoadMoreObject.self, tap: {[weak self] (object, indexPath) -> Bool in
            
            if let loadmoreObject = object as? GLLoadMoreObject {
                if ( loadmoreObject.loading ) {
                    return false
                }
                
                loadmoreObject.loading = true
                loadmoreObject.fail = false
                
                self?.reloaLoadingCell()
            }
            
            if let loadMoreTableModel = self?.tableViewModel {
                loadMoreTableModel.load(true)
            }
            
            return true
        })
                
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.grayColor()

        tableViewModel?.setup(cellFactory, modelDelegate: self)
        setupActionsFactory()
        tableViewActions = actionsFactory.actions()
        setupTableActions(self.tableViewActions)

        tableView.dataSource = tableViewModel?.mutableTableModel
        tableView.delegate = self.tableViewActions

    }
    
    // MARK: SCLoadMoreTableViewModelDelegate
    
    func tableViewModelWillLoadData(model: GLLoadMoreTableModel, more: Bool) {
        
        var refreshing: Bool = false
        
        if let refresh = self.refreshControl {
            refreshing = refresh.refreshing
        }
        
        if ( !more && !refreshing ) {
            self.tableShowLoadingView()
        } else {
            self.tableHideStateView()
        }
    }
    
    
    func tableViewModelDidFail(model: GLLoadMoreTableModel, error: NSError, more: Bool) {
        self.hasLoadedData(model.items(), error: error, more: more)
        
        if (more) {
            // Showing load more cell error state
            self.reloaLoadingCell()
        }
    }

    func tableViewModelDidLoadData(model: GLLoadMoreTableModel, items: [AnyObject], more: Bool) {
        self.tableHideStateView()
        self.tableView.reloadData()
        
        self.hasLoadedData(items, error: nil, more: more)
    }
    
    func hasLoadedData(objects: Array<AnyObject>?, error err: NSError?, more: Bool) {
        if let refresh = self.refreshControl {
            if refresh.refreshing {
                refresh.endRefreshing()
            }
        }
        
        // if there is no data and list is local - show no data, not error
        var loadedItems: [AnyObject] = [AnyObject]()
        if let tableViewModel = tableViewModel {
            if let objects = tableViewModel.items() {
                loadedItems = objects
            }
        }
        
        
        if ( objects?.count == 0 && loadedItems.count == 0 ) {
            if let error = err {
                self.tableShowErrorView(error)
            } else {
                self.tableShowNoDataView()
            }
        } else {
            if let _ = err {
                self.tableHideStateView()
                if !more {
                    //waiting for pull-to-refresh disappeared
                    RACSignal.empty().delay(0.5).deliverOnMainThread().subscribeCompleted({ [weak self]() -> Void in
                        self?.tableShowErrorNotificationView()
                        })
                    
                }
            }
        }
    }
    
    
    private func reloaLoadingCell() {
        
        if let loadMoreTableModel = self.tableViewModel {
            if let object = loadMoreTableModel.tableHasLoadMoreObject() {
                if let _ = loadMoreTableModel.mutableTableModel?.pathForObject(object) {
                    UIView.transitionWithView(self.tableView,
                        duration: 0.5,
                        options: UIViewAnimationOptions.CurveEaseInOut,
                        animations: { [weak self] () -> Void in
                            self?.tableView.reloadData()
                        }, completion: { [weak self](finished) -> Void in
                            if (!finished) {
                                self?.tableView.reloadData()
                            }
                        })
                }
            }
        }
    }
}


class GLLoadMoreActions: GLActions {
    
    let numberOfCellsToStartLoadMore = 0
    private var autoload: ((UITableViewCell, AnyObject) -> Void)?
    private weak var controller: GLLoadMoreTableViewController!
    
    init(controller: GLLoadMoreTableViewController, autoload:((UITableViewCell, AnyObject ) -> Void)?) {
        self.autoload = autoload
        self.controller = controller
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
        
        // checking, if we have load more cell with load more object that is not loading more...
        // calling load more block
            
        guard let
            model = controller.tableViewModel,
            loadObject = model.tableHasLoadMoreObject(),
            indexPathLoadMore = model.mutableTableModel?.pathForObject(loadObject) else {
                return
        }
            
        if indexPathLoadMore.section == indexPath.section &&
            indexPath.row >= (indexPathLoadMore.row - numberOfCellsToStartLoadMore) {
                if ( !loadObject.fail && !loadObject.loading ) {
                    loadObject.loading = true
                    self.autoload?(cell, loadObject)
                }
        }
    }
}


extension GLLoadMoreTableViewController {
    func pullDownToRefresh() {
        self.tableViewModel?.load()
    }


    func reloadData() {
        self.tableViewModel?.load()
    }


    // MARK: States

    func tableShowErrorNotificationView() {
        //TODO
    }

    func tableShowNoDataView() {
        SVProgressHUD.showInfoWithStatus("No data")
    }


    func tableShowErrorView(error: NSError) {
        SVProgressHUD.showErrorWithStatus(error.localizedDescription)
    }


    func tableShowLoadingView() {
        SVProgressHUD.showWithStatus("Loading")
    }


    func tableHideStateView() {
        SVProgressHUD.dismiss()
    }


    func retryAction() {
        self.tableViewModel?.load()
    }
}


protocol GLActionsFactoryProtocol {
    func actions() -> GLActions
}


class GLLoadMoreTableActionFactory: GLActionsFactoryProtocol {
    
    private var autoload: ((UITableViewCell, AnyObject) -> Void)?
    private weak var controller: GLLoadMoreTableViewController!
    
    init(controller: GLLoadMoreTableViewController, autoload:((UITableViewCell, AnyObject ) -> Void)?) {
        self.autoload = autoload
        self.controller = controller
    }
    
    func actions() -> GLActions {
        return GLLoadMoreActions(controller: controller, autoload: autoload)
    }
}


class GLTableActionFactory: GLActionsFactoryProtocol {
    func actions() -> GLActions {
        return GLActions()
    }
}

