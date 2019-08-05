//
//  PushPrimer.swift
//  Gymmie
//
//  Created by Blake Rogers on 4/2/17.
//  Copyright © 2017 kinnectus. All rights reserved.
//

import UIKit

class PushPrimer: UIViewController {


    override func viewDidLoad() {
        setViews()
        getUserImage()
        UserDefaults.standard.set(true, forKey: "viewedPrimer")
    }
  
    func setViews(){
        view.backgroundColor = createColor(58, green: 58, blue: 60)
        view.add(views: requestImage,partner_one_Image,partner_two_Image,userImage,allowButton,skipButton)
        //constrain primer image
        requestImage.constrainInView(view: view, top: 100, left: 0, right: 0, bottom: nil)
        requestImage.setHeightTo(constant: view.frame.height*0.60)
        //constrain partner
        partner_one_Image.setXTo(con: requestImage.x(), by: -100)
        partner_one_Image.setYTo(con: requestImage.y(), by: 0)
        partner_one_Image.setWidthTo(constant: 120)
        partner_one_Image.setHeightTo(constant: 120)
        //constrain partner
        partner_two_Image.setXTo(con: requestImage.x(), by: 100)
        partner_two_Image.setYTo(con: requestImage.y(), by: 0)
        partner_two_Image.setWidthTo(constant: 120)
        partner_two_Image.setHeightTo(constant: 120)
        //constrain userImage
        userImage.setXTo(con: requestImage.x(), by: 0)
        userImage.setYTo(con: requestImage.y(), by: 0)
        userImage.setWidthTo(constant: 176)
        userImage.setHeightTo(constant: 176)
        //constrain allowButton
        allowButton.constrainInView(view: view , top: nil, left: 20, right: -10, bottom: nil)
        allowButton.setXTo(con: view.x(), by: 0)
        allowButton.setTopTo(con: requestImage.bottom(), by: 40)
        //constrain skipButton
        skipButton.setXTo(con: view.x(), by: 0)
        skipButton.setTopTo(con: allowButton.bottom(), by: 10)
        //add targets
        allowButton.addTarget(self , action: #selector(PushPrimer.allowPush(_:)), for: .touchUpInside)
        skipButton.addTarget(self , action: #selector(PushPrimer.declinePush(_:)), for: .touchUpInside)
    }
    
    func getUserImage(){
        if let user = UserDefaults.standard.data(forKey: FBPermissions.fbUser){
            if let gymmieUser = NSKeyedUnarchiver.unarchiveObject(with: user) as? GymmieUser{
                userImage.image = gymmieUser.image
                userImage.layer.borderColor = UIColor.white.cgColor
                userImage.layer.borderWidth = 2
            }
        }
//        if let image = GymmieUser.currentUser()?.imageURL{
//            userImage.loadImageWithURL(url: image)
////            userImage.layer.borderWidth = 2
////            userImage.layer.borderColor = UIColor.white.cgColor
//        }
    }
    let requestImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "apnPrimerImage")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let partner_one_Image : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "ZackOriginaldarker")
        iv.layer.cornerRadius = 60
        iv.layer.masksToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 1
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let partner_two_Image : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "AlexaOriginaldarker")
        iv.layer.cornerRadius = 60
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 1
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let userImage : UIImageView = {
        let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.layer.cornerRadius = 88
            iv.layer.masksToBounds = true
            iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let allowButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "OK", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = gymmieOrange()
        button.layer.cornerRadius = 10.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let skipButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "skip this step", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light),.foregroundColor:createColor(129, green: 130, blue: 133)])
        button.setAttributedTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func allowPush(_ sender: UIButton){
        if let appDel = UIApplication.shared.delegate as? AppDelegate{
//            appDel.establishNotificationSettings()
//            appDel.allowedNotificationViaPrimer(allowed: true)
        }
      

    }
    @objc func declinePush( _ sender: UIButton){
        if let appDel = UIApplication.shared.delegate as? AppDelegate{
           
//            appDel.allowedNotificationViaPrimer(allowed: false)
        }
        OperationQueue.main.addOperation({
            let home = HomeVC()
            let homeNav = UINavigationController(rootViewController: home)
            if let window = UIApplication.shared.keyWindow{
                window.rootViewController = homeNav
                window.makeKeyAndVisible()
            }
        })
    }
}
