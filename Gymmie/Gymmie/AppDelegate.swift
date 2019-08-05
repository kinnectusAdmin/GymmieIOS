//
//  AppDelegate.swift
//  Gymmie
//
//  Created by Blake Rogers on 6/27/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit
//import FBSDKCoreKit
//import FBSDKLoginKit
//import Foundation
//import Firebase
import UserNotifications
import UserNotificationsUI
//
import CoreLocation
//import AVFoundation
//import Fabric
//import Crashlytics
//
//import FirebaseDatabase
//import FirebaseAuth
//import Branch
//import Mixpanel


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate{

    var window: UIWindow?
    public var gymmieFIRUser: Any?//User?
    func autoShowVC(){
        //get the tab barcontroller
    }
    func allowedNotificationViaPrimer(allowed: Bool){
//        let did_Allow = allowed ? "allowedNotficationViaPrimer" : "declinedNotificationViaPrimer"
//        if let user = GymmieUser.currentUser()?.userID{
//            if !allowed{
//            FBSDKAppEvents.logEvent(did_Allow, valueToSum: 1.0, parameters: ["user":user])
//            }
//        }else{
//              FBSDKAppEvents.logEvent(did_Allow, valueToSum: 1.0)
//        }

    }
    func skippedTutorial(from page: Int){
//         FBSDKAppEvents.logEvent("SkippedTutorial", valueToSum: 1.0, parameters: ["atPage": page])
    }
    func createdWorkout(workout:Event){
//        FBSDKAppEvents.logEvent("CreatedWorkout", valueToSum: 1.0, parameters: ["day":workout.dayOfWorkout,"time":workout.startHour])
    }

    func matchedWithUser(matched: Bool){
//        FBSDKAppEvents.logEvent(matched ? "MatchedPartners" : "UnmatchedPartners", valueToSum: 1.0)
    }

    func ratedUser(rated: Bool){
//        FBSDKAppEvents.logEvent(rated ? "RatedUser" : "SkippedRating", valueToSum: 1.0)
    }
    func swipedRightWhenLiked(swiped: Bool){
//        FBSDKAppEvents.logEvent(swiped ? "swipedRightWhenLiked" : "swipedLeftWhenLiked", valueToSum: 1.0)
    }
    func autoShowChat(with Convo:Int){

    }
    func getFBUserData(){
//        let fbController = FBController(delegate: self)
//        fbController.getUser()
    }
//
//
    func showHome(){
        let home = HomeVC()
        let homeNav = UINavigationController(rootViewController: home)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = homeNav
        window?.makeKeyAndVisible()
    }
//
    func tryAutoFBSignIn(withUser user: GymmieUser){

//        guard let token = FBSDKAccessToken.current(), !AppDatabase.authCode.isEmpty else{
//            showSignUp(validating: false)
//            return
//        }

//        if Calendar.current.compare(token.expirationDate, to: Date(), toGranularity: .day) == .orderedDescending{
//
//            let wholeDay: TimeInterval = 3600 * 23
//            let today = Date()
//            guard let expirationDate = user.lastSignIn?.addingTimeInterval(wholeDay) else { showHome(); return }
//                if expirationDate.compare(today) == .orderedAscending{
//                    print("token expired")
//                    showSignUp(validating: true)
//                }else{
//                    showHome()
//                }
//        }else{
//            //go to signup to refresh token
//            showSignUp(validating: false)
//        }
    }
//
    func tryAutoGymmieSignIn(withUser user: GymmieUser){
        let data = AppDatabase()
            data.signUpDelegate = self
            data.authenticate(user)
    }
//
//
    func autoLogin(){
        guard let user = GymmieUser.currentUser() else{
            showSignUp(validating: false)
            return
        }
        tryAutoFBSignIn(withUser: user)

    }
    func removeStoredData(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "currentUser")
        defaults.removeObject(forKey: FBPermissions.fbUser)
        defaults.removeObject(forKey: "storedGymmiePassword")
        defaults.removeObject(forKey: "authCode")
        defaults.removeObject(forKey: "isFaceBookUser")
        defaults.removeObject(forKey: "savedEvents")
        defaults.synchronize()
    }
    func establishNotificationSettings(){

        var acceptAction = UIMutableUserNotificationAction()
            acceptAction.identifier = "acceptInvite"
            acceptAction.title = "Accept"
            acceptAction.activationMode = .background
        var declineAction = UIMutableUserNotificationAction()
            declineAction.identifier = "declineInvite"
            declineAction.title = "Decline"
            declineAction.activationMode = .background
            declineAction.isDestructive = true
        var ratingAction = UIMutableUserNotificationAction()
            ratingAction.identifier = "rateWorkout"
            ratingAction.title = "Rate"
            ratingAction.activationMode = .foreground
        var ignoreAction = UIMutableUserNotificationAction()
            ignoreAction.identifier = "ignoreRating"
            ignoreAction.title = "Ignore"
            ignoreAction.activationMode = .background
            ignoreAction.isDestructive = true
        var viewWorkout = UIMutableUserNotificationAction()
            viewWorkout.identifier = "viewWorkout"
            viewWorkout.title = "View"
            viewWorkout.activationMode = .foreground
        var replyAction = UIMutableUserNotificationAction()
            replyAction.identifier = "reply"
            replyAction.title = "Reply"
            replyAction.activationMode = .background
            replyAction.behavior = .textInput

        let inviteCategory = UIMutableUserNotificationCategory()
            inviteCategory.identifier = "INVITE"
            inviteCategory.setActions([acceptAction,declineAction], for: .minimal)
        let rateWorkoutCategory = UIMutableUserNotificationCategory()
            rateWorkoutCategory.identifier = "RATE_WORKOUT"
            rateWorkoutCategory.setActions([ratingAction], for: .minimal)
        let workoutUpdateCategory = UIMutableUserNotificationCategory()
            workoutUpdateCategory.identifier = "WORKOUT_UPDATED"
            workoutUpdateCategory.setActions([viewWorkout], for: .minimal)
        let messageCategory = UIMutableUserNotificationCategory()
            messageCategory.identifier = "MESSAGE"
            messageCategory.setActions([replyAction], for: .minimal)
        let categories:Set = [inviteCategory,rateWorkoutCategory,workoutUpdateCategory,messageCategory]
        let types: UIUserNotificationType = [.alert,.badge,.sound]
//        if #available(iOS 10.0, *) {
//            let options: UNAuthorizationOptions = [.alert,.sound,.badge]
//
//            UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: { bool, error in
//                print(bool)
//                if error != nil{
//                    print(error?.localizedDescription)
//                }
//            })
//                showHome()
//        }else{
            // Fallback on earlier versions

            let notificationSettings = UIUserNotificationSettings(types: types, categories: categories)
                UIApplication.shared.registerUserNotificationSettings(notificationSettings)
                UIApplication.shared.registerForRemoteNotifications()

        //}



    }
