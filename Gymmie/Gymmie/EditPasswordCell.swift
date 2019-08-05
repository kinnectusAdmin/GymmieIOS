//
//  EditPasswordCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 9/8/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit
protocol  EditPasswordDelegate {
    func changePassword(_ toPassword:String)
    func changePasswordError()
}
class EditPasswordCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        setViews()
    }
    func setViews(){
        contentView.add(views: oldPasswordField,newPasswordField,submitButton)
        
        oldPasswordField.constrainInView(view: contentView , top: 0, left: 0, right: nil, bottom: nil)
        
        newPasswordField.setTopTo(con: oldPasswordField.bottom(), by: 4)
        newPasswordField.setLeftTo(con: oldPasswordField.left(), by: 0)
        newPasswordField.setWidthTo(constant: contentView.frame.width*0.6)
        submitButton.constrainInView(view: contentView , top: 0, left: nil, right: 0, bottom: nil)
        
        
    }
    var delegate: EditPasswordDelegate?
    var oldPassword: String{
        return oldPasswordField.text!
    }
    var newPassword: String{
        return newPasswordField.text!
    }
    var passwordChanged: Bool {
        return oldPassword != newPassword
    }
    let oldPasswordField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Current Password"
        field.textAlignment = .left
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    let newPasswordField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "New Password"
        field.textAlignment = .left
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    let submitButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Submit", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light),.foregroundColor: UIColor.darkGray])
        button.setAttributedTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    func submitChange(_ sender: UIButton){
        guard let userPassword = GymmieUser.currentUser()?.password else{
            return
        }
        guard oldPassword == userPassword else{
            delegate?.changePasswordError()
            return
        }
        
        if passwordChanged{
            delegate?.changePassword(newPassword)
            newPasswordField.text = ""
            oldPasswordField.text = ""
        
        }else{
            delegate?.changePasswordError()
            }
        
    }

}
