//
//  MatchProfileVC.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/4/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
//import FBSDKShareKit
//import Firebase
//import FirebaseAuth
//import FirebaseDatabase
class MatchProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        matchInfoCV.register(MatchViewCell.self , forCellWithReuseIdentifier: "MatchViewCell")
        matchInfoCV.register(MatchInfoCell.self , forCellWithReuseIdentifier: "MatchInfoCell")
        matchInfoCV.register(MatchDetailCell.self , forCellWithReuseIdentifier: "MatchDetailCell")
        matchInfoCV.register(MatchRatingCell.self , forCellWithReuseIdentifier: "MatchRatingCell")
        matchInfoCV.register(MatchSectionView.self , forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MatchSectionView")
        
        matchInfoCV.delegate = self
        matchInfoCV.dataSource = self
//        navigationController?.isNavigationBarHidden = true
//        UIApplication.shared.keyWindow?.viewWithTag(13)?.alpha = 0
//        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = createColor(200, green: 200, blue: 200)
    
        //view.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setMatchAndWorkout()
        setViews()
        setTitle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        endSearch()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        endSearch()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getMatches()
        searchingForMatch = true
        makeSearch()
    }
    var searchingForMatch: Bool = true {
        didSet{
            print(searchingForMatch)
        }
    }
    
    func makeSearch(){
//        if !searchingForMatch && matchToView != nil{
//            endSearch()
//            UIView.animate(withDuration: 1.0, animations: {
//                self.matchInfoCV.alpha = 1.0
//            })
//            return
//        }

        let delays = [0.0,0.5,1.0]
        let tags = [34,35,36]
        let center = CGPoint(x: view.frame.width/2 - 75 , y: view.frame.height/2 - 150)
        let iv = UIImageView(frame: CGRect(origin: center , size: CGSize(width: 150, height: 150)))
        iv.layer.cornerRadius = 75
        iv.layer.masksToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 2.0
        iv.tag = 33
        
    
            if  view.viewWithTag(33) == nil{
                if  let userImage = GymmieUser.currentUser()!.image{
                    iv.image = userImage
                    iv.contentMode = .scaleAspectFill
                }else{
                    iv.loadImageWithURL(url: GymmieUser.currentUser()!.imageURL!)
                }
                view.insertSubview(iv, belowSubview: matchInfoCV)
            }
        
     
        for i in 0...2{
            let circleView = UIView()
                circleView.frame =  CGRect(origin: center , size: CGSize(width: 150, height: 150))
                circleView.tag = tags[i]
                circleView.backgroundColor = gymmieOrange().withAlphaComponent(0.8)
                circleView.layer.cornerRadius = 75
                circleView.layer.borderColor = gymmieOrange().cgColor
                circleView.layer.borderWidth = 2
            
            if matches.count == 0 || searchingForMatch {
                if view.viewWithTag(tags[i]) == nil{
                    view.insertSubview(circleView , belowSubview: view.viewWithTag(33)!)
                    let expand = CABasicAnimation(keyPath: "transform.scale")
                        expand.fromValue = 1.0
                        expand.toValue = 3.0
                    
                    let fade = CABasicAnimation(keyPath: "opacity")
                        fade.fromValue = 1.0
                        fade.toValue = 0
                    
                    let combine = CAAnimationGroup()
                        combine.animations = [expand,fade]
                        combine.duration = 2.5
                        combine.beginTime = CACurrentMediaTime().advanced(by: delays[i])
                        combine.delegate = self
                        combine.setValue(tags[i], forKey: "searchAnim")
                        combine.isRemovedOnCompletion = true
                    circleView.layer.add(combine, forKey: nil)
                }
              
            }
            
            
        }
    }
    
    let matchInfoCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: 300, height: 400)
        let frame = CGRect(x: 0, y: 0, width:300, height: 500)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
            cv.backgroundColor = UIColor.white
            cv.translatesAutoresizingMaskIntoConstraints = false
            cv.alpha = 0
            cv.showsVerticalScrollIndicator = false
        return cv
    }()
    let controlView: UIView = {
        let v = UIView()
            v.backgroundColor = UIColor.clear
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    var passShadow = CALayer()
    var failShadow = CALayer()
    
    func showPass_FailShadow(pass: Bool){
        print(pass)
        if let shadow = view.layer.sublayers?.last{
            if shadow.backgroundColor == UIColor.clear.cgColor{
                passShadow.shadowOpacity = pass ? 1 : 0
                failShadow.shadowOpacity = pass ? 0 : 1
                return
            }
        }
        print("making shadow")
            passShadow.backgroundColor = UIColor.clear.cgColor
            failShadow.backgroundColor = UIColor.clear.cgColor
            passShadow.frame = CGRect(x: view.frame.width, y: 0, width: 10, height: view.frame.height)
            failShadow.frame = CGRect(x: -10, y: 0, width: 10, height: view.frame.height)
            view.layer.addSublayer(passShadow)
            view.layer.addSublayer(failShadow)
            passShadow.shadowColor = UIColor.green.cgColor
            failShadow.shadowColor = UIColor.red.cgColor
            passShadow.shadowRadius = 10
            failShadow.shadowRadius = 10
            passShadow.shadowOffset = CGSize(width: -10, height: 0)
            failShadow.shadowOffset = CGSize(width: 10, height: 0)
            passShadow.shadowPath = UIBezierPath(rect: passShadow.bounds).cgPath
            failShadow.shadowPath = UIBezierPath(rect: failShadow.bounds).cgPath
            passShadow.shadowOpacity = pass ? 1 : 0
            failShadow.shadowOpacity = pass ? 0 : 1
    }
    
    let ROTATION_STRENGTH:CGFloat = 320
    let ROTATION_MAX:CGFloat = 1
    let ROTATION_ANGLE = M_PI/8
    var originalPoint = CGPoint.zero
    var nextHeightCon = NSLayoutConstraint()
    var nextWidthCon = NSLayoutConstraint()
    @objc func passFailHandler(_ gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: matchInfoCV)
        let direction = gesture.velocity(in: matchInfoCV)
        let xFromCenter = gesture.translation(in: gesture.view?.superview).x
    
        switch gesture.state {
        case .began:
           print("Began")
            originalPoint = self.view.center
//           if matchInfoCV.center.x == originalPoint.x && direction.y != 0{
//           
//            break
//            }
        case .changed:
           
            if abs(xFromCenter) > 10{
                
            
            showPass_FailShadow(pass: xFromCenter > 30)
            
            let rotationStrength:CGFloat = CGFloat(min(xFromCenter/ROTATION_STRENGTH, ROTATION_MAX))
            let rotationAngle = CGFloat(ROTATION_ANGLE)*rotationStrength
            let transform = CGAffineTransform(rotationAngle: rotationAngle)
            
            matchInfoCV.transform = transform
            matchInfoCV.center.x = originalPoint.x + xFromCenter
            matchInfoCV.alpha = 1.0 - abs(xFromCenter/view.frame.width)
            //nextImage.frame.size.height = min(view.frame.height,nextHeightCon.constant + abs(nextHeightCon.constant*(xFromCenter/view.frame.width)))
            print("Height Con is \(nextHeightCon.constant)")
           // nextImage.frame.size.width = min(view.frame.width,nextWidthCon.constant +  abs(nextWidthCon.constant*(xFromCenter/view.frame.height)))
            print("Width Con is \(nextWidthCon.constant)")
            }
        case .ended:
            passShadow.removeFromSuperlayer()
            failShadow.removeFromSuperlayer()
            
            let like = translation.x > 100
            let dislike = translation.x < -100
            if like{
                growFromCenter()
                like_disLikeUser(like: like)
                
                break
            }else if dislike{
                growFromCenter()
                like_disLikeUser(like: false)
             
                break
            }else{
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                    self.matchInfoCV.center.x = self.originalPoint.x
                    self.matchInfoCV.transform = CGAffineTransform(rotationAngle: 0)
                    self.matchInfoCV.alpha = 1.0
                    }, completion: nil)
            }
        default:
            break
        }
    }

    func growFromCenter(){
  
                matchInfoCV.transform = CGAffineTransform(rotationAngle: 0)
                matchTopCon.constant = view.frame.height
                matchInfoCV.center.x = view.center.x
        
                view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
                    self.matchInfoCV.alpha = 1.0
                    self.nextWidthCon.constant = self.view.frame.width*0.75
                    self.matchTopCon.constant = 0
                    self.view.layoutIfNeeded()
                    },completion: {_ in
                        if self.matchToView != nil{
                        self.matchInfoCV.scrollToItem(at: IndexPath(item:0,section:0), at: .top, animated: true)
                        }
                        self.view.layoutIfNeeded()
                })
    
    }

    @objc func like_disLikePressed(_ sender: UIButton){
        like_disLikeUser(like: sender.tag == 1)
    }
    
    func like_disLikeUser(like: Bool){
        //send like or dislike message to Gymmie Server
        guard let userWorkout = workoutToView else{return}
        guard let match = matchToView else { return }
             let data = AppDatabase()
                 data.matchesDelegate = self
                 data.match_UnmatchUser(partner: match, partnerEvent: userWorkout, for: workout , match: like)
        if let appDel = UIApplication.shared.delegate as? AppDelegate{
            if match.isAMatch && like{
//                appDel.swipedRightWhenLiked(swiped: true)
            }else if match.isAMatch && !like{
//                appDel.swipedRightWhenLiked(swiped: false)
            }
        }
            matchToView = self.matches.popLast()
        if matches.count == 0 && matchToView == nil{
            self.matchInfoCV.isScrollEnabled = false
            passFailBottomCon.constant = passFailView.frame.height
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
                self.matchInfoCV.alpha = 0
                },completion:{_ in
                    
                    self.searchingForMatch = true
                    self.makeSearch()
                    self.inviteMessage()
            })
        }
    }
    
    func setTitle(){
        if let title = UIApplication.shared.keyWindow?.viewWithTag(13){
                title.alpha = 1.0
        }
        if let count = navigationController?.viewControllers.count{
            if count < 2{
            let homeItem = UIBarButtonItem(title: "HOME", style: .plain, target: self, action: #selector(MatchProfileVC.goHomeHandler(_:)))
                navigationItem.leftBarButtonItem = homeItem
            }
        }
        let settingsItem = UIBarButtonItem(title: "SETTINGS", style: .plain, target: self, action: #selector(MatchProfileVC.settingsHandler(_:)))
            navigationItem.rightBarButtonItem = settingsItem
    }
    
    @objc func settingsHandler(_ sender: UIBarButtonItem){
        endSearch()
        searchingForMatch = false
        
        let workoutGen = WorkoutGeneratorVC()
            workoutGen.workout = workout
            workoutGen.editingWorkout = true
            workoutGen.view.alpha = 0
            workoutGen.view.frame = navigationController!.view.frame
        navigationController!.addChild(workoutGen)
        navigationController!.view.addSubview(workoutGen.view)
       
        let title = UIApplication.shared.keyWindow?.viewWithTag(13)
        
        UIView.animate(withDuration: 0.25, animations: {
            workoutGen.view.alpha = 1
              title?.alpha = 0
        })
    
        
    }
    var passFailBottomCon = NSLayoutConstraint()
    let passFailView: PassFailView = {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let v = PassFailView(frame: frame)
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var matchHeightCon = NSLayoutConstraint()
    var matchWidthCon = NSLayoutConstraint()
    var pass_failGesture = UIPanGestureRecognizer()
    var showDetailGesure = UIPanGestureRecognizer()
    
    var matchTopCon = NSLayoutConstraint()
    var topOffset:CGFloat{
       return navigationController!.navigationBar.frame.height + 20
    }
    var nextTopCon = NSLayoutConstraint()
    func setViews(){
        
        view.backgroundColor = UIColor.white//gymmieOrange().withAlphaComponent(0.6)
        view.add(views: matchInfoCV,passFailView)
        matchInfoCV.constrainInView(view: view, top: nil, left: -20, right: 20, bottom: 0)
    
        matchTopCon = matchInfoCV.setTopTo(con: view.top(), by: 0)
        
//        controlView.constrainWithMultiplier(view: matchInfoCV, width: 1.0, height: 1.0)
        pass_failGesture = UIPanGestureRecognizer(target: self , action: #selector(MatchProfileVC.passFailHandler(_:)))
        pass_failGesture.delaysTouchesBegan = true
        matchInfoCV.addGestureRecognizer(pass_failGesture)
        for gesture in matchInfoCV.gestureRecognizers!{
            if gesture == pass_failGesture{
                gesture.delegate = self
            }
        }
//        controlView.addGestureRecognizer(pass_failGesture)
        
        passFailView.constrainInView(view: view, top: nil, left: -20, right: 20, bottom: nil)
        passFailBottomCon = passFailView.setBottomTo(con: view.bottom(), by: 0)
        passFailView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        passFailView.goButton.addTarget(self, action: #selector(MatchProfileVC.like_disLikePressed(_:)), for: .touchUpInside)
        passFailView.noGoButton.addTarget(self, action: #selector(MatchProfileVC.like_disLikePressed(_:)), for: .touchUpInside)
    }
    
    let handleView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var inviteLabel: UILabel = {
        let label = UILabel()
        label.textColor = gymmieOrange()
        label.textAlignment = .center
        label.alpha = 0
        label.adjustsFontSizeToFitWidth = true 
        label.text = "Looks like there are no more matches near you"
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let inviteButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Invite your Friends :)", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = gymmieOrange()
        button.layer.cornerRadius = 10.0
        button.layer.borderWidth = 1.0
        button.alpha = 0
        button.layer.borderColor = gymmieOrange().cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   
    @objc func invite(_ sender: UIButton){
        
//        var content = FBSDKAppInviteContent()
//        //https://itunes.apple.com/us/app/gymmie-app/id1148412934?ls=1&mt=8
//        content.appLinkURL = URL(string: "https://fb.me/1261130080636284")
//        content.appInvitePreviewImageURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/gymmie-569f6.appspot.com/o/Images%2FFacebookInviteImage%2FgymmieLogoForFB.jpg?alt=media&token=34e13cab-31d2-4132-a403-e286e39acf7a")
//        if let title = UIApplication.shared.keyWindow?.viewWithTag(13){
//            title.alpha = 0
//        }
//        searchingForMatch = false
//        if let home = navigationController?.viewControllers[0] as? HomeVC{
//            home.invite()
//        }
//         navigationController?.popViewController(animated: false)
//
        
    }
  
    func inviteMessage(){
        view.add(views: inviteButton,inviteLabel)
        inviteButton.constrainInView(view: view , top: nil, left: 0, right: 0, bottom: -10)
        inviteButton.setHeightTo(constant: 50)
        
        inviteLabel.constrainInView(view: view , top: nil, left: 0, right: 0, bottom: nil)
        inviteLabel.setBottomTo(con: inviteButton.top(), by: -10)
        
        inviteButton.addTarget(self, action: #selector(MatchProfileVC.invite(_:)), for: .touchUpInside)
        UIView.animate(withDuration: 0.5, animations: {
            self.inviteButton.alpha = 1.0
            self.inviteLabel.alpha = 1.0
            self.passFailView.alpha = 0
        })

    }
    
    var matchToView: GymmieUser?{
        didSet{
                workoutToView = matchToView?.events?.first
            DispatchQueue.main.async(execute: {
                self.matchInfoCV.reloadData()
            })
        }
        
    }
    
    var workoutToView: Event?
    
    var matchedWorkouts = [Event](){
        didSet{
            workoutToView = matchedWorkouts.popLast()
        }
    }
    
    var matches = [GymmieUser]()
    
    var workout = Event(){
        didSet{
            passFailView.workout = workout
        }
    }
    
    @objc func goHomeHandler(_ sender:UIBarButtonItem){
        navigationController?.viewControllers = [HomeVC()]
    }
}
class MatchSectionView: UICollectionReusableView{
    
    override func layoutSubviews() {
        setViews()
    }
    
    var attributeLabel: UILabel = {
        let label = UILabel()
            label.textColor = gymmieOrange()
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 18, weight: .light)
            //label.layer.borderWidth = 1
    return label
    }()
    
    func setViews(){
        layer.borderWidth = 2
        layer.borderColor = createColor(233, green: 233, blue: 233).cgColor
        backgroundColor = createColor(245, green: 245, blue: 245)
        addSubview(attributeLabel)
        attributeLabel.setXTo(con: self.x(), by: 0)
        attributeLabel.setYTo(con: self.y(), by: 0)
    }
}
extension MatchProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return section == 0 ? CGSize.zero : CGSize(width: view.frame.width, height: 25)
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let suppView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MatchSectionView", for: indexPath) as! MatchSectionView
        let titles = ["","About Me","Partner Preferences","Special Workout Considerations","Partner Rating"]
        suppView.attributeLabel.text = titles[indexPath.section]
        return suppView
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        guard let workout = workoutToView else { return cell }
        //            let match = workout.planner
        guard let match = matchToView else{ return CGSize.zero }
        let defaultSize = CGSize(width: view.frame.width , height: 30)
        switch indexPath.section {
        case 0:
            return CGSize(width: view.frame.width, height:view.frame.height*0.4)
        case 1,2,3:
           //About  || Partner Preferences || Workout Considerations Section
            let userInfo = [1:match.bio,2:match.partnerPreferences,3:match.workoutConsiderations]
            let infoForSection = userInfo[indexPath.section]!
            let info = infoForSection.isEmpty ? "Not Applicable" : infoForSection
            let size = CGSize(width: view.frame.width, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimateSize = NSString(string: info).boundingRect(with: size, options: options, attributes: [.font:UIFont.systemFont(ofSize: 14)], context: nil)
            let sizeForDetail = CGSize(width: view.frame.width, height: estimateSize.height+24)
                return sizeForDetail
//
//        case 2:
//            //Goals Section
//            let stackHeight:CGFloat = match.fitnessGoals.count > 3 ? 85 : 45
//            let sizeForDetail = CGSize(width: view.frame.width, height: stackHeight)
//                return match.fitnessGoals.isEmpty ? CGSize(width: view.frame.width, height: 50) : sizeForDetail
//        case 3:
//            
//            //Fitness Level
//              return CGSize(width: view.frame.width, height: 50)
//        case 6:
//            
//            //Exercise
//            let height:CGFloat =  workout.exercises.count > 3 ? 85 : 45
//            let sizeForDetail = CGSize(width: view.frame.width, height: height)
//            return workout.exercises.isEmpty ? CGSize(width:view.frame.width, height: 50) : sizeForDetail
        case 4:
            // Rating
            return CGSize(width: view.frame.width, height:60)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  matches.count > 0 ? 5 : matchToView == nil ? 0 : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count > 0 ? 1 : matchToView == nil ? 0 : 1
    }
 
    func matchInfoCell(at indexPath: IndexPath)->MatchInfoCell{
        let cell = matchInfoCV.dequeueReusableCell(withReuseIdentifier: "MatchInfoCell", for: indexPath) as! MatchInfoCell
//        pass_failGesture = UIPanGestureRecognizer(target: self , action: #selector(MatchProfileVC.passFailHandler(_:)))
//        cell.addGestureRecognizer(pass_failGesture)
        guard let match = matchToView else {  return  cell }
        let info = [1:match.bio,2:match.partnerPreferences,3:match.workoutConsiderations]
        if let detail = info[indexPath.section]{
            cell.info = detail.isEmpty ? "NA" : detail
        }
        return cell
    }
    
    func matchDetailCell(at indexPath: IndexPath)->MatchDetailCell{
        let cell = matchInfoCV.dequeueReusableCell(withReuseIdentifier: "MatchDetailCell", for: indexPath) as! MatchDetailCell
        guard let workout = workoutToView else { return cell }
        guard let match = matchToView else {return cell }
//        pass_failGesture = UIPanGestureRecognizer(target: self , action: #selector(MatchProfileVC.passFailHandler(_:)))
//        cell.addGestureRecognizer(pass_failGesture)
        let filteredExercises = workout.exercises.filter({$0 != ""})
        let exercises = filteredExercises.isEmpty ? ["None Set"] : filteredExercises
        let goals = match.fitnessGoals.first == "" ? ["Not Really into Goals..."] : match.fitnessGoals
        let details:[Int:[String]?] = [2:goals,3:[match.fitnessLevel],6:exercises]
        if cell.tintColor != UIColor.red{
        
            if let detail = details[indexPath.section]{
                cell.addOptions(for: detail!)
                cell.tintColor = UIColor.red
            }
        }
        return cell
    }
    func matchViewCell( at indexPath: IndexPath)->MatchViewCell{
        let cell = matchInfoCV.dequeueReusableCell(withReuseIdentifier: "MatchViewCell", for: indexPath) as! MatchViewCell
//             pass_failGesture = UIPanGestureRecognizer(target: self , action: #selector(MatchProfileVC.passFailHandler(_:)))
//            cell.addGestureRecognizer(pass_failGesture)
            cell.imageSessionTask?.cancel()
            cell.matchViewDelegate = self
        guard let match = matchToView else {return cell }
        guard let workout = workoutToView else {return cell}
            cell.match = match
            cell.workout = workout
        return cell
    }
    
    func ratingCell(at indexPath: IndexPath)->MatchRatingCell{
        let cell = matchInfoCV.dequeueReusableCell(withReuseIdentifier: "MatchRatingCell", for: indexPath) as! MatchRatingCell
        
        guard let match = matchToView else {return cell  }
        if  cell.tintColor != UIColor.red{
            cell.setRating(for: match.rating ?? 5)
            cell.tintColor = UIColor.red
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            return matchViewCell(at: indexPath)
        case 1,2,3:
            return matchInfoCell(at: indexPath)
        case 4:
            return ratingCell(at: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    func show_HideSelection(){
        let hide = matchInfoCV.contentOffset.y == 0
        print(matchInfoCV.contentOffset.y)
        let offset = CGFloat(hide ?  -self.passFailView.frame.height:0)
        print(offset)
        UIView.animate(withDuration: 0.25, animations: {
            self.passFailView.frame.origin.y = self.view.frame.height + offset
        })
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            controlView.alpha = 1.0
            show_HideSelection()
    }
}

extension MatchProfileVC : DatabaseMatchesDelegate{
    func getMatches(){
        let data = AppDatabase()
            data.matchesDelegate = self
            data.getMatches(for: workout.eventID)
    }
    func endSearch(){
        searchingForMatch = false
        for i in 33...36{
            if let animView = view.viewWithTag(i){
                animView.layer.removeAllAnimations()
                animView.removeFromSuperview()
            }
        }
    }
    func foundMatches(matches: [GymmieUser]){
        let fbMatches = matches.filter({$0.fbURL?.isEmpty == false})
        for match in fbMatches{
            match.getImage()
        }
        searchingForMatch = fbMatches.count == 0
        if searchingForMatch{
            DispatchQueue.main.async(execute: {
                self.inviteMessage()
            })
           
            return
        }
        
        let matchesFound = fbMatches.sorted(by: { user1, user2 in
            let event1 = user1.events?.first?.dateForEvent()
            let event2 = user2.events?.first?.dateForEvent()
            return event1?.compare(event2!) == .orderedAscending
        })
        
        if let user = GymmieUser.currentUser(){
            let justMen = user.menOnly && !user.womenOnly
            let justWomen = user.womenOnly && !user.menOnly
            if justMen{
                self.matches = matchesFound.filter({$0.gender == "male"})
                 matchToView = self.matches.popLast()
                return
            }
            
            if justWomen{
                self.matches = matchesFound.filter({$0.gender == "female"})
                matchToView = self.matches.popLast()
                return
            }
        }
        
        self.matches = matchesFound
        matchToView = self.matches.popLast()
    }
     
    func matchedWithUser(matched: Bool,user: GymmieUser){
        matchInfoCV.isUserInteractionEnabled = false
        passFailView.isUserInteractionEnabled = false 
        let matchPage = MatchPartnerVC()
            matchPage.userMatch = user
            matchPage.workout = workout
            matchPage.matchedWorkout = user.events!.first!
            matchPage.localUserImage.image = GymmieUser.currentUser()!.image!
        DispatchQueue.main.async {
             self.navigationController?.pushViewController(matchPage, animated: true)
        }
       
    }
    
    func connectionFailed(){}
    func failedToGetData(){}

}
extension MatchProfileVC : CAAnimationDelegate{
   
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let tag = anim.value(forKey: "searchAnim") as? Int{
        
            view.viewWithTag(tag)?.removeFromSuperview()
            
            if tag == 35 {
                if matchToView != nil && !searchingForMatch{
                    UIView.animate(withDuration: 0.25, animations: {
                        self.matchInfoCV.alpha = 1.0
                    
                        }, completion: {_ in
                            self.endSearch()
                    })
                    
                }else{
                  makeSearch()
                }
            }
        }
        
    }
}
//extension MatchProfileVC : FBSDKAppInviteDialogDelegate{
//    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
//        print(error?.localizedDescription)
//
//    }
//    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
//
//    }
//
//}

extension MatchProfileVC: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
         return true
    }
}
extension MatchProfileVC: MatchViewDelegate{
    @objc func dismissMatch(_ gesture: UITapGestureRecognizer){
        if let iv = view.viewWithTag(69), let shade = view.viewWithTag(70){
               let title = UIApplication.shared.keyWindow?.viewWithTag(13)
            if let viewCell = matchInfoCV.cellForItem(at: IndexPath(item: 0, section: 0)) as? MatchViewCell{
                show_HideSelection()
                UIView.animate(withDuration: 1.0, animations: {
                    iv.frame = viewCell.profileImage.frame
                    iv.layer.cornerRadius = viewCell.profileImage.layer.cornerRadius
                    self.navigationController?.isNavigationBarHidden = false
                    shade.frame.size.height -= self.passFailView.frame.height
                    title?.alpha = 1.0
                    },completion: {_ in
                        UIView.animate(withDuration: 0.25, animations: {
                            iv.alpha = 0
                            shade.alpha = 0
                            },completion: {_ in
                                if let gesture = iv.gestureRecognizers?.first{
                                    iv.removeGestureRecognizer(gesture)
                                }
                                if let gesture = shade.gestureRecognizers?.first{
                                    shade.removeGestureRecognizer(gesture)
                                }
                                iv.removeFromSuperview()
                                shade.removeFromSuperview()
                            
                        })
                })
            }
        }
    }
    func showMatch(image: UIImage){
        if matchInfoCV.contentOffset.y == 0{
        
            if let viewCell = matchInfoCV.cellForItem(at: IndexPath(item: 0, section: 0)) as? MatchViewCell{
            
                let shade = UIView()
                    shade.tag = 70
                    shade.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                    shade.frame = CGRect(x: 0, y: -72, width: navigationController!.view.frame.width, height: navigationController!.view.frame.height+passFailView.frame.height)
                    shade.alpha = 0
                    view.addSubview(shade)
                
                let dismissGestureShade = UITapGestureRecognizer(target: self , action: #selector(MatchProfileVC.dismissMatch(_:)))
                    shade.addGestureRecognizer(dismissGestureShade)
                let dismissGesture = UITapGestureRecognizer(target: self , action: #selector(MatchProfileVC.dismissMatch(_:)))
                    shade.addGestureRecognizer(dismissGesture)
                
                let iv = UIImageView()
                    iv.image = image
                    iv.tag = 69
                    iv.layer.borderColor = UIColor.white.cgColor
                    iv.layer.borderWidth = 2
                    iv.contentMode = .scaleAspectFill
                    iv.layer.masksToBounds = true
                    iv.layer.cornerRadius = viewCell.profileImage.layer.cornerRadius
                    iv.frame = viewCell.profileImage.frame
                    iv.isUserInteractionEnabled = true
                    iv.addGestureRecognizer(dismissGesture)
                    view.addSubview(iv)
                let title = UIApplication.shared.keyWindow?.viewWithTag(13)
                
               
                let offset = -self.passFailView.frame.height
              
                    self.passFailView.frame.origin.y = self.view.frame.height + offset
             
                
                UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.3, options: [], animations: {
                        shade.alpha = 1.0
                        iv.frame.size.height = self.view.frame.height*0.5
                        iv.frame.size.width = self.view.frame.width*0.8
                        iv.frame.origin.x = self.view.frame.width*0.1
                        iv.frame.origin.y = 30
                        iv.contentMode = .scaleAspectFit
                        iv.layer.cornerRadius = 10.0
                        self.navigationController?.isNavigationBarHidden = true
                        self.passFailView.frame.origin.y = self.view.frame.height
                        title?.alpha = 0
                    }, completion: nil)
            }
        }
    }
}
