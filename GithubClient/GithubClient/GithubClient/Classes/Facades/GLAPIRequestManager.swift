//
// Created by Vitalii Bogdan on 7/26/16.
// Copyright (c) 2016 vbogdan. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Alamofire
import SwiftyJSON

protocol GLAPIRequestManagerProtocol {
    func getUsers(lastId: Int, limit: Int) -> SignalProducer<[GLUserProtocol]?, NSError>
    func getFollowersForUser(user: GLUserProtocol, page: Int) ->
            SignalProducer<[GLUserProtocol]?, NSError>
}

class GLAPIRequestManager: GLAPIRequestManagerProtocol {

    private func getUsersWithUrl(url: String, parameters:[String:AnyObject]) -> SignalProducer<[GLUserProtocol]?, NSError> {
        return SignalProducer<[GLUserProtocol]?, NSError> { observer, disposable in
            Alamofire.request(.GET, url, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    guard let data = response.data, json = JSON(data: data).array else {
                        observer.sendNext([])
                        observer.sendCompleted()
                        return;
                    }

                    observer.sendNext(json.flatMap(GLUser.create))
                    observer.sendCompleted()

                case .Failure(let error):
                    observer.sendFailed(error)
                }
            }
        }
    }

    func getUsers(lastId: Int, limit: Int) -> SignalProducer<[GLUserProtocol]?, NSError> {
        return self.getUsersWithUrl("https://api.github.com/users", parameters: ["since": lastId, "per_page": limit])
    }


    func getFollowersForUser(user: GLUserProtocol, page: Int) ->
            SignalProducer<[GLUserProtocol]?, NSError> {
        guard let followersURL = user.followersURL else {
            return SignalProducer<[GLUserProtocol]?, NSError> {
                observer, disposable in
                observer.sendFailed(NSError(domain: "No followersURL", code: 0, userInfo: [:]))
            }
        }
        return self.getUsersWithUrl(followersURL, parameters: ["page": page])
    }

}


class APIRequestManagerLocator {
    private static var manager: GLAPIRequestManagerProtocol = GLAPIRequestManager()

    static func populateWithManager(manager: GLAPIRequestManagerProtocol) {
        APIRequestManagerLocator.manager = manager
    }

    static var sharedManager: GLAPIRequestManagerProtocol {
        return APIRequestManagerLocator.manager
    }
}

