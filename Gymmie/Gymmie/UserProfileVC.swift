
//
//  UserProfileVC.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/17/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
import Photos
//import Firebase
//import FirebaseStorage
//import FirebaseDatabase
class UserProfileVC: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            userInfoCV.register(ProfileViewCell.self , forCellWithReuseIdentifier: "ProfileViewCell")
            userInfoCV.register(ProfileInfoCell.self , forCellWithReuseIdentifier: "ProfileInfoCell")
            userInfoCV.register(ProfileDetailCell.self , forCellWithReuseIdentifier: "ProfileDetailCell")
            userInfoCV.register(ProfileFitnessCell.self , forCellWithReuseIdentifier: "FitnessCell")
            userInfoCV.register(SectionView.self , forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionView")
            userInfoCV.delegate = self
            userInfoCV.dataSource = self
            navigationController?.navigationBar.barTintColor = UIColor.white
           
            // Do any additional setup after loading the view.
        }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            setViews()
            user = GymmieUser.currentUser()!
            setKeyBoardNotification()
        }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        }

        let userInfoCV: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                layout.itemSize = CGSize(width: 300, height: 400)
            let frame = CGRect(x: 0, y: 0, width:300, height: 500)
            let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
                cv.backgroundColor = UIColor.white
                cv.translatesAutoresizingMaskIntoConstraints = false
            return cv
        }()
   
        func setTitle(){
            let menuItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menuButton"), style: .plain, target: self, action: nil)
            let circleItem = UIBarButtonItem(image: #imageLiteral(resourceName: "circleButton"), style: .plain, target: self, action: nil)
            //navigationItem.leftBarButtonItem = menuItem
            //navigationItem.rightBarButtonItem = circleItem
        }
   
    
        func setViews(){
            //setTitle()
            view.add(views:userInfoCV,editView)
            editView.delegate = self
            userInfoCV.constrainWithMultiplier(view: view , width: 1, height: 1)
            //userInfoCV.constrainInView(view: view , top: 0, left: -10, right: 10, bottom: 0)
            editView.constrainInView(view: view, top: nil, left: -20, right: 20, bottom: 0)
        }
   
    
    let editView: EditProfileView = {
        let v = EditProfileView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let goalView: AddGoalsView = {
        let v = AddGoalsView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var dismissEditGesture = UITapGestureRecognizer()
    var editingDetail = String()
    var editDetailView =  EditDetailView()
    var keyboardOffset = CGFloat()
    var user = GymmieUser()
}
class SectionView: UICollectionReusableView{
    override func layoutSubviews() {
        setViews()
    }
    
    var attributeLabel: UILabel = {
        let label = UILabel()
        label.textColor = gymmieOrange()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    func setViews(){
        layer.borderWidth = 2
        layer.borderColor = createColor(233, green: 233, blue: 233).cgColor
        backgroundColor = createColor(245, green: 245, blue: 245)
        addSubview(attributeLabel)
        attributeLabel.setYTo(con: self.y(), by: 0)
        attributeLabel.setXTo(con: self.x(), by: 0)
        attributeLabel.setWidthTo(constant: self.frame.width-20)
        
    }
    
}
extension UserProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
        
         func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
         let defaultSize = CGSize(width: view.frame.width , height: 30)
         switch indexPath.section {
         case 0:
                return CGSize(width: view.frame.width, height:view.frame.height*0.375)
         case 1,2,3:
            let info = [1:user.bio,2:user.partnerPreferences,3:user.workoutConsiderations]
            let size = CGSize(width:view.frame.width, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimateSize = NSString(string: info[indexPath.section]!).boundingRect(with: size, options: options, attributes: [.font:UIFont.systemFont(ofSize: 14)], context: nil)
            return CGSize(width: view.frame.width, height: max(30,estimateSize.height+24))
  
//         case 2:
//            let stackHeight = user.fitnessGoals.count > 3 ? 85 : 45
//            let editoffset = editView.editProfile ? 30 : 0
//           
//            let height = CGFloat(stackHeight + editoffset)
//            let sizeForDetail = CGSize(width: view.frame.width, height: height)
//            return user.fitnessGoals.isEmpty ? CGSize(width: view.frame.width, height: 50) : sizeForDetail
//         case 3:
//            return CGSize(width: view.frame.width , height: 45)
         default:
            return CGSize.zero
            }
         }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
    
    
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 4
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return section == 0 ? CGSize.zero : CGSize(width: view.frame.width, height: 30)
        }
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let suppView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionView", for: indexPath) as! SectionView
        let titles = ["","ABOUT ME","PARTNER PREFERENCES","SPECIAL WORKOUT CONSIDERATIONS"]
            suppView.attributeLabel.text = titles[indexPath.section]
        return suppView
        
    }
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if editView.editProfile{
                let titles = ["","About Me","Partner Preferences","Special Workout Considerations"]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileInfoCell", for: indexPath) as! ProfileInfoCell
            cell.infoTextView.becomeFirstResponder()
            cell.infoTextView.resignFirstResponder()
            switch indexPath.section{
            case 1,2,3:
                editingDetail  = titles[indexPath.section]
                show_HideEdit(show: editView.editProfile)
//            case 2:
//                if editView.editProfile {
//                    showGoals()
//                }
            default: editingDetail = ""
                }
            }
        }
      
        func userInfoCell(at indexPath: IndexPath)->ProfileInfoCell{
            let cell = userInfoCV.dequeueReusableCell(withReuseIdentifier: "ProfileInfoCell", for: indexPath) as! ProfileInfoCell
            let titles = ["","About Me","Partner Preferences","Special Workout Considerations"]
                cell.titleLabel.text = titles[indexPath.section]
                cell.editing = editView.editProfile
            
            switch indexPath.section {
            case 1:
                 cell.info = user.bio
                 
                return cell
            case 2:
                
                let preferences = user.partnerPreferences.isEmpty ? "None" : user.partnerPreferences
                cell.info = preferences
               
                return cell
            case 3:
                let considerations = user.workoutConsiderations.isEmpty ? "None" : user.workoutConsiderations
                 cell.info = considerations
              
                return cell
            default:
                return cell
            }
        }
        
        func userDetailCell(at indexPath: IndexPath)->ProfileDetailCell{
            let cell = userInfoCV.dequeueReusableCell(withReuseIdentifier: "ProfileDetailCell", for: indexPath) as! ProfileDetailCell
            
                switch indexPath.section{
                case 2:
                        if editView.editProfile{
                            cell.titleLabel.text = "Goals"
                            let goals = user.fitnessGoals.filter({$0 != ""})
                            cell.addOptions(for: goals,editing: editView.editProfile)
                            cell.delegate = self 
                             return cell
                        }
                    cell.titleLabel.text = "Goals"
                        if !user.fitnessGoals.contains(""){
                    cell.addOptions(for: user.fitnessGoals,editing: editView.editProfile)
                    cell.tintColor = UIColor.red
                        }
                   
                    return cell
                default:
                    return cell
                }
        }
    
        func profileViewCell( at indexPath: IndexPath)->ProfileViewCell{
            let cell = userInfoCV.dequeueReusableCell(withReuseIdentifier: "ProfileViewCell", for: indexPath) as! ProfileViewCell
                cell.delegate = self
            
            if let image = user.image{
                cell.profileImage.image = image
                cell.profileImage.layer.masksToBounds = true
                cell.profileImage.layer.cornerRadius = 75
                cell.profileImage.layer.borderColor = UIColor.white.cgColor
                cell.profileImage.layer.borderWidth = 2
                cell.profileBlurImage.image = image
            }
            if let imageURL = user.imageURL{
                if !imageURL.isEmpty{
                    cell.photoURL = imageURL
                }else{
                    cell.setDefaultImage()
                }
            }
                cell.nameField.backgroundColor = editView.editProfile ? createColor(240, green: 240, blue: 240).withAlphaComponent(0.6) : UIColor.clear
                cell.ageField.backgroundColor = editView.editProfile ? createColor(240, green: 240, blue: 240).withAlphaComponent(0.6) : UIColor.clear
                cell.ageField.alpha = !editView.editProfile && user.age == nil ? 0 : 1
                cell.ageField.isUserInteractionEnabled = editView.editProfile
                cell.nameField.isUserInteractionEnabled = editView.editProfile
                cell.user = user
            return cell
        }
      
    func fitnessCell( at indexPath: IndexPath)->ProfileFitnessCell{
        let cell = userInfoCV.dequeueReusableCell(withReuseIdentifier: "FitnessCell", for: indexPath) as! ProfileFitnessCell
            cell.delegate = self
            cell.fitnessLevel = user.fitnessLevel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch indexPath.section{
            case 0:
                return profileViewCell(at: indexPath)
//            case 2:
//                return userDetailCell(at: indexPath)
//            case 3:
//                return fitnessCell(at: indexPath)
            case 1,2,3:
                return userInfoCell(at: indexPath)
            default:
                return UICollectionViewCell()
            }
        }
    
    func show_HideEditView(){
        let lastPath = IndexPath(item: 0, section: 5)
        if let lastCell = userInfoCV.cellForItem(at: lastPath){
            let hide = userInfoCV.visibleCells.contains(lastCell)
            print(hide)
        }
        let hide = userInfoCV.contentOffset.y > 0
        print(userInfoCV.contentOffset.y)
        let offset = CGFloat(hide ?  0 : -self.editView.frame.height)
        print(offset)
    
        UIView.animate(withDuration: 0.25, animations: {
            self.editView.frame.origin.y = self.view.frame.height + offset
        })
        print(editView.frame)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        show_HideEditView()
    }
  
    }
