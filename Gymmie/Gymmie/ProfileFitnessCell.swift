//
//  ProfileFitnessCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 1/14/17.
//  Copyright © 2017 kinnectus. All rights reserved.
//

import UIKit
protocol FitnessDelegate {
    func setLevel( level : String)
}
class ProfileFitnessCell: UICollectionViewCell {
    override func layoutSubviews() {
        setViews()
    }
    
    func setViews(){
        //addSubview(titleLabel)
        //titleLabel.constrainInView(view: self , top: 0, left: -10, right: 10, bottom: nil)
        //titleLabel.setHeightTo(constant: 40)
        contentView.add(views: lowButton,midButton,hiButton)
       
        lowButton.addTarget(self , action: #selector(ProfileFitnessCell.setLevel(_:)), for: .touchUpInside)
     
        midButton.addTarget(self , action: #selector(ProfileFitnessCell.setLevel(_:)), for: .touchUpInside)
   
        hiButton.addTarget(self , action: #selector(ProfileFitnessCell.setLevel(_:)), for: .touchUpInside)
    }
    var delegate: FitnessDelegate?
    var lowWidth = NSLayoutConstraint()
    var lowLeft = NSLayoutConstraint()
    var midWidth = NSLayoutConstraint()
    var midLeft = NSLayoutConstraint()
    var hiWidth = NSLayoutConstraint()
    var hiLeft = NSLayoutConstraint()
    
    var fitnessLevel: String = "" {
        didSet{
            setLevel(level: fitnessLevel)
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Fitness Level"
        label.textColor = gymmieOrange()
        label.backgroundColor = createColor(230, green: 230, blue: 230)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.layer.borderColor = createColor(210, green: 210, blue: 210).cgColor
        label.layer.borderWidth = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lowButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 10, width: self.contentView.frame.width*0.3, height: 25))
        let title = NSAttributedString(string: "LOW", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = gymmieOrange()
        button.layer.cornerRadius = 10.0
      
        return button
    }()
    
    lazy var midButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 10, width: self.contentView.frame.width*0.3, height: 25))
        let title = NSAttributedString(string: "MEDIUM", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = gymmieOrange()
        button.layer.cornerRadius = 10.0
       
        return button
    }()
    
    lazy var hiButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 10, width: self.contentView.frame.width*0.3, height: 25))
        let title = NSAttributedString(string: "HIGH", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = gymmieOrange()
        button.layer.cornerRadius = 10.0
       
        return button
    }()
    
    func setLevel(level: String){
        let thirdWidth = contentView.frame.width*0.32
       
        switch level{
            case "LOW":
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.lowButton.frame.origin.x = (self.contentView.frame.width - self.frame.width*0.75)/2
                    self.lowButton.frame.size.width = self.contentView.frame.width*0.75 + 10.0
                    self.midButton.frame.origin.x = self.contentView.frame.width
                    self.hiButton.frame.origin.x = self.contentView.frame.width
                })
                
                lowButton.backgroundColor = gymmieOrange()
                midButton.backgroundColor = gymmieOrange().withAlphaComponent(0.8)
                hiButton.backgroundColor = gymmieOrange().withAlphaComponent(0.8)
            case "MEDIUM":
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.lowButton.frame.origin.x = -thirdWidth
                    self.midButton.frame.size.width = self.contentView.frame.width * 0.75 + 10.0
                    self.midButton.center.x = self.contentView.center.x
                    self.hiButton.frame.origin.x = self.contentView.frame.width
                })
                
                midButton.backgroundColor = gymmieOrange()
                lowButton.backgroundColor = gymmieOrange().withAlphaComponent(0.8)
                hiButton.backgroundColor = gymmieOrange().withAlphaComponent(0.8)
            case "HIGH":
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.lowButton.frame.origin.x = -thirdWidth
                    self.midButton.frame.origin.x = -thirdWidth
                    self.hiButton.frame.size.width = self.contentView.frame.width*0.75 + 10.0
                    self.hiButton.center.x = self.contentView.center.x
                    
                })
                
                hiButton.backgroundColor = gymmieOrange()
                midButton.backgroundColor = gymmieOrange().withAlphaComponent(0.8)
                lowButton.backgroundColor = gymmieOrange().withAlphaComponent(0.8)
            default:
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.lowButton.frame.size.width = thirdWidth
                    self.lowButton.frame.origin.x = 5
                    self.midButton.frame.size.width = thirdWidth
                    self.midButton.center.x = self.contentView.center.x
                    self.hiButton.frame.size.width = thirdWidth
                    self.hiButton.frame.origin.x = self.contentView.frame.width - thirdWidth - 5
                })
            }

    }
    
    @objc func setLevel(_ sender: UIButton){
        switch sender.titleLabel!.text!{
            case "LOW":
                lowButton.backgroundColor = gymmieOrange()
                midButton.backgroundColor = gymmieOrange().withAlphaComponent(0.8)
                hiButton.backgroundColor = gymmieOrange().withAlphaComponent(0.8)
            case "MEDIUM":
                midButton.backgroundColor = gymmieOrange()
                lowButton.backgroundColor = gymmieOrange().withAlphaComponent(0.8)
                hiButton.backgroundColor = gymmieOrange().withAlphaComponent(0.8)
            case "HIGH":
                hiButton.backgroundColor = gymmieOrange()
                midButton.backgroundColor = gymmieOrange().withAlphaComponent(0.8)
                lowButton.backgroundColor = gymmieOrange().withAlphaComponent(0.8)
        default:break
        }
        
        let bounceAnim = CASpringAnimation(keyPath: "transform.scale")
            bounceAnim.fromValue = 1.1
            bounceAnim.toValue = 1
            bounceAnim.duration = bounceAnim.settlingDuration
            bounceAnim.initialVelocity = 0.1
            bounceAnim.damping = 2
        
        sender.layer.add(bounceAnim, forKey: nil)
        delegate?.setLevel(level: sender.titleLabel!.text!)
    }
    
}
