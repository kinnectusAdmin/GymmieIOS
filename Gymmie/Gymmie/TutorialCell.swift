//
//  TutorialCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 10/10/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit
protocol TutorialDelegate{
    func signUp()
}
class TutorialCell: UICollectionViewCell {
    override func layoutSubviews() {
        setViews()
        //contentView.backgroundColor = UIColor.red
    }
    var tutorialDelegate: TutorialDelegate?
    let tutorialImage: UIImageView = {
       let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
        
            iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let goHomeButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "GO TO APP!", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = gymmieOrange()
        button.layer.cornerRadius = 10.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func signUpHandler(_ sender: UIButton){
        print("should signUP")
        tutorialDelegate?.signUp()
    }
    func setViews(){
        add(views: tutorialImage,goHomeButton)
        //constrain tutorial image
//        tutorialImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: 0).isActive = true
        
        tutorialImage.constrainInView(view: self, top: 0, left: 0, right: 0, bottom: nil)
        tutorialImage.setHeightTo(constant: self.frame.height*0.75)
    
        //constrain signup button
        goHomeButton.setXTo(con: self.x(), by: 0)
        goHomeButton.setBottomTo(con: self.bottom(), by: 0)
        goHomeButton.setWidthTo(constant: contentView.frame.width*0.6)
        goHomeButton.addTarget(self, action: #selector(TutorialCell.signUpHandler(_:)), for: .touchUpInside)
        
    }
}
