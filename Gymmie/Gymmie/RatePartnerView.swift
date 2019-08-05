//
//  RatePartnerView.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/7/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
protocol RatePartnerDelegate {
    func showReport()
    func skip()
    func ratingSet()
}
class RatePartnerView: UIView {

    var partnerRating = 5
    var delegate: RatePartnerDelegate?
    var rateLabel: UILabel = {
        let label = UILabel()
            label.text = "RATE YOUR PARTNER?"
            label.textColor = gymmieOrange()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 30, weight: .light)
            label.adjustsFontSizeToFitWidth = true
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let profileBlurImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        let blur = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect:blur)
        
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        iv.addSubview(blurEffectView)
        
        blurEffectView.topAnchor.constraint(equalTo: iv.topAnchor, constant: 0).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: iv.bottomAnchor, constant: 20).isActive = true
        blurEffectView.leftAnchor.constraint(equalTo: iv.leftAnchor, constant: 0).isActive = true
        blurEffectView.rightAnchor.constraint(equalTo: iv.rightAnchor, constant: 0).isActive = true
        
        return iv
    }()
    
    var workout: Event?{
        didSet{
            
            detailLabel.text = workout?.workoutName//workout?.locationDetail
            scheduleLabel.text = workout?.scheduleDetail
        }
    }
    
    var match: GymmieUser? {
        didSet{
            let age = match?.age == nil ? "" :",\(match!.age!)"
            
            nameLabel.text = "\(match!.fullName)".appending(age)
            if let url = match?.imageURL{
                if url.isEmpty{
                    setDefaultImage()
                    return
                }
                photoURL = url
                
            }else{
               setDefaultImage()
                
            }
        }
    }
    func setDefaultImage(){
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 60
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 2
        profileImage.image = #imageLiteral(resourceName: "defaultImage2")
        profileBlurImage.image = #imageLiteral(resourceName: "defaultImage2")
    }
    var photoURL: String = ""{
        didSet{
            //https://unsplash.com/search/pretty?photo=ggJRxqOEaFY
            profileImage.loadImageWithURL(url: photoURL)
            profileImage.layer.masksToBounds = true
            profileImage.layer.cornerRadius = 60
            profileImage.layer.borderColor = UIColor.white.cgColor
            profileImage.layer.borderWidth = 2
            profileBlurImage.loadImageWithURL(url: photoURL)
        }
    }
    
    let profileImage : UIImageView = {
        let iv = UIImageView()
        //iv.backgroundColor = UIColor.red
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    var unmatching: Bool = false
    var detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let scheduleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let submitButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "SUBMIT A RATING", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = createColor(152, green: 202, blue: 72)
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let reportButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "REPORT PARTNER", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = createColor(240, green: 81, blue: 51)
          button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var skipButton : UIButton = {
        let button = UIButton()
        let skip_chat = self.unmatching ? "SKIP PARTNER RATING" : "BACK TO CHAT"
        let title = NSAttributedString(string: skip_chat, attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = gymmieOrange()
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func layoutSubviews() {
        setViews()
        
    }
    var skipGesture: UITapGestureRecognizer?
    @objc func skipHandler(_ gesture: UITapGestureRecognizer){
        if skipGesture != nil{
            profileBlurImage.removeGestureRecognizer(skipGesture!)
        }
        delegate?.skip()
    }
    @objc func ratingHandler(_ gesture: UITapGestureRecognizer){
        if let view = gesture.view?.superview{
            setRating(to: view.tag)
        }
    }
    let starHolder: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.clear
        return v
    }()

    func setStars(){
    
        for i in 1...5{
            let placeInView = Int((self.frame.width - 300)/2)
            let starView = UIView()
                starView.tag = i
            //let y =  rateLabel.frame.maxY + ((rateLabel.frame.maxY - submitButton.frame.minY) - 60 )/2
            let rateGesture = UITapGestureRecognizer(target: self , action: #selector(RatePartnerView.ratingHandler(_:)))
            let frame = CGRect(x: placeInView + (i-1)*60, y: 0, width: 60, height: 60)
                starView.frame = frame
                starView.backgroundColor = UIColor.white
            starHolder.addSubview(starView)
            
            //draw the star shape
            let rect = CGSize(width: 50, height: 50)
            let starPath = UIBezierPath()
            let point1 = CGPoint(x: rect.width/2, y: 0)
            let point2 = point1.applying(CGAffineTransform(translationX: 8, y:rect.height*0.33))
            let point3 = point2.applying(CGAffineTransform(translationX: rect.width/2-10, y: 0))
            let point4 = point2.applying(CGAffineTransform(translationX: 4, y: rect.height*0.32))
            let point5 =  point3.applying(CGAffineTransform(translationX: -5, y: rect.height*0.67))
            let point6 =  point1.applying(CGAffineTransform(translationX: 0, y: rect.height*0.8))
            let point10 = point1.applying(CGAffineTransform(translationX: -8, y: rect.height*0.33))
            let point9 = point10.applying(CGAffineTransform(translationX: -rect.width/2+10, y: 0))
            let point8 = point10.applying(CGAffineTransform(translationX: -4, y: rect.height*0.32))
            let point7 = point9.applying(CGAffineTransform(translationX: 5, y: rect.height*0.67))
            let points = [point2,point3,point4,point5,point6,point7,point8,point9,point10]
            starPath.move(to: point1)
            
            for point in points{
                starPath.addLine(to: point)
            }
            
            starPath.close()
            starPath.lineWidth = 1
            starPath.stroke()
            
            let starLayer = CAShapeLayer()
            //starLayer.bounds = starView.layer.frame
            starLayer.frame = CGRect(x: 5 , y: 5, width: 50, height: 50)
            starLayer.fillColor = UIColor.orange.cgColor
            starLayer.strokeColor = UIColor.blue.cgColor
            starLayer.path = starPath.cgPath
            //starView.layer.addSublayer(starLayer)
            starView.layer.mask = starLayer
            
            let innerStar = CAShapeLayer()
            let innerPath = starPath
            innerPath.apply(CGAffineTransform(scaleX: 0.99, y: 0.99))
            innerStar.path = innerPath.cgPath
            innerStar.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
            innerStar.fillColor = UIColor.clear.cgColor
            innerStar.strokeColor = UIColor.red.cgColor
            
            let coverView = UIView()
            coverView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            coverView.backgroundColor = gymmieOrange()
            coverView.layer.mask = innerStar
            
            coverView.addGestureRecognizer(rateGesture)
            starView.addSubview(coverView)
            
        }
    }
    func setRating(to rating: Int){
        partnerRating = rating
        for sub in starHolder.subviews{
            let tag = sub.tag
            if tag <= rating && tag > 0{
                print(tag)
                sub.backgroundColor = gymmieOrange()
                
            }else if tag != 0{
                sub.backgroundColor = UIColor.white
            }
        }
    }
    
    func setViews(){
        
        backgroundColor = UIColor.white
        add(views: profileBlurImage,profileImage,nameLabel,detailLabel,scheduleLabel,rateLabel,starHolder,submitButton,reportButton,skipButton)
        //constrain profileBlurImage
            profileBlurImage.constrainInView(view: self , top: 0, left: -10, right: 10, bottom: nil)
            profileBlurImage.setHeightTo(constant: frame.height*0.375)
        //constrain profileImage
       let offset = (frame.height*0.375 - 173)/2
            profileImage.setTopTo(con: profileBlurImage.top(), by: offset)
            profileImage.setXTo(con: x(), by: 0)
            profileImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //constrain namelabel
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 4).isActive = true
            nameLabel.setXTo(con: x(), by: 0)
        //constrain detailLabel
            detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
            detailLabel.setXTo(con: x(), by: 0)
        //constrain schedulelabel
            scheduleLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 0).isActive = true
            scheduleLabel.setXTo(con: x(), by: 0)
        
        rateLabel.constrainInView(view: self, top: nil, left: 0, right: 0, bottom: nil)
        rateLabel.setTopTo(con: profileBlurImage.bottom(), by: 8)
        starHolder.constrainInView(view: self , top: nil, left: 0, right: 0, bottom: nil)
        starHolder.setHeightTo(constant: 60)
        starHolder.setTopTo(con: rateLabel.bottom(), by: 0)
        
        setStars()
        //constrain skip button
        skipButton.constrainInView(view: self, top: nil, left: 20, right: -20, bottom: -40)
        skipButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        skipButton.addTarget(self , action: #selector(RatePartnerView.skipRating(_:)), for: .touchUpInside)
        //constrain  report Button
        reportButton.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -8).isActive = true
        reportButton.constrainInView(view: self, top: nil, left: 20, right: -20, bottom: nil)
        reportButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        reportButton.addTarget(self , action: #selector(RatePartnerView.showReport(_:)), for: .touchUpInside)
        //constrain submit button
        submitButton.bottomAnchor.constraint(equalTo: reportButton.topAnchor, constant: -8).isActive = true
        submitButton.constrainInView(view: self, top: nil, left: 20, right: -20, bottom: nil)
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.addTarget(self , action: #selector(RatePartnerView.submitRating(_:)), for: .touchUpInside)
        
        //set skipGesture on blur Image
        skipGesture = UITapGestureRecognizer(target: self , action: #selector(RatePartnerView.skipHandler(_:)))
    }
    
}

extension RatePartnerView{
    @objc func skipRating(_ sender: UIButton){
        removeFromSuperview()
        delegate?.skip()
    }
    @objc func showReport(_ sender: UIButton){
        removeFromSuperview()
        delegate?.showReport()
    }
    
    @objc func submitRating(_ sender: UIButton){
        if let appDel = UIApplication.shared.delegate as? AppDelegate{
//            appDel.ratedUser(rated: true)
        }
        
        let data = AppDatabase()
            data.submit(rating: partnerRating , forUser: match!.userID!)
        
        removeFromSuperview()
        delegate?.ratingSet()
        
        
    }
}
