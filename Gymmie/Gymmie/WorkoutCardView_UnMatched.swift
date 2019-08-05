//
//  WorkoutView.swift
//  Gymmie
//
//  Created by Blake Rogers on 11/27/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
public var imageCache = NSCache<AnyObject,UIImage>()

class WorkoutCardView_UnMatched: UIView {

    override func layoutSubviews() {
        setViews()
    }
   
    var workout: Event?{
        didSet{
            title.text = workout?.workoutName.localizedUppercase
           // workoutTypeLabel.text = workout?.workout.type
           // locationLabel.text = workout?.locationDetail
            scheduleLabel.text = workout?.scheduleDetail
            middleCardView.backgroundColor = UIColor.white
            topCardView.layer.borderColor =  UIColor.white.cgColor
            backgroundColor =  UIColor.white
        }
    }
    
    var matched: Bool{
        return workout?.isMatched ?? false
    }
    var clickLabel: UILabel = {
        let label = UILabel()
            label.backgroundColor = gymmieOrange()
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.text = "CLICK HERE TO FIND PARTNERS"
            label.font = UIFont.systemFont(ofSize: 15, weight: .light)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.layer.cornerRadius = 10.0
        
        return label
    }()
    let title: UILabel = {
        let label = UILabel()
            label.adjustsFontSizeToFitWidth = true
            label.font = UIFont.systemFont(ofSize: 30, weight: .light)
            label.textAlignment = .center
            label.textColor = gymmieOrange()
            label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let workoutTypeLabel: UILabel = {
        let label = UILabel()
            label.textColor = gymmieOrange()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 15, weight: .light)
            label.translatesAutoresizingMaskIntoConstraints = false
   
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = gymmieOrange()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
       
        return label
    }()
    
    let scheduleLabel: UILabel = {
        let label = UILabel()
            label.textColor = gymmieOrange()
            label.textAlignment = .center
            label.numberOfLines = 2
            label.font = UIFont.systemFont(ofSize: 12, weight: .light)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let middleCardView: UIView = {
        let v = UIView()
            v.layer.cornerRadius = 10.0
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let topCardView: UIView = {
        let v = UIView()
            v.layer.cornerRadius = 10.0
            v.layer.borderWidth = 1.0
            v.backgroundColor = UIColor.white
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    func setViews(){
        layer.masksToBounds = true
        layer.cornerRadius = 10.0
        layer.borderColor = gymmieOrange().cgColor
        layer.borderWidth = 1.0
        add(views: middleCardView,topCardView,clickLabel)
        topCardView.add(views:title,scheduleLabel)
        //constrain middle card
        middleCardView.constrainWithMultiplier(view: self, width: 0.95, height: 1)
        //constrain top card
        topCardView.constrainWithMultiplier(view: self, width: 0.9, height: 1)
        //constrain click label
        clickLabel.constrainInView(view: self, top: -8, left: -8, right: 8, bottom: nil)
        //constrain title
        title.setYTo(con: topCardView.y(), by: 0)
        title.constrainInView(view: topCardView, top: nil, left: 0, right: 0, bottom: nil)
        //constrain workout type
//        workoutTypeLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: -4).isActive = true
//        workoutTypeLabel.centerXAnchor.constraint(equalTo: topCardView.centerXAnchor).isActive = true
//        //constrain location label
//        locationLabel.topAnchor.constraint(equalTo: workoutTypeLabel.bottomAnchor, constant: 0).isActive = true
//        locationLabel.centerXAnchor.constraint(equalTo: topCardView.centerXAnchor).isActive = true
        //constrain schedule label
        scheduleLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0).isActive = true
        scheduleLabel.centerXAnchor.constraint(equalTo: topCardView.centerXAnchor).isActive = true 
        
    }
}
