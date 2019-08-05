//
//  BlockPartnerView.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/20/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
//import Firebase
//import FirebaseDatabase

protocol BlockPartnerDelegate{
    func cancelBlockUser()
    func blockUser()
    func userIsBlocking(_ searching: Bool)
}
class BlockPartnerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        setViews()
        getUsersToReport()
    }
    func setViews(){
        backgroundColor = UIColor.white 
        layer.masksToBounds = true
        layer.cornerRadius = 10.0
        
        add(views: userImage,blockLabel,nameLabel,searchField,submitButton,cancelButton)
        blockLabel.constrainInView(view: self , top: -10, left: -10, right: 10, bottom: nil)
        blockLabel.setHeightTo(constant: 30)
        
        userImage.setLeftTo(con: left(), by: 4)
        userImage.setBottomTo(con: searchField.top(), by: 0)
        userImage.setWidthTo(constant: 40)
        userImage.setHeightTo(constant: 40)
        
        nameLabel.setYTo(con: userImage.y(), by: 0)
        nameLabel.setLeftTo(con: userImage.right(), by: 8)
      
       
        
        searchField.constrainInView(view: self, top: nil, left: 0, right: 0, bottom: nil)
        searchField.setBottomTo(con: submitButton.top(), by: -16)
        searchField.delegate = self
        
        submitButton.constrainInView(view: self, top: nil, left: 0, right: nil, bottom: 0)
        submitButton.setHeightTo(constant: 25)
        submitButton.setRightTo(con: x(), by: -4)
        submitButton.addTarget(self, action: #selector(BlockPartnerView.submitUserToBlock(_:)), for: .touchUpInside)
        
        cancelButton.constrainInView(view: self, top: nil, left: nil, right: 0, bottom: 0)
        cancelButton.setHeightTo(constant: 25)
        cancelButton.setLeftTo(con: x(), by: 4)
        cancelButton.addTarget(self , action: #selector(BlockPartnerView.cancelBlockUser(_:)), for: .touchUpInside)
    }
    
    var imageHeightCon = NSLayoutConstraint()
    var nameHeightCon = NSLayoutConstraint()
    var blockLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Block User"
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = createColor(201, green: 82, blue: 72)
        return label
    }()
    let userImage : UIImageView = {
        let iv = UIImageView()
            iv.layer.masksToBounds = true
            iv.layer.cornerRadius = 20
            iv.contentMode = .scaleAspectFill
            iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    var nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    let searchField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Name..."
        
        field.textAlignment = .left
        field.font = UIFont.systemFont(ofSize: 15)
        field.borderStyle = .roundedRect
        return field
    }()
    let submitButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Submit", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = createColor(201, green: 82, blue: 72)
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let cancelButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Cancel", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = createColor(201, green: 82, blue: 72)
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var session: URLSession = {
        let config = URLSessionConfiguration.default
        let queue = OperationQueue.main
        let sessDefined = Foundation.URLSession.shared
        //sessDefined.delegate = self
        
        
        return sessDefined
    }()
    lazy var getImageHandler:(Data?,URLResponse?,Error?)->Void = {
        (data,response,error) in
        
        if error == nil{
            if let image = UIImage(data: data!){
                imageCache.setObject(image, forKey: response!.url!.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    self.userImage.image = image
                }
            }
        }else{
            print(error?.localizedDescription)
        }
    }
    var imageURL: String?{
        didSet{
            if let image = imageCache.object(forKey: imageURL! as AnyObject){
                userImage.image = image as UIImage
            }else{
                let url = URL(string:imageURL!)
                var task = session.dataTask(with: url!, completionHandler: getImageHandler)
                task.resume()
            }
        }
    }
    
    var showing: Bool = false
    var offenderFound: Chatter?
    var userArray = [Chatter]()
    var delegate: BlockPartnerDelegate?
}

extension BlockPartnerView: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        show_hidePartner(show: true)
        showing = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        findMatchWithName(textField.text!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
extension BlockPartnerView{
    
    @objc func submitUserToBlock(_ sender: UIButton){
        guard let offender = offenderFound else {
            return
        }
        let data = AppDatabase()
        let gymmieOffender = GymmieUser()
            gymmieOffender.userID = offender.user_id?.intValue ?? 0//offender.user_id! as Int?
        guard let currentUser = GymmieUser.currentUser() else{
            return
        }
        
       // data.block(partner: gymmieOffender, from: currentUser, shouldBlock: true)
        delegate?.blockUser()
    }
    
    @objc func cancelBlockUser(_ sender: UIButton){
        delegate?.cancelBlockUser()
    }
   
   
    func showMatch(match:GymmieUser){
        let matchImageURL = match.imageURL!
        imageURL = matchImageURL
    }
    
    func findMatchWithName(_ name: String){
        
        for offender in userArray{
            if let offenderName = offender.name{
                if offenderName.lowercased().contains(name) || offenderName.contains(name){
                    offenderFound =  offender
                    break
                }
            }
        }
        
        //Get the user image for the name
        guard let offender = offenderFound else{
            userImage.image = #imageLiteral(resourceName: "defaultImage2")
        
            return
        }
        nameLabel.text = offender.name!
        nameLabel.alpha = 1.0
        guard let url = offender.image_URL else{
            userImage.image = #imageLiteral(resourceName: "defaultImage2")
            return
        }
        if !url.isEmpty{
            userImage.loadImageWithURL(url:url)
        }
        
    }
    
    func showOffender(){
        guard let offender = offenderFound else{
            userImage.image = #imageLiteral(resourceName: "defaultImage2")
            nameLabel.text = ""
            return
        }
        nameLabel.text = offender.name!
        searchField.text = offender.name!
        if let url = offender.image_URL{
            userImage.loadImageWithURL(url: url)
        }else{
            userImage.image = #imageLiteral(resourceName: "defaultImage2")
        }
    }
    
    func getUsersToReport(){
//        let firDatabase = Database.database().reference()
//        let usersRef = firDatabase.child("Users")
//        usersRef.observeSingleEvent(of: .value, with: {
//            (snapshot) in
//            if let userDict = snapshot.value as? [String:AnyObject]{
//                let userKeys = userDict.keys
//                
//                for userKey in userKeys{
//                    if let user = userDict[userKey] as? [String: AnyObject]{
//                        let chatter = Chatter()
//                        chatter.setValuesForKeys(user)
//                        self.userArray.append(chatter)
//                        
//                    }
//                }
//            }
//            
//        })
    }
   
    func show_hidePartner(show: Bool){
        if !showing{
        delegate?.userIsBlocking(show)
        userImage.image = show ? #imageLiteral(resourceName: "defaultImage2") : nil
        
        UIView.animate(withDuration: 1.0, animations: {
//            self.imageHeightCon.constant += show ? 50 : -50
//            self.nameHeightCon.constant += show ? 50 : -50
            self.layoutIfNeeded()
        })
        
        }
    }
}
