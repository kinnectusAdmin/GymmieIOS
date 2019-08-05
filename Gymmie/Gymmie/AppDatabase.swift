
//
//  AppDatabase.swift
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
//import FBSDKLoginKit
//import FBSDKCoreKit
//import FacebookLogin
//import FacebookCore
//
//import Crashlytics
protocol DatabaseDelegate {
    func connectionFailed()
    func failedToGetData()
}
protocol ProfileDelegate: class{
    func foundUser(user: GymmieUser)
    //func fetchedPartnerWorkouts(workouts: [Event])
   
}

protocol DatabaseSignUpDelegate : class{
    func unauthorizedSignUp()
    func userSignUpSucceeded()
    func fbUserSignUpSucceeded()
    func userSignInSucceeded()
    func fbUserSignInSucceeded()
    
}

protocol DatabaseMatchesDelegate :class, DatabaseDelegate{
    func foundMatches(matches: [GymmieUser])
    func matchedWithUser(matched: Bool,user: GymmieUser)
  
   // func fetchedMatchesActivity(activities: [PartnerActivity])
}

protocol DatabaseWorkoutDelegate: class{
    func workoutCollection(workouts: [Workout])
    func fetchedUserWorkouts(workouts:[Event])
    func gymCollection(gyms: [Gym])
    func createdWorkout(workout: Event)
    func fetchedPartnerWorkouts(workouts: [Event])
    func fetchedInvites(invites: [Invite])
}

protocol DatabaseMessageDelegate: class,DatabaseDelegate{
    func messageSent()
   
}

protocol DatabaseUserDelegate: class, DatabaseDelegate{
    func scheduledWorkout(withWorkout workout: Event)
    func fetchedInvites(invites: [Invite])
}

protocol DatabaseChatDelegate: class{
    func foundChatters(chatters: [Chatter])
    func fetchedConvos(conversations: [Convo])
}

class AppDatabase: NSObject{
    let fbClientToken = "ba46cf3ed93c1099547a3d917f516d1e"
    let authenticateFBUserURL = "https://gymmie.herokuapp.com/authenticate?facebook_token"
    let createFBUserURL = "https://gymmie.herokuapp.com/user_create?facebook_token"
    let host = "https://gymmie.herokuapp.com"
    let createWorkoutURL = "https://gymmie.herokuapp.com/workouts.json?workout[user_id]={userID}&workout[name]={workoutName}&workout[day]={day}&workout[workout_type_id]={workoutTypeID}&workout[gym_id]={locationID}&workout[start_time]={startTime}&workout[end_time]={endTime}&workout[exercise]={exercises}"
    let updateWorkoutURL = "https://gymmie.herokuapp.com/workouts/{event_id}.json?workout[user_id]={userID}&workout[name]={workoutName}&workout[day]={day}&workout[workout_type_id]={workoutTypeID}&workout[gym_id]={locationID}&workout[start_time]={startTime}&workout[end_time]={endTime}&workout[exercise]={exercises}&workout[conversation_id]={convoID}"
    let workoutTypesURL = "https://gymmie.herokuapp.com/workout_types.json"
    let gymsURL = "https://gymmie.herokuapp.com/gyms.json"
    let authenticateUserURL = "https://gymmie.herokuapp.com/authenticate?"
    let createUserURL = "https://gymmie.herokuapp.com/user_create?first_name"
    let findPartnersURL = "https://gymmie.herokuapp.com/partners.json"
    let userRequestsURL = "https://gymmie.herokuapp.com/user_requests.json"
    let pendingRequestsURL = "https://gymmie.herokuapp.com/pending_requests.json"
    let findTrainerURL = "https://gymmie.herokuapp.com/trainer"
    let findClassURL = "https://gymmie.herokuapp.com/class"
    //let matchesURL = "https://gymmie.herokuapp.com/matches.json"
    let matchesURL = "https://gymmie.herokuapp.com/workouts/id/matches"
    let activityURL = "https://gymmie.herokuapp.com/friends_activity.json"
    let favoritesURL = "https://gymmie.herokuapp.com/user_favorites.json?user_favorite[user_id]=1&user_favorite[partner_id]=1&user_favorite[approved]=1"
    let blockUserURL = "https://gymmie.herokuapp.com/user_blocks.json?user_block[user_id]={user}&user_block[partner_id]={partner}&user_block[status]={block}"
    let inviteUserURL = "https://gymmie.herokuapp.com/user_requests.json?user_request[user_id]={}&user_request[partner_id]={}&user_request[workout_id]={}&user_request[status]=requested&user_request[start_time]={start}&user_request[end_time]={}?"
    let rateUserURL = "https://gymmie.herokuapp.com/user_ratings.json?user_rating[user_id]={userID}&user_rating[partner_id]={partnerID}&user_rating[rating]={rating}"
   
    weak var profileDelegate: ProfileDelegate?
    weak var workoutDelegate: DatabaseWorkoutDelegate?
    weak var matchesDelegate: DatabaseMatchesDelegate?
    weak var signUpDelegate: DatabaseSignUpDelegate?
    weak var messageDelegate: DatabaseMessageDelegate?
    weak var userDelegate: DatabaseUserDelegate?
    weak var chatDelegate: DatabaseChatDelegate?
    var session: URLSession = {
        let config = URLSessionConfiguration.default
        let queue = OperationQueue.main
        let sessDefined = Foundation.URLSession.shared
            //sessDefined.delegate = self
        return sessDefined
    }()
    