//

    func showSignUp(validating: Bool){
        let signIn = SignInVC()
            signIn.validatingUser = validating
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = signIn
        window?.makeKeyAndVisible()
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
//          Fabric.with([Crashlytics.self])
//        UIApplication.shared.applicationIconBadgeNumber = 0
//
//       FBSDKApplicationDelegate.sharedInstance().application(application , didFinishLaunchingWithOptions: launchOptions)
//        UINavigationBar.appearance().tintColor = gymmieOrange()
//         application.statusBarStyle = .default
//
//        if UserDefaults.standard.bool(forKey: "tutorialViewed"){
//
//               autoLogin()
//        }else{
//
//            showOnboard()
//        }
//
//        let branch: Branch = Branch.getInstance()
//        branch.initSession(launchOptions: launchOptions, automaticallyDisplayDeepLinkController: true, deepLinkHandler: { params, error in
//            if error == nil {
//                // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
//                // params will be empty if no data found
//                // ... insert custom logic here ...
//                print("params: %@", params?.description)
//            }
//        })
//        // showSignUp()
//
//        do{
//
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//
//        }catch{
//            print("sound not going to work")
//        }
////
////        let defaults = UserDefaults.standard
////            defaults.set("1.0.13", forKey: "version")
////            defaults.synchronize()
////       Mixpanel.initialize(token: "3100e1ea1250b11936998addfbdbefc7")
        return true
    }
    
    func showOnboard(){
        let onboard = OnboardVC()
        window?.rootViewController = onboard
        window?.makeKeyAndVisible()
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("registered for notifications")
        showHome()
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.hexString
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "deviceToken")
        defaults.synchronize()
        if let user = GymmieUser.currentUser(){
            let data = AppDatabase()
                data.validate(user)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            showHome()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        for key in userInfo.keys{
//            
//            print("\(key): \(userInfo[key])")
//            
//        }
//        SoundPlayer.playSound(sound: "all-eyes-on-me", type: "mp3")
        //aps key alert value message
      //type
      //receiver_info
    //sender_info
//        guard let aps = userInfo["aps"] as? [String: AnyObject] else{
//            return
//        }
//        guard let category = userInfo["type"] as? String else{
//            return
//        }
//        var page = 3
//        switch category {
//        case "INVITE","RATE_WORKOUT":
//            page = 3
//            if application.applicationState == .inactive{
//                //autoLogin(to: page)
//            }
//          
//        case "MESSAGE":
//            page = 4
//           
//            if application.applicationState == .inactive{
//                autoShowChat(with: 0)
//            }
//            
//        case "NEW_MATCHES":
//            page = 1
//            if application.applicationState == .inactive{
//                
//            }
//           
//        default:
//            break
//        }
//        if let nav =  window?.rootViewController as? UINavigationController{
//            if let tab = nav.topViewController as? UITabBarController{
//                tab.viewControllers?[page].tabBarItem.badgeValue = "1"
//            }
//        }
//        
//        print("received notification")
        
    }

    

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // pass the url to the handle deep link call
//        Branch.getInstance().handleDeepLink(url);
//
//
//
//       let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
    return true//handled
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        print("resigning")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        gymmieFIRUser?.delete(completion: {
//            callBack in
//            print(callBack?.localizedDescription)
//        })
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // pass the url to the handle deep link call
//        Branch.getInstance().continue(userActivity)
        
        return true
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       
     
//        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      
       print("terminating")
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
    }
    
    var locationManager = CLLocationManager()
    func getLocation(){
        guard let currentUser = UserDefaults.standard.string(forKey: "currentUser") else{
            
            return
        }
        
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus(){
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.delegate = self
            
                self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                self.locationManager.requestLocation()
                locationManager.activityType = .fitness
               
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default: break
            }
        }else{
            if let tracking = GymmieUser.currentUser()?.monitoringLocation{
                if tracking{
                  
                }
            }
        }
    }
  
}

