//
//  PrivacyVC.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/20/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//



import UIKit

class PrivacyVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        privacyTV.register(SettingsCell.self , forCellReuseIdentifier: "SettingsCell")
        privacyTV.delegate = self
        privacyTV.dataSource = self
        privacyTV.allowsMultipleSelection = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViews()
    }
    
    func setViews(){

        view.add(views: privacyTV)
        privacyTV.constrainInView(view: view, top: 0, left: -20, right: 20, bottom: 0)
    }
    var showingMenu: Bool = false
    lazy var menuGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self , action: #selector(PrivacyVC.hideMenuHandler(_:)))
    }()
    var hideMenuGesture = UITapGestureRecognizer()
    let privacyTV:UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor.white
        tv.backgroundView = nil
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var showMenOnly: Bool = false{
        didSet{
            if showMenOnly{showWomenOnly = false}
        }
    }
    var showWomenOnly: Bool = false{
        didSet{
            if showWomenOnly{ showMenOnly = false}
        }
    }
    var showAll: Bool = false{
        didSet{
            if showAll{
                showMenOnly = false
                showWomenOnly = false
            }
        }
    }
}

extension PrivacyVC{
    
    func blockUser(){
      let block = BlockPartnerVC()
          block.view.frame = navigationController!.view.bounds
        navigationController?.addChild(block)
        
        navigationController?.view.addSubview(block.view)
        navigationController?.view.bringSubviewToFront(block.view)
        
    }
    
    func reportUser(){
        let report = ReportPartnerVC()
            report.view.frame = navigationController!.view.bounds
        navigationController?.addChild(report)
        navigationController?.view.addSubview(report.view)
        navigationController?.view.bringSubviewToFront(report.view)
    }
}
extension PrivacyVC : UITableViewDelegate, UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let settingLabel: UILabel = {
            let label = UILabel()
            label.text = "Privacy Settings"
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18, weight: .light)
            label.backgroundColor = createColor(252, green: 187, blue: 117)
            return label
        }()
        return settingLabel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            let user = GymmieUser.currentUser()!
                user.womenOnly = !user.womenOnly
                user.updateCurrentUser(server: false)
            
        case 1:
             let user = GymmieUser.currentUser()!
                user.menOnly = !user.menOnly
                user.updateCurrentUser(server: false)
            
        case 2,3:
            tableView.deselectRow(at: indexPath , animated: false)
            indexPath.row == 2 ? blockUser() : reportUser()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row{
        case 0,1:
            if let user = GymmieUser.currentUser(){
                if row == 0{
                    user.womenOnly = false
                }
                if row == 1{
                    user.menOnly = false
                }
                user.updateCurrentUser(server: false)
            }
        default:
            break
        }
    }
    func settingCell(at indexPath: IndexPath)->SettingsCell{
        let cell = privacyTV.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        if let user = GymmieUser.currentUser(){
            if indexPath.row == 0 && user.womenOnly || indexPath.row == 1 && user.menOnly{
                privacyTV.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
            }
        }
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : createColor(210, green: 210, blue: 210)
        let setting = ["Match Only Women","Match Only Men"]
            cell.settingLabel.text = setting[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
            label.text = "Back To Menu"
            label.textAlignment = .center
            label.backgroundColor = createColor(252, green: 187, blue: 117)
            label.textColor = UIColor.black
            label.font = UIFont.systemFont(ofSize: 18, weight: .light)
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(menuGesture)
        return label
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0,1:
            return settingCell(at: indexPath)
        case 2:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "Block User"
            cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : createColor(210, green: 210, blue: 210)
            return cell
        case 3:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "Report User"
                cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : createColor(210, green: 210, blue: 210)
            return cell
        default: return UITableViewCell()
        }
    }
}
extension PrivacyVC: MenuDelegate{
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
       
        resetView()
        let privacy = PrivacyVC()
        let home = HomeVC()
        navigationController?.setViewControllers([home,privacy], animated: true)
    }
    
    
    
    func showContactUs(){
//        resetView()
//        let contact = ContactUsVC()
//        let home = HomeVC()
//        navigationController?.setViewControllers([home,contact], animated: true)
        
    }
    
    func showPrivacySettings(){
        show_hideMenu(show: false)
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
    
    @objc func hideMenuHandler( _ gesture: UITapGestureRecognizer){
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
