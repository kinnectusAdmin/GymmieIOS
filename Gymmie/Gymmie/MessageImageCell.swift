//
//  MessageImageCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 10/3/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit

class MessageImageCell: UICollectionViewCell {
    
    
 override func layoutSubviews() {
    
    }
    var session: URLSession = {
        let config = URLSessionConfiguration.default
        let queue = OperationQueue.main
        let sessDefined = Foundation.URLSession.shared
        //sessDefined.delegate = self
        
        
        return sessDefined
    }()
    lazy var getImageHandler:(Data?,URLResponse?,Error?)->Void = {
        (data,response,error) in
        
        if error == nil{
            if let image = UIImage(data: data!){
                imageCache.setObject(image, forKey: response!.url!.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    self.messageImage.image = image
                }
            }
        }else{
            print(error?.localizedDescription)
        }
    }
    var imageURL: String?{
        didSet{
            print("did set Image")
            
            if let image = imageCache.object(forKey: imageURL! as AnyObject){
                DispatchQueue.main.async {
                     self.messageImage.image = image as UIImage
                }
               
            }else{
                let url = URL(string:imageURL!)
                var task = session.dataTask(with: url!, completionHandler: getImageHandler)
                task.resume()
            }
            
        }
    }
    let timeStamp: UILabel = {
        let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12, weight: .light)
            label.textAlignment = .center
            label.textColor = UIColor.lightGray
        return label
    }()
    
    let messageImage:  UIImageView = {
        let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
        //iv.backgroundColor = UIColor.brown
            iv.layer.cornerRadius = 8.0
            iv.layer.masksToBounds = true

        return iv
    }()
    var wasSent: Bool = false
    var wasReceived: Bool = false
    func setUpViews(){
        contentView.add(views: messageImage,timeStamp)
        
    }
}