extension AppDelegate: CLLocationManagerDelegate{
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("trying to begin updating Locations")
        let location = locations.last
    
        // let accuracy = location!.horizontalAccuracy
        let time = location!.timestamp
        let coord = location!.coordinate
        
        
        print("user is at \(coord.latitude) and \(coord.longitude)")
        let locationString = "\(coord.latitude),\(coord.longitude)"
//        let data = AppDatabase()
//        data.updateUserLocation(at: String(describing:coord.latitude), long: String(describing: coord.longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status ==  .notDetermined{
            print("status changed to denied or not determined")
            //locationManager.stopUpdatingLocation()
            locationManager.stopMonitoringSignificantLocationChanges()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways{
            print("status changed to authorized")
       }
    }
}
extension AppDelegate: DatabaseSignUpDelegate{
    func unauthorizedSignUp(){
        showSignUp(validating: false)
    }
    
    func fbUserSignInSucceeded(){
            showHome()
        
    }
    
    func userSignInSucceeded(){
       showHome()
        
    }
    
    func fbUserSignUpSucceeded(){}
    func userSignUpSucceeded(){}
    func connectionFailed(){}
    func failedToGetData(){}
}
extension AppDelegate: FBControllerDelegate{
    
    func failedToFindUser(error: String){
        showSignUp(validating: false)
    }
    
    func foundCurrentUser(user: GymmieUser){
    
        
        let defaults = UserDefaults.standard
            defaults.set(user.email, forKey: "currentUser")
        
        let data = AppDatabase()
            data.signUpDelegate = self
            data.validate(user)
    }
    
    func foundNewUser(user: GymmieUser){
        
    }
    
    func setSwitchFalse(){}
    func setSwitchTrue(){}
    func placeName(name:String){}
    func permissionRemoved(){}
    func postError(error: NSError){}
    func postSuccessful(){}
}
