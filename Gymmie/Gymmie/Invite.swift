//
//  Invite.swift
//  Gymmie
//
//  Created by Blake Rogers on 10/2/16.
//  Copyright © 2016 T3. All rights reserved.
//

import Foundation
class Invite: NSObject, NSCoding{
    var id:NSNumber?
    var user_id: NSNumber?
    var workout_id:NSNumber?
    var status: String?
    var created_at: String?
    var updated_at:String?
    var partner_id:NSNumber?
    var user_profile_id: NSNumber?
    var url: String?
    var timeSinceInvite: String{
        guard var inviteDate = created_at else{
            return ""
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        inviteDate.characters.removeLast(5)
       
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = formatter.date(from: inviteDate)
        let formattedDate = MyCalendar.timeSinceEvent(onDate: date!)
        return formattedDate
    }
    func encode(with aCoder: NSCoder) {
        if let idInt = id as? Int{
             aCoder.encode(idInt, forKey: "id")
        }
        if let userIDInt = user_id as? Int{
            aCoder.encode(userIDInt, forKey: "user_id")
        }
        if let workoutIDInt = workout_id as? Int{
             aCoder.encode(workoutIDInt, forKey: "workout_id")
        }
        if let userProfileIDInt = user_profile_id as? Int{
            aCoder.encode(userProfileIDInt, forKey: "user_profile_id")
        }
        if let partnerIDInt = partner_id as? Int{
             aCoder.encode(partnerIDInt, forKey: "partner_id")
        }
        aCoder.encode(status, forKey: "status")
        aCoder.encode(created_at, forKey: "created_at")
        aCoder.encode(updated_at, forKey: "updated_at")
        aCoder.encode(url, forKey: "url")
    }
    
    override init(){
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        
        self.id = aDecoder.decodeObject(forKey: "id") as? NSNumber
        self.user_id = aDecoder.decodeObject(forKey: "user_id") as? NSNumber
        self.workout_id = aDecoder.decodeObject(forKey: "workout_id") as? NSNumber
        self.status = aDecoder.decodeObject(forKey: "status") as? String
        self.created_at = aDecoder.decodeObject(forKey: "created_ at") as? String
        self.updated_at = aDecoder.decodeObject(forKey: "updated_at") as? String
        self.partner_id = aDecoder.decodeObject(forKey: "partner_id") as? NSNumber
        self.user_profile_id = aDecoder.decodeObject(forKey: "user_profile_id") as? NSNumber
        self.url = aDecoder.decodeObject(forKey: "url") as? String
        
    }
    
}
