//
//  MatchInfoCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/4/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit

class MatchInfoCell: UICollectionViewCell {

    override func layoutSubviews() {
        setViews()
    }

    var infoTextView: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.gymmieProfileFont()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    var detail = String()
    
    var editing: Bool = false{
        didSet{
            infoTextView.isUserInteractionEnabled = editing
        }
    }
    
    var info: String = ""{
        didSet{
            infoTextView.text = info
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = gymmieOrange()
        label.backgroundColor = createColor(230, green: 230, blue: 230)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.layer.borderColor = createColor(210, green: 210, blue: 210).cgColor
        label.translatesAutoresizingMaskIntoConstraints = false 
        label.layer.borderWidth = 1
        return label
    }()
    
    func setViews() {
        backgroundColor = UIColor.white
        addSubview(infoTextView)
        infoTextView.constrainInView(view: contentView, top: 0, left: 8, right: 0, bottom: nil)
    }
}

