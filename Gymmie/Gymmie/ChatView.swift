//
//  ChatView.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/7/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
protocol MessageDelegate{
    func sendMessage( message: String)
    func sendImage()
    func resizeFor(height: CGFloat)
}
class ChatView: UIView {
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews() {
        setViews()
    }
    func dismissedKeyboard(){
        if chatTextView.isFirstResponder{
            chatTextView.resignFirstResponder()
        }
    }
    let getImageButton : UIButton = {
        let button = UIButton()
            button.tag = 10
            button.setImage(#imageLiteral(resourceName: "cameraButton"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let sendButton : UIButton = {
        let button = UIButton()
            button.tag = 11
        let title = NSAttributedString(string: "Send", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light),.foregroundColor: UIColor.darkGray])
        button.setAttributedTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let chatTextView: UITextView = {
        let v = UITextView()
        v.textColor = UIColor.black
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 8.0
        v.font = UIFont.systemFont(ofSize: 15, weight: .light)
        v.layer.borderColor = createColor(220, green: 220, blue: 220).cgColor
        v.layer.borderWidth = 1
        v.textAlignment = .left
        v.backgroundColor = UIColor.white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    var delegate: MessageDelegate?
    var message:  String{
        return chatTextView.text
    }
    func setViews(){
        backgroundColor = UIColor.white
        add(views: getImageButton,sendButton,chatTextView)
        
        getImageButton.constrainInView(view: self, top: 0, left: 4, right: nil, bottom: 0)
        getImageButton.addTarget(self , action: #selector(ChatView.sendHandler(_:)), for: .touchUpInside)
        chatTextView.constrainWithMultiplier(view: self, width: 0.7, height: 0.7)
        chatTextView.delegate = self
        sendButton.constrainInView(view: self, top: 0, left: nil, right: 0, bottom: 0)
        sendButton.setLeftTo(con: chatTextView.right(), by: 4)
        sendButton.addTarget(self , action: #selector(ChatView.sendHandler(_:)), for: .touchUpInside)
    
        
    }
    var chatHeight = CGFloat()
    @objc func sendHandler(_ sender: UIButton){
        if sender.tag == 10{
            delegate?.sendImage()
        }else{
            delegate?.sendMessage(message: message)
            chatTextView.text = ""
            delegate?.resizeFor(height: chatTextView.contentSize.height+10)
        }
        
        if chatTextView.isFirstResponder{
            chatTextView.resignFirstResponder()
        }
        
    }
}
extension ChatView: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let alltext = textView.text.appending(text)
        let textRect = alltext.rectForText(width: chatTextView.frame.width,textSize: 15)
        if textView.frame.height < textRect.height{
        delegate?.resizeFor(height: textRect.height)
        }
        return true
    }
}
