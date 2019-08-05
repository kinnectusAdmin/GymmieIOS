//
//  ReportPartnerView.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/7/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
//import Firebase
//import FirebaseDatabase

protocol ReportDelegate {
    func submitReport(report: String,other: String)
    func cancelReport()
    func userIsReporting(reporting: Bool)
}
class ReportPartnerView: UIView {

    override func layoutSubviews() {
        setViews()
        getUsersToReport()
        setReportButtons()
    }
    var buttonsAdded: Bool = false
    var other = String()
    var delegate: ReportDelegate?
    var fullReport: String = ""
    
    var reportLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Report Partner".localizedUppercase
        label.backgroundColor = createColor(204, green: 82, blue: 72)
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var imageHeightCon = NSLayoutConstraint()
    var nameHeightCon = NSLayoutConstraint()
    let userImage : UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 20
        iv.alpha = 0
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
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
    
    func setReportButtons(){
        if buttonsAdded{
            return
        }
        let reports = ["Late","Rude","Inappopriate","Uncooperative","Hazardous Behaviour","Fake Profile","No Show","Other"]
        
        for i in 0...7{
            let button = UIButton(type: .custom)
                button.tag = i
                button.setImage(#imageLiteral(resourceName: "checkBox"), for: .normal)
                button.setTitle(reports[i], for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
                button.titleEdgeInsets.left = 10
                button.titleEdgeInsets.right = -10
                button.translatesAutoresizingMaskIntoConstraints = false
          
            addSubview(button)
                button.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor,constant:20).isActive = true
            //button.widthAnchor.constraint(equalToConstant: 200).isActive = true
            
                let topOffset = 16
                button.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: CGFloat(topOffset+i*30)).isActive = true
            
                button.addTarget(self, action: #selector(ReportPartnerView.addReport(_:)), for: .touchUpInside)
            
        }
        buttonsAdded = true
    }
    
    let submitButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Submit", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = createColor(204, green: 82, blue: 72)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Cancel", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = createColor(204, green: 82, blue: 72)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8.0
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
    var searchTop = NSLayoutConstraint()
    var offenderFound: Chatter?
    var userArray = [Chatter]()
    var reporting: Bool = false
    
    func setViews(){
        backgroundColor = UIColor.white
        layer.masksToBounds = true
        layer.cornerRadius = 10.0
        add(views: reportLabel,userImage,nameLabel,searchField,submitButton,cancelButton)
        //constrain rating label
        reportLabel.constrainInView(view: self, top: -8, left: -10, right: 10, bottom: nil)
        reportLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //constrain userimage
        userImage.setLeftTo(con: left(), by: 4)
        userImage.setBottomTo(con: searchField.top(), by: 0)
        userImage.setWidthTo(constant: 40)
        
        imageHeightCon = userImage.setHeightTo(constant: 40)
        //constrain name
        nameLabel.setYTo(con: userImage.y(), by: 0)
        nameLabel.setLeftTo(con: userImage.right(), by: 8)
        
        //constrain search
        searchField.constrainInView(view: self, top: nil, left: 0, right: 0, bottom: nil)
        searchTop = searchField.setBottomTo(con: submitButton.top(), by: -260)
        searchTop.isActive = true
        searchField.delegate = self
        //constrain submit button
        submitButton.constrainInView(view: self, top: nil, left: 0, right: nil, bottom: 0)
        submitButton.rightAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor, constant: -4).isActive = true
        submitButton.addTarget(self , action: #selector(ReportPartnerView.submit(_:)), for: .touchUpInside)
        //constrain cancel button
        cancelButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor, constant: 4).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
        cancelButton.addTarget(self , action: #selector(ReportPartnerView.cancelAll(_:)), for: .touchUpInside)
       
    }
}
extension ReportPartnerView{
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
        if !reporting{
        delegate?.userIsReporting(reporting: show)
        
        userImage.image = show ? #imageLiteral(resourceName: "defaultImage2") : nil
            UIView.animate(withDuration: 0.5, animations: {
                self.userImage.alpha = 1.0
            })
        }
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
            nameLabel.text = ""
            return
        }
        
        nameLabel.text = offender.name!
        guard let url = offender.image_URL else{
            userImage.image = #imageLiteral(resourceName: "defaultImage2")
            return
        }
        if !url.isEmpty{
        userImage.loadImageWithURL(url:url)
        }
    }
    
    @objc func submit(_ sender: UIButton){
        delegate?.submitReport(report: fullReport, other: other)
    }
    
    @objc func cancelAll(_ sender: UIButton){
        delegate?.cancelReport()
    }
    
    @objc func addReport(_ sender: UIButton){
        let reports = ["Late","Rude","Inappropriate","Uncooperative","Hazardous Behavior","Fake Profile","No Show","Other"]
        let report = "\(reports[sender.tag]),"
        if fullReport.contains(report){
            fullReport = fullReport.replacingOccurrences(of: report , with: "")
            sender.setImage(#imageLiteral(resourceName: "checkBox"), for: .normal)
        }else{
            fullReport = fullReport.appending(report)
            sender.setImage(#imageLiteral(resourceName: "checkBox2"), for: .normal)
        }
        print(fullReport)
    }
}

extension ReportPartnerView: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        show_hidePartner(show: true)
        reporting = true
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
