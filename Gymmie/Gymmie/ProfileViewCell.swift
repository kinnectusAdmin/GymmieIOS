//
//  ProfileViewCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/30/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit

protocol ProfileViewDelegate {
    func setPhotos()
    func editScreen(set: Bool)
    func setInfo(details: (firstName:String,lastName:String,age:String))
}

class ProfileViewCell: UICollectionViewCell {
    
    override func layoutSubviews() {
        setViews()
    }
    
    func setViews(){
        ageField.delegate = self
        nameField.delegate = self
        contentView.add(views: profileBlurImage,profileImage,ageField,nameField)
        //constrain profileBlurImage
        profileBlurImage.constrainWithMultiplier(view: contentView, width: 1, height: 1)
        
        //constrain profileImage
        profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: self.frame.width*0.35).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: self.frame.width*0.35).isActive = true
        profileImage.isUserInteractionEnabled = true
        
        let setPhotoGesture = UITapGestureRecognizer(target: self , action: #selector(ProfileViewCell.photoHandler(_:)))
        profileImage.addGestureRecognizer(setPhotoGesture)
        //constrain name
        nameField.setXTo(con: contentView.x(), by: 0)
        nameField.setTopTo(con: profileImage.bottom(), by: 4)
        //constrain age
        ageField.setLeftTo(con: nameField.right(), by: 0)
        ageField.setYTo(con: nameField.y(), by: 0)
        
    }
    
    var name: [String]{
        return nameField.text!.components(separatedBy: " ")
    }
    
    var age: String{
        return ageField.text!.replacingOccurrences(of: ",", with: "")
    }
    
    let profileBlurImage : UIImageView = {
        
        let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.layer.masksToBounds = true
            iv.translatesAutoresizingMaskIntoConstraints = false
        
        let blur = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect:blur)
            blurEffectView.translatesAutoresizingMaskIntoConstraints = false
            blurEffectView.layer.opacity = 0.85
            iv.addSubview(blurEffectView)
        
            blurEffectView.topAnchor.constraint(equalTo: iv.topAnchor, constant: 0).isActive = true
            blurEffectView.bottomAnchor.constraint(equalTo: iv.bottomAnchor, constant: 20).isActive = true
            blurEffectView.leftAnchor.constraint(equalTo: iv.leftAnchor, constant: 0).isActive = true
            blurEffectView.rightAnchor.constraint(equalTo: iv.rightAnchor, constant: 0).isActive = true
        
        return iv
    }()
 
    var delegate: ProfileViewDelegate?
    
    var user: GymmieUser? {
        didSet{
            if let userAge = user?.age{
                ageField.text = ",\(userAge)"
            }
        let name = user?.fullName ?? ""
            nameField.text = name != " " ? name : ""
        }
    }
    
    var photoURL: String = ""{
        didSet{
            if photoURL.isEmpty{
             setDefaultImage()
            }else{
            //https://unsplash.com/search/pretty?photo=ggJRxqOEaFY
            profileImage.loadImageWithURL(url: photoURL)
            profileImage.layer.masksToBounds = true
            profileImage.layer.cornerRadius = (self.frame.width*0.35)/2
            profileImage.layer.borderColor = UIColor.white.cgColor
            profileImage.layer.borderWidth = 2
            profileBlurImage.loadImageWithURL(url: photoURL)
            }
        }
    }
    func setDefaultImage(){
        profileImage.image = #imageLiteral(resourceName: "defaultImage2")
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = (self.frame.width*0.35)/2
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 2
        profileBlurImage.image = #imageLiteral(resourceName: "defaultImage2")
    }
    let profileImage : UIImageView = {
        let iv = UIImageView()
        //iv.backgroundColor = UIColor.red
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    @objc func photoHandler( _ gesture: UITapGestureRecognizer){
        delegate?.setPhotos()
    }
    
    let ageField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Age"
        
        //field.keyboardType = .asciiCapableNumberPad

        field.textColor = UIColor.white
        field.textAlignment = .left
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 20, weight: .light)
        return field
    }()
    
    let nameField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "User Name"
        field.adjustsFontSizeToFitWidth = true
        field.textColor = UIColor.white
        field.textAlignment = .center
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 20, weight: .light)
        return field
    }()
}

extension ProfileViewCell: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.editScreen(set: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.editScreen(set: false)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == ageField{
           let correction = textField.text!.trimmingCharacters(in: .letters).trimmingCharacters(in: .punctuationCharacters).trimmingCharacters(in: .whitespaces)
            ageField.text = correction
        }
        delegate?.setInfo(details: (name.first ?? "", name.last ?? "" ,age))
        textField.resignFirstResponder()
        return true
    }
}
