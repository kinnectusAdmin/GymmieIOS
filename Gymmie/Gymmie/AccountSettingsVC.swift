//
//  AccountSettingsVC.swift
//  Gymmie
//
//  Created by Blake Rogers on 9/8/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit

class AccountSettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTV.delegate = self
        settingsTV.dataSource = self
        
        settingsTV.register(EditNameEmailCell.self , forCellReuseIdentifier: "EditNameEmailCell")
        settingsTV.register(EditPasswordCell.self , forCellReuseIdentifier: "EditPasswordCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViews()
    }
    func setViews(){
        view.add(views: settingsLabel, settingsTV)
        let topOffset = navigationController!.navigationBar.frame.height + 20
        settingsLabel.constrainInView(view: view , top: 0 , left: -20, right: 20, bottom: nil)
        settingsLabel.setHeightTo(constant: 30)
        
        settingsTV.constrainInView(view: view , top: nil, left: -20, right: 20, bottom: 0)
        settingsTV.setTopTo(con: settingsLabel.bottom(), by: 0)
    }
    
    var editingName: Bool = false{
        didSet{
            if editingName{
                editingEmail = false
                editingPassword = false
                editingSocialAccount = false
            }
        }
    }
    var editingEmail: Bool = false{
        didSet{
            if editingEmail{
                editingName = false
                editingPassword = false
                editingSocialAccount = false
            }
        }
    }
    var editingPassword: Bool = false{
        didSet{
            if editingPassword{
                editingName = false
                editingEmail = false
                editingSocialAccount = false
            }
        }
    }
    var editingSocialAccount: Bool = false{
        didSet{
            if editingSocialAccount{
                editingName = false
                editingEmail = false
                editingPassword = false
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var editingThings: Bool = false
    var editingRows = [IndexPath]()
    var gymUser: GymmieUser?
    
    var settingsLabel: UILabel = {
        let label = UILabel()
            label.text = "Account Settings"
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.backgroundColor = createColor(252, green: 187, blue: 117)
            label.font = UIFont.systemFont(ofSize: 18, weight: .light)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let settingsTV:UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor.white
        tv.backgroundView = nil
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let options = ["Change Name","Change Password","Change Email","Back To Menu"/*,"Attach a Social Media Account"*/]

    var showingMenu: Bool = false
    var menuGesture = UITapGestureRecognizer()
    var hideMenuGesture = UITapGestureRecognizer()
    @objc func sectionHandler(_ gesture: UITapGestureRecognizer){
        let tag = gesture.view!.tag
        if tag == 3{
            show_hideMenu(show: true)
            showingMenu = !showingMenu
            return
        }
        
        let row = IndexPath(row: 0, section: tag)
        if editingRows.count > 0{
        for (index,editingRow) in editingRows.enumerated(){
            if editingRows.contains(editingRow){
                editingRows.remove(at: index)
                settingsTV.deleteRows(at: [editingRow], with: .fade)
                editingRows.append(row)
                settingsTV.insertRows(at: [row], with: .fade)
            }else{
                editingRows.append(row)
                settingsTV.insertRows(at: [row], with: .fade)
            }
        }
            
        }else{
            editingRows.append(row)
            settingsTV.insertRows(at: [row], with: .fade)
        }
    }
}

extension AccountSettingsVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let row = IndexPath(row: 0, section: section)
   
   
    return editingRows.contains(row) ? 1 : 0
    
    }
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
            label.text = options[section]
            label.textAlignment = .center
//          label.backgroundColor = createColor(252, green: 187, blue: 117)
        let  sectionGesture = UITapGestureRecognizer(target: self, action: #selector(AccountSettingsVC.sectionHandler(_:)))
        let remainder = section % 2
        let lightGray = createColor(250, green: 250, blue: 250)
        let darkGray = createColor(220, green: 220, blue: 220)
        let menuColor = createColor(252, green: 187, blue: 117)
        let sectionColor = remainder > 0 ? lightGray : darkGray
        let sectionView = UIView()
            sectionView.backgroundColor = section == 3 ? menuColor : sectionColor
            sectionView.tag = section
            sectionView.addSubview(label)
            sectionView.addGestureRecognizer(sectionGesture)
        return sectionView
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
            switch (indexPath as NSIndexPath).section{
            case 0:
                let nameCell = tableView.dequeueReusableCell(withIdentifier:"EditNameEmailCell", for: indexPath) as! EditNameEmailCell
                nameCell.name_EmailLabel.text = "Name:"
                nameCell.changeName = true
                nameCell.oldValueLabel.text = gymUser?.fullName
                nameCell.newValueField.placeholder = "First Name..."
                nameCell.lastNameField.placeholder = "Last Name..."
                nameCell.lastNameField.alpha = 1.0
                nameCell.delegate = self
                cell = nameCell
            case 1:
                let passwordCell = tableView.dequeueReusableCell(withIdentifier: "EditPasswordCell", for: indexPath) as! EditPasswordCell
                passwordCell.newPasswordField.isSecureTextEntry = true
                passwordCell.oldPasswordField.isSecureTextEntry = true
                passwordCell.delegate = self
                cell = passwordCell
            case 2:
                let emailCell = tableView.dequeueReusableCell(withIdentifier:   "EditNameEmailCell", for: indexPath) as! EditNameEmailCell
                emailCell.name_EmailLabel.text = "Email:"
                emailCell.changeEmail = true
                emailCell.oldValueLabel.text = gymUser?.email
                emailCell.newValueField.placeholder = "Enter email..."
                emailCell.lastNameField.alpha = 0
                emailCell.delegate = self
                cell = emailCell
               
               
               
//            case 3:
//                 let socialCell = tableView.dequeueReusableCell(withIdentifier: Cell.socialMediaCell, for: indexPath) as! SocialMediaAccountCell
//                    socialCell.delegate = self
//                    cell = socialCell
              
            default:
              break
        }
        return cell
    
    }

}

extension AccountSettingsVC: EditNameEmailDelegate{
    func editName(first: String,last:String){
        guard let user = GymmieUser.currentUser() else {return }
            user.firstName = first
            user.lastName = last
            user.updateCurrentUser(server: true)
        alert(title: "Account Edit", message: "Your account change is being processed.")
        
    }
    func editEmail( with email: String){
        alert(title: "Account Edit", message: "Your account change is being processed.")
        guard let user = GymmieUser.currentUser() else {return }
            user.email = email
            user.updateCurrentUser(server: true)
    }
    func changeNameEmailError(){
        alert(title: "Account Edit", message: "Edit your info before submitting")
        
    }
}

extension AccountSettingsVC: EditPasswordDelegate {
    func changePassword(_ toPassword:String){
        guard let user = GymmieUser.currentUser() else {return}
                    user.password = toPassword
                    user.updateCurrentUser(server: true)
        alert(title: "Account Edit", message: "Your account change is being processed.")
    }
    func changePasswordError(){
            alert(title: "Account Edit", message: "Hmmm...something went wrong. Try again?")
    }
}
extension AccountSettingsVC: SocialDelegate{
    func attachFB(){}
    func attachTwitter(){}
    func attachIG(){}
}
extension AccountSettingsVC: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        for controller in navigationController!.viewControllers{
            
            if let tabBarController = controller as? UITabBarController{
                tabBarController.selectedIndex = item.tag
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
extension AccountSettingsVC: MenuDelegate{
    internal func invite() {
        
    }

    func resetView(){
        showingMenu = false
        self.navigationController?.navigationBar.frame.origin.x = 0
        if let screen = navigationController?.view.viewWithTag(33){
            screen.removeFromSuperview()
            if let logo = UIApplication.shared.keyWindow?.viewWithTag(13){
                logo.alpha = 1
            }
        }
    }
    
    func showSettings(){
        show_hideMenu(show: false)
        
    }
    
    
    
    func showContactUs(){
//        resetView()
//        let contact = ContactUsVC()
//        let home = HomeVC()
//        navigationController?.setViewControllers([home,contact], animated: true)
     
    }
    
    func showPrivacySettings(){
        resetView()
        let privacy = PrivacyVC()
        let home = HomeVC()
        navigationController?.setViewControllers([home,privacy], animated: true)
      
    }
    
    func showUserProfile(){
        resetView()
        let profile = UserProfileVC()
        let home = HomeVC()
        navigationController?.setViewControllers([home,profile], animated: true)
        
    }
    func logout(){
        //make the current user nil in the defaults
        // if signed up manually with gymmie server
        let def = UserDefaults.standard
        def.removeObject(forKey: "authCode")
        //if signed up through facebook or othe social media
        def.removeObject(forKey: "currentUser")
        AppDatabase.logOutUser()
        //        let controller = FBController()
        //        if controller.checkAccessToken(){
        //            controller.logOutUser()
        //        }
        
        let window = UIApplication.shared.keyWindow
        if let signIn = storyboard?.instantiateInitialViewController() as? SignInVC{
            window?.rootViewController = signIn
            window?.makeKeyAndVisible()
        }
        
        
    }
    func handleMenu( _ sender: UIBarButtonItem){
        showingMenu = !showingMenu
        show_hideMenu(show: showingMenu)
    }
    
    func hideMenuHandler( _ gesture: UITapGestureRecognizer){
        showingMenu = !showingMenu
        show_hideMenu(show: showingMenu)
        
    }
    func show_hideMenu(show: Bool){
        if show{
            if let logo = UIApplication.shared.keyWindow?.viewWithTag(13){
                logo.alpha = 0
            }
            
            let screen = UIView()
            screen.backgroundColor = UIColor.black
            screen.alpha = 0.3
            screen.frame = navigationController!.view.frame
            screen.tag = 33
            hideMenuGesture = UITapGestureRecognizer(target: self, action:  #selector(HomeVC.hideMenuHandler(_:)))
            screen.addGestureRecognizer(hideMenuGesture)
            navigationController!.view.addSubview(screen)
            
            let menu = MenuVC()
            navigationController?.addChild(menu)
            navigationController?.view.insertSubview(menu.view, at: 0)
            
            menu.delegate = self
            menu.view.frame = CGRect(x: 0, y: 0, width: view.frame.width*0.66, height: view.frame.height)
            
            let offset = self.view.frame.width*0.66
            UIView.animate(withDuration: 0.25, animations: {
                self.navigationController?.navigationBar.frame.origin.x = offset
                self.view.frame.origin.x = offset
                screen.frame.origin.x = offset
                }, completion: {_ in
                    self.navigationController!.view.bringSubviewToFront(menu.view)
            })
            
        }else{
            if let logo = UIApplication.shared.keyWindow?.viewWithTag(13){
                logo.alpha = 1
            }
            
            if let menu = navigationController?.children.last, let screen = navigationController?.view.viewWithTag(33){
                navigationController?.view.sendSubviewToBack(menu.view)
                UIView.animate(withDuration: 0.25, animations: {
                    self.navigationController?.navigationBar.frame.origin.x = 0
                    self.view.frame.origin.x = 0
                    menu.view.frame.origin.x = 0
                    screen.frame.origin.x = 0
                    screen.alpha = 0
                    }, completion: {_ in
                        
                        menu.removeFromParent()
                        menu.view.removeFromSuperview()
                        screen.removeGestureRecognizer(self.hideMenuGesture)
                        screen.removeFromSuperview()
                })
                
            }
        }
    }
}
