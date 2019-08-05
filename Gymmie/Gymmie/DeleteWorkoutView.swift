//
//  DeleteWorkoutView.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/26/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
protocol DeleteWorkoutDelegate {
    func cancelDelete()
    func deleteWorkout()
}
class DeleteWorkoutView: UIView {

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
    var delegate: DeleteWorkoutDelegate?
    
    func setViews(){
        backgroundColor = UIColor.white
        layer.masksToBounds = true
        layer.cornerRadius = 10.0
       
        
        add(views: deleteLabel,warningLabel,noButton,yesButton)
        
        deleteLabel.constrainInView(view: self , top: -10, left: -10, right: 10, bottom: nil)
        deleteLabel.setHeightTo(constant: 40)
        
        warningLabel.setTopTo(con: deleteLabel.bottom(), by: 8)
        warningLabel.constrainInView(view: self , top: nil, left: 0, right: 0, bottom: nil)
        warningLabel.setHeightTo(constant: 30)
        
        noButton.setTopTo(con: warningLabel.bottom(), by: 8)
        noButton.setLeftTo(con: left(), by: 4)
        noButton.setRightTo(con: x(), by: -4)
        noButton.addTarget(self , action: #selector(DeleteWorkoutView.cancel(_:)), for: .touchUpInside)
        
        yesButton.setLeftTo(con: x(), by: 4)
        yesButton.setTopTo(con: warningLabel.bottom(), by: 8)
        yesButton.setRightTo(con: right(), by: -4)
        yesButton.addTarget(self , action: #selector(DeleteWorkoutView.deleteWorkout(_:)), for: .touchUpInside)
   
    }
    
    var deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "Delete Workout?"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = createColor(239, green: 82, blue: 50)
        
        return label
    }()
    var warningLabel: UILabel = {
        let label = UILabel()
            label.text = "Select \"Yes\" to permanently delete this workout"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let yesButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "YES", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8.0
        button.backgroundColor = createColor(151, green: 201, blue: 70)
        return button
    }()
    let noButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "NO", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8.0
        button.backgroundColor = createColor(239, green: 82, blue: 50)
        
        return button
    }()
    @objc func cancel(_ sender: UIButton){
        delegate?.cancelDelete()
        removeFromSuperview()
    }
    @objc func deleteWorkout(_ sender: UIButton){
        delegate?.deleteWorkout()
        removeFromSuperview()
    }

}
