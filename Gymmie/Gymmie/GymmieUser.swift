//
//  GymmieUser.swift
//  Gymmie
//
//  Created by Blake Rogers on 7/31/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase



class GymmieUser:  NSObject, NSCoding{
   
    var isFacebookUser: Bool{
        return fbURL != nil
    }
    var lastSignIn: Date?
    var fbID: String?
    var fbURL: String?
    var fbEmail: String?
    var email = String()
    var age: Int?
    var password: String?
    var userID: Int?
    var profileID: Int?
 
    var gender: String?
    var name: String?
    var firstName: String?
    var lastName: String?
    
    var fullName: String{
        return "\(firstName ?? "") \(lastName ?? "")"
    }
    
    var image: UIImage?
    var fbImages: [UIImage]?
    var imageURL: String?
    var dataURL: String?
    var bio = String()
    var partnerPreferences = String()
    var workoutConsiderations = String()
    var rating: Double?
    var userType: String?
    var fitnessLevel = String()
    var fitnessGoals = [String]()
    var events: [Event]?
    var isAMatch: Bool = false
    var gym: String?
    var monitoringLocation: Bool = false
    var conversations: [Convo]?
    var privacySettings: [String:String]?
    var matchPreferences: [String: String]?
    var menOnly: Bool = false
    var womenOnly: Bool = false
    
    func session()-> URLSession{
        
        let sessDefined = Foundation.URLSession.shared
        
        return sessDefined
    }
    
    func getImageHandler(data: Data?,response: URLResponse?,error: Error?){
        
        if error == nil{
            if let dataImage = UIImage(data: data!){
                
                imageCache.setObject(dataImage, forKey: response!.url!.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    self.image = dataImage
                }
            }
        }else{
            print(error?.localizedDescription)
        }
    }
    func getImage(){
        if let image = imageCache.object(forKey: imageURL as AnyObject){
            DispatchQueue.main.async {
                self.image = image as UIImage
                
            }
            
        }else{
            let url = URL(string:imageURL ?? "")
            if url != nil{
                var task = session().dataTask(with: url!, completionHandler: getImageHandler)
                task.resume()
            }
        }

    }
    func updateSettings(_ location:Bool, fb: Bool, men: Bool, women: Bool,all:Bool, radius: Float){
        var settingsDict = [String:String]()
            settingsDict.updateValue(location.description, forKey: "location")
            settingsDict.updateValue(fb.description, forKey: "fb")
            settingsDict.updateValue(men.description, forKey: "women")
            settingsDict.updateValue(all.description, forKey: "all")
            settingsDict.updateValue(String(radius), forKey: "radius")
        data = AppDatabase()
    }
    
 
    
    static func currentUser()-> GymmieUser?{
        let defaults = UserDefaults.standard
        guard let currentUser = defaults.string(forKey: "currentUser") else{
            return nil
        }
        
        let userDict = defaults.dictionary(forKey: currentUser)
        
        guard let userData = userDict?["user"] as? Data else{
            return nil
            }
        let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as! GymmieUser
            return user
        
    }
    
    weak var data: AppDatabase?
    
    func updateCurrentUser(server:Bool){
        if let urlPath = imageURL{
                if let url = URL(string: urlPath){
                    do{
                        let data = try Data(contentsOf: url)
                        let image = UIImage(data: data)
                        self.image = image
                    }catch{
                        
                    }
                }
        }
        
        let defaults = UserDefaults.standard
        guard let currentUser = defaults.string(forKey: "currentUser") else { return}
        var userDict = defaults.dictionary(forKey: currentUser)
    
        let userData = NSKeyedArchiver.archivedData(withRootObject: self)
            userDict?.updateValue(userData, forKey: "user")
        defaults.set(userDict, forKey: currentUser)
        defaults.synchronize()
      
        if server{
        let data = AppDatabase()
            data.updateUserInfo(for: self)
        }
        
    }
    static func inviteUser(toWorkout workout: Event){
        //invite user to a certain workout
        //locally update the local list for users workouts when the confirmation
//        let database = AppDatabase()
//            database.inviteUser(someUser, toEvent: someEvent)
        
    }
    
    func removeConversations(){
        conversations = nil
        updateCurrentUser(server:false)
    }

   func removeWorkout(_ workout: Event){
    let data = AppDatabase()
        data.cancelEvent(event: workout)
    }
 
