//
//  MenuCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/17/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

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
        backgroundColor = createColor(210, green: 210, blue: 210)
        contentView.add(views: menuLabel,separatorView)
        menuLabel.constrainWithMultiplier(view: self , width: 1, height: 1)
       addSubview(separatorView)
        separatorView.constrainInView(view: contentView , top: nil, left: -16, right: 16, bottom: 10)
        separatorView.setHeightTo(constant: 1)
       
    }
    
    var menuLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let separatorView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 1))
            v.backgroundColor = UIColor.darkGray
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

}
