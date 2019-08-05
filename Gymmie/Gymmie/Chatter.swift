//
//  Chatter.swift
//  Gymmie
//
//  Created by Blake Rogers on 9/28/16.
//  Copyright © 2016 T3. All rights reserved.
//

import Foundation
class Chatter: NSObject{
    var email: String?
    var name: String?
    var first_name: String?
    var last_name: String?
    var profile_id: NSNumber?
    var image_URL: String?
    var user_id: NSNumber?
    var device: String?
    var chat_id: String?
    var fireToken: String?
    var cover_URL: String?
    var chatterID: String?
    var rating: NSNumber?
    
    var gymUser: GymmieUser{
        var user = GymmieUser()
            user.firstName = first_name ?? name
            user.lastName = last_name
            user.userID = user_id?.intValue
            user.imageURL = image_URL
    return user
    }
}
