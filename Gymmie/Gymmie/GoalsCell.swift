//
//  GoalsCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 1/14/17.
//  Copyright © 2017 kinnectus. All rights reserved.
//

import UIKit

class GoalsCell: UITableViewCell {

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
    let goalsLabel: UILabel = {
        let label = UILabel()
            label.text = "Goal"
            label.textColor = UIColor.black
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 18, weight: .light)
            label.adjustsFontSizeToFitWidth = true
            label.translatesAutoresizingMaskIntoConstraints = false
    return label
    }()
    
    let goalNameField: UITextField = {
        let field = UITextField()
            field.placeholder = "Goal"
            field.backgroundColor = createColor(230, green: 230, blue: 230)
            field.textAlignment = .center
            field.font = UIFont.systemFont(ofSize: 18)
            field.borderStyle = .roundedRect
            field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
   
    
    let clearButton: UIButton = {
        let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "xButton@75"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setViews(){
        
        contentView.add(views: goalsLabel,goalNameField,clearButton)
        
        //constrain label
        goalsLabel.constrainInView(view: contentView , top: 8, left: 4, right: nil, bottom: 0)
        //constrain clear button
        clearButton.setYTo(con: goalsLabel.y(), by: 0)
        clearButton.setRightTo(con: contentView.right(), by: -8)
        clearButton.addTarget(self , action: #selector(GoalsCell.clear(_:)), for: .touchUpInside)
        clearButton.setHeightTo(constant: 30)
        clearButton.setWidthTo(constant: 30)
        //constrain goal
        goalNameField.constrainInView(view: contentView , top: 0, left: nil, right: nil, bottom: 8)
        goalNameField.setLeftTo(con: goalsLabel.right(), by: 8)
        goalNameField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6).isActive = true
       
    }
    
    
    @objc func clear(_ sender: UIButton){
        goalNameField.text = ""
    }
    
}


