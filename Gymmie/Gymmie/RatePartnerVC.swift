//
//  RatePartnerVC.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/7/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit

class RatePartnerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        setViews()
    }
    var userID: Int = 0
    let rateView = RatingView()
    func setViews(){
        rateView.delegate = self 
        view.addSubview(rateView)
         view.backgroundColor = UIColor(white: 0.2, alpha: 1)
        rateView.translatesAutoresizingMaskIntoConstraints = false
        rateView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 150).isActive = true
        rateView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        rateView.heightAnchor.constraint(equalToConstant: 225).isActive = true
        rateView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.8, constant: 0).isActive = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RatePartnerVC: RatingDelegate{

    func submitRating(rating: Int){
//        let data = AppDatabase()
//            data.submit(rating: rating , forUser: userID)
        if let appDel = UIApplication.shared.delegate as? AppDelegate{
            appDel.ratedUser(rated: true)
        }
        dismiss(animated: true , completion: nil)
    }
    func cancelRating(){
        dismiss(animated: true , completion: nil)
    }
}
