//
//  AddWorkoutCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/26/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit

class AddWorkoutCell: UICollectionViewCell {
    override func layoutSubviews() {
        setViews()
    }
    func setViews(){
     
        contentView.addSubview(addWorkoutButton)
        addWorkoutButton.setXTo(con: contentView.x(), by: 0)
        addWorkoutButton.setYTo(con: contentView.y(), by: 0)
        addWorkoutButton.setWidthTo(constant: contentView.frame.width*0.5)
      
    }
    
    let addWorkoutButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: " ADD WORKOUT ", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = gymmieOrange()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10.0
        
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let addButton : UIImageView = {
        let iv = UIImageView()
            iv.image = #imageLiteral(resourceName: "addWorkoutButton")
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.layer.masksToBounds = true
            iv.layer.cornerRadius = 10.0
        
        return iv
    }()
}
