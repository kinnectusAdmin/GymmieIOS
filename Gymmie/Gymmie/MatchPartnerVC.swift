//
//  MatchPartnerVC.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/5/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
//import Firebase
//import FirebaseAuth
//import FirebaseDatabase

class MatchPartnerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true 
        // Do any additional setup after loading the view.
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViews()
        animateUsers()
        if let title = UIApplication.shared.keyWindow?.viewWithTag(13){
            UIView.animate(withDuration: 0.25, animations: {
                title.alpha = 0.0
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let data = AppDatabase()
            data.notify(notification: "You have a new gym partner!", to: userMatch!.userID!, type: "INVITE")
        
        if let appDel = UIApplication.shared.delegate as? AppDelegate{
//                appDel.matchedWithUser(matched: true)
        }
        makeConvo()
    }
   
    func makeConvo(){
//        let workoutID = String(workout!.eventID)
//        let partnerWorkoutID = String(matchedWorkout.eventID)
//        
//        guard let chatterID = Auth.auth().currentUser?.uid else{return}
//        guard let partnerID = userMatch?.userID else { return }
//            let partnerRef = Database.database().reference().child("Users").queryOrdered(byChild: "user_id").queryEqual(toValue: partnerID)
//            let newConvoID = NSUUID().uuidString
//        workout?.convoID = newConvoID
//        matchedWorkout.convoID = newConvoID
//        
//        let data = AppDatabase()
//            data.addConvoFor(event: workout!, for: GymmieUser.currentUser()!)
//            data.addConvoFor(event: matchedWorkout, for: userMatch!)
//        
//            partnerRef.observeSingleEvent(of: .value , with: {
//            snapshot in
//            //get the partners information
//            if let object = snapshot.value as? [String:Any]{
//                print(object)
//                if let partnerID = object.map({ key, value in return key}).first{
//                
//                   
//                    let chatters = [chatterID,partnerID]
//                  
//                 //make the conversation for both users
//                let convoRef = Database.database().reference().child("User_Messages").child(newConvoID)
//                            convoRef.updateChildValues(["convoID":newConvoID,"conversantIDs":["0":chatterID,"1":partnerID],"workoutIDs":["0":workoutID,"1":partnerWorkoutID]])
//                }
//            }
//        })
//       
//        
//
//        
    }
    var workout: Event? {
        didSet{
            //workout?.partner = userMatch
            cardView.workout = workout
        }
    }
    
    var matchedWorkout = Event()
    
    var userMatch: GymmieUser?{
        didSet{
            if let url = userMatch?.imageURL{
                matchedUserImage.loadImageWithURL(url: url)
            }else{
                matchedUserImage.image = #imageLiteral(resourceName: "defaultImage2")
            }
        }
    }

    let cardView: WorkoutCardView = {
        let v = WorkoutCardView()
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let titleImage : UIImageView = {
        let iv = UIImageView()
            iv.image = #imageLiteral(resourceName: "gymmieTitle")
        
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
   
    let localUserImage : UIImageView = {
        let iv = UIImageView()
        iv.layer.borderWidth = 2
        iv.layer.masksToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let matchedUserImage : UIImageView = {
        let iv = UIImageView()
        iv.layer.borderWidth = 2
        iv.layer.masksToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let goImage : UIImageView = {
        let iv = UIImageView()
            iv.image = #imageLiteral(resourceName: "thumbsUp")
            iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let goChatButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Chat With Your Partner", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = gymmieOrange()
        button.layer.cornerRadius = 10.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let goHomeButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Go Back to Home", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = gymmieOrange()
        button.layer.cornerRadius = 10.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var matchLabel: UILabel = {
        let label = UILabel()
        let shadow = NSShadow()
            shadow.shadowColor = gymmieOrange()
            shadow.shadowOffset = CGSize(width: -2, height: 0)
            label.adjustsFontSizeToFitWidth = true
        let attributes: [NSAttributedString.Key:Any] = [.foregroundColor:UIColor.white,
                          .font:UIFont.systemFont(ofSize: 35, weight: .light)]
        let attString = NSAttributedString(string: "Meet Your Workout Partner!", attributes: attributes)
        
            label.textColor = UIColor.white
            label.attributedText = attString
            label.textAlignment = .center
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc func goChatHandler( _ sender: UIButton){
        if !workout!.convoID.isEmpty{
        let chatVC = ChatDetailVC()
                workout?.partner = userMatch
                chatVC.workout = workout!
                chatVC.matchedWorkout = matchedWorkout
        let home = HomeVC()
            navigationController?.pushViewController(chatVC , animated: true)
        }
    }
    
    @objc func goHomeHandler( _ sender: UIButton){
        if !workout!.convoID.isEmpty{
        let home = HomeVC()
            navigationController?.setViewControllers([home], animated: true )
        }
    }
    
    func animateUsers(){
        let localOriginX = view.layer.frame.minX
        let matchOriginX = view.layer.frame.maxX
        let imageWidth = view.frame.width*0.4/2
       let toCenter = CASpringAnimation(keyPath: "position.x")
            toCenter.fromValue = localOriginX
            toCenter.toValue = view.layer.frame.midX - imageWidth - 10
            toCenter.duration = toCenter.settlingDuration
        localUserImage.layer.add(toCenter, forKey: nil)
    
    let squeeze = CASpringAnimation(keyPath: "transform.scale")
        squeeze.fromValue = 0.7
        squeeze.toValue = 1.0
        squeeze.duration = squeeze.settlingDuration
        squeeze.beginTime = CACurrentMediaTime()+0.1
        localUserImage.layer.add(squeeze, forKey: nil)
        
    let toMatchCenter = CASpringAnimation(keyPath: "position.x")
        toMatchCenter.fromValue = matchOriginX
        toMatchCenter.toValue = view.layer.frame.midX+imageWidth+10
        toMatchCenter.duration = toMatchCenter.settlingDuration
        matchedUserImage.layer.add(toMatchCenter, forKey: nil)
        matchedUserImage.layer.add(squeeze, forKey: nil)
    }
    
    func setViews(){
       // setMatchAndWorkout()
        view.backgroundColor = UIColor(white: 0.2, alpha: 1)
        view.add(views:matchLabel,localUserImage,matchedUserImage,cardView,goImage,goChatButton,goHomeButton)
        let margins = view.layoutMarginsGuide
        //constrain title image
        //titleImage.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        //titleImage.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        //titleImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //titleImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        //constrain match label
        matchLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.95).isActive = true
        matchLabel.setTopTo(con: view.top(), by: 75)
        matchLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0).isActive = true
        //constrain local user image
        localUserImage.rightAnchor.constraint(equalTo: margins.centerXAnchor, constant: -10).isActive = true
        let heightWidth = view.frame.width*0.4
        let radius = heightWidth/2
        localUserImage.heightAnchor.constraint(equalToConstant: heightWidth).isActive = true
        localUserImage.widthAnchor.constraint(equalToConstant: heightWidth).isActive = true
        localUserImage.setTopTo(con: matchLabel.bottom(), by: 10)
         localUserImage.layer.cornerRadius = radius
        //constrain matched user image
        matchedUserImage.leftAnchor.constraint(equalTo: margins.centerXAnchor, constant: 10).isActive = true
        matchedUserImage.setYTo(con: localUserImage.y(), by: 0)
        matchedUserImage.heightAnchor.constraint(equalToConstant: heightWidth).isActive = true
        matchedUserImage.widthAnchor.constraint(equalToConstant: heightWidth).isActive = true
        matchedUserImage.layer.cornerRadius = radius
        //constrain goImage
        goImage.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        goImage.setYTo(con: localUserImage.bottom(), by: -10)
        goImage.heightAnchor.constraint(equalToConstant: 75).isActive = true
        goImage.widthAnchor.constraint(equalToConstant: 75).isActive = true
        //constrain gochat button
        goChatButton.setXTo(con: view.x(), by: 0)
        goChatButton.setTopTo(con: goImage.bottom(), by: 10)
        goChatButton.setWidthTo(constant: 250)
        goChatButton.addTarget(self , action: #selector(MatchPartnerVC.goChatHandler(_:)), for: .touchUpInside)
        //constrain gohome button
        goHomeButton.setXTo(con: view.x(), by: 0)
        goHomeButton.setTopTo(con: goChatButton.bottom(), by: 10)
        goHomeButton.setWidthTo(constant: 250)
        goHomeButton.addTarget(self , action: #selector(MatchPartnerVC.goHomeHandler(_:)), for: .touchUpInside)
        //constrain Card view
        cardView.constrainInView(view: view, top: nil, left: 0, right: 0, bottom: -40)
        cardView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
