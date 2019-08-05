//
//  ResetPasswordVC.swift
//  Gymmie
//
//  Created by Blake Rogers on 9/10/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setKeyBoardNotification()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var email: String{
        return emailField.text!
    }
    
    func setup(){
        view.add(views: backgroundImage,screenView,emailField,newPasswordField,confirmPasswordField,backButton,resetButton)
        backgroundImage.constrainWithMultiplier(view: view , width: 1, height: 1)
        
        resetButton.setBottomTo(con: view.bottom(), by: -100)
        resetButton.setXTo(con: view.x(), by: 0)
        resetButton.addTarget(self , action: #selector(ResetPasswordVC.resetPassword(_:)), for: .touchUpInside)
        resetButton.setWidthTo(constant: 250)
        
        backButton.setBottomTo(con: resetButton.top(), by: -4)
        backButton.setRightTo(con: resetButton.right(), by: 0)
        backButton.addTarget(self , action: #selector(ResetPasswordVC.goBack(_:)), for: .touchUpInside)
        
        screenView.constrainWithMultiplier(view: view , width: 1, height: 1)
        emailField.setXTo(con: view.x(), by: 0)
        emailField.setWidthTo(constant: 250)
        keyboardOffsetCon = emailField.setBottomTo(con: backButton.top(), by: -4)
        
        newPasswordField.setTopTo(con: emailField.bottom(), by: 8)
        newPasswordField.setWidthTo(constant: 250)
        newPasswordField.setXTo(con: view.x(), by: 0)
        
        
        confirmPasswordField.setTopTo(con: newPasswordField.bottom(), by: 8)
        confirmPasswordField.setWidthTo(constant: 250)
        confirmPasswordField.setXTo(con: view.x(), by: 0)
        emailField.delegate = self
        newPasswordField.delegate = self
        confirmPasswordField.delegate = self
    }
    let screenView: UIView = {
        let v = UIView()
            v.alpha = 0
            v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let backgroundImage : UIImageView = {
        let iv = UIImageView()
            iv.image = #imageLiteral(resourceName: "gymmieSignIn")
            iv.contentMode = .scaleAspectFill
            iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let emailField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Email"
        field.textAlignment = .center
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    let newPasswordField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "New Password"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        field.textAlignment = .center
        field.alpha = 0
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    let confirmPasswordField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Confirm New Password"
        field.textAlignment = .center
        field.isSecureTextEntry = true
        field.borderStyle = .roundedRect
        field.alpha = 0
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    
    let backButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Back To Sign In", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: 0.0),NSForegroundColorAttributeName: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let resetButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Reset Password", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: 0.0),NSForegroundColorAttributeName: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = createColor(105, green: 156, blue: 252)
        button.layer.cornerRadius = 9.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var dismissKeyboardGesture: UITapGestureRecognizer?
    var keyboardOffsetCon = NSLayoutConstraint()
    
    var newPassword: String{
        return newPasswordField.text!
    }
    var confirmPassword: String{
        return confirmPasswordField.text!
    }
    func resetPassword(_ sender: UIButton){
        if email.isEmpty || newPassword.isEmpty{
            alert(title: "Ooops!", message: "Your Email and New Password can't be blank!")
            return
            if newPassword != confirmPassword{
                alert(title: "What a minute...", message: "Your passwords don't match.")
                return
            }
        }
        
        let data = Database()
       
        data.updatePassword(email: email, newPassword: newPassword , oldPassword: confirmPassword)
        alert(title: "Good to Go!", message: "Your password has been reset")
    }
    
    func goBack(_ sender: UIButton){
        dismiss(animated: true , completion: nil)
    }
    
}
extension ResetPasswordVC: UITextFieldDelegate{
    
    func moveSignIn(byOffset offSet: CGFloat,withDuration duration: Double){
      
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
            self.keyboardOffsetCon.constant = offSet
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func dismissKeyboard(_ gesture: UITapGestureRecognizer){
        if emailField.isFirstResponder{
            emailField.resignFirstResponder()
        }else if newPasswordField.isFirstResponder{
            newPasswordField.resignFirstResponder()
        }else if confirmPasswordField.isFirstResponder{
            confirmPasswordField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func showScreen(){
        UIView.animate(withDuration: 0.25, animations: {
            self.screenView.alpha = 1.0
        })
    }
    func keyBoardWillShow(_ notification: Foundation.Notification){
        setKeyboardGesture(true)
        showScreen()
        let keyBoardEndRect = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let endY = keyBoardEndRect.origin.y
        print(endY)
        let signInY = backButton.frame.minY
        let durationNumber = (notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let duration = Double(durationNumber)
        //if the containers bottom is going to be lower than the top origin of the keyboard frame
        if signInY > endY{
            //find out how much higher
            let offSet = signInY - endY
            // make the keyboardOffset constant equal the offset +-
            moveSignIn(byOffset: -offSet - 85 , withDuration: duration)
        }
        //let offSet = view.frame.height - height
        UIView.animate(withDuration: duration , animations: {
            self.newPasswordField.alpha =  1.0
            self.confirmPasswordField.alpha = 1.0
        })
        
    }
    
    func setKeyboardGesture(_ set: Bool){
        if set{
            if dismissKeyboardGesture == nil{
                dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(SignInVC.dismissKeyboard(_:)))
                screenView.addGestureRecognizer(dismissKeyboardGesture!)
            }
        }else{
            if dismissKeyboardGesture != nil{
                screenView.removeGestureRecognizer(dismissKeyboardGesture!)
                dismissKeyboardGesture = nil
            }
        }
    }
    func removeScreen(){
        UIView.animate(withDuration: 0.25, animations: {
            self.screenView.alpha = 0
        })
    }
    func keyBoardWillHide(_ notification: Foundation.Notification){
        setKeyboardGesture(false)
        removeScreen()
        let durationNumber = (notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let duration = Double(durationNumber)
        moveSignIn(byOffset:-75, withDuration: duration)
//        UIView.animate(withDuration: duration , animations: {
//            self.newPasswordField.alpha =  0
//            self.confirmPasswordField.alpha = 0
//        })
    }
    
    func setKeyBoardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(SignInVC.keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignInVC.keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}



