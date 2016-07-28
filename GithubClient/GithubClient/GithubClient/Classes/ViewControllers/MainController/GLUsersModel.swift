//
// Created by Vitalii Bogdan on 7/26/16.
// Copyright (c) 2016 vbogdan. All rights reserved.
//

import Foundation
import ReactiveCocoa

class GLUsersModel: GLLoadMoreTableModel {

    internal var disposable: Disposable?

    func sendRequest(more: Bool) -> SignalProducer<[GLUserProtocol]?, NSError> {
        
        var lastId: Int = 0
        
        if ( more ) {
            if let items = self.items() {
                let object: GLItemObject<GLUserProtocol>? = items[items.count - 2] as? GLItemObject<GLUserProtocol> // last - loading object
                lastId = object?.object.uid?.integerValue ?? 0
            }
        }

        let requestsManager = APIRequestManagerLocator.sharedManager
        return requestsManager.getUsers(lastId, limit: numberOfPage)
    }

    override func load(more: Bool) {
        super.load(more)

        //cancel previus a request
        if let disposable = disposable {
            disposable.dispose()
        }

        disposable = sendRequest(more)
        .on(failed: {[weak self] (responseError: NSError) in
            self?.responseError(responseError, more: more)
        }, next: {[weak self] users in
            var items = [GLItemObject<GLUserProtocol>]()
            if let users = users {
                for user in users {
                    let item = GLItemObject<GLUserProtocol>(
                            object: user,
                            cell: GLUserCell.self)
                    items.append(item)
                }
            }

            self?.responseSuccess(items, more: more)
        })
        .start()

    }

}
