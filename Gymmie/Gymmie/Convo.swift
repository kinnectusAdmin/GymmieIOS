//
//  Convo.swift
//  Gymmie
//
//  Created by Blake Rogers on 8/2/16.
//  Copyright © 2016 T3. All rights reserved.
//

import Foundation
import UIKit
//import Firebase
//import FirebaseAuth
//import FirebaseStorage
//import FirebaseDatabase
protocol ConvoDelegate{
    func updateConvo()
}
class Convo: NSObject, NSCoding{
    var convoDelegate: ConvoDelegate?
    var conversantIDs =  [String]()
    var convoID =  String()
    var messageIDs = [String: Bool]()
    var messageReferences: [String]?{
        let keys = messageIDs.map({key,value in return key})
        return keys
    }
    var workoutIDs = [String]()
    var messages = [ChatMessage]()
    func encode(with aCoder: NSCoder){
        aCoder.encode(conversantIDs, forKey: "conversantIDs")
        aCoder.encode(messages, forKey: "messages")
        aCoder.encode(convoID, forKey: "convoID")
    }
    
    override init(){
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        self.conversantIDs = aDecoder.decodeObject(forKey: "conversantIDs") as? [String] ?? []
        self.messages = aDecoder.decodeObject(forKey: "messages") as? [ChatMessage] ?? []
        self.convoID = aDecoder.decodeObject(forKey: "convoID") as? String ?? ""
        }

func sendImageMessage(url: String, width: NSNumber, height: NSNumber,timeStamp:String){
//    let firDatabase = Database.database().reference()
//    let messageReference = firDatabase.child("Messages")
//        messageReference.keepSynced(true)
//  
//    guard let currentUser = Auth.auth().currentUser?.uid else{
//        return
//        }
//
//    var userReferences = [String: DatabaseReference]()
//    var userChatterIDs = [String:[String]]()
//    let convoReference = firDatabase.child("User_Messages").child(convoID)
//        convoReference.keepSynced(true)
//   
//    let object: [String:Any] = ["fromID":currentUser,"image_URL":url,"image_width":width,"image_height":height,"timeStamp":timeStamp,"convoID":convoID]
//    
//        messageReference.childByAutoId().updateChildValues(object, withCompletionBlock: {
//        (error,ref) in
//        let key = ref.key
//      
//        convoReference.child("messageIDs").updateChildValues([key:true])
//        })
    }
    
    func sendTextMessage(message: ChatMessage){
//        let firDatabase = Database.database().reference()
//        let messageReference = firDatabase.child("Messages")
//        let timeStamp = message.timeStamp!.stringValue
//        guard let currentUser = Auth.auth().currentUser?.uid else{
//            return
//        }
//        let convoReference = firDatabase.child("User_Messages").child(convoID)
//            convoReference.keepSynced(true)
//
//        let object: [String:Any] = ["message":message.message!,"fromID":currentUser,"timeStamp":timeStamp,"convoID":convoID]
//
//        messageReference.childByAutoId().updateChildValues(object, withCompletionBlock: {
//            (error,ref) in
//            let key = ref.key
//            convoReference.child("messageIDs").updateChildValues([key:true])
//        })
    }
    
    func observeConvo(){
//        let firDatabase = Database.database().reference()
//        let messageReference = firDatabase.child("Messages")
//        
//        guard let chatterID = Auth.auth().currentUser?.uid else{return}
//        
//        let convoReference = firDatabase.child("User_Messages").child(convoID).child("messageIDs")
//        convoReference.observe(.childAdded, with: {
//            snapshot in
//            
//            let newMessageID = snapshot.key
//            self.messageIDs.updateValue(true, forKey: newMessageID)
//            
//            messageReference.child(newMessageID).observeSingleEvent(of: .value, with: {messageSnap in
//                guard  let messageObject = messageSnap.value as? [String: AnyObject] else{
//                    return
//                }
//                
//                let chatMessage = ChatMessage()
//                    chatMessage.setValuesForKeys(messageObject)
//                
//                if !self.messages.contains(chatMessage){
//                    self.messages.append(chatMessage)
//                    
//                }
//                
//                self.convoDelegate?.updateConvo()
//            
//            })
//        })
//        
    }
}
