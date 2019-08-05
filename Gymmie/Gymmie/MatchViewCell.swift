//
//  MatchViewCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/5/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
protocol MatchViewDelegate {
    func showMatch(image: UIImage)
}
class MatchViewCell: UICollectionViewCell {
    override func layoutSubviews() {
        setViews()
   
    }
    
    func setViews(){
        clipsToBounds = true
        contentView.add(views: profileBlurImage,profileImage,didSwipeRightImage,nameLabel,detailLabel,scheduleLabel)
        didSwipeRightImage.addSubview(swipedLabel)
        //constrain profileBlurImage
        profileBlurImage.constrainInView(view: self , top: -10, left: -10, right: 10, bottom: 10)
        //constrain profileImage
        profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        //profileImage.setYTo(con: contentView.y(), by: 0)
        profileImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: self.frame.width*0.35).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: self.frame.width*0.35).isActive = true
        let showGesture = UITapGestureRecognizer(target: self , action: #selector(MatchViewCell.showMatch(_:)))
            profileImage.addGestureRecognizer(showGesture)
        //constrain backButton
        //backButton.constrainInView(view: contentView , top: 10, left: 0, right: nil, bottom: nil)
    
        //constrain swipedRight Image
        didSwipeRightImage.setTopTo(con: profileImage.top(), by: 0)
        didSwipeRightImage.constrainInView(view: contentView, top: nil, left: nil, right: -10, bottom: nil)
        didSwipeRightImage.setHeightTo(constant: 50)
        didSwipeRightImage.setWidthTo(constant: 50)
       
        imageLoading.frame.origin.x = contentView.frame.size.width/2 - 20
        imageLoading.center.y = self.frame.height/2 - 40
        contentView.addSubview(imageLoading)
   
        //constrain swiped label
        swipedLabel.constrainInView(view: didSwipeRightImage, top: -10, left: -10, right: 10, bottom: 10)
        //constrain namelabel
        nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 4).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
      //constrain detailLabel
        detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        detailLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        //constrain schedulelabel
        scheduleLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 0).isActive = true
        scheduleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
    }
    let didSwipeRightImage : UIView = {
        let v = UIView()
        v.contentMode = .scaleAspectFit
        v.isHidden = true
        v.backgroundColor = createColor(152, green: 202, blue: 72)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.cornerRadius = 11.0
        return v
    }()
    let backButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "<", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var swipedLabel: UILabel = {
        let label = UILabel()
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.numberOfLines = 3
            label.isHidden = true
            label.translatesAutoresizingMaskIntoConstraints = false
        let atts: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 9, weight: .light)]
        let nsString = NSString(string: "THEY SWIPED RIGHT")
        let range = nsString.range(of: "THEY")
        let attString = NSMutableAttributedString(string: "THEY SWIPED RIGHT", attributes: atts)
            attString.addAttributes([.font:UIFont.systemFont(ofSize: 12, weight: .light)], range: range)
            label.attributedText = attString
        
        return label
    }()
    let profileBlurImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
    
        let blur = UIBlurEffect(style: .dark)
           
        let blurEffectView = UIVisualEffectView(effect:blur)
            blurEffectView.layer.opacity = 0.85
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
            //let detail = workout?.locationDetail == "@ Not Set" ? "@ ODU Student Rec Center" : workout?.locationDetail
            //detailLabel.text = workout?.workoutName ?? ""
            scheduleLabel.text = workout?.scheduleDetail
        }
    }
    
    var match: GymmieUser? {
        didSet{
            profileImage.image = nil
            profileBlurImage.image = nil
            swipedLabel.isHidden = match!.isAMatch == false
            didSwipeRightImage.isHidden = match!.isAMatch == false
            let age = match?.age == nil ? "" : ",\(match!.age!)"
            nameLabel.text = "\(match!.fullName)".appending(age)
            if let image = match?.image{
                profileImage.image = image
                profileBlurImage.image = image
                imageLoading.stopAnimating()
            }else if let url = match?.imageURL{
                if url.isEmpty{
                    profileImage.image = #imageLiteral(resourceName: "defaultImage2")
                    profileBlurImage.image = #imageLiteral(resourceName: "defaultImage2")
                }
               photoURL = url
            }else{
                profileImage.image = #imageLiteral(resourceName: "defaultImage2")
                profileBlurImage.image = #imageLiteral(resourceName: "defaultImage2")
                imageLoading.stopAnimating()
                
            }
            //didSwipeRightImage.alpha = (match?.isAMatch)! ? 1.0 : 0.0
        }
    }
    var matchViewDelegate: MatchViewDelegate?
    
    @objc func showMatch(_ gesture: UITapGestureRecognizer){
        if let image = profileImage.image{
            matchViewDelegate?.showMatch(image: image)
        }
    }
    let imageLoading : UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
            v.hidesWhenStopped = true
            v.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        return v
    }()
    var imageSessionTask: URLSessionDataTask?
    func session()-> URLSession{
        
        let sessDefined = Foundation.URLSession.shared
      
        return sessDefined
    }
    func getImageHandler(data: Data?,response: URLResponse?,error: Error?){
        
        if error == nil{
            if let dataImage = UIImage(data: data!){
                
                imageCache.setObject(dataImage, forKey: response!.url!.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    self.profileImage.image = dataImage
                    self.profileBlurImage.image = dataImage
                    self.imageLoading.stopAnimating()
                    }
                }
            }else{
                print(error?.localizedDescription)
            }
    }
    var photoURL: String = ""{
        didSet{
            if match?.image == nil {imageLoading.startAnimating()};
            if let image = imageCache.object(forKey: photoURL as AnyObject){
                DispatchQueue.main.async {
                    self.profileImage.image = image as UIImage
                    self.profileBlurImage.image = image as UIImage
                    self.imageLoading.stopAnimating()
                }
         
            }else{
                DispatchQueue.global().async(execute: {
                    let url = URL(string:self.photoURL)
                    if url != nil{
                        
                        
                        self.imageSessionTask = self.session().dataTask(with: url!, completionHandler: self.getImageHandler)
                        self.imageSessionTask?.resume()
                    }
                })
                
            }
        }
    }
    
    lazy var profileImage : UIImageView = {
        let iv = UIImageView()
            iv.layer.masksToBounds = true
            iv.layer.cornerRadius = (self.frame.width*0.35)/2
            iv.layer.borderColor = UIColor.white.cgColor
            iv.layer.borderWidth = 2
         iv.isUserInteractionEnabled = true
        //iv.backgroundColor = UIColor.red
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let scheduleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
