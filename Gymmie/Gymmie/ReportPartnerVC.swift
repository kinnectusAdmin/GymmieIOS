//
//  ReportPartnerVC.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/7/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit

class ReportPartnerVC: UIViewController {

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
    
    var userToReport: GymmieUser!
    let reportView = ReportPartnerView()
  
    func setViews(){
       
        view.addSubview(reportView)
        view.backgroundColor = UIColor(white: 0.2, alpha: 1)
     
        reportView.translatesAutoresizingMaskIntoConstraints = false
        reportView.setXTo(con: view.x(), by: 0)
        reportView.setYTo(con: view.y(), by: 0)
        let width = view.frame.width*0.8
        let height: CGFloat = 390
        reportView.setWidthTo(constant: width)
        reportHeightCon = reportView.setHeightTo(constant: height)
        
        reportView.delegate = self
    }
  
    var reportHeightCon = NSLayoutConstraint()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ReportPartnerVC: ReportDelegate{
    func userIsReporting(reporting: Bool) {
       reportHeightCon.constant += reporting ? 45 : -45
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func submitReport(report: String, other: String){
        reportView.removeFromSuperview()
        let data = AppDatabase()
//        if let currentUser = GymmieUser.currentUser(){
//           data.reportUser(user: currentUser , byUser: userToReport, with: report , and: other)
//        }
        removeFromParent()
        view.removeFromSuperview()
        dismiss(animated: true, completion: nil)
    }
    
    func cancelReport(){
        reportView.removeFromSuperview()
        removeFromParent()
        view.removeFromSuperview()
        dismiss(animated: true, completion: nil)
    }
}