    override init() {
    }

    
  required init(coder aDecoder: NSCoder){
        
        let defaultPrivacySetting = ["Settings":"Public"]
        let defaultMatchPreferences = ["allMatches":"true","location":"10"]
        super.init()
        if let imageData = aDecoder.decodeObject(forKey: "imageData") as? Data{
            self.image = UIImage(data: imageData)
        }
        self.age = aDecoder.decodeObject(forKey: "age") as? Int
        self.lastSignIn = aDecoder.decodeObject(forKey: "lastSignIn") as? Date
        self.password = aDecoder.decodeObject(forKey: "password") as? String
        self.gender = aDecoder.decodeObject(forKey: "gender") as? String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        self.imageURL = aDecoder.decodeObject(forKey: "imageURL") as? String
        self.dataURL = aDecoder.decodeObject(forKey: "dataURL") as? String
        self.profileID = aDecoder.decodeObject(forKey: "profileID") as? Int
        self.fbID = aDecoder.decodeObject(forKey: "fbID") as? String
        self.fbURL = aDecoder.decodeObject( forKey: "fbURL") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        self.userID = aDecoder.decodeObject(forKey: "userID") as? Int
        self.bio = aDecoder.decodeObject( forKey: "bio") as! String
        self.userType = aDecoder.decodeObject( forKey: "userType")  as? String ?? "normal"
        self.fitnessLevel = aDecoder.decodeObject(forKey: "fitnessLevel") as! String
        self.fitnessGoals = aDecoder.decodeObject(forKey: "fitnessGoals") as? [String] ?? []
        self.events = aDecoder.decodeObject(forKey: "events") as? [Event] ?? []
        self.gym = aDecoder.decodeObject(forKey: "gym") as? String ?? ""
        self.monitoringLocation = aDecoder.decodeBool(forKey: "monitoringLocation") as? Bool ?? false
        self.conversations = aDecoder.decodeObject(forKey: "conversations") as? [Convo]
        self.workoutConsiderations = aDecoder.decodeObject(forKey: "workoutConsiderations") as? String ?? ""
        self.partnerPreferences = aDecoder.decodeObject(forKey: "partnerPreferences") as? String ?? ""
        self.menOnly = aDecoder.decodeBool(forKey: "menOnly")
        self.womenOnly = aDecoder.decodeBool(forKey: "womenOnly")
    
    
    }
func encode(with aCoder: NSCoder){
    if let userImage = image{
        let imageData = UIImagePNGRepresentation(userImage)
        aCoder.encode(imageData, forKey: "imageData")
    }
        aCoder.encode(age ?? "", forKey: "age")
        aCoder.encode(workoutConsiderations, forKey: "workoutConsiderations")
        aCoder.encode(partnerPreferences, forKey: "partnerPreferences")
        aCoder.encode(lastSignIn, forKey: "lastSignIn")
        aCoder.encode(events, forKey: "events")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(profileID, forKey: "profileID")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(imageURL, forKey: "imageURL")
        aCoder.encode(dataURL, forKey: "dataURL")
        aCoder.encode(fbURL, forKey: "fbURL")
        aCoder.encode(fbID,forKey: "fbID")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(userID, forKey: "userID")
        aCoder.encode(bio, forKey: "bio")
        aCoder.encode(rating ?? 5, forKey: "rating")
        aCoder.encode(userType, forKey: "userType")
        aCoder.encode(fitnessLevel, forKey: "fitnessLevel")
        aCoder.encode(fitnessGoals, forKey: "fitnessGoals")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(monitoringLocation, forKey: "monitoringLocation")
        aCoder.encode(gym , forKey: "gym")
        aCoder.encode(conversations, forKey: "conversations")
        aCoder.encode(menOnly, forKey: "menOnly")
        aCoder.encode(womenOnly, forKey: "womenOnly")
    }

}

extension GymmieUser: DatabaseUserDelegate{
    internal func fetchedUserWorkouts(workouts: [Event]) {
        events = workouts
        if userID == GymmieUser.currentUser()?.userID {
            updateCurrentUser(server:false)
        }
        
    }

    internal func fetchedInvites(invites: [Invite]) {
        
    }

    func scheduledWorkout(withWorkout workout: Event) {
        if events != nil{
            events?.append(workout)
        }else{
            events = [workout]
        }
        
        updateCurrentUser(server:false)
    }
    func failedToGetData() {
        
    }
    func connectionFailed() {
        
    }
}
