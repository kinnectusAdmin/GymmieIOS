//
//  MenuVC.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/17/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
protocol MenuDelegate {
    func showUserProfile()
    func showPrivacySettings()
    func showContactUs()
    func showSettings()
    func invite()
    func logout()
}
class MenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        menuTV.delegate = self
        menuTV.dataSource = self
        menuTV.register(MenuCell.self , forCellReuseIdentifier: "MenuCell")
    
        // Do any additional setup after loading the view.
        setViews()
        guard let user = GymmieUser.currentUser() else {return}
            nameLabel.text = user.fullName
        if let image = user.image{
                userImage.image = image
        }else{
            if let url = user.imageURL{
                loadImageWithURL(url: url)
            }else{
                userImage.image = #imageLiteral(resourceName: "defaultImage2")
            }
        }
    }
    
    func session()-> URLSession{
        
        let sessDefined = Foundation.URLSession.shared
        
        return sessDefined
    }
    func getImageHandler(data: Data?,response: URLResponse?,error: Error?){
        
        if error == nil{
            if let dataImage = UIImage(data: data!){
                
                imageCache.setObject(dataImage, forKey: response!.url!.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    self.userImage.image = dataImage
                }
                if let user = GymmieUser.currentUser(){
                    user.image = dataImage
                    user.updateCurrentUser(server: false)
                }
            }else{
                DispatchQueue.main.async {
                     self.userImage.image = #imageLiteral(resourceName: "defaultImage2")
                }
               
            }
        }else{
            print(error?.localizedDescription)
        }
    }
    func loadImageWithURL(url: String){
        
        if let image = imageCache.object(forKey: url as AnyObject){
            DispatchQueue.main.async {
                self.userImage.image = image as UIImage
            }
            
        }else{
            let url = URL(string:url)
            if url != nil{
                var task = session().dataTask(with: url!, completionHandler: getImageHandler)
                task.resume()
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    var delegate: MenuDelegate?
    func setViews(){
        view.backgroundColor = UIColor.white
        view.add(views: userImage,nameLabel, menuTV)
        userImage.constrainInView(view: view , top: 20, left: 0, right: nil, bottom: nil)
        userImage.setWidthTo(constant: 50)
        userImage.setHeightTo(constant: 50)
        nameLabel.setYTo(con: userImage.centerYAnchor, by: 0)
        nameLabel.setLeftTo(con: userImage.rightAnchor, by: 8)
        nameLabel.setRightTo(con: view.layoutMarginsGuide.rightAnchor, by: 0)
        menuTV.setTopTo(con: userImage.bottom(), by: 8)
        menuTV.constrainInView(view: view, top: nil, left: -8, right: 8, bottom: 50)
    }
    
    let menuItems = ["Profile","Privacy Settings","Invite Your Friends","Log Out"]
    
    let menuTV:UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = createColor(210, green: 210, blue: 210).withAlphaComponent(0.8)
        tv.backgroundView = nil
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let userImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 25
        return iv
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
            label.text = "User Name"
            label.textColor = UIColor.darkGray
            label.textAlignment = .left
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 18, weight: .light)
            label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
}

extension MenuVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row{
        case 0:
            removeFromParent()
            view.removeFromSuperview()
            delegate?.showUserProfile()
        
        case 1:
            removeFromParent()
            view.removeFromSuperview()
            delegate?.showPrivacySettings()
//        case 2:
//            removeFromParentViewController()
//            view.removeFromSuperview()
//            delegate?.showContactUs()
//        case 3:
//            removeFromParentViewController()
//            view.removeFromSuperview()
//            delegate?.showSettings()
        case 2:
            removeFromParent()
            view.removeFromSuperview()
            delegate?.invite()
        case 3:
            removeFromParent()
            view.removeFromSuperview()
            delegate?.logout()
        default:break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            
            cell.menuLabel.text = menuItems[indexPath.row]
        
        return cell
    }
}
