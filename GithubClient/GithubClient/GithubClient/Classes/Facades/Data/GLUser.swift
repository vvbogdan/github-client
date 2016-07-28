//
// Created by Vitalii Bogdan on 7/26/16.
// Copyright (c) 2016 vbogdan. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GLUser {
    let uid: NSNumber?
    let login: String?
    let avatarURL: String?
    let followersURL: String?
    let profileURL: String?
}

// MARK:- JSON Parsing

extension GLUser {
    static func create(json: JSON) -> GLUser? {
        if let uid = json["id"].number {

            let login = json["login"].string
            let avatarURL = json["avatar_url"].string
            let followersURL = json["followers_url"].string
            let profileURL = json["html_url"].string

            return GLUser(
                    uid: uid,
                    login: login,
                    avatarURL: avatarURL,
                    followersURL: followersURL,
                    profileURL: profileURL
            )
        }
        return nil
    }
}


protocol GLUserProtocol {

    var uid: NSNumber? {get}
    var login: String? {get}
    var avatarURL: String? {get}
    var followersURL: String? {get}
    var profileURL: String? {get}

}

extension GLUser: GLUserProtocol {

}
