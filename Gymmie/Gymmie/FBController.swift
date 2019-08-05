////
////  FBController.swift
////  Gymmie
////
////  Created by Blake Rogers on 9/13/16.
////  Copyright © 2016 T3. All rights reserved.
////
//
//
import UIKit
//import FBSDKCoreKit
//import FBSDKLoginKit
//import FacebookShare
//import FacebookCore
//import FBSDKShareKit
//import Firebase
//import FirebaseAuth
//import FirebaseDatabase

protocol FBControllerDelegate{
    func foundNewUser(user: GymmieUser)
    func foundCurrentUser(user: GymmieUser)
    func failedToFindUser(error: String)
    func setSwitchFalse()
    func setSwitchTrue()
    func placeName(name:String)
    func permissionRemoved()
    func postError(error: NSError)
    func postSuccessful()
    
}
class FBController : NSObject {
//    var delegate: FBControllerDelegate?
//    convenience init(delegate: FBControllerDelegate?){
//        self.init()
//        self.delegate = delegate
//    }
//    var checkAccessToken: Bool{
//        return AccessToken.current == nil
//    }
    
   
    func setGetUserHandler(){
        
//        handler = {
//            (connection: FBSDKGraphRequestConnection?, result: Any? , error: Error?)->Void in
//
//            if error == nil{
//                var gymmieUser = GymmieUser()
//                if let fbResult  = result as? [String: AnyObject]{
//                    let keys = fbResult.keys
//                    //print(fbResult)
//                    let id = fbResult["id"] as! String
//                    gymmieUser.fbID = id
////                    self.getPhotos(for: id)
////                    self.getAlbums()
////                    self.getFriends(for: id)
//                    //self.getBio(for: id)
//                    if let picture = fbResult["picture"] as? [String: AnyObject]{
//                        //keys are data, url/ and is_silhouette
//                        if let data = picture["data"] as? [String:AnyObject]{
//                            let imagePath = data["url"] as! String
//                            let imageURL = URL(string: imagePath)
//                            let data = try! Data(contentsOf: imageURL!)
//                            let image = UIImage(data: data)
//                            gymmieUser.imageURL = "https://graph.facebook.com/\(id)/picture?type=large"
//                            gymmieUser.image = image
//                            //store the image url in gymmie user object and get userimage also
//                        }
//                    }
//
//                    if let lastName = fbResult["last_name"] as? String{
//                        print(lastName)
//                        gymmieUser.lastName = lastName
//                    }
//
//                    if let link = fbResult["link"] as? String{
//                        gymmieUser.fbURL = link
//                        print(link)
//                    }
//
//                    if let firstName = fbResult["first_name"] as? String{
//                        print(firstName)
//                        gymmieUser.name = firstName
//                        gymmieUser.firstName = firstName
//
//                    }
//
//                    if let gender = fbResult["gender"] as? String{
//                        gymmieUser.gender = gender
//                        print("found gender")
//                    }
//
//                    if let friendList = fbResult["friendlists"] as? [String:Any]{
//                        if let friends = friendList["data"] as? [[String:Any]]{
//                            print(friends)
//                        }
//                    }
//                    if let photoColl = fbResult["photos"] as? [String:AnyObject]{
//
//                        if let photos = photoColl["data"] as? [[String: AnyObject]]{
//
//                            let images = photos.map({$0["images"]})
//
//                            print(images)
//                        }
//                    }
//                    if let bday = fbResult["birthday"] as? String{
//                        let formatter = DateFormatter()
//                            formatter.locale = Locale(identifier: "en_US_POSIX")
//                            formatter.timeZone = TimeZone(secondsFromGMT: 0)
//                            formatter.dateFormat = "MM/dd/yyyy"//"yyyy-MM-dd'T'HH:mm:ss"
//                        if let date = formatter.date(from:bday){
//                            gymmieUser.age =  MyCalendar.yearsSince(date: date)
//
//                        }
//                    }
//                    if let email = fbResult["email"] as? String{
//                        gymmieUser.email = email
//
//                        }else{
//                             gymmieUser.email = id+"@facebook.com"
//                            }
//                        let defaults = UserDefaults.standard
//
//
////                    guard let localUser = defaults.dictionary(forKey: email) else{
////                        let userData = NSKeyedArchiver.archivedData(withRootObject: gymmieUser)
////                        defaults.set(userData, forKey: FBPermissions.fbUser)
////                        self.delegate?.foundNewUser(user: gymmieUser)
////                        return
////                    }
////
//                    let userData = NSKeyedArchiver.archivedData(withRootObject: gymmieUser)
//                    defaults.set(userData, forKey: FBPermissions.fbUser)
//                        self.delegate?.foundCurrentUser(user: gymmieUser)
//                }
//            }else{
//                if let errMsg = error?.localizedDescription{
//                self.delegate?.failedToFindUser(error: errMsg)
//                }
//            }
//        }
    }
    
