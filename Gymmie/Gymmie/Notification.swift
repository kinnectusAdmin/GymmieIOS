//
//  Notification.swift
//  Gymmie
//
//  Created by Blake Rogers on 8/2/16.
//  Copyright © 2016 T3. All rights reserved.
//

import Foundation
import UIKit
class Notification{
    var invite: Invite?
    var notfication: String?
    var type: String?
    var relevantUser: GymmieUser?
    var relevantUserPicURL: String?
    var relevantUSerPic: UIImage?
    var notificationTask: URLSessionTask?
    var workout: Event?
    var timeStamp: Date?
    init(){
        
    }
    init(type: String, sender: GymmieUser, notification: String, atTime: Date){
        self.type = type
        self.relevantUser = sender
        self.notfication = notification
        self.timeStamp = atTime
        
    }
}
