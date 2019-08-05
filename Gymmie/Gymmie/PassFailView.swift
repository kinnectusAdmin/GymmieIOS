//
//  PassFailView.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/5/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit

class PassFailView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var workout: Event? {
        didSet{
            workoutNameLabel.text = workout!.workoutName.capitalized
            //workoutTypeLabel.text = workout!.workout.type
            //locationLabel.text = workout!.locationDetail
            scheduleLabel.text = workout!.scheduleDetail
        }
    }
    func setViews(){
        backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        add(views: workoutNameLabel,scheduleLabel,goButton,noGoButton)

        //constrain namelabel
        workoutNameLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        workoutNameLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor, constant: 0).isActive = true
        
        //constrain workoutTypeLabel
//       workoutTypeLabel.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 0).isActive = true
//        workoutTypeLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
//        //constrain locationLabel
//        locationLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
//        locationLabel.topAnchor.constraint(equalTo: workoutTypeLabel.bottomAnchor,constant:0).isActive = true
        //constrain schedule label
        scheduleLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
        scheduleLabel.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 0).isActive = true
        //constrain noGo button
        noGoButton.constrainInView(view: self, top: 0, left: 20, right: nil, bottom: 0)
        //constrain go Button
        goButton.constrainInView(view: self, top: 0, left: nil, right: -20, bottom: 0)
    }
    var workoutNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white 
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    var workoutTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    var scheduleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white 
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    let goButton : UIButton = {
        let button = UIButton()
            button.tag = 1
            button.setImage(#imageLiteral(resourceName: "thumbsUp"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let noGoButton : UIButton = {
        let button = UIButton()
            button.tag = 2
            button.setImage(#imageLiteral(resourceName: "thumbsDown"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