    func getAlbums(){
//       var req = GraphRequest(graphPath: "me", parameters: ["field":"albums.limit(2){photos.limit(2){picture}"], accessToken: AccessToken.current , httpMethod: .GET, apiVersion: .defaultVersion)
//        req.start({ response, result in
//            switch result{
//            case .failed(let error):
//                print(error.localizedDescription)
//            case .success(response: let fbResponse):
//                if let images = fbResponse.stringValue{
//                    print(images)
//                }
//                if let images = fbResponse.arrayValue{
//                    print(images)
//                }
//               if let images = fbResponse.dictionaryValue{
//                if let data = images["data"] as? [[String:Any]]{
//                    for album in data{
//                        if let id = album["id"] as? String{
//                            self.getPhotos(for: id)
//                        }
//                        }
//                    }
//
//                }
//            }
//        })
    }
    func getBio(for user: String){
//        print(user)
//        var req = GraphRequest(graphPath: "/\(user)/bio", parameters: [:], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
//        req.start({response,result in
//            switch result{
//            case .failed(let error):
//                print(error.localizedDescription)
//            case .success(response: let response):
//                print(response)
//            }
//
//        })
    }
    func getPhotos(for album:String){
//        var req = GraphRequest(graphPath: "\(album)", parameters: ["fields":"picture.type(large)"], accessToken: AccessToken.current , httpMethod: .GET, apiVersion: .defaultVersion)
//        req.start({ response, result in
//            switch result{
//            case .failed(let error):
//                print(error.localizedDescription)
//            case .success(response: let fbResponse):
//                if let images = fbResponse.stringValue{
//                    print(images)
//                }
//                if let images = fbResponse.arrayValue{
//                    print(images)
//                }
//                if let images = fbResponse.dictionaryValue{
//                    if let data = images["picture"] as? [String:Any]{
//                        print(data)
//                        if let imageData = data["data"] as? [String:Any]{
//                            if let url = imageData["url"] as? String{
//                                print(url)
//                            }
//                        }
//                    }
//
//                }
//            }
//        })
    }
    func getPhotoData(for photo: String){
//        var req = GraphRequest(graphPath: photo, parameters: ["fields":"picture"], accessToken: AccessToken.current , httpMethod: .GET, apiVersion: .defaultVersion)
//
//        req.start({ response, result in
//            switch result{
//            case .failed(let error):
//                print(error.localizedDescription)
//            case .success(response: let fbResponse):
//                if let images = fbResponse.stringValue{
//                    print(images)
//                }
//                if let images = fbResponse.arrayValue{
//                    print(images)
//                }
//
//                if let images = fbResponse.dictionaryValue{
//                    if let imageData = images["picture"] as? [String: Any]{
//                        if let data = imageData["data"] as? [String:Any]{
//                            if let urlPath = data["url"] as? String{
//                                if let url = URL(string: urlPath){
//                                    do{
//                                     let fbData = try Data(contentsOf: url)
//                                        let image = UIImage(data: fbData)
//                                        if let user = GymmieUser.currentUser(){
//
//                                        }
//                                    }catch{
//                                        print(error.localizedDescription)
//
//                                    }
//                                }
//                            }
//                        }
//                    }
//
//                }
//
//            }
//
//        })
//
    }
    func getFriends(for user: String){
       
//        var req = GraphRequest(graphPath: "\(user)/friendlists", parameters: ["field":"name"], accessToken: AccessToken.current , httpMethod: .GET, apiVersion: .defaultVersion)
//        req.start({ response, result in
//            switch result{
//            case .failed(let error):
//                print(error.localizedDescription)
//            case .success(response: let fbResponse):
//                if let images = fbResponse.stringValue{
//                    print(images)
//                }
//                if let images = fbResponse.arrayValue{
//                    print(images)
//                }
//                if let images = fbResponse.dictionaryValue{
//                    if let data = images["data"] as? [[String:Any]]{
//                        print(data)
//                    }
//
//                }
//            }
//        })
    }
    