extension UserProfileVC: EditProfileDelegate{
    func hideBar(hide: Bool){
//        navigationController?.isNavigationBarHidden = hide
//        UIApplication.shared.keyWindow?.viewWithTag(13)?.alpha = hide ? 0 : 1.0
    }
    func cancelEdit(){
        hideBar(hide: false)
        
        let fitnessPath = IndexPath(item: 0, section: 3)
        if let fitnessCell = userInfoCV.cellForItem(at: fitnessPath) as? ProfileFitnessCell{
            fitnessCell.setLevel(level: user.fitnessLevel)
            fitnessCell.isUserInteractionEnabled = false
        }
        let paths = userInfoCV.indexPathsForVisibleItems.filter({$0 != fitnessPath})
        userInfoCV.reloadItems(at: paths)
    }
    
    func saveEdit(){
        //add function to save userData
        hideBar(hide: false)
    
        user.bio = user.bio
        user.partnerPreferences = user.partnerPreferences
        user.workoutConsiderations = user.workoutConsiderations
        user.updateCurrentUser(server: true)
        let fitnessPath = IndexPath(item: 0, section: 3)
        
        if let fitnessCell = userInfoCV.cellForItem(at: fitnessPath) as? ProfileFitnessCell{
            fitnessCell.setLevel(level: user.fitnessLevel)
            fitnessCell.isUserInteractionEnabled = false
        }
        let paths = userInfoCV.indexPathsForVisibleItems.filter({$0 != fitnessPath})
        userInfoCV.reloadItems(at: paths)
    }
    
