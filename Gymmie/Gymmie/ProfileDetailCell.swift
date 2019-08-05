//
//  ProfileDetailCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/30/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
protocol ProfileDetailDelegate{
    func addNewGoal()
    func editDetail()
    func showGoals()
}

class ProfileDetailCell: UICollectionViewCell {
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
        label.adjustsFontSizeToFitWidth = true 
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
    var delegate: ProfileDetailDelegate?
    @objc func setGoalsHandler(_ sender: UIButton){
        delegate?.showGoals()
    }
    
    func addOptions(for options: [String],editing: Bool){
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
        
        if editing{
            let y = options.count > 3 ? 80 : 45
            let button = UIButton(frame: CGRect(x: 0, y: y, width: 50, height: 25))
                button.setImage(#imageLiteral(resourceName: "addGoalButton"), for: .normal)
                button.addTarget(self , action: #selector(ProfileDetailCell.setGoalsHandler(_:)), for: .touchUpInside)
                button.center.x = contentView.center.x
            contentView.addSubview(button)
            
            
        }
        
    }
//    func addOptions(for options: [String],editing: Bool){
//        removeOptions()
//        var editingOptions = options+["plusSign",]
//        let groups = editing ? editingOptions.groupBy(limit:3) : options.groupBy(limit: 3)
//        let labelGroups = groups.map({$0.map({title ->UIView in
//            let detailButton : UIButton = {
//                let button = UIButton()
//                if title != "plusSign"{
//                    let title = NSAttributedString(string: title, attributes: [.font:UIFont.systemFont(ofSize: 12, weight: .light),.foregroundColor: UIColor.white])
//                    button.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
//                    button.setAttributedTitle(title, for: .normal)
//                    button.backgroundColor = gymmieOrange()
//                    button.layer.cornerRadius = 10
//                }else{
//                    button.setImage(#imageLiteral(resourceName: "addGoalButton"), for: .normal)
//                    button.addTarget(self , action: #selector(ProfileDetailCell.setGoalsHandler(_:)), for: .touchUpInside)
//                }
//                return button
//            }()
//            return detailButton
//        })})
//        for (index,group) in labelGroups.enumerated(){
//            let stackView = UIStackView(arrangedSubviews: group)
//            for label in stackView.arrangedSubviews{
//                //label.constrainInView(view: stackView, top: 0, left: nil, right: nil, bottom: -10)
//            
//                label.setHeightTo(constant: 25)
//            }
//            stackView.axis = .horizontal
//            stackView.spacing = 10
//            stackView.alignment = .center
//            stackView.distribution = .fillEqually
//            stackView.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview(stackView)
//            let stackSpacing = 5
//            stackView.constrainInView(view: contentView, top: CGFloat(5 + index*(25+stackSpacing)), left: 10, right: -10, bottom: nil)
//            stackView.setHeightTo(constant: 25)
//        }
//  
//    }
    
    func setViews(){
    }
}

