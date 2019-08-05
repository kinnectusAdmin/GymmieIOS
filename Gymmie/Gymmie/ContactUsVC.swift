//
//  ContactUsVC.swift
//  Gymmie
//
//  Created by Blake Rogers on 9/7/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
//        for item in tabBarController!.tabBar.items!{
//            item.enabled = false
//        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDismissGesture()
    }
    override func viewWillDisappear(_ animated: Bool) {
        setDismissGesture()
    }
    
    func setViews(){
        view.clipsToBounds = true
        view.backgroundColor = createColor(220, green: 220, blue: 220)
        view.add(views: contactLabel,subjectField, subjectLabel, messageLabel, messageView, sendButton)
        
        let topOffset = navigationController!.navigationBar.frame.height + 20
        contactLabel.constrainInView(view: view , top: topOffset, left: -20, right: 20, bottom: nil)
        contactLabel.setHeightTo(constant: 30)
        
        subjectField.setTopTo(con: contactLabel.bottom(), by: 50)
        subjectField.setRightTo(con: view.right(), by: -10)
        subjectField.setWidthTo(constant: view.frame.width*0.7)
        
        subjectLabel.setLeftTo(con: view.left(), by: 8)
        subjectLabel.setYTo(con: subjectField.y(), by: 0)
        subjectField.delegate = self
        
        messageView.setRightTo(con: subjectField.right(), by: 0)
        messageView.setTopTo(con: subjectField.bottom(), by: 8)
        messageView.setWidthTo(constant: view.frame.width*0.7)
        messageView.setHeightTo(constant: view.frame.height*0.33)
        messageView.delegate = self
        
        messageLabel.setLeftTo(con: view.left(), by: 8)
        messageLabel.setTopTo(con: messageView.top(), by: 0)
        
        sendButton.setWidthTo(constant: view.frame.width*0.5)
        sendButton.setTopTo(con: messageView.bottom(), by: 8)
        sendButton.setXTo(con: messageView.x(), by: 0)
        //sendButton.setHeightTo(constant: 30)
        sendButton.addTarget(self , action: #selector(ContactUsVC.sendMessage(_:)), for: .touchUpInside)
        
    }
 
    var subject: String{
        return subjectField.text!
    }
    
    var message: String{
        return messageView.text
    }
    
    @objc func dismissHandler(_ gesture: UITapGestureRecognizer){
        for sub in view.subviews{
            if sub.isFirstResponder{
                sub.resignFirstResponder()
                break
            }
        }
    }
    
    var dismissKeyboardGesture: UITapGestureRecognizer?
    
    func setDismissGesture(){
        if dismissKeyboardGesture == nil{
            dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(ContactUsVC.dismissHandler(_ :)))
            view.addGestureRecognizer(dismissKeyboardGesture!)
        }else{
            view.removeGestureRecognizer(dismissKeyboardGesture!)
            dismissKeyboardGesture == nil
        }
    }
    
    var contactLabel: UILabel = {
        let label = UILabel()
            label.text = "Contact Us"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.backgroundColor = createColor(252, green: 187, blue: 117)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var subjectLabel: UILabel = {
        let label = UILabel()
            label.text = "Subject:"
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    let subjectField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textAlignment = .center
        field.backgroundColor = createColor(200, green: 200, blue: 200)
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 12)
        return field
    }()
    var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.text = "Message:"
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
       
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    let messageView: UITextView = {
        let v = UITextView()
        v.textColor = UIColor.black
        v.textAlignment = .left
        v.backgroundColor = createColor(200, green: 200, blue: 200)
        v.layer.cornerRadius = 8.0
        v.font = UIFont.systemFont(ofSize: 12, weight: .light)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let sendButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Send", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = createColor(252, green: 187, blue: 117)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8.0
        return button
        }()
    
    @objc func sendMessage(_ sender: UIButton){
        messageView.text = ""
        subjectField.text = ""
    
       alert(title: "Thanks!", message: "Thank you for your feedback! We'll be in touch very soon...")
//        let data = Database()
    
    }
}

extension ContactUsVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case subjectField:
            subjectField.resignFirstResponder()
            messageView.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
}

extension ContactUsVC: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "\n"{
            textView.text = ""
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension ContactUsVC: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        for controller in navigationController!.viewControllers{
            
            if let tabBarController = controller as? UITabBarController{
                tabBarController.selectedIndex = item.tag
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