    func startEdit(){
       hideBar(hide: true)
        let fitnessPath = IndexPath(item: 0, section: 3)
        if let fitnessCell = userInfoCV.cellForItem(at: fitnessPath) as? ProfileFitnessCell{
            fitnessCell.setLevel(level: "")
            fitnessCell.isUserInteractionEnabled = true
        }
        let paths = userInfoCV.indexPathsForVisibleItems.filter({$0 != fitnessPath})
        userInfoCV.reloadItems(at: paths)
    }
}

extension UserProfileVC: ProfileDetailDelegate{
    func addNewGoal(){}
    func editDetail(){}
    
    @objc func dismissEdit(_ gesture: UITapGestureRecognizer){
        if let viewCell = userInfoCV.cellForItem(at: IndexPath(item: 0, section: 0)) as? ProfileViewCell{
            if viewCell.ageField.isFirstResponder{
                viewCell.ageField.resignFirstResponder()
            }else if viewCell.nameField.isFirstResponder{
                viewCell.nameField.resignFirstResponder()
            }
        }
    }
    func editScreen(set: Bool) {
        if set{
            let screen = UIView()
                screen.tag = 100
                screen.alpha = 0
                screen.backgroundColor = UIColor(white: 0.2, alpha: 0.6)
            if let viewCell = userInfoCV.cellForItem(at: IndexPath(item: 0, section: 0)){
                let rect = view.convert(viewCell.frame , to: view)
                screen.frame = CGRect(x: 0, y: rect.maxY, width: view.frame.width, height: view.frame.height*0.5)
                view.addSubview(screen)
                let dismissGesture = UIGestureRecognizer(target: self, action:#selector(UserProfileVC.dismissEdit(_:)))
                screen.addGestureRecognizer(dismissGesture)
                UIView.animate(withDuration: 0.25, animations: {
                    screen.alpha = 1.0
                })
            }
        }else{
            
            if let screen = view.viewWithTag(100){
                UIView.animate(withDuration: 0.25, animations: {
                    screen.alpha = 0.0
                    }, completion: {_ in
                        if let gestures = screen.gestureRecognizers{
                            for gesture in gestures{
                                screen.removeGestureRecognizer(gesture)
                            }
                        }
                        screen.removeFromSuperview()
                        
                })
            }
        }
    }
    
}
extension UserProfileVC: UITextFieldDelegate{
    
