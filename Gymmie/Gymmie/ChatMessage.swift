//
//  ChatMessage.swift
//  Gymmie
//
//  Created by Blake Rogers on 9/28/16.
//  Copyright © 2016 T3. All rights reserved.
//

import Foundation

class ChatMessage: NSObject, NSCoding {
    var message_id: String?
    var fromID: String?
    var message: String?
    var convoID: String?
    var image_URL: String?
    var image_height: NSNumber?
    var image_width: NSNumber?
    var timeStamp: NSNumber?
    
    override init(){
    
    }
    convenience init(date: TimeInterval, message: String?,url: String?){
        self.init()
        self.message = message
        self.image_URL = url
        self.timeStamp = NSNumber(value: date)
//        guard let chatterID =  Auth.auth().currentUser?.uid else{
//            return
//        }
//
//        self.fromID = chatterID
      
    }
    func encode(with aCoder: NSCoder){
        aCoder.encode(convoID, forKey: "convoID")
        aCoder.encode(message, forKey: "message")
        aCoder.encode(fromID, forKey:"fromID")
        aCoder.encode(image_URL, forKey: "image_URL")
        aCoder.encode(image_height, forKey: "image_height")
        aCoder.encode(image_width,forKey:"image_width")
        aCoder.encode(timeStamp, forKey: "timeStamp")

        
    }
    
    
    required init(coder aDecoder: NSCoder){
        super.init()
        self.convoID = aDecoder.decodeObject(forKey: "convoID") as? String
        self.message = aDecoder.decodeObject(forKey: "message") as? String
        self.fromID = aDecoder.decodeObject(forKey: "fromID") as? String
        self.image_URL = aDecoder.decodeObject(forKey: "image_URL") as? String
        self.image_height = aDecoder.decodeObject(forKey: "image_height") as? NSNumber
        self.image_width = aDecoder.decodeObject(forKey: "image_width") as? NSNumber
        self.timeStamp = aDecoder.decodeObject(forKey: "timeStamp") as? NSNumber
    
    }
}
