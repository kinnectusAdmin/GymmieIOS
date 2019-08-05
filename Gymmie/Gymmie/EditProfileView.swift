//
//  EditProfileView.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/17/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
protocol EditProfileDelegate{
    func cancelEdit()
    func saveEdit()
    func startEdit()
}
class EditProfileView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        setViews()
    }
    
    func setViews(){
        backgroundColor = UIColor(white: 0.2, alpha: 0.6)
        add(views: editButton,saveButton,cancelButton)
        editButton.constrainWithMultiplier(view: self, width: 0.5, height: 0.75)
        
        saveButton.setLeftTo(con: editButton.rightAnchor, by: 4)
        saveButton.setWidthTo(constant: 75)
        saveButton.setYTo(con: editButton.centerYAnchor, by: 0)
        
        cancelButton.setRightTo(con: editButton.leftAnchor, by: -4)
        cancelButton.setWidthTo(constant: 75)
        cancelButton.setYTo(con: editButton.centerYAnchor, by: 0)
    
        editButton.addTarget(self , action: #selector(EditProfileView.editHandler(_:)), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(EditProfileView.saveProfile(_:)), for: .touchUpInside)
        cancelButton.addTarget(self , action: #selector(EditProfileView.cancelEdit(_:)), for: .touchUpInside)
    }
    
    func edit(){
        editProfile = !editProfile
        print(editProfile ? "can edit" : "can't edit")
        editButton.backgroundColor = editProfile ? UIColor.clear : gymmieOrange()
        editButton.isEnabled = !editProfile
        setEditOptions(editing: editProfile)
    }
    
    @objc func editHandler( _ sender: UIButton){
       edit()
        delegate?.startEdit()
    }
    
    func setEditOptions(editing: Bool){
        let cancelOrigPosition = cancelButton.center.x
        
        let moveCancel = CABasicAnimation(keyPath: "position.x")
            moveCancel.fromValue = editing ? -cancelButton.frame.width : cancelOrigPosition
            moveCancel.toValue = editing ? cancelOrigPosition : -cancelButton.frame.width
            moveCancel.duration = 0.25
        cancelButton.layer.add(moveCancel, forKey: nil)
        cancelButton.alpha = editing ? 1.0 : 0
        
        let saveOrigPosition = saveButton.center.x
        let moveSave = CABasicAnimation(keyPath: "position.x")
            moveSave.fromValue = editing ? frame.width : saveOrigPosition
            moveSave.toValue = editing ? saveOrigPosition : frame.width
            moveSave.duration = 0.25
        saveButton.layer.add(moveSave, forKey: nil)
        
        saveButton.alpha = editing ? 1.0 : 0
        
    }
    
    @objc func saveProfile(_ sender: UIButton){
        edit()
         delegate?.saveEdit()
    }
    
    @objc func cancelEdit(_ sender: UIButton){
        edit()
        delegate?.cancelEdit()
        
    }
    
    var delegate: EditProfileDelegate?
   
    let editButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "EDIT PROFILE", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = gymmieOrange()
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let saveButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "SAVE", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = createColor(151, green: 200, blue: 70)
        button.layer.cornerRadius = 8.0
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let cancelButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "CANCEL", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = createColor(239, green: 82, blue: 50)
        button.layer.cornerRadius = 8.0
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var editProfile: Bool = false
}
