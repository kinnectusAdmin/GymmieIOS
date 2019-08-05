//
//  RatingView.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/7/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
protocol RatingDelegate {
    func submitRating(rating: Int)
    func cancelRating()
}
class RatingView: UIView {

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
    var delegate: RatingDelegate?
    var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Rate Your Partner"
        label.backgroundColor = createColor(204, green: 82, blue: 72)
        label.font = UIFont.systemFont(ofSize: 25, weight: 0.25)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    var rating: Int = 5{
        didSet{
            for sub in subviews{
                if let star = sub as? UIButton{
                    star.isSelected = star.tag <= rating
                }
            }
        }
    }
    let avatarImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "defaultImage2")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 25
        return iv
    }()
    var nameLabel: UILabel = {
        let label = UILabel()
            label.text = "Name of User"
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    func setStars(){
        
        for i in 1...5{
            let starButton : UIButton = {
                let button = UIButton()
                    button.tag = i
                    button.setImage(#imageLiteral(resourceName: "greyStar"), for: .normal)
                    button.setImage(#imageLiteral(resourceName: "goldStar"), for: .selected)
                    button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            
            addSubview(starButton)
            starButton.addTarget(self, action: #selector(RatingView.ratePartner(_:)), for: .touchUpInside)
            let starSpace = 200
            let offset = 20
            starButton.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor, constant: CGFloat(offset+(i-1)*45)).isActive = true
            starButton.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 4).isActive = true
        }
    }
    
    let submitButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Submit", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: 0.25),NSForegroundColorAttributeName: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = createColor(204, green: 82, blue: 72)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Cancel", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: 0.25),NSForegroundColorAttributeName: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = createColor(204, green: 82, blue: 72)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    func setViews(){
        backgroundColor = UIColor.white
        layer.masksToBounds = true
        layer.cornerRadius = 10.0
        add(views: ratingLabel,avatarImage,nameLabel, submitButton,cancelButton)
        //constrain rating label
        ratingLabel.constrainInView(view: self, top: -8, left: -10, right: 10, bottom: nil)
        ratingLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //constrain submit button
        submitButton.constrainInView(view: self, top: nil, left: 0, right: nil, bottom: 0)
        submitButton.rightAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor, constant: -8).isActive = true
        submitButton.addTarget(self, action: #selector(RatingView.submit(_:)), for: .touchUpInside)
        //constrain avatar
        avatarImage.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor, constant: 0).isActive = true
        avatarImage.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8).isActive = true
        avatarImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        avatarImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //constrain name
        nameLabel.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 8).isActive = true
        //constrain cancel button
        cancelButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor, constant: 8).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor).isActive = true
        cancelButton.addTarget(self, action: #selector(RatingView.cancelAll(_:)), for: .touchUpInside)
        
        setStars()
    }
}
extension RatingView{
    func ratePartner(_ sender: UIButton){
        rating = sender.tag
    }
    func submit(_ sender: UIButton){
        delegate?.submitRating(rating: rating)
    }
    func cancelAll(_ sender: UIButton){
        delegate?.cancelRating()
    }
    
}
