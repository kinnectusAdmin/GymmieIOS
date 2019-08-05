//
//  MatchPreferenceCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 9/16/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit

class   SettingsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectImage.image = selected ? #imageLiteral(resourceName: "checkMark") : nil
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        setViews()
        
    }
    func setViews(){
       contentView.add(views: settingLabel,selectImage)
        
        settingLabel.constrainInView(view: contentView, top: 0, left: 0, right: nil, bottom: 0)
        settingLabel.setRightTo(con: selectImage.left(), by: 0)
      
      
        selectImage.constrainInView(view: contentView , top: 0, left: nil, right: 0, bottom: 0)
        selectImage.setWidthTo(constant: 50)
    
    }
    var settingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    let selectImage : UIImageView = {
        let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
}
