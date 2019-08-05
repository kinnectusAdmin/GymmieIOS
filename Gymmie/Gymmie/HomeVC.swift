//  HomeVC.swift
//  Gymmie
//
//  Created by Blake Rogers on 11/27/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
//import FBSDKShareKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        workoutCardCV.register(WorkoutCardCell.self , forCellWithReuseIdentifier: "WorkoutCardCell")
        workoutCardCV.register(AddWorkoutCell.self , forCellWithReuseIdentifier: "AddWorkoutCell")
        workoutCardCV.delegate = self
        workoutCardCV.dataSource = self
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.white
        
       setViews()
        //setTitle()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "showedAutoWorkout"){
            addWorkout()
            defaults.set(true , forKey: "showedAutoWorkout")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let bar = navigationController?.navigationBar.viewWithTag(66){
            bar.alpha = 0
        }
        navigationController?.navigationBar.viewWithTag(14)?.alpha = 0
        navigationController?.navigationBar.viewWithTag(15)?.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
       navigationController?.navigationBar.tintColor = gymmieOrange()
        super.viewWillAppear(animated)
         getUserWorkouts()
        setTitle()
        //makeDummyEvents()
    }
   
    func setTitle(){
        
        if let  bar = navigationController?.navigationBar.viewWithTag(66){
            bar.alpha = 1.0
        }else{
        let bar = UIView()
            bar.tag = 66
            bar.backgroundColor = gymmieOrange()
        let y = navigationController!.navigationBar.frame.height
        let width = navigationController!.navigationBar.frame.width
            bar.frame = CGRect(x: 0, y: y, width: width, height: 1)
        
            navigationController?.navigationBar.addSubview(bar)
        }
        
        let logo = UIButton()
            logo.setImage(#imageLiteral(resourceName: "logo"), for: .normal)
            logo.isUserInteractionEnabled = false
            logo.translatesAutoresizingMaskIntoConstraints = false
            logo.tag = 13
           
        if let window = UIApplication.shared.keyWindow{
            if let gymmieLogo = window.viewWithTag(13){
                    gymmieLogo.alpha = 1.0
                window.bringSubviewToFront(gymmieLogo)
            }else{
                
                window.addSubview(logo)
                logo.setTopTo(con: window.top(), by: 25)
                logo.setXTo(con: window.x(), by: 0)
                logo.setHeightTo(constant: 30)
                logo.setWidthTo(constant: 108)
                
            }
        }
        if let menu = navigationController?.navigationBar.viewWithTag(14), let delete = navigationController?.navigationBar.viewWithTag(15){
            menu.alpha = 1.0
            delete.alpha = 1.0
        }else{
        let menuButton = UIButton()
            menuButton.setImage(#imageLiteral(resourceName: "menuButton"), for: .normal)
            menuButton.addTarget(self , action: #selector(HomeVC.handleMenu(_:)), for: .touchUpInside)
            menuButton.frame = CGRect(x: 5, y: 8, width: 30, height: 30)
            menuButton.tag = 14
            navigationController?.navigationBar.addSubview(menuButton)
       
        let deleteButton = UIButton()
            deleteButton.setImage(#imageLiteral(resourceName: "deleteCard"), for: .normal)
            deleteButton.addTarget(self , action: #selector(HomeVC.deleteHandler(_:)), for: .touchUpInside)
            deleteButton.frame = CGRect(x: view.frame.width-38, y: 8, width: 30, height: 30)
            deleteButton.reversesTitleShadowWhenHighlighted = false
            deleteButton.tag = 15
            navigationController?.navigationBar.addSubview(deleteButton)
        }

    }
 
    @objc func deleteHandler(_ sender: UIButton){
        
        if deletingCard{
            workoutCardCV.reloadData()
            if let window = UIApplication.shared.keyWindow{
                if let barscreen = window.viewWithTag(11){
                    barscreen.removeFromSuperview()
                    deletingCard = false
                    return
                }
            }
        }
        
        deletingCard = true
        workoutCardCV.reloadData()
        let barscreen = UIView()
            barscreen.backgroundColor = UIColor.white
            barscreen.alpha = 0.5
            barscreen.tag = 11
        if let window = UIApplication.shared.keyWindow{
            
            
            if let barFrame = navigationController?.navigationBar.frame{
                window.addSubview(barscreen)
            barscreen.frame = CGRect(x: 0, y: 0, width: barFrame.width - 100 , height: barFrame.height + 20)
            }
        }
    }
    
    var deletingCard: Bool = false
    var showingMenu: Bool = false
    var hideMenuGesture = UITapGestureRecognizer()
    var workoutToDelete: Event?
    
    func setViews(){
        view.backgroundColor = UIColor.white
        let end = CGPoint(x: 0, y: 0.5)
        let grey = createColor(210, green: 210, blue: 210).cgColor
        let white = UIColor.white.cgColor
        let bv = UIImageView(image: #imageLiteral(resourceName: "homeBackground"))
            bv.contentMode = .scaleAspectFill
            bv.alpha = 0.7
            bv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bv)
        bv.constrainInView(view: view , top: 0, left: -20, right: 20, bottom: 0)
        view.addSubview(workoutCardCV)
        workoutCardCV.constrainInView(view: view, top: 0, left: -20, right: 20, bottom: 0)
        
    }
   
    let bottomView: UIView = {
        let blurEffect = UIBlurEffect(style:.light)
        let effectView = UIVisualEffectView(effect: blurEffect)
            effectView.translatesAutoresizingMaskIntoConstraints = false
        let v = UIView()
            v.addSubview(effectView)
            effectView.constrainWithMultiplier(view: v, width: 1, height: 1)
            v.translatesAutoresizingMaskIntoConstraints = false
        let trashview = UIImageView(image: #imageLiteral(resourceName: "trashSymbol"))
            v.addSubview(trashview)
            trashview.contentMode = .scaleAspectFill
            trashview.translatesAutoresizingMaskIntoConstraints = false
            trashview.constrainWithMultiplier(view: v, width: 0.2, height: 0.8)
        
        return v
    }()
    
    let deleteView: DeleteWorkoutView = {
        let v = DeleteWorkoutView()
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var userWorkouts: [Event]?{
        didSet{
            DispatchQueue.main.async(execute: {
                self.workoutCardCV.reloadData()
            })
        }
    }
    
    let  workoutCardCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width:300, height: 400)
        let frame = CGRect(x: 0, y: 0, width:300, height: 500)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
            cv.backgroundColor = UIColor.clear
            cv.contentInset.top = 20
            cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section{
        case 0:
            guard let workouts = userWorkouts else{ return CGSize.zero}
                let width = view.frame.width
                let height:CGFloat = 100
            return CGSize(width: width, height: height)
        case 1:
            let width = view.frame.width
            let defaultHeight: CGFloat = 50
            let defaultSize = CGSize(width: width, height: defaultHeight)
            return defaultSize
        default:
            return CGSize.zero
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let workouts = userWorkouts else{return 1}
        
        return section == 0 ? workouts.count : deletingCard ? 0 : 1
    }
    func showDeleteOptionFor(workout: Event){
        workoutToDelete = workout
        let screen = UIView()
            screen.backgroundColor = UIColor.black
            screen.alpha = 0.3
            screen.frame = navigationController!.view.frame
            screen.tag = 69
        view.add(views: screen, deleteView)
        deleteView.delegate = self
        deleteView.setXTo(con: view.x(), by: 0)
        deleteView.setYTo(con: view.y(), by: 0)
        deleteView.setWidthTo(constant: 200)
        deleteView.setHeightTo(constant: 130)
    }
    
    func addWorkout() {
        let createPage = WorkoutGeneratorVC()
        let gym = Gym(name: "Student Rec Center", id: 1)
        let typeOfWorkout = Workout(type: "Upper Body", id: 1)
        let today = Date()
        let weekDayInt = Calendar.current.component(.weekday, from: today)
        let days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
        let day = days[weekDayInt-1]
        let currentHour = MyCalendar.time(forDate: Date())
        
        let nextHour = MyCalendar.time(forDate: Date().addingTimeInterval(3600))
        
        let newWorkout = Event(day: day , start: currentHour, end: nextHour, workout: typeOfWorkout , gym: gym)
            createPage.workout = newWorkout
            createPage.view.alpha = 1
    
        
        
            createPage.view.frame = navigationController!.view.frame
        navigationController!.addChild(createPage)
        navigationController!.view.addSubview(createPage.view)
        
        let title = UIApplication.shared.keyWindow?.viewWithTag(13)
        
        UIView.animate(withDuration: 0.25, animations: {
            createPage.view.alpha = 1
            title?.alpha = 0
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutCardCell", for: indexPath) as! WorkoutCardCell
        switch indexPath.section {
        case 0 :
            guard let workouts = userWorkouts else{return}
            let workout = workouts[indexPath.item]
            if deletingCard{
                showDeleteOptionFor(workout: workout)
                return
            }
            if !workout.isMatched{
                //go to gymmie tinder
                let matchPage = MatchProfileVC()
                    matchPage.workout = workout
                //present(matchPage, animated: true, completion: nil)
                navigationController?.pushViewController(matchPage, animated: true)
            }else{
                //go to chat page with partner
                let chat = ChatDetailVC()
                    chat.workout = workout 
                navigationController?.pushViewController(chat , animated: true)
            }
        case 1:
            addWorkout()
        default: break
        }
    }
  
    func workoutCard(at indexPath: IndexPath)->WorkoutCardCell{
        let cell = workoutCardCV.dequeueReusableCell(withReuseIdentifier: "WorkoutCardCell", for: indexPath) as! WorkoutCardCell
        guard let workouts = userWorkouts else{return cell}
        let workoutEvent = workouts[indexPath.item]
        cell.event = workoutEvent
        //cell.gradient.removeAllAnimations()
        //cell.gradient.removeFromSuperlayer()
        return cell
    }
    
    func addWorkout(at indexPath: IndexPath)->AddWorkoutCell{
        let cell = workoutCardCV.dequeueReusableCell(withReuseIdentifier: "AddWorkoutCell", for: indexPath) as! AddWorkoutCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            print("setting cell")
          return workoutCard(at: indexPath)
        case 1:
            return addWorkout(at: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
}

extension HomeVC: MenuDelegate{
    func resetView(){
        showingMenu = false
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.frame.origin.x = 0
            if let screen = self.navigationController?.view.viewWithTag(33){
                screen.removeFromSuperview()
            }
            if let logo = UIApplication.shared.keyWindow?.viewWithTag(13){
                logo.alpha = 1
            }
        }
       
    }
    
    func showSettings(){
        let account = AccountSettingsVC()
        navigationController?.pushViewController(account, animated: true)
       resetView()
    }

    func showContactUs(){
//        let contact = ContactUsVC()
//        navigationController?.pushViewController(contact, animated: true)
//        resetView()
    }
    
    func showPrivacySettings(){
        let privacy = PrivacyVC()
           navigationController?.pushViewController(privacy, animated: true)
        resetView()
    }
    
    func showUserProfile(){
        let profile = UserProfileVC()
           navigationController?.pushViewController(profile , animated: true )
        resetView()
    }
    func invite(){
//
//        var content = FBSDKAppInviteContent()
//        //https://itunes.apple.com/us/app/gymmie-app/id1148412934?ls=1&mt=8
//       content.appLinkURL = URL(string: "https://fb.me/1261130080636284")
//        content.appInvitePreviewImageURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/gymmie-569f6.appspot.com/o/Images%2FFacebookInviteImage%2FgymmieLogoForFB.jpg?alt=media&token=34e13cab-31d2-4132-a403-e286e39acf7a")
//        FBSDKAppInviteDialog.show(from: self.navigationController! , with: content, delegate: self)
    }
    
    func logout(){
        AppDatabase.logOutUser()
        let window = UIApplication.shared.keyWindow
        let signIn = SignInVC()
            window?.rootViewController = signIn
            window?.makeKeyAndVisible()
    }
    
    
    @objc func handleMenu( _ sender: UIBarButtonItem){
        showingMenu = !showingMenu
        show_hideMenu(show: showingMenu)
    }
    
    @objc func hideMenuHandler( _ gesture: UITapGestureRecognizer){
        showingMenu = !showingMenu
        show_hideMenu(show: showingMenu)
        
    }
    
    func show_hideMenu(show: Bool){
        if show{
            if let logo = UIApplication.shared.keyWindow?.viewWithTag(13){
                logo.alpha = 0
            }
            let screen = UIView()
                screen.backgroundColor = UIColor.black
                screen.alpha = 0.3
                screen.frame = navigationController!.view.frame
                screen.tag = 33
            hideMenuGesture = UITapGestureRecognizer(target: self, action:  #selector(HomeVC.hideMenuHandler(_:)))
                screen.addGestureRecognizer(hideMenuGesture)
            navigationController!.view.addSubview(screen)
            
            let menu = MenuVC()
            navigationController?.addChild(menu)
            navigationController?.view.insertSubview(menu.view, at: 0)
           
                menu.delegate = self
                menu.view.frame = CGRect(x: 0, y: 0, width: view.frame.width*0.66, height: navigationController!.view.frame.height)
            
           let offset = self.view.frame.width*0.66
                UIView.animate(withDuration: 0.25, animations: {
                self.navigationController?.navigationBar.frame.origin.x = offset
                self.view.frame.origin.x = offset
                screen.frame.origin.x = offset
                }, completion: {_ in
                    self.navigationController?.view.bringSubviewToFront(menu.view)
            })
            
        }else{
           
            if let menu = navigationController?.children.last, let screen = navigationController?.view.viewWithTag(33), let logo = UIApplication.shared.keyWindow?.viewWithTag(13){
                navigationController?.view.sendSubviewToBack(menu.view)
                UIView.animate(withDuration: 0.25, animations: {
                    self.navigationController?.navigationBar.frame.origin.x = 0
                    self.view.frame.origin.x = 0
                    menu.view.frame.origin.x = 0
                    screen.frame.origin.x = 0
                    screen.alpha = 0
                    logo.alpha = 1
                    }, completion: {_ in
                
                        menu.removeFromParent()
                        menu.view.removeFromSuperview()
                        screen.removeGestureRecognizer(self.hideMenuGesture)
                        screen.removeFromSuperview()
                })
                
            }
        }
    }

    }

extension HomeVC: DeleteWorkoutDelegate{
    func cancelDelete() {
        if let screen = view.viewWithTag(69){
            screen.removeFromSuperview()
        }
        if let window = UIApplication.shared.keyWindow{
            if let barScreen = window.viewWithTag(11){
                barScreen.removeFromSuperview()
            }
        }
        deletingCard = false
        workoutCardCV.reloadData()
    }
    func deleteWorkout() {
        if let screen = view.viewWithTag(69){
            screen.removeFromSuperview()
        }
        if let window = UIApplication.shared.keyWindow{
            if let barScreen = window.viewWithTag(11){
                barScreen.removeFromSuperview()
            }
        }
        userWorkouts = userWorkouts!.filter({
            $0.eventID != workoutToDelete!.eventID
        })
        deletingCard = false
        workoutCardCV.reloadData()
        //insert code to remove workout in database
         let data = AppDatabase()
          data.cancelEvent(event: workoutToDelete!)
        
    }
}

extension HomeVC: DatabaseWorkoutDelegate{
    internal func createdWorkout(workout: Event) {}

    func getUserWorkouts(){
        let data = AppDatabase()
            data.workoutDelegate = self
            data.fetchUserWorkouts()
            //data.getPendingRequests()
    }
    
    func workoutCollection(workouts: [Workout]){}
    func fetchedUserWorkouts(workouts:[Event]){
        userWorkouts = workouts
    }
    func gymCollection(gyms: [Gym]){}
    func fetchedPartnerWorkouts(workouts: [Event]){}
    func fetchedInvites(invites: [Invite]){
    }
}

//extension HomeVC : FBSDKAppInviteDialogDelegate{
//    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
//       print(error?.localizedDescription)
//        resetView()
//    }
//    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
//        
//            resetView()
//        
//       
//    }
//    
//}
