//
//  PartnerChatView.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/7/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit

class PartnerChatView: UIView {

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
        //setMatchAndWorkout()
        add(views: profileBlurImage,nameLabel,detailLabel,scheduleLabel)
     
        //constrain profileBlurImage
        profileBlurImage.constrainWithMultiplier(view: self, width: 1, height: 1)
       
        //constrain namelabel
        nameLabel.setTopTo(con: layoutMarginsGuide.topAnchor, by: 8)
        nameLabel.setXTo(con: layoutMarginsGuide.centerXAnchor, by: 0)
        //constrain detailLabel
        detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        detailLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        //constrain schedulelabel
        scheduleLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 4).isActive = true
        scheduleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
    }
    
    let profileBlurImage : UIImageView = {
        let iv = UIImageView()
      
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        let blur = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect:blur)
            blurEffectView.layer.opacity = 0.85
            blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        iv.addSubview(blurEffectView)
        blurEffectView.constrainWithMultiplier(view: iv, width: 1, height: 1)
       
        return iv
    }()
    var workout = Event(){
        didSet{
            if let partner = workout.partner{
                match = partner
            }
            //detailLabel.text = workout.workoutName//"\(workout.workout.type) Workout ".appending(workout.locationDetail)
            scheduleLabel.text = workout.scheduleDetail
        }
    }
 
    
    var match : GymmieUser? {
        didSet{
            let age = match?.age == nil ? "" : ",\(match!.age!)"
            nameLabel.text = "\(match!.fullName)".appending(age)
            if let url = match?.imageURL{
                photoURL = url
            }
        }
    }
    
    var photoURL: String = ""{
        didSet{
            //https://unsplash.com/search/pretty?photo=ggJRxqOEaFY
         
            profileBlurImage.loadImageWithURL(url: photoURL)
        }
    }

    var nameLabel: UILabel = {
        let label = UILabel()
            label.text = ""
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let scheduleLabel: UILabel = {
        let label = UILabel()
            label.text = ""
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
