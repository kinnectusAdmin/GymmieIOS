//
//  MatchDetailCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/4/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit

class MatchDetailCell: UICollectionViewCell {
    override func layoutSubviews() {
        setViews()
    }
    let infoStack: UIStackView = {
        let view = UIStackView()
            view.axis = .vertical
            view.alignment = .center
            view.spacing = 4
            view.distribution = .fill
            view.translatesAutoresizingMaskIntoConstraints = false
           
        return view
        
    }()
  
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = gymmieOrange()
        label.backgroundColor = createColor(230, green: 230, blue: 230)
        label.textAlignment = .center
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.layer.borderColor = createColor(210, green: 210, blue: 210).cgColor
        label.layer.borderWidth = 1
         label.translatesAutoresizingMaskIntoConstraints = false 
        return label
    }()
    
    func removeOptions(){
        for sub in contentView.subviews{
            sub.removeFromSuperview()
        }
    }
    
    func addOptions(for options: [String]){
        removeOptions()
        for (index,option) in options.enumerated(){
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 75, height: 25))
            label.backgroundColor = gymmieOrange()
            label.layer.cornerRadius = 10.0
            label.layer.masksToBounds = true
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12, weight: .light)
            label.text = option
            switch options.count{
            case 1:
                label.frame = CGRect(x: 0, y: 10, width: contentView.frame.width/2, height: 25)
                label.center.x = contentView.center.x
                contentView.addSubview(label)
                break
            case 2:
                let width = Int(contentView.frame.width*0.375)
                let originOffset = (Int(contentView.frame.width) - width*2 - 10)/2
                label.frame = CGRect(x: originOffset + index*(width+10), y: 10, width: width, height: 25)
                contentView.addSubview(label)
                break
            case 3:
                let width = Int(contentView.frame.width*0.25)
                let originOffset = (Int(contentView.frame.width) - width*3 - 20)/2
                label.frame = CGRect(x: originOffset + index*(width + 10), y: 10, width: width, height: 25)
                contentView.addSubview(label)
                break
            case 4:
                let width = Int(contentView.frame.width*0.375)
                let originOffset = (Int(contentView.frame.width) - width*2 - 10)/2
                let x = index < 2 ? index*(width+10) : (index-2)*(width+10)
                let y = index >= 2 ? 40 : 0
                label.frame = CGRect(x: originOffset + x, y: 10 + y, width: width, height: 25)
                contentView.addSubview(label)
                break
            case 5:
                
                let width = index > 2 ? Int(contentView.frame.width*0.375)  : Int(contentView.frame.width*0.25)
                let originOffset = (Int(contentView.frame.width) - Int(contentView.frame.width*0.25)*3 - 20)/2
                let x = index < 3 ? index*(width+10) : (index-3)*(width+20)
                let y = index >= 3 ? 40 : 0
                label.frame = CGRect(x: originOffset + x, y: 10 + y, width: width, height: 25)
                contentView.addSubview(label)
                break
            case 6:
                
                let width = Int(contentView.frame.width*0.25)
                let originOffset = (Int(contentView.frame.width) - width*3 - 20)/2
                let x = index < 3 ? index*(width+10) : (index-3)*(width+10)
                let y = index >= 3 ? 40 : 0
                
                label.frame = CGRect(x: originOffset + x, y: 10 + y, width: width, height: 25)
                contentView.addSubview(label)
                break
            default:
                break
            }
        }
    
        
    }
//    func addOptions(for options: [String]){
//        removeOptions()
//        if options.isEmpty{
//            return 
//        }
//        let groups = options.groupBy(limit: 3)
//        
//        let labelGroups = groups.map({$0.map({ title -> UIButton in
//                let detailLabel = UIButton()
//            
//                let title = NSAttributedString(string: title, attributes: [.font:UIFont.systemFont(ofSize: 12, weight: .light),.foregroundColor: UIColor.white])
//                    detailLabel.setAttributedTitle(title , for: .normal)
//                    detailLabel.backgroundColor = gymmieOrange()
//                    detailLabel.isEnabled = false
//                    detailLabel.layer.cornerRadius = 10
//                    detailLabel.translatesAutoresizingMaskIntoConstraints = false
//                    detailLabel.setHeightTo(constant: 25)
//            return detailLabel
//            })
//        })
//        for (index,group) in labelGroups.enumerated(){
//            let stackView = UIStackView(arrangedSubviews: group)
//            for label in stackView.arrangedSubviews{
//                label.constrainInView(view: stackView, top: 0, left: nil, right: nil, bottom: -10)
//            }
//            
//            stackView.axis = .horizontal
//            stackView.spacing = 5
//            stackView.alignment = .center
//            stackView.distribution = .fillEqually
//            stackView.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview(stackView)
//            stackView.constrainInView(view: contentView, top: CGFloat(index*40), left: 0, right: 0, bottom: nil)
//            stackView.setHeightTo(constant: 40)
//        }
//        
//    
//    }
    
    func setViews(){
        contentView.clipsToBounds = true
        
        
    }
}
