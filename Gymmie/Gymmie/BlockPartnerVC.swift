//
//  BlockPartnerVC.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/20/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit

class BlockPartnerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
          setViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    func setViews(){
        view.backgroundColor = UIColor(white: 0.2, alpha: 0.6)
        view.addSubview(blockView)
        blockView.delegate = self
        
        blockHeightCon = blockView.setHeightTo(constant: 120)
        blockView.setWidthTo(constant: view.frame.width*0.7)
        blockView.setXTo(con: view.x(), by: 0)
        blockView.setYTo(con: view.y(), by: -50)
        
        
    }
    var blockHeightCon = NSLayoutConstraint()
    var blockView: BlockPartnerView = {
        let v = BlockPartnerView()
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
  

}
extension BlockPartnerVC: BlockPartnerDelegate{
    func cancelBlockUser(){
        blockView.removeFromSuperview()
        removeFromParent()
        view.removeFromSuperview()
      
    }
    
    func blockUser(){
        blockView.removeFromSuperview()
        removeFromParent()
        view.removeFromSuperview()
        alert(title: "Blocked User", message: "User will be blocked from your feed.")
        
    }
    
    func userIsBlocking(_ searching: Bool){
        blockHeightCon.constant += searching ? 45 : -45
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