    var newUserSignIn: Bool = false
    var signedInFBUser: GymmieUser?{
            didSet{
              //update the storedFBUser with the id returned from gymmie
                let defaults = UserDefaults.standard
                let userData = defaults.data(forKey: FBPermissions.fbUser)
                let facebookUser = NSKeyedUnarchiver.unarchiveObject(with: userData!) as! GymmieUser
                    signedInFBUser?.fbID = facebookUser.fbID
                    signedInFBUser?.lastSignIn = Date()
                if signedInFBUser?.age == nil{
                    signedInFBUser?.age = facebookUser.age
                }
                if signedInFBUser?.imageURL == nil{
                    signedInFBUser?.imageURL = facebookUser.imageURL
                    //set the image here
                    signedInFBUser?.image = facebookUser.image
                    
                    let updatedUserData = NSKeyedArchiver.archivedData(withRootObject: signedInFBUser!)
                    var userDict = [String: AnyObject]()
                        userDict.updateValue(updatedUserData as AnyObject, forKey: "user")
                    defaults.set(userDict, forKey: signedInFBUser!.email)
                    defaults.set(signedInFBUser!.email, forKey: "currentUser")
                    defaults.synchronize()
                    GymmieUser.currentUser()?.updateCurrentUser(server: true)
                }else{
                    let updatedUserData = NSKeyedArchiver.archivedData(withRootObject: signedInFBUser!)
                    var userDict = [String: AnyObject]()
                    userDict.updateValue(updatedUserData as AnyObject, forKey: "user")
                    defaults.set(userDict, forKey: signedInFBUser!.email)
                    defaults.set(signedInFBUser!.email, forKey: "currentUser")
                  
                    defaults.synchronize()
                }
                
            
                //perform signup with firebase
                    createChatter(with: signedInFBUser!.email,
                                    id: signedInFBUser!.userID!,
                                    profile: signedInFBUser!.profileID!,
                                    firstName: signedInFBUser!.firstName!,lastName:signedInFBUser!.lastName!,
                                    imageURL: signedInFBUser!.imageURL!)
                
            }
        }
    func updateFIRUser(){
//        guard let userID = Auth.auth().currentUser?.uid else{
//             return
//        }
//            let userRef = Database.database().reference().child("Users").child(userID)
//                userRef.observeSingleEvent(of: .value , with: {
//                snapshot in
//                if let userObject = snapshot.value as? [String:Any]{
//                    let gymmieID = self.signedInFBUser!.userID!
//                    let profileID = self.signedInFBUser!.profileID!
//                    let email = self.signedInFBUser!.email
//                    let imageURL = self.signedInFBUser?.imageURL ?? ""
//                    let rating = self.signedInFBUser?.rating ?? 5.0
//                    let firstName = self.signedInFBUser!.firstName!
//                    let lastName = self.signedInFBUser!.lastName!
//                    let userData = ["chat_id":userID,"user_id":gymmieID,"profile_id":profileID,"email":email,"image_URL":imageURL,"first_name":firstName,"last_name":lastName] as [String : Any]
//
//                    let userRef =  Database.database().reference().child("Users").child(userID)
//                    userRef.updateChildValues(userData)
//                }else{
////                    self.createChatter(with: self.signedInFBUser!.email,
////                                       id: self.signedInFBUser!.userID!,
////                                       profile: self.signedInFBUser!.profileID!,
////                                       firstName: self.signedInFBUser!.firstName!,lastName:self.signedInFBUser!.lastName!,
////                                       imageURL: self.signedInFBUser!.imageURL!)
//                }
//            })
//

    }
        var signedInUser: GymmieUser?{
            didSet{
                
                signedInUser?.lastSignIn = Date()
                signedInUser?.password = password
                let defaults = UserDefaults.standard
                let gymmieData = NSKeyedArchiver.archivedData(withRootObject: signedInUser!)
    
                var user = [String: AnyObject]()
                    user.updateValue(gymmieData as AnyObject, forKey: "user")
    
                defaults.set(user, forKey: signedInUser!.email)
                defaults.set(signedInUser!.email, forKey: "currentUser")
                defaults.synchronize()
              
                
                if newUserSignIn{
                    createChatter(with: signedInUser!.email,
                                       id: signedInUser!.userID!,
                                       profile: signedInUser!.profileID!,
                                       firstName: signedInUser!.firstName!,lastName:signedInUser!.lastName!,
                                       imageURL: nil)
                }
            }
        }
    
    enum HeaderField: String{
        case Auth
        case JSON
        case None
        case POST
        case GET
        case PUT
        case DEL
    }
    
   static var authCode: String {
        let defaults = UserDefaults.standard
        if let code = defaults.string(forKey: "authCode"){
            return code
        }
        return ""
    }
    
    var deviceToken: String = {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "deviceToken") else{
            return ""
        }
        