    func getUser(){
//
//        setGetUserHandler()
//        FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"birthday,picture.type(large),first_name,last_name,email,gender,link"]).start(completionHandler: handler!)
    
    }
    

    
    
    func determinePermission(){
//
//        FBSDKAccessToken.refreshCurrentAccessToken(nil)
//
//        if FBSDKAccessToken.current().declinedPermissions.contains("publish_actions"){
//            self.delegate?.setSwitchFalse()
//
//        }else{
//            self.delegate?.setSwitchTrue()
//
//        }
        
    }
    func setRequestTokenHandler(){
       /* managerHandler = {(result: FBSDKLoginManagerLoginResult?,error: NSError?) in
            if error == nil{
                self.delegate?.setSwitchTrue()
                
            }else{
                print(error!.localizedDescription)
                self.delegate?.setSwitchFalse()
                
                
            }
            if result!.isCancelled{
                self.delegate?.setSwitchFalse()
                
            }
        }*/
    }
//    var managerHandler: FBSDKLoginManagerRequestTokenHandler?
    
    func grantPublishPermissions(vc: UIViewController){
//        let manager = FBSDKLoginManager()
//        manager.logIn(withPublishPermissions: ["publish_actions"],  from: vc, handler: managerHandler!)
    }
    func setPostHandler(){
/*        handler = {(connection: FBSDKGraphRequestConnection?, result: AnyObject?,error: NSError?) in
        if error == nil{
            self.delegate?.postSuccessful()
        }else{
            self.delegate?.postError(error!)
            
            
            }
        }*/
    }
//    var handler: FBSDKGraphRequestHandler?
    func tryPost(message: String){
//        if FBSDKAccessToken.current() != nil{
//            setPostHandler()
//            FBSDKGraphRequest(graphPath: "me/feed", parameters: ["message": message], httpMethod: "POST").start(completionHandler: handler)
//        }
    }
    func tokenChanged(notification:NSNotification){
        print("token changed")
        
    }
    
    
    func setRemovePublishHandler(){
        
   /*     removePublishHandler = {(connection: FBSDKGraphRequestConnection?,result:AnyObject?,error: NSError?) in
        if error == nil{
            FBSDKAccessToken.refreshCurrentAccessToken(nil)
            
            print("removed publish permission")
            self.delegate?.permissionRemoved()
            
            
        }else{
            print(error?.localizedDescription)
            }
        }*/
    }
    func removePublishPermission(){
//        FBSDKGraphRequest(graphPath: "me/permissions/publish_actions", parameters: nil, httpMethod: "DELETE").start(completionHandler:handler!)
    }
    func logOutUser(){
//        let manager = FBSDKLoginManager()
//            manager.logOut()
//        FBSDKProfile.setCurrent(nil)
            
    }
}
