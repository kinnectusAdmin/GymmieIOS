//
//  ChatDetailVC.swift
//  Gymmie
//
//  Created by Blake Rogers on 8/27/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit
import Photos
//import FirebaseAuth
//import Firebase
//import FirebaseStorage
//import FirebaseDatabase

class ChatDetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        setViews()
        chatDetailCV.contentInset.top = 20
        chatDetailCV.scrollIndicatorInsets.top = 20
        chatDetailCV.register(ChatDetailCell.self , forCellWithReuseIdentifier: "ChatDetailCell")
        chatDetailCV.register(MessageImageCell.self , forCellWithReuseIdentifier: "MessageImageCell")
        chatDetailCV.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTitle()
        getConvo()
        if unmatching{
            
            if let screen = view.viewWithTag(69){
                screen.removeFromSuperview()
            }
            
            let home = HomeVC()
            navigationController?.setViewControllers([home], animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setKeyBoardNotification()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if dismissGesture != nil{
        chatDetailCV.removeGestureRecognizer(dismissGesture!)
            dismissGesture == nil
        }
        if unmatching{
            if let appDel = UIApplication.shared.delegate as? AppDelegate{
//                appDel.matchedWithUser(matched: false)
            }
        }
    }
    var unmatching: Bool = false
    func setViews(){
        
        view.clipsToBounds = true
        view.backgroundColor = UIColor.white
        chatDetailCV.delegate = self
        chatDetailCV.dataSource = self
        view.add(views: partnerChatView,chatDetailCV,chatView)
        partnerChatView.constrainInView(view: view, top: 0, left: -20, right: 20, bottom: nil)
        partnerChatView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        chatDetailCV.constrainInView(view: view, top: nil, left: -20, right: 20, bottom: nil)
        chatDetailCV.setBottomTo(con: chatView.top(), by: 0)
        chatDetailCV.setTopTo(con: partnerChatView.bottomAnchor , by: 0)
        chatView.constrainInView(view: view, top: nil, left: -18, right: 18, bottom: nil)
        chatView.delegate = self
        chatBottomCon = chatView.setBottomTo(con: view.bottom(), by: 0)
        chatHeightCon = chatView.setHeightTo(constant: 44)
        let rateGesture = UITapGestureRecognizer(target: self , action: #selector(ChatDetailVC.ratingTap(_ :)))
        partnerChatView.addGestureRecognizer(rateGesture)
        dismissGesture = UITapGestureRecognizer(target: self , action: #selector(ChatDetailVC.dismissHandler(_:)))
        chatDetailCV.addGestureRecognizer(dismissGesture!)
        
    }
    
    func setTitle(){
        
        if let titleImage = UIApplication.shared.keyWindow?.viewWithTag(13){
            titleImage.alpha = 1
        }
        //navigationController?.navigationBar.barTintColor = createColor(200, green: 200, blue: 200)
        navigationController?.navigationBar.isTranslucent = false
        let homeItem = UIBarButtonItem(title: "⟨ HOME", style: .plain, target: self, action: #selector(ChatDetailVC.goHomeHandler(_:)))
        navigationItem.leftBarButtonItem = homeItem
        let unmatchItem = UIBarButtonItem(title: "UNMATCH", style: .plain , target: self, action: #selector(ChatDetailVC.unmatchHandler(_:)))

        navigationItem.rightBarButtonItem = unmatchItem
    }
    
    @objc func unmatchHandler(_ sender: UIBarButtonItem){
        showUnmatchOptionFor()
    }
  

    var currentConvo: Convo?{
        didSet{
            if let workouts = currentConvo?.workoutIDs{
                if let partnerWorkoutID = workouts.filter({$0 != String(workout.eventID)}).first{
                    let event = Event()
                        event.eventID = Int(partnerWorkoutID)!
                    matchedWorkout = event
                }
            }
            currentConvo?.convoDelegate = self
            conversants = currentConvo?.conversantIDs
            currentConvo?.observeConvo()
            chatDetailCV.reloadData()
        }
    }
        var dismissGesture: UITapGestureRecognizer?
    var chatHeightCon = NSLayoutConstraint()
    var chatBottomCon = NSLayoutConstraint()
    var imageToSend: UIImage?
    var imagePicker = UIImagePickerController()
    var viewingPartner: Bool = false
    var currentMessageConversant_s = [Chatter](){
        didSet{
            if let partner = currentMessageConversant_s.filter({$0.user_id!.intValue != GymmieUser.currentUser()!.userID!}).first{
               
                partnerChatView.match = partner.gymUser
                
            }
        }
    }
    
    var searchedRanges = [NSRange]()
    var conversants: [String]?{
        didSet{
//            let userReference = Database.database().reference().child("Users")
//            guard let userReferences = conversants?.map({ ref in
//
//                return userReference.child(ref)
//            }) else{
//                return
//            }
//            for ref in userReferences{
//                ref.observeSingleEvent(of: .value, with: {userSnap in
//                    guard let userObject = userSnap.value as? [String: AnyObject] else{
//                        return
//                    }
//                    let chatter = Chatter()
//                    chatter.setValuesForKeys(userObject)
//                    self.currentMessageConversant_s.append(chatter)
//                })
//            }
        }
    }

   
    var workout = Event(){
        didSet{
            partnerChatView.workout = workout
        }
    }

    
    var matchedWorkout = Event()
    let partnerChatView:  PartnerChatView = {
        let view = PartnerChatView()
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let chatView: ChatView = {
        let v = ChatView()
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let chatDetailCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.itemSize = CGSize(width: 300, height: 400)
        let frame = CGRect(x: 0, y: 0, width:300, height: 500)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
            cv.backgroundColor = UIColor(white: 0.95, alpha: 1)
            cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    let unmatchView: UnmatchView = {
        let v = UnmatchView()
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    var ratingView = RatePartnerView()

    @objc func goHomeHandler(_ sender:UIBarButtonItem){
        let home = HomeVC()
       
       navigationController?.popToRootViewController(animated: true)
    }
    @objc func dismissHandler(_ gesture: UITapGestureRecognizer){
        if chatView.chatTextView.isFirstResponder{
            chatView.chatTextView.resignFirstResponder()
        }
    }
    func showUnmatchOptionFor(){
     
        let screen = UIView()
            screen.backgroundColor = UIColor.black
            screen.alpha = 0.3
            screen.frame = navigationController!.view.frame
            screen.tag = 69
        view.add(views: screen, unmatchView)
        unmatchView.delegate = self
        unmatchView.setXTo(con: view.x(), by: 0)
        unmatchView.setYTo(con: view.y(), by: 0)
        unmatchView.setWidthTo(constant: 200)
        unmatchView.setHeightTo(constant: 150)
    }
   
    func scrollToBottom(){
        if let items = currentConvo?.messages.count{
            if items > 1{
        let lastPath = IndexPath(item: items-1, section: 0)
          
                    chatDetailCV.selectItem(at: lastPath, animated: true, scrollPosition: .bottom)
                
            }
        }
    }
    
    func getConvo(){
//        guard let chatterID = Auth.auth().currentUser?.uid else{return}
//        let convoID = workout.convoID
//        if convoID.isEmpty{
//            return
//        }
//        let convoRef = Database.database().reference().child("User_Messages").child(convoID)
//            convoRef.observeSingleEvent(of: .value , with: {
//                    snapshot in
//                        if let convoObject = snapshot.value as? [String:AnyObject] {
//                            let convo = Convo()
//                            convo.setValuesForKeys(convoObject)
//                            self.currentConvo = convo
//                        }else{
//                            self.workout.convoID = ""
//                            self.workout.isMatched = false
//                            let data = AppDatabase()
//                                data.updateEvent(event: self.workout)
//                        }
//                    })
    }
}

extension ChatDetailVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
            if let messages = currentConvo?.messages{
                let message = messages[indexPath.item]
                
                guard let chat = message.message else{
                   
                    guard let imageURL = message.image_URL else {
                       
                        return CGSize.zero
                        }
              
                    let height = CGFloat(message.image_height!.floatValue/message.image_width!.floatValue*200)
                    
                    let size = CGSize(width: view.frame.width, height:height)
                  
                    return size
                    }
                let size = CGSize(width: 275, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimateSize = NSString(string: chat).boundingRect(with: size, options: options, attributes: [.font:UIFont.systemFont(ofSize: 18)], context: nil)
                return CGSize(width: view.frame.width, height: estimateSize.height+20)
                }
      
       return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
            guard let selectedConvo = currentConvo else{return count}
            count = selectedConvo.messages.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
    func chatWithImage(at indexPath: IndexPath,wasSent: Bool,with message: ChatMessage)->MessageImageCell{
        let chatCell = chatDetailCV.dequeueReusableCell(withReuseIdentifier: "MessageImageCell", for: indexPath) as! MessageImageCell
        let interval = message.timeStamp
        let date = Date(timeIntervalSince1970: TimeInterval(interval!))
        let timeSince = MyCalendar.timeSinceEvent(onDate: date)
            chatCell.timeStamp.text = timeSince
            chatCell.timeStamp.frame = CGRect(x: 0, y: -20, width: view.frame.width, height: 20)
            chatCell.wasSent = wasSent
        let height = CGFloat(message.image_height!.floatValue/message.image_width!.floatValue*200)
        let size = CGSize(width: 200, height:height)
        let imageX = wasSent ? view.frame.width - size.width - 8 : 8
        let imagePoint = CGPoint(x: imageX, y: 0)
            chatCell.messageImage.frame = CGRect(origin: imagePoint, size: size)
        if let url = message.image_URL{
            chatCell.messageImage.loadImageWithURL(url:url)
            chatCell.setUpViews()
        }
        return chatCell
        
    }
    func chatWithText(at indexPath: IndexPath, wasSent: Bool, message: ChatMessage)->ChatDetailCell{
        
        let chatCell = chatDetailCV.dequeueReusableCell(withReuseIdentifier: "ChatDetailCell", for: indexPath) as! ChatDetailCell
        let interval = message.timeStamp!
        let date = Date(timeIntervalSince1970: TimeInterval(interval))
        chatCell.setMessage(message: message.message!, at: date, sent: wasSent)
//        let interval = message.timeStamp!
//        let date = Date(timeIntervalSince1970: TimeInterval(interval))
//        let timeSince = MyCalendar.timeSinceEvent(onDate: date)
//            chatCell.timeStamp.text = timeSince
//        
//        let chat = message.message!
//            chatCell.message.text = chat
//        let estimateSize = chat.rectForText(width: 250,textSize:15)
//        
//        let messageX:CGFloat = wasSent ? view.frame.width-estimateSize.width-24 : 30
//        let messageTextColor = wasSent ? UIColor.black : UIColor.white
//        let messageBackground = wasSent ? createColor(210, green: 210, blue: 210) : gymmieOrange()
//            chatCell.message.frame = CGRect(x: messageX,y: 0, width: estimateSize.width, height: estimateSize.height)
//            chatCell.message.textColor = messageTextColor
//        
//        
//        let image = wasSent ? ChatDetailCell.sendBubbleImage : ChatDetailCell.receiveBubbleImage
//            chatCell.bubbleImageView.image = image
//            chatCell.bubbleImageView.tintColor = messageBackground
//            print(chatCell.bubbleImageView.frame)
//        let bubbleY = chatCell.message.frame.minY - 8
//        let bubbleX = messageX + (wasSent ? 8 : 0)
//        chatCell.bubbleImageView.frame = CGRect(x: bubbleX ,y: bubbleY , width: estimateSize.width+16, height: estimateSize.height+24)
//            print(chatCell.bubbleImageView.frame)
        
        return chatCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
//            guard let message = currentConvo?.messages[indexPath.item] else { return cell}
//                let fromID = String(describing:message.fromID!)
//                guard let chatterID = Auth.auth().currentUser?.uid else{ return cell}
//                let messageWasSent = fromID == chatterID
//            guard let chat = message.message else{
//                //if there was no message check for the image data which should be there in this case
//                guard let imageURL = message.image_URL else{return cell}
//                return chatWithImage(at: indexPath,wasSent: messageWasSent, with: message)
//                }
//            return chatWithText(at: indexPath, wasSent: messageWasSent, message: message)
        return cell
    }
 
}

extension ChatDetailVC: UITextViewDelegate{
    func moveChat(byOffset offSet: CGFloat,withDuration duration: Double){
        let chatY = chatView.frame.maxY
        if offSet < chatY{
            
            let difference = offSet-chatY
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
                self.chatBottomCon.constant = -offSet
                self.view.layoutIfNeeded()
                }, completion: nil)
            return
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
            self.chatBottomCon.constant = offSet
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func keyBoardWillShow(_ notification: Foundation.Notification){
        let keyBoardEndRect = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let offSet = keyBoardEndRect.height
        let durationNumber = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let duration = Double(durationNumber)
        moveChat(byOffset: offSet , withDuration: duration)
        scrollToBottom()
        
    }
    
    func keyBoardWillHide(_ notification: Foundation.Notification){
        let durationNumber = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let duration = Double(durationNumber)
        moveChat(byOffset: 0, withDuration: duration)
    }
    
    func setKeyBoardNotification(){
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatDetailVC.keyBoardWillShow(_:)), name: NSNotification.Name.UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatDetailVC.keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

extension ChatDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func photoHandler(_ action: UIAlertAction!){
        if let appSettings = URL(string: UIApplication.openSettingsURLString){
            UIApplication.shared.openURL(appSettings)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        if let logo = UIApplication.shared.keyWindow?.viewWithTag(13){
            logo.alpha = 1
        }
        //picker.dismiss(animated: true , completion: nil)
        picker.removeFromParent()
        picker.dismiss(animated: true , completion: nil)
        //picker.view.removeFromSuperview()
    }
    
    func getImage(){
        if PHPhotoLibrary.authorizationStatus() == .denied{
            let alertController = UIAlertController(title: "Settings", message: "Looks like we don't have acces to Photos. Enable access for Gymmie to continue.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Settings", style: .default, handler: photoHandler)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(action)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        }else{
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.hidesBarsOnSwipe = true
            UINavigationBar.appearance().tintColor = gymmieOrange()
            imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
            imagePicker.navigationBar.tintColor = gymmieOrange()
          present(imagePicker, animated: true , completion: nil)
            
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        guard let chatID = Auth.auth().currentUser?.uid else {return }
//        let origImge = info[UIImagePickerControllerOriginalImage] as? UIImage
//
//        let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
//
//                if !currentMessageConversant_s.isEmpty {
//            imageToSend = editedImage == nil ? origImge : editedImage
//        let imageData = UIImagePNGRepresentation(imageToSend!)
//        let storageRef = Storage.storage().reference().child("Message_Images").child(chatID).child(UUID().uuidString)
//            storageRef.putData(imageData!, metadata: nil, completion: {
//                metaData, error in
//                if error != nil{
//                    return
//                }
//                if let url = metaData?.downloadURL(){
//                    let width = NSNumber(value:Float(self.imageToSend!.size.width))
//                    let height = NSNumber(value: Float(self.imageToSend!.size.height))
//                    let timeStamp = String(Date().timeIntervalSince1970)
//                    self.currentConvo?.sendImageMessage(url: url.absoluteString , width:width , height:height , timeStamp:timeStamp)
//
//                    if let partnerID = self.partnerChatView.match?.userID{
//                        let data = AppDatabase()
//                        if let userName = GymmieUser.currentUser()?.firstName{
//                        data.notify(notification: "\(userName) sent an image",to: partnerID, type: "MESSAGE")
//                        }
//                    }
//                }
//            })
//        }
//        if let logo = UIApplication.shared.keyWindow?.viewWithTag(13){
//            logo.alpha = 1
//        }
//        dismiss(animated: true , completion: nil)
    }
}

extension ChatDetailVC: DatabaseChatDelegate{
    func idsForRecipients(recipients: [Chatter])->[String]{
        return recipients.map({$0.chat_id!})
    }
    func foundChatters(chatters: [Chatter]) {
     
    }
    func fetchedConvos(conversations: [Convo]){
   
    }
}
extension ChatDetailVC: ConvoDelegate{
    func updateConvo() {
       
        DispatchQueue.main.async(execute: {
            self.chatDetailCV.reloadData()
            self.scrollToBottom()
        })
 
    }
}

extension ChatDetailVC: UnmatchDelegate{
    func cancelUnmatch() {
        if let screen = view.viewWithTag(69){
            screen.removeFromSuperview()
        }
        
    }
    func unmatch() {
     
//        if currentConvo == nil || currentMessageConversant_s.isEmpty{
//            if let screen = view.viewWithTag(69){
//                screen.removeFromSuperview()
//            }
//            return
//        }
//
//        unmatching = true
//        guard let userID = Auth.auth().currentUser?.uid else {return}
//        let convoReference = Database.database().reference().child("User_Messages").child(currentConvo!.convoID)
//            convoReference.removeValue()
//        if let messageReferences = currentConvo!.messageReferences{
//            let refs = messageReferences.map({ ref -> DatabaseReference in
//                return Database.database().reference().child("Messages").child(ref)
//            })
//            for ref in refs{
//                ref.removeValue()
//            }
//        }
//
//        if let screen = view.viewWithTag(69){
//            screen.removeFromSuperview()
//        }
//
//        suggestRating()
//
//        //insert function to unmatch with a partner
//        let data = AppDatabase()
//        if let partner = partnerChatView.match{
//            data.match_UnmatchUser(partner: partner, partnerEvent:matchedWorkout , for: workout, match: false)
//        }
    }
}

extension ChatDetailVC: MessageDelegate{
    func sendMessage( message: String){
        let timeStamp = Date().timeIntervalSince1970
        let chatMessage = ChatMessage(date: timeStamp , message: message , url: nil)
        currentConvo?.sendTextMessage(message: chatMessage)
        if let partnerID = partnerChatView.match?.userID{
        let data = AppDatabase()
            data.notify(notification: chatMessage.message!, to: partnerID, type: "MESSAGE")
        }
       
    }
    
    func sendImage(){
        getImage()
        if let logo = UIApplication.shared.keyWindow?.viewWithTag(13){
            logo.alpha = 0
        }
        
    }
    
    func resizeFor(height: CGFloat){
        chatHeightCon.constant = height
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
}
extension ChatDetailVC: RatePartnerDelegate{
    func ratingSet() {
        if viewingPartner{
            viewingPartner = false
             navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        let home = HomeVC()
        let matching = MatchProfileVC()
        matching.workout = workout
        navigationController?.setViewControllers([home,matching], animated: true)
    }
    func showReport(){
        reportUser()
    }
    func ratingHandler(sender: UIBarButtonItem){
        suggestRating()
    }
    
    @objc func ratingTap(_ gesture: UITapGestureRecognizer){
        if viewingPartner{
            UIView.animate(withDuration: 0.25, animations: {
                self.ratingView.alpha = 0
                }, completion: { _ in
                    self.ratingView.removeFromSuperview()
            })
            viewingPartner = false
            if chatView.chatTextView.isFirstResponder{
                chatView.chatTextView.resignFirstResponder()
            }
        }else{
             viewingPartner = true
            suggestRating()
           
        }
    }
    
    func suggestRating(){
        if viewingPartner{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        ratingView.unmatching = unmatching
        ratingView.alpha = 0
        ratingView.match = currentMessageConversant_s.filter({$0.user_id!.intValue != GymmieUser.currentUser()!.userID!}).first!.gymUser
        ratingView.workout = workout
        ratingView.delegate = self
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ratingView)
        ratingView.constrainWithMultiplier(view: view , width: 1, height: 1.05)
 
        UIView.animate(withDuration: 0.25, animations: {
            self.ratingView.alpha = 1
        })
    }
  
    func skip(){
        if viewingPartner{
            viewingPartner = false
             navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        if let appDel = UIApplication.shared.delegate as? AppDelegate{
//            appDel.ratedUser(rated: false)
        }
        let home = HomeVC()
        let matching = MatchProfileVC()
            matching.workout = workout
        navigationController?.setViewControllers([home,matching], animated: true)
    }
    
    func reportUser(){
        if viewingPartner{
            viewingPartner = false
             navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        let report = ReportPartnerVC()
        navigationController?.present(report, animated: true, completion: nil)
    }
    
}