      return token
    }()
    
    /* 
     "https://gymmie.herokuapp.com/workouts.json?workout[user_id]={userID}&workout[name]={workoutName}workout[workout_type_id]={workoutTypeID}&workout[gym_id]={locationID}&workout[start_time]={startTime}&workout[end_time]={endTime}&workout[exercises]={exercises}"
     */
    func list(for inputs:[String])->String{
        if inputs.isEmpty{
            return ""
        }
        var string = inputs.reduce("", {value1,value2 in
            return value1 + "," + value2
            
        })
        string.characters.remove(at: string.startIndex)
        
        return string
    }
    var addConvoHandler: SessionTaskHandler = {
        data,response, error in
        do{
            if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary{
                print(json)
            }
        }catch{
            
        }
    }
    func addConvoFor(event: Event, for user: GymmieUser){
        let timeStart = event.startHour
        let timeEnd = event.endHour
        let userID = user.userID!
        let exercises = list(for: event.exercises)
        let workoutPath = "https://gymmie.herokuapp.com/workouts/\(event.eventID).json?workout[user_id]=\(userID)&workout[conversation_id]=\(event.convoID)"
        makeRequestForPath(pathURL:workoutPath,handler: addConvoHandler, fields: .Auth,.JSON,.PUT)
    }
    func updateEvent(event: Event){
        let timeStart = event.startHour
        let timeEnd = event.endHour
        let userID = GymmieUser.currentUser()!.userID!
        let exercises = list(for: event.exercises)
        let workoutName = event.workoutName.isEmpty ? event.workout.type : event.workoutName
        let workoutPath = updateWorkoutURL.replace(strings: ["{event_id}","{userID}","{workoutName}","{day}","{workoutTypeID}","{locationID}","{startTime}","{endTime}","{exercises}","{convoID}"], with: ["\(event.eventID)","\(userID)",workoutName,event.dayOfWorkout,"\(event.workout.id)","\(event.gym.id)",timeStart,timeEnd,exercises,event.convoID]).replacingOccurrences(of: " ", with: "_")
           makeRequestForPath(pathURL:workoutPath,handler: updateEventHandler, fields: .Auth,.JSON,.PUT)
    }
    lazy var updateEventHandler: SessionTaskHandler = { (data,response,error) in
        if error == nil{
            do{
                if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as? [String: AnyObject]{
                    print(json)
                    //enter function for creating workout json response
                    if let serverError = json["error"] as? String{
                        return
                    }
                    self.updatedWorkout(workout: json)
                }
            }catch{
                print(error)
            }
        }else{
            
            print(error?.localizedDescription)
        }
    }
    
    func updatedWorkout(workout:[String:AnyObject]){
        guard let user = GymmieUser.currentUser() else{ return }
        let updatedWorkout = makeWorkout(workout: workout)
        if let plannedWorkouts = user.events{
            for (index, event) in user.events!.enumerated(){
                if event.eventID == updatedWorkout.eventID {
                    user.events!.remove(at: index)
                    user.events!.append(updatedWorkout)
                }
            }
        }
        user.updateCurrentUser(server:false)
    }
    func scheduleEvent(event: Event, for user: Int){
        let workoutURL = "https://gymmie.herokuapp.com/workouts.json?workout[user_id]={userID}&workout[name]={workoutName}&workout[day]={day}&workout[start_time]={startTime}&workout[end_time]={endTime}&workout[gym_id]={locationID}&workout[workout_type_id]={workoutTypeID}"
        let timeStart = event.startHour
        let timeEnd = event.endHour
      
        //let exercises = list(for: event.exercises)
        let workoutName = event.workoutName.isEmpty ? event.workout.type : event.workoutName
        let workoutPath = workoutURL.replace(strings:
            ["{userID}","{workoutName}","{day}","{startTime}","{endTime}","{locationID}","{workoutTypeID}"], with:
            ["\(user)",workoutName,event.dayOfWorkout,timeStart,timeEnd,"1","10"]).replacingOccurrences(of: " ", with: "_")
       
        makeRequestForPath(pathURL:workoutPath,handler: scheduleEventHandler, fields: .Auth,.JSON,.POST)
        
    }
    func gotUserInvites(inviteArray: [[String:Any]]){
        //var requests = [WorkoutRequest]()
        guard let userID = GymmieUser.currentUser()?.userID else{
            return
        }
        for requestObject in inviteArray{
            
            
            let requestID = requestObject["user_request_id"] as? NSNumber
            let user_id = requestObject["user_id"] as? NSNumber
            let user_profile_id = requestObject["user_profile_id"] as? NSNumber
            let first_name = requestObject["first_name"] as? String
            let last_name  = requestObject["last_name"] as? String
            let photo = requestObject["photo"] as? String
            let cover = requestObject["cover"] as? String
            let start_time = requestObject["start_time"] as? String
            let end_time = requestObject["end_time"] as? String
//            
//            var workoutRequest = WorkoutRequest(requestID: requestID, userID: user_id, profileID: user_profile_id, firstName: first_name, lastName: last_name, photo: photo, cover: cover, startTime: start_time, endTime: end_time)
//            
            if let workout = requestObject["workout"] as? [String:AnyObject]{
                let id = workout["id"] as? NSNumber
                let type = workout["type"] as? String
                let start_date = workout["start_date"] as? String
                let end_date = workout["end_date"] as? String
                let gym = workout["gym"] as? String
                let frequency = workout["frequency"] as? NSNumber
//                let  gymmieWorkout = GymmieWorkout(id: id, type: type, startDate: start_date, endDate: end_date, gym: gym,frequency: frequency)
//                workoutRequest.workout = gymmieWorkout
            }
//            requests.append(workoutRequest)
        }
        //notificationDelegate?.fetchedInvites(invites: requests)
    }
    
    lazy var pendingRequestsHandler: SessionTaskHandler = {
        data,response, error in
        if error != nil{
            return
        }
        do{
            if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String:Any]]{
                print(json)
                self.gotUserInvites(inviteArray: json)
            }
        }catch{
            
        }
    }
    
    func getPendingRequests(){
        makeRequestForPath(pathURL:pendingRequestsURL,handler: pendingRequestsHandler, fields: .Auth,.GET,.JSON)
    }

    lazy var scheduleEventHandler: SessionTaskHandler = { (data,response,error) in
        if error == nil{
            do{
                if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as? [String: AnyObject]{
                print(json)
                //enter function for creating workout json response
                    if let serverError = json["error"] as? String{
                        return
                    }
                self.createdWorkout(workout:json)
                }
            }catch{
               print(error)
            }
        }else{
            
            print(error?.localizedDescription)
        }
    }
    func getLocations(){
        makeRequestForPath(pathURL:gymsURL,handler: getLocationsHandler, fields: .Auth,.JSON,.GET)
    }
    
    lazy var getLocationsHandler: SessionTaskHandler = { (data,response,error) in
        if error != nil{
            print(error?.localizedDescription)
            return
        }
        
        do{
            if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as? NSArray{
                print(json)
                //enter function for getting workout json response
                self.retrievedLocations(locations:json)
            }
        }catch{
            
        }
    }
    
    func retrievedLocations(locations: NSArray){
        var locationArray = [Gym]()
        for location in locations as! [[String: AnyObject]]{
            let id = location["id"] as! Int
            let name = location["name"] as! String
            let gym = Gym(name: name,id: id)
            locationArray.append(gym)
        }
        workoutDelegate?.gymCollection(gyms: locationArray)
        
    }
    func getWorkouts(){
        makeRequestForPath(pathURL:workoutTypesURL,handler: getWorkoutsHandler, fields: .Auth,.JSON,.GET)
    }
    
    lazy var getWorkoutsHandler: SessionTaskHandler = { (data,response,error) in
        if error != nil{
            print(error?.localizedDescription)
            return
        }
    
        do{
            if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as? NSArray{
                print(json)
                //enter function for getting workout json response
                self.retrievedWorkouts(workouts:json)
            }
        }catch{
        
        }
    }
    
    func retrievedWorkouts(workouts: NSArray){
        var workoutArray = [Workout]()
        for workout in workouts as! [[String: AnyObject]]{
           let id = workout["id"] as! Int
            let type = workout["name"] as! String
            let exercise = Workout(type: type, id: id)
            workoutArray.append(exercise)
        }
         workoutDelegate?.workoutCollection(workouts: workoutArray)
    }
    
    lazy var updateInfoHandler: SessionTaskHandler = {
        (data,response,error) in
        if error != nil{
            return
        }
        do{
            let json = try JSONSerialization.jsonObject(with: data!,options:.mutableContainers)
                print(json)

            }catch{
                print(error)
            }
    }

    func updateEmail(email: String,newEmail:String, password: String){
        let emailURL = "https://gymmie.herokuapp.com/change_email?email=\(email)&password=\(password)&new_email=\(newEmail)"
        makeRequestForPath(pathURL:emailURL , handler: updateEmailHandler, fields: .Auth,.JSON,.POST)
    }
    
    lazy var updateEmailHandler: SessionTaskHandler = {
        (data,response, error) in
        if error != nil{
            print(error)
        }
        do{
            if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary{
                print(json)
            }
        }catch{
            
        }
    }
    
    func updatePassword(email: String, newPassword: String, oldPassword: String){
        
        let passwordURL = "https://gymmie.herokuapp.com/change_password?email=\(email)&password=\(oldPassword)&new_password=\(newPassword)"
        makeRequestForPath(pathURL: passwordURL, handler: passwordHandler, fields: .Auth,.POST,.JSON)
    }
    
    lazy var passwordHandler: SessionTaskHandler = {
        (data,response,error) in
        if error != nil{
            print(error)
        }
        do{
            if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary{
                print(json)
            }
        }catch{
            
        }
    }
    
    func updateUserInfo(for user: GymmieUser){
        var updateURL = "https://gymmie.herokuapp.com/update_profile.json?user_profile[user_id]=\(user.userID!)&user_profile[first_name]=\(user.firstName!)&user_profile[last_name]=\(user.lastName!)"
        
        if let age = user.age{
            updateURL.append("&user_profile[age]=\(user.age!)")
            }
        if user.bio != "Sort of a Mystery..."{
            updateURL.append("&user_profile[description]=\(user.bio.replacingOccurrences(of: " ", with: "_"))")
        }
        if !user.workoutConsiderations.isEmpty{
            updateURL.append("&user_profile[workout_considerations]=\(user.workoutConsiderations.replacingOccurrences(of: " ", with: "_"))")
        }
        if !user.partnerPreferences.isEmpty{
            updateURL.append("&user_profile[partner_preferences]=\(user.partnerPreferences.replacingOccurrences(of: " ", with: "_"))")
        }
        if !user.fitnessGoals.isEmpty && !user.fitnessGoals.contains(""){
            let goals = list(for: user.fitnessGoals).replacingOccurrences(of: " " , with: "_")
            updateURL.append("&user_profile[fitness_goals]=\(goals)")
        }
        if user.fitnessLevel != "Not Set"{
            updateURL.append("&user_profile[fitness_level]=\(user.fitnessLevel)")
        }
        
        if let imageURL = user.imageURL{
            updateURL.append("&user_profile[photo]=\(imageURL)")
        }
     
        
       
        makeRequestForPath(pathURL: updateURL, handler: updateInfoHandler, fields: .JSON,.Auth,.POST)
    }

    let messageHandler: SessionTaskHandler = {
        (data,response,error) in
        if error != nil{
            return
        }
        do{
            if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary{
                print(json)
            }
        }catch{
            
        }
    }
    
    func notify(notification: String, to user:Int, type:String ){
//        let userID = GymmieUser.currentUser()!.userID!
//       let messageURL =  "https://gymmie.herokuapp.com/send_message.json?message=\(notification)&message_type=\(type)&user_id=\(userID)&partner_id=\(user)"
//    let encodedMessage = messageURL.addingPercentEscapes(using: String.Encoding.utf8)
//        makeRequestForPath(pathURL: encodedMessage!, handler: messageHandler, fields: .JSON,.Auth,.GET)
        
    }
    
  lazy  var match_UnmatchUserHandler: SessionTaskHandler = {
        data,response,error in
        if error != nil{
            return
        }
        do{
            if let json = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers) as? NSDictionary{
                print(json)
                if let status = json["status"] as? String, let isMatched = json["is_matched"] as? Bool{
                    if status == "match" && isMatched{
                        if let userID = json["partner_id"] as? NSNumber, let workoutID = json["partner_workout_id"] as? NSNumber{
                        let photo = json["partner_profile_photo"]  as? String
                        let partner = GymmieUser()
                            partner.imageURL = photo
                            partner.userID = userID.intValue
                        let partnerWorkout = Event()
                            partnerWorkout.eventID = workoutID.intValue
                            partner.events = [partnerWorkout]
                            self.matchesDelegate?.matchedWithUser(matched: true,user: partner)

                        }
                    }
                }
            }
        }catch{
            
        }
    }
    
    
    func match_UnmatchUser(partner: GymmieUser,partnerEvent: Event, for event: Event, match: Bool){
        guard let userID = GymmieUser.currentUser()?.userID else{
            return
        }
 
        let matchReqURL = "https://gymmie.herokuapp.com/user_requests.json?user_request[user_id]=\(userID)&user_request[partner_id]=\(partner.userID!)&user_request[workout_id]=\(event.eventID)&user_request[partner_workout_id]=\(partnerEvent.eventID)&user_request[status]=\(match ? "match":"unmatch")"
      
        makeRequestForPath(pathURL: matchReqURL, handler: match_UnmatchUserHandler, fields: .POST,.Auth,.JSON)
        
    }
   
    lazy var submitRatingHandler: SessionTaskHandler = {
        data,response, error in
        if error != nil{
            return
        }
        
        do{
            if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary{
                print(json)
            }
            
        }catch{
            
        }
    }
    
    func submit(rating: Int, forUser user: Int){
        if let userID = GymmieUser.currentUser()?.userID{
        let rateUserPath = "https://gymmie.herokuapp.com/user_ratings.json?user_rating[user_id]=\(userID)&user_rating[partner_id]=\(user)&user_rating[rating]=\(rating)"
        makeRequestForPath(pathURL: rateUserPath, handler: submitRatingHandler, fields: .JSON,.POST,.Auth)
        }
    }

    let deleteEventHandler: SessionTaskHandler = {
        (data,response,error) in
        if error != nil{
            return
        }
        do{
            if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary{
                print(json)
            }
        }catch{
            
        }
    }
    
    func cancelEvent(event: Event){
//        let deleteURL = "https://gymmie.herokuapp.com/workouts/\(event.eventID).json"
//        makeRequestForPath(pathURL: deleteURL, handler: deleteEventHandler, fields: .JSON,.Auth,.DEL)
//
//        if event.convoID.isEmpty{
//            return
//        }
//        let convoRef = Database.database().reference().child("User_Messages").child(event.convoID)
//            convoRef.observeSingleEvent(of: .value , with: {
//            snapshot in
//            if let convoObject = snapshot.value as? [String: Any]{
//                let convo = Convo()
//                    convo.setValuesForKeys(convoObject)
//
//
//                convoRef.removeValue()
//                if let refs = convo.messageReferences{
//                    for ref in refs{
//                        let messageRef = Database.database().reference().child("Messages").child(ref)
//                            messageRef.removeValue()
//                    }
//                }
//            }
//        })
    }
    
    func makeWorkout(workout:[String:AnyObject])->Event{
        let day = workout["day"] as? String ?? ""
        let start = workout["start_time"] as? String ?? ""
        let end = workout["end_time"] as? String ?? ""
        let location = workout["gym"] as? String ?? ""
        let gymID = workout["gym_id"] as? Int ?? 1
        let id = workout["id"] as? Int
        let name = workout["name"] as? String ?? ""
        let url = workout["url"] as? String
        let workoutType = workout["workout_type"] as? String ?? ""
        let workoutID = workout["workout_type_id"] as? Int ?? 3
        let exercises = workout["exercise"] as? String ?? ""
        let matched = workout["is_matched"] as? Bool ?? false
        let typeOfWorkout = Workout(type: workoutType, id: workoutID)
        let gym = Gym(name: location, id: gymID)
        let convoID = workout["conversation_id"] as? String ?? ""
        let userWorkout = Event(day: day, start: start, end: end, workout: typeOfWorkout, gym: gym)
     
        userWorkout.exercises = exercises.replacingOccurrences(of: "_", with: " ").components(separatedBy: ",")
        userWorkout.workoutName  = name.replacingOccurrences(of: "_", with: " ")
        userWorkout.startHour = start.replacingOccurrences(of: "_", with: "")
        userWorkout.endHour = end.replacingOccurrences(of: "_", with: "")
        userWorkout.eventID = id!
        userWorkout.eventURL = url
        userWorkout.isMatched = matched
        userWorkout.convoID = convoID
        return userWorkout
    }
    
    func gotUserWorkouts(workouts: NSArray){
        var userWorkouts = [Event]()
        for workout in workouts{
            let workoutEvent = makeWorkout(workout: workout as! [String : AnyObject])
                userWorkouts.append(workoutEvent)
        }
        if let user = GymmieUser.currentUser(){
            user.events = userWorkouts
           user.updateCurrentUser(server:false)
        }
        workoutDelegate?.fetchedUserWorkouts(workouts: userWorkouts)
    }

    lazy var fetchedUserWorkoutHandler: SessionTaskHandler = {
            data,response, error in
        if error != nil{
            return
        }
        
        do{
            if let json = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers) as? NSArray{
                print(json)
                self.gotUserWorkouts(workouts: json)
            }else{
                self.workoutDelegate?.fetchedUserWorkouts(workouts: [])
            }
        }catch{
            
        }
    }
  
    func fetchUserWorkouts(){
        if let userID = GymmieUser.currentUser()?.userID{
        let workoutUrl = "https://gymmie.herokuapp.com/\(userID)/workouts.json"
        makeRequestForPath(pathURL: workoutUrl, handler: fetchedUserWorkoutHandler, fields: .Auth,.GET,.JSON)
        }
    }
    
    lazy var blockUserHandler: SessionTaskHandler = {
        (data,response,error) in
        if error != nil{
            return
            }
            do{
           
            }catch{
            
            }
        }
    
    func block(partner:GymmieUser, from user: GymmieUser,shouldBlock: Bool){
        let block = shouldBlock ? "1" : "0"
        let partnerID = partner.userID!
        let userID = user.userID!
        let blockPath = blockUserURL.replacingOccurrences(of: "{user}", with: "\(userID)").replacingOccurrences(of: "{partner}", with: "\(partnerID)" ).replacingOccurrences(of: "{block}", with: block)
       makeRequestForPath(pathURL: blockPath, handler: blockUserHandler, fields: .JSON,.Auth,.POST)
        
    }
    
    let reportUserHandler: SessionTaskHandler = {
        (data,response,error) in
        
        if error != nil{
            return
        }
        do{
            if let json = try JSONSerialization.jsonObject(with: data!,options: .mutableContainers) as? NSDictionary{
                print(json)
            }
        }catch{
            
        }
    }
    
    func reportUser(user:GymmieUser, byUser: GymmieUser,with report:String,and other: String){
       
        let partnerID = user.userID!
        let userID = byUser.userID!
   
        
        let reportPath = "https://gymmie.herokuapp.com/user_reports.json?user_report[user_id]=\(userID)&user_report[partner_id]=\(partnerID)&user_report[status]=\(report)&other=\(other)"
        makeRequestForPath(pathURL: reportPath, handler: reportUserHandler, fields: .JSON,.Auth,.POST)
    }
    
    lazy var userLocationHandler: SessionTaskHandler = {
        (data,response,error) in
        
        if error != nil{
            return
        }
        do{
            if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [NSDictionary]{
            print (json)
            }
        }catch{
            
        }
    }
    
    func updateUserLocation(at lat:String, long: String){
        let id = GymmieUser.currentUser()!.userID!
        let locationURL = "https://gymmie.herokuapp.com/user_locations.json?user_location[user_id]=\(id)&user_location[latitude]=\(lat)&user_location[longitude]=\(long)"
        makeRequestForPath(pathURL:  locationURL, handler: userLocationHandler, fields: .JSON,.Auth,.POST)
    }

    typealias SessionTaskHandler = (Data?,URLResponse?,Error?)->()
    
    func sendTaskWithRequest(request: URLRequest, using handler: SessionTaskHandler?){
    let task = session.dataTask(with: request, completionHandler:handler! )
        task.resume()
    }
    
    func makeRequestForPath(pathURL:String,handler: SessionTaskHandler?, fields:HeaderField...){
    
        guard let url = URL(string: pathURL) else{
            return
        }
        
        let req = NSMutableURLRequest(url: url)
        //req.httpBody = path.data(using: .utf8)
        for field in fields{
            switch field {
            case .POST:
               req.httpMethod = "POST"
            case .GET:
                req.httpMethod = "GET"
            case .JSON:
                req.addValue("application/json", forHTTPHeaderField: "Content-Type")
            case .Auth:
                req.addValue(AppDatabase.authCode, forHTTPHeaderField: "Authorization")
            case .PUT:
                req.httpMethod = "PUT"
            case .DEL:
                req.httpMethod = "DELETE"
            default: break
            }
        }
        
        sendTaskWithRequest(request: req as URLRequest,using: handler)
    }

   
    func getMatches(for workout: Int){
        let matchURL = matchesURL.replacingOccurrences(of: "id", with: "\(workout)")
        makeRequestForPath(pathURL:matchURL,handler:getMatchesHandler, fields: .Auth,.JSON,.GET)
    }
    
    lazy  var getMatchesHandler: SessionTaskHandler = { (data,response,error) in
        if error != nil{
            self.matchesDelegate?.connectionFailed()
            print(error?.localizedDescription)
            return
        }
        do{
            if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as? NSArray{
                print(json)
                self.foundMatches(matchesResponse: json)
            }
        }catch{
            self.foundMatches(matchesResponse: [])
        }
        
    }
    var password: String?
    func createUserWithCredentails(firstName: String,lastName: String, email: String, password: String,gender: String){
        newUserSignIn = true
        self.password  = password
        let createUserPath: String = "https://gymmie.herokuapp.com/user_create?first_name=\(firstName)&last_name=\(lastName)&email=\(email)&password=\(password)&apns_token=\(deviceToken)&gender=\(gender)"
       
        makeRequestForPath(pathURL:createUserPath,handler: createUserHandler, fields: .None,.POST)
        
    }
    
    lazy var createUserHandler: SessionTaskHandler = { (data,response,error) in
        
        if error == nil{
            do{
            if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as? [String: AnyObject]{
                print(json)
                self.createdUser(json: json as NSDictionary)
                }
            }catch let dataError{
                print(dataError)
            }
        }else{
            print(error?.localizedDescription)
        }
    }
    
    func createFBUserWithCredentails(firstName: String, lastName: String, email: String, fbID: String,fbURL: String,gender: String,image:String){
    
//           newUserSignIn = true
//        let address = email//.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
//        let createUserPath: String = "https://gymmie.herokuapp.com/user_create?facebook_token=\(fbID)&email=\(address)&first_name=\(firstName)&last_name=\(lastName)&apns_token=\(deviceToken)&gender=\(gender)&facebook_url=\(fbURL)&photo=\(image)"
//    
//        makeRequestForPath(pathURL:createUserPath,handler: createFBUserHandler, fields: .None,.POST)
    }
    
    lazy var createFBUserHandler: SessionTaskHandler = { (data,response,error) in
        
        if error == nil{
            do{
         
            if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as? NSDictionary{
                print(json)
                self.createdFBUser(json: json as NSDictionary)
            }
            }catch{
                print(error)
            }
        }else{
            print(error?.localizedDescription)
        }
    }
    
    func validate(_ fbUser:GymmieUser){
        let fbID = fbUser.fbID!
        let email = fbUser.email
        let firstName = fbUser.firstName!
        let lastName = fbUser.lastName!
        let authUserPath: String = "https://gymmie.herokuapp.com/authenticate?facebook_token=\(fbID)&email=\(email)&first_name=\(firstName)&last_name=\(lastName)&apns_token=\(deviceToken)&facebook_url=\(fbUser.fbURL!)"
      
        makeRequestForPath(pathURL:authUserPath,handler: authenticateFBUserHandler, fields: .None,.POST)
    }
    
    lazy  var authenticateFBUserHandler: SessionTaskHandler = {(data,response,error) in
        
        if error != nil{
            print(error?.localizedDescription)
            return
        }
        
        let detail = response.debugDescription
        print(detail)
        do{
            if let jso = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSString{
                print("its a string")
            }
        }catch{
            print("something not working")
        }
        do{
           
            if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as? NSDictionary{
                print(json)
                self.authenticatedFBUser(authResponse: json as NSDictionary)
                }
        }catch{
            //self.signUpDelegate?.unauthorizedSignUp()
        }
        
    }
    
    func authenticate(_ user: GymmieUser){
        let email = user.email
        password = user.password!
        
        let authUserPath: String = "https://gymmie.herokuapp.com/authenticate?email=\(email)&password=\(password!)&apns_token=\(deviceToken)"
        makeRequestForPath(pathURL:authUserPath,handler:authenticateUserHandler, fields: .POST)
    }
    
    lazy var authenticateUserHandler: SessionTaskHandler = {(data,response,error) in
    
        if error == nil{
            print(response)
            do{
            
            if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as? [String: AnyObject]{
                print(json)
                self.authenticatedUser(authResponse: json as NSDictionary)
                
                }
            }catch{
                self.signUpDelegate?.unauthorizedSignUp()
//                try? Auth.auth().signOut()
                
            }
        }else{
            self.signUpDelegate?.unauthorizedSignUp()
//               try? Auth.auth().signOut()
            
            print(error?.localizedDescription)
        }
    }
   
    let userTypes = ["","GymmieTrainer","GymmieUser","GymmieClass"]
    let firstNameKey = "first_name"
    let lastNameKey = "last_name"
    let nameKey = "name"
    let descriptionKey = "description"
    let emailKey = "email"
    let fitnessLevelKey = "fitness_level"
    let gymKey = "gym"
    let phoneKey = "phone"
    let typeKey = "user_type"
    let interestsKey = "interests"
    let goalsKey = "goals"
    let workoutsKey = "workouts"
    let idKey = "user_id"
    let profileKey = "user_profile_id"
    let photoKey = "photo"
    let coverPhotoKey = "cover"
  
    var userToFind: Int?

    func returnUser(user: [String: AnyObject]){
        if let error = user["error"] as? String {
            return 
        }
        if let userArray = user["user"] as? [[String: AnyObject]]{
            if let foundUser = userArray[0] as? [String: AnyObject]{
                let gymmieUser = makeUser(user: foundUser)
                  profileDelegate?.foundUser(user: gymmieUser)
            }
        }
    }
    
    lazy  var foundUserHandler: SessionTaskHandler = {(data,response,error) in
        if error != nil{
            print(error?.localizedDescription)
            return
        }
        
        do{
            if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as? [String: AnyObject]{
                print(json)
                self.returnUser(user: json)
            }
        }catch{
            
        }
    }
    
    func refreshUser(user: GymmieUser){
        var updateURL = "https://gymmie.herokuapp.com/update_profile.json?user_profile[user_id]=\(user.userID!)"
        if user.isFacebookUser{
            let fbID = user.fbID!
            let email = user.email
            let firstName = user.firstName!
            let lastName = user.lastName!
            let authUserPath: String = "https://gymmie.herokuapp.com/authenticate?facebook_token=\(fbID)&email=\(email)&first_name=\(firstName)&last_name=\(lastName)&apns_token=\(deviceToken)"
          
            makeRequestForPath(pathURL:authUserPath,handler: foundUserHandler, fields: .JSON,.POST,.Auth)
        }else{
            let email = user.email
            let password = user.password!
            let authUserPath: String = "https://gymmie.herokuapp.com/authenticate?email=\(email)&password=\(password)&apns_token=\(deviceToken)"
                  makeRequestForPath(pathURL:authUserPath,handler: foundUserHandler, fields: .JSON,.POST,.Auth)
        }
    }
    
    func createdWorkout(workout:[String:AnyObject]){
        guard let user = GymmieUser.currentUser() else{ return }
        let newWorkout = makeWorkout(workout: workout)
        if let plannedWorkouts = user.events{
            user.events!.append(newWorkout)
                workoutDelegate?.createdWorkout(workout: newWorkout)
            }else{
                user.events = [newWorkout]
            }
        user.updateCurrentUser(server:false)
        
    }
    
    func authenticatedFBUser(authResponse:NSDictionary){
        if let error = authResponse["error"] as? [String:AnyObject]{
            signUpDelegate?.unauthorizedSignUp()
            return
        }else{
            
        if let authCode = authResponse["auth_token"] as? String{
            let def = UserDefaults.standard
                def.set(authCode, forKey: "authCode")
            }
        
        if let userArray = authResponse["user"] as? [[String: AnyObject]]{
            print("got array of users")
            print("fetching a current user")
            if let user = userArray[0] as? [String: AnyObject]{
                //print(user)
                if let imageURL = user[photoKey]{
                    signedInFBUser = makeUser(user: user)
                    signUpDelegate?.fbUserSignInSucceeded()
                }else{
                    signedInFBUser = makeUser(user: user)
                    signUpDelegate?.fbUserSignUpSucceeded()
                    }
                }
            }
        }
    }
    lazy var imageHandler: SessionTaskHandler = {
        (data,response,error) in
        if error != nil{
            return
        }
    }
    func storeUserImage(with URL: String){
        makeRequestForPath(pathURL: URL, handler: imageHandler, fields: .POST,.Auth,.JSON)
        
    }
    func makeUser(user:[String:AnyObject])->GymmieUser{
        print(user.keys)
        let age = user["age"] as? NSNumber
        let lastName = user[lastNameKey] as? String ?? ""
        let firstName = user[firstNameKey] as? String ?? ""
        let name = user[nameKey] as? String ?? ""
        let fitnessLevel = user[fitnessLevelKey] as? String ?? "Cheesey Fries"
        let userType = user[typeKey] as? String ?? "normal"
        let goals = user[goalsKey] as? String ?? "Not Really Into Goals..."
        let bio = user[descriptionKey] as? String ?? "Sort of a Mystery..."
        let gym = user[gymKey] as? String ?? "Home Gym"
        let workouts = user[workoutsKey] as? [String:AnyObject] ?? [:]
        let email = user[emailKey] as? String ?? ""
        let userID = user[idKey] as? Int
        let fbURL = user["facebook_url"] as? String
        let rating = user["rating"] as? NSNumber
        let imageURL = user[photoKey] as? String
        let coverPhoto = user[coverPhotoKey] as? String
        let profileID = user[profileKey] as? Int
        let workoutConsiderations = user["workout_considerations"] as? String ?? ""
        let partnerPreferences = user["partner_preferences"] as? String ?? ""
        let isAMatch = user["has_swiped"] as? Bool ?? false
        let gymmieUser = GymmieUser()
            gymmieUser.partnerPreferences = partnerPreferences.replacingOccurrences(of: "_", with: " ")
            gymmieUser.firstName = firstName
            gymmieUser.lastName = lastName
            gymmieUser.name = name
            gymmieUser.imageURL = imageURL
            gymmieUser.isAMatch = isAMatch
            gymmieUser.rating = rating?.doubleValue
            gymmieUser.fitnessLevel = fitnessLevel
            gymmieUser.userType = userType
            gymmieUser.fitnessGoals = goals.replacingOccurrences(of: "_", with: " ").components(separatedBy: ",")
            gymmieUser.bio = bio.replacingOccurrences(of: "_", with: " ")
            gymmieUser.fbURL = fbURL
            gymmieUser.age = age?.intValue
            gymmieUser.gym = gym
            gymmieUser.userID = userID
            gymmieUser.profileID = profileID
            gymmieUser.email = email
            gymmieUser.workoutConsiderations = workoutConsiderations.replacingOccurrences(of: "_", with: " ")

        if let workouts = user["workouts"] as? [[String: AnyObject]]{
            gymmieUser.events = []
            for workout in workouts{
                gymmieUser.events!.append(makeWorkout(workout: workout))
                gymmieUser.events!.map({$0.planner = gymmieUser})
            }
           
        }
       
        return gymmieUser
    }
    func createdFBUser(json: NSDictionary){
        if let authCode = json["auth_token"] as? String{
            let def = UserDefaults.standard
            def.set(authCode, forKey: "authCode")
        }
       
        if let userArray = json["user"] as? [[String: AnyObject]]{
            if let user = userArray[0] as? [String: AnyObject]{
              
               signedInFBUser = makeUser(user: user)
                signUpDelegate?.fbUserSignUpSucceeded()
                
                 signUpDelegate = nil
            }
        }
        
    }
    func createdUser(json: NSDictionary){
        if let authCode = json["auth_token"] as? String{
            let def = UserDefaults.standard
            def.set(authCode, forKey: "authCode")
        }
        if let userArray = json["user"] as? [[String: AnyObject]]{
            print("got array of users")
            if let user = userArray[0] as? [String: AnyObject]{
                // print(user)
                signedInUser = makeUser(user: user)
                
                signUpDelegate?.userSignUpSucceeded()
                signUpDelegate = nil
            }
        }
    }
    
    func authenticatedUser(authResponse:NSDictionary){
        //refresh authentication code
        if let authCode = authResponse["auth_token"] as? String{
            let def = UserDefaults.standard
            def.set(authCode, forKey: "authCode")
            }else{
            signUpDelegate?.unauthorizedSignUp()
            signUpDelegate = nil
            return
        }
        //get user object
        
        if let userArray = authResponse["user"] as? [[String: AnyObject]]{
            print("got array of users")
            print("fetching a current user")
            if let user = userArray[0] as? [String: AnyObject]{
                //print(user)
                signedInUser = makeUser(user: user)
                signUpDelegate?.userSignInSucceeded()
            }
        }
        
    }
    
    func passonWorkouts(){
        if let window = UIApplication.shared.keyWindow{
            if let root = window.rootViewController as? HomeVC{
                root.userWorkouts = GymmieUser.currentUser()?.events
            }
        }
    }
 static  func logOutUser(){
//    do{
////        try Auth.auth().signOut()
//    //make the current user nil in the defaults
//    // if signed up manually with gymmie server
//    let def = UserDefaults.standard
//        def.removeObject(forKey: "authCode")
//    //if signed up through facebook or othe social media
//        def.removeObject(forKey: "currentUser")
//    let controller = FBController()
//    if !controller.checkAccessToken{
//        controller.logOutUser()
//        }
//    }catch{
//
//    }
//
    }
    
    func foundMatches(matchesResponse: NSArray){
        print(matchesResponse)
        var matches = [GymmieUser]()
        for match in matchesResponse as! [[String: AnyObject]]{
            let gymUser = makeUser(user: match)
            if let applicableWorkout = match["workout_id"] as? Int{
                if let events = gymUser.events{
                    gymUser.events = events.filter({$0.eventID == applicableWorkout})
                }
            }
            
            matches.append(gymUser)
        }
        
        matchesDelegate?.foundMatches(matches: matches)
       
        
    }
    
    lazy  var notificationHandler: SessionTaskHandler = { (data,response,error) in
        
        if error == nil{
            do{
                if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as? [String: AnyObject]{
                    print(json)
                   
                    
                }
            }catch{
                print(error)
            }
        }else{
           
            print(error?.localizedDescription)
        }
    }
}
//This extension will provide the database withe the ability to create and retrieve the users chat logs.  Using Firebase. It will not supplant the actual users information storage and matching capability.    /
//When the user is created a firebase user must be created as well. From then on the user will be identified by the uid provided by firebase associated with their email address.   
//A messages node will be created that will house all messages, the child id of each message will be an auto id. 
//the  sender and receiver will both receive references to the messages

