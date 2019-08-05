//
//  ChatDetailCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 8/27/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit

class ChatDetailCell: UICollectionViewCell{

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
    override func layoutSubviews() {
        setupViews()
    }

    
 static let receiveBubbleImage: UIImage = {
    let image = #imageLiteral(resourceName: "chatBubbleGrey").resizableImage(withCapInsets: UIEdgeInsets(top: 50, left: 25, bottom: 50, right: 25)).withRenderingMode(.alwaysTemplate)
        return image
    }()
    
 static let sendBubbleImage: UIImage = {
    let image = #imageLiteral(resourceName: "sendingGreyBubble").resizableImage(withCapInsets: UIEdgeInsets(top: 50, left: 25, bottom: 50, right: 25)).withRenderingMode(.alwaysTemplate)
       // let image = #imageLiteral(resourceName: "sendingGreyBubble")
        return image
    }()
    
    let bubbleImageView: UIImageView = {
        let iv = UIImageView()
            iv.image = ChatDetailCell.sendBubbleImage
            //iv.translatesAutoresizingMaskIntoConstraints = false
            iv.tintColor = createColor(210, green: 210, blue: 210)
            //iv.backgroundColor = UIColor.blue
            return iv
    }()
    
    let messageView: UITextView = {
        let tv = UITextView()
            tv.backgroundColor = UIColor.clear
            tv.textAlignment = .left
            tv.frame = CGRect(x: 0, y: 0, width: 250, height:50)
            tv.font = UIFont.systemFont(ofSize: 15)
            tv.textColor = UIColor.black
            tv.isUserInteractionEnabled = false
        
        return tv
    }()
  
    let timeStamp: UILabel = {
        let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12, weight: .light)
            label.textAlignment = .center
            label.textColor = UIColor.lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageBubble: UIView = {
        let view = UIView()
            view.layer.cornerRadius = 11
            view.clipsToBounds = false
        return view
    }()

    func setMessage(message: String, at time: Date,sent: Bool){
     
        timeStamp.text = MyCalendar.timeSinceEvent(onDate: time)
        messageView.text = message
        let height = messageView.contentSize.height
        let width = messageView.contentSize.width
        let estimateSize = message.rectForText(width: 300,textSize:16)
        let midWidth = (width+estimateSize.width)/2
        let midHeight = min(frame.height,(height + estimateSize.height)/2)
        let messageX:CGFloat = sent ? frame.width-midWidth-10 : 10
        let messageTextColor = sent ? UIColor.black : UIColor.white
        let messageBackground = sent ? createColor(210, green: 210, blue: 210) : gymmieOrange()
     
            messageView.frame = CGRect(x: messageX,y: 0, width: midWidth, height: midHeight)
            messageView.textColor = messageTextColor
        
        messageBubble.frame = messageView.frame.applying(CGAffineTransform.init(scaleX: 1, y: 1.05))
        messageBubble.backgroundColor = messageBackground
    
    }
    func setupViews(){
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        addSubview(messageView)
        insertSubview(messageBubble, belowSubview: messageView)
        
        addSubview(timeStamp)
        
        //Add constraints for timeStamp
        timeStamp.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -4).isActive = true
        timeStamp.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
    
        
    }
}