    func keyBoardWillShow(_ notification: Foundation.Notification){
//        let keyBoardEndRect = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let offset = keyBoardEndRect.height
//        let durationNumber = (notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
//        let duration = Double(durationNumber)
//        let originY = editDetailView.frame.origin.y
//        UIView.animate(withDuration: duration, animations: {
//            self.editDetailView.frame.origin.y = max(10,originY-offset)
//        })
//
    }
    
    func keyBoardWillHide(_ notification: Foundation.Notification){
//        let durationNumber = (notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
//        let duration = Double(durationNumber)
    }
    
    func setKeyBoardNotification(){
//        NotificationCenter.default.addObserver(self, selector: #selector(UserProfileVC.keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(UserProfileVC.keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

extension UserProfileVC: EditDetailDelegate{
    @objc func handleEdit(_ gesture: UITapGestureRecognizer){
        show_HideEdit(show: false)
    }
    func show_HideEdit(show: Bool){
        let textHeight = editingDetail.rectForText(width: view.frame.width*0.8, textSize: 20).height + 30
        var showFrame =  CGRect(x: 5, y: view.frame.height/2, width: view.frame.width*0.8, height: max(textHeight,view.frame.height*0.25))
            showFrame.origin.x = view.center.x - showFrame.width/2
        var hideFrame = CGRect(x: view.frame.width - 30, y: view.frame.height - 30, width: 25, height: 25)
        let userDetail = ["About Me" : user.bio, "Partner Preferences" : user.partnerPreferences, "Special Workout Considerations": user.workoutConsiderations]
       
        if show{
            let screen = UIView()
                screen.frame = view.bounds
                screen.tag = 69
                screen.backgroundColor = UIColor(white: 0.2, alpha: 0.6)
            dismissEditGesture = UITapGestureRecognizer(target: self , action: #selector(UserProfileVC.handleEdit(_:)))
                screen.addGestureRecognizer(dismissEditGesture)
            view.add(views: screen,editDetailView)
            view.bringSubviewToFront(editDetailView)
            editDetailView.delegate = self
            editDetailView.detail = editingDetail
            editDetailView.detailInfo = userDetail[editingDetail] ?? ""
            editDetailView.frame = hideFrame
        }
        
       
        UIView.animate(withDuration: 0.25, animations: {
            self.editDetailView.frame = show ? showFrame : hideFrame
            
            },completion: { _ in
                if !show{
                self.view.viewWithTag(69)?.removeFromSuperview()
                self.view.viewWithTag(69)?.removeGestureRecognizer(self.dismissEditGesture)
                self.editDetailView.removeFromSuperview()
                    return
                }
                self.editDetailView.detailTextView.becomeFirstResponder()
        })
        
    }
   
    func saveInfo(info: String) {
        switch editingDetail{
        case "About Me":
            user.bio = info
        case "Partner Preferences":
            user.partnerPreferences = info
        case "Special Workout Considerations":
            user.workoutConsiderations = info
        default: break
        }
        user.updateCurrentUser(server:true)
        userInfoCV.reloadData()
        show_HideEdit(show: false)
    }
}
extension UserProfileVC: ProfileViewDelegate{
    func setPhotos() {
        if editView.editProfile{
        getImage()
        }
    }
    func setInfo(details: (firstName:String,lastName:String, age: String)) {
        let firstName = details.firstName
        let lastName = details.lastName
        let age = details.age
        user.firstName = firstName.isEmpty ? user.firstName : firstName
        user.lastName = lastName.isEmpty ? user.lastName : lastName
        user.age = Int(age)
        user.updateCurrentUser(server:true)
    }
}

extension UserProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func photoHandler(_ action: UIAlertAction!){
  
        if let appSettings = URL(string: UIApplication.openSettingsURLString){
            UIApplication.shared.openURL(appSettings)
            }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        UINavigationBar.appearance().tintColor = UIColor.white
        self.dismiss(animated: true, completion: nil)
        if let logo = UIApplication.shared.keyWindow?.viewWithTag(13){
            logo.alpha = 1
        }
    }
    
    func getImage(){
        let imagePicker = UIImagePickerController()
        if PHPhotoLibrary.authorizationStatus() == .denied{
            let alertController = UIAlertController(title: "Settings", message: "Looks like we don't have acces to Photos. Enable access for Gymmie to continue.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Settings", style: .default, handler: photoHandler)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(action)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        }else{
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.hidesBarsOnSwipe = true
            UINavigationBar.appearance().tintColor = gymmieOrange()
            
            //imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
            imagePicker.navigationBar.tintColor = gymmieOrange()
            self.present(imagePicker, animated: true, completion: nil)
            if let logo = UIApplication.shared.keyWindow?.viewWithTag(13){
                logo.alpha = 0
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        guard let chatID = Auth.auth().currentUser?.uid else {return }
        
//        let origImge = info[UIImagePickerControllerOriginalImage] as? UIImage
        
//        let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
//
//        UINavigationBar.appearance().tintColor = UIColor.white
//
//            let imageToSend = editedImage == nil ? origImge : editedImage
//            if let cell = userInfoCV.cellForItem(at: IndexPath(item: 0, section: 0)) as? ProfileViewCell{
//                cell.profileImage.image = imageToSend
//                cell.profileBlurImage.image = imageToSend
//                user.image = imageToSend
//                let expand = CABasicAnimation(keyPath: "transform.scale")
//                    expand.toValue = 1.25
//                    expand.duration = 0.25
//                    expand.autoreverses = true
//                DispatchQueue.main.async {
//                     cell.profileImage.layer.add(expand , forKey: nil)
//                }
//
//            }
//            let imageData = UIImagePNGRepresentation(imageToSend!)
//            let storageRef = Storage.storage().reference().child("Images").child("Profile_Images").child(chatID).child(UUID().uuidString)
//            let width = imageToSend!.size.width
//            let height = imageToSend!.size.height
//
//        storageRef.putData(imageData!, metadata: nil, completion: {
//                metaData, error in
//                if error != nil{
//                    return
//                }
//            if let url = metaData?.downloadURL()?.path{
//                print(url)
//            }
//                if let url = metaData?.downloadURL()?.absoluteString{
////                    let width = NSNumber(value:Float(imageToSend.size.width))
////                    let height = NSNumber(value: Float(imageToSend.size.height))
////                    let timeStamp = String(Date().timeIntervalSince1970)
//
//                let userRef = Database.database().reference().child("Users").child(chatID)
//                    userRef.updateChildValues(["image_URL":url])
//                    self.user.imageURL = url
//                    self.userInfoCV.reloadData()
//                    self.saveEdit()
//                }
//            })
//
//        if let logo = UIApplication.shared.keyWindow?.viewWithTag(13){
//            logo.alpha = 1
//        }
//
//        self.dismiss(animated: false, completion: nil)
    }
}

extension UserProfileVC: AddGoalsDelegate{
    func goalTooLong(){
        alert(title: "Your goal is too wordy", message: "Keep it short please.")
    }
    func showGoals(){
        let screen = UIView()
            screen.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            screen.frame = view.bounds
            screen.tag = 69
        view.addSubview(screen)
        view.addSubview(goalView)
        goalView.delegate = self
        goalView.goals = user.fitnessGoals
        goalView.translatesAutoresizingMaskIntoConstraints = false
        goalView.constrainInView(view: view, top: 50, left: 0, right: 0, bottom: nil)
        goalView.heightAnchor.constraint(equalToConstant: 375).isActive = true
        goalView.alpha = 0.0
       
        UIView.animate(withDuration: 0.25, animations: {
            self.goalView.alpha = 1.0
        })
    }
    
    func cancelGoals() {
        if let screen = view.viewWithTag(69){
            screen.removeFromSuperview()
        }
        goalView.removeFromSuperview()
    }
    
    func submitGoals(goals: [String]) {
        cancelGoals()
        user.fitnessGoals = goals
        user.updateCurrentUser(server: true)
        let fitnessPath = IndexPath(item: 0, section: 3)
        let paths = userInfoCV.indexPathsForVisibleItems.filter({$0 != fitnessPath})
        userInfoCV.reloadItems(at: paths)
    }
}

extension UserProfileVC: FitnessDelegate{
    func setLevel(level: String) {
        user.fitnessLevel = level
    }
}

