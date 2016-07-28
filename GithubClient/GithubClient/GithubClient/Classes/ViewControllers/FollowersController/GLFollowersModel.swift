//
// Created by Vitalii Bogdan on 7/26/16.
// Copyright (c) 2016 vbogdan. All rights reserved.
//

import Foundation
import ReactiveCocoa

class GLFollowersModel: GLUsersModel {

    var user: GLUserProtocol!

    init(user: GLUserProtocol){
        self.user = user;
    }

    override func sendRequest(more: Bool) -> SignalProducer<[GLUserProtocol]?, NSError> {
        let numberOfPage = Float(self.offset) / Float(self.numberOfPage)
        let page = more ? roundf(numberOfPage) + 1 : 1
        let requestsManager = APIRequestManagerLocator.sharedManager
        return requestsManager.getFollowersForUser(user, page: Int(page))
    }
}
