//
//  EditNameEmailCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 9/8/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit
protocol EditNameEmailDelegate{
    func editName(first: String,last: String)
    func editEmail( with email: String)
    func changeNameEmailError()
}
class EditNameEmailCell: UITableViewCell {

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
        contentView.add(views: name_EmailLabel,oldValueLabel,newValueField,lastNameField, submitButton)
        name_EmailLabel.constrainInView(view: contentView , top: 0, left: 0, right: nil, bottom: nil)
        
        oldValueLabel.setTopTo(con: contentView.top(), by: 0)
        oldValueLabel.setLeftTo(con: name_EmailLabel.right(), by: 4)
        oldValueLabel.setWidthTo(constant: 200)
        
        newValueField.setTopTo(con: contentView.top(), by: 12)
        newValueField.setLeftTo(con: oldValueLabel.left(), by: 0)
        newValueField.setWidthTo(constant: contentView.frame.width*0.6)
        
        lastNameField.setTopTo(con: newValueField.bottom(), by: 4)
        lastNameField.setLeftTo(con: oldValueLabel.left(), by: 0)
        lastNameField.setWidthTo(constant: contentView.frame.width*0.6)
        lastNameField.setBottomTo(con: contentView.bottom(), by: 0)
        
        submitButton.constrainInView(view: contentView, top:  0, left: nil, right: 0, bottom: nil)
        submitButton.addTarget(self , action: #selector(EditNameEmailCell.submitChange(_:)), for: .touchUpInside)
        
    }
    var delegate: EditNameEmailDelegate?
    var changeEmail: Bool = false
    var changeName: Bool = false
    
    var newValue: String{
        return newValueField.text!
    }
    
    var oldValue: String{
        return oldValueLabel.text!
    }
    
    var valueChanged: Bool{
        return newValue != oldValue && !newValue.isEmpty
    }
    
    var lastName: String{
        return lastNameField.text!
    }
    
    let lastNameField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textAlignment = .left
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    
    var name_EmailLabel: UILabel = {
        let label = UILabel()
            label.textColor = UIColor.black
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 18, weight: .light)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var oldValueLabel: UILabel = {
        let label = UILabel()
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 18, weight: .light)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let newValueField : UITextField = {
        let field = UITextField()
            field.translatesAutoresizingMaskIntoConstraints = false
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
    @objc func submitChange(_ sender: UIButton){
        if valueChanged{
            if changeName{
                
                delegate?.editName(first: newValue,last: lastName)
                oldValueLabel.text = "\(newValue) \(lastName)"
                newValueField.text = ""
                lastNameField.text = ""
            }else if changeEmail{
               oldValueLabel.text = newValue
                newValueField.text = ""
                delegate?.editEmail(with: newValue)
            }
        }else{
          delegate?.changeNameEmailError()
        }
    }
    

}