extension AppDatabase{

    func signInAnonymously(){
//        Auth.auth().signInAnonymously(completion: {
//            result in
//            if let error = result.1 as? NSError{
//                print(error.localizedDescription)
//                return
//            }
//            if let appDel = UIApplication.shared.delegate as? AppDelegate{
//                appDel.gymmieFIRUser = result.0
//            }
//        })
    }
    
    func logCrashlyticsUser(email: String){
//        Crashlytics.sharedInstance().setUserEmail(email)
    }
    
    func monitorMessages(){
        if let appDel = UIApplication.shared.delegate as? AppDelegate{
            //appDel.monitorMessages()
        }
    }
    
   

    func createChatter(with email: String,id: Int,profile:Int, firstName: String,lastName: String,imageURL:String?){
//        logCrashlyticsUser(email: email)
//
//        let firDatabase = Database.database().reference()
//
//            //create a user in the user node in firebase
//        guard let token = AccessToken.current?.authenticationToken else { return }
//              let credential = FacebookAuthProvider.credential(withAccessToken: token )
//        Auth.auth().signIn(with: credential , completion: {
//            callback in
//
//            if let error = callback.1{
//                print(error.localizedDescription)
//            }
//
//        if let user = callback.0{
//            if let chatterID = user.uid as? String{
//                let userData = ["chat_id":chatterID,"user_id":id,"profile_id":profile,"email":email,"image_URL":imageURL ?? "","first_name":firstName,"last_name":lastName] as [String : Any]
//
//                let userRef =  firDatabase.child("Users").child(chatterID)
//                   userRef.updateChildValues(userData)
//            }
//        }
//    })
    }
}


