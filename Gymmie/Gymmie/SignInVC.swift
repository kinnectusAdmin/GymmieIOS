////
////  SignInVC.swift
////  Gymmie
////
////  Created by Blake Rogers on 6/27/16.
////  Copyright © 2016 T3. All rights reserved.
////
//
import UIKit
//import FBSDKLoginKit
//import FBSDKCoreKit
//import FacebookLogin
//import FacebookCore
//import Firebase
//import FirebaseAuth

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkForStoredData()
        setKeyBoardNotification()
    }
    
    func checkForStoredData(){
        let defaults = UserDefaults.standard
            let keys = ["currentUser",FBPermissions.fbUser,"authCode","storedGymmiePassword","isFaceBookUser"]
        for key in keys{
            guard let data = defaults.object(forKey: key) else{
                print("no data for key \(key)")
                continue
            }
            print("found data for key \(key)")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViews()
        
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        if newUserFromResetVC{
           pressedNewUser(self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //setKeyboardGesture(false)
    }
    var validatingUser: Bool = false
    func setViews(){
        view.backgroundColor = gymmieOrange()
        view.add(views: backgroundImage)
        backgroundImage.constrainWithMultiplier(view: view , width: 1, height: 1)
        if validatingUser{
            signingInUser(completed: false)
            getFBUserData()
            return
        }
        view.add(views:signInFBButton,signInDialogue)
        signInFBButton.constrainInView(view: view , top: nil, left: 0, right: 0, bottom: nil)
        //signInFBButton.setBottomTo(con: view.bottom(), by: -100)
        signInFBButton.setYTo(con: view.y(), by: 50)
        signInFBButton.addTarget(self, action: #selector(SignInVC.pressedSignInFB(_:)), for: .touchUpInside)
        signInFBButton.setHeightTo(constant: 40)
        
        signInDialogue.constrainInView(view: view, top: nil, left: 0, right: 0, bottom: 0)
        signInDialogue.setTopTo(con: signInFBButton.bottom(), by: 0)
//        signUpButton.constrainInView(view: view , top: nil, left: 0, right: 0, bottom: nil)
//        signUpButton.setBottomTo(con: signInFBButton.top(), by: -8)
//        signUpButton.addTarget(self , action: #selector(SignInVC.pressedSignIn(_:)), for: .touchUpInside)
//        signUpButton.setHeightTo(constant: 40)
        
//        newUserButton.setRightTo(con: signInFBButton.right(), by: 0)
//        newUserButton.setBottomTo(con: signInFBButton.top(), by: -2)
//        newUserButton.addTarget(self , action: #selector(SignInVC.pressedNewUser(_:)), for: .touchUpInside)
        
//        forgotPasswordButton.setBottomTo(con: signInFBButton.top(), by: -2)
//        forgotPasswordButton.setLeftTo(con: signInFBButton.left(), by: 0)
//        forgotPasswordButton.addTarget(self , action: #selector(SignInVC.pressedForgotPassword(_:)), for: .touchUpInside)
        
//        containerCon = containerView.setHeightTo(constant: 60)
//        containerView.setXTo(con: view.x(), by: 0)
//        containerView.setLeftTo(con: signInFBButton.left(), by: 0)
//        containerView.setRightTo(con: signInFBButton.right(), by: 0)
//       keyboardOffsetCon = containerView.setBottomTo(con: newUserButton.top(), by: -2)
//        containerView.add(views: firstNameTF,lastNameTF,name_EmailSeparator, emailTF,email_GenderSeparator, maleGenderButton,femaleGenderButton,confirmPasswordTF,passwordTF,confirmPasswordSeparator)
        
//        firstNameTF.constrainInView(view: containerView , top: 0, left: 0, right: nil, bottom: nil)
//        firstNameTF.setRightTo(con: containerView.x(), by: 0)
//        firstNameTF.delegate = self
//        userNameCon = firstNameTF.setHeightTo(constant: 0)
        
//        lastNameTF.constrainInView(view: containerView , top: 0, left: nil, right: 0, bottom: nil)
//        lastNameTF.setLeftTo(con: containerView.x(), by: 0)
//        lastNameTF.heightAnchor.constraint(equalTo: firstNameTF.heightAnchor, multiplier: 1).isActive = true
//        lastNameTF.delegate = self
        
//        emailTF.setHeightTo(constant: 20)
//        emailTF.constrainInView(view: containerView , top: nil, left: 0, right: 0, bottom: nil)
//        emailTF.setTopTo(con: firstNameTF.bottom(), by: 4)
//        emailTF.delegate = self
        
//        name_EmailSeparator.constrainInView(view: containerView , top: nil, left: -10, right: 10, bottom: nil)
//        name_EmailSeparator.setHeightTo(constant: 1)
//        name_EmailSeparator.setTopTo(con:firstNameTF.bottom() , by: 0)
        
//        email_GenderSeparator.constrainInView(view: containerView , top: nil, left: -10, right: 10, bottom: nil)
//        email_GenderSeparator.setHeightTo(constant: 1)
//        email_GenderSeparator.setTopTo(con: emailTF.bottom(), by: 0)
        
//        maleGenderButton.setTopTo(con: emailTF.bottom(), by: 0)
//        maleGenderButton.setLeftTo(con: containerView.left(), by: 0)
//        maleGenderButton.setRightTo(con: containerView.x(), by: 0)
//        maleGenderButton.addTarget(self , action: #selector(SignInVC.selectedMaleGender(_:)), for: .touchUpInside)
//        genderCon = maleGenderButton.setHeightTo(constant: 0)
        
//        femaleGenderButton.setTopTo(con: emailTF.bottomAnchor, by:0)
//        femaleGenderButton.setRightTo(con: containerView.right(), by: 0)
//        femaleGenderButton.setLeftTo(con: containerView.x(), by: 0)
//        femaleGenderButton.addTarget(self , action: #selector(SignInVC.selectedFemaleGender(_:)), for: .touchUpInside)
//        femaleGenderButton.heightAnchor.constraint(equalTo: maleGenderButton.heightAnchor, multiplier: 1).isActive = true
//        
//        passwordTF.setHeightTo(constant: 20)
//        passwordTF.setTopTo(con: maleGenderButton.bottom(), by: 4)
//        passwordTF.constrainInView(view: containerView , top: nil, left: 0, right: 0, bottom: nil)
//        passwordTF.delegate = self
//        confirmPasswordSeparator.constrainInView(view: containerView , top: nil, left: -10, right: 10, bottom: nil)
//        confirmPasswordSeparator.setHeightTo(constant: 1)
//        confirmPasswordSeparator.setBottomTo(con: passwordTF.bottom(), by: 0)
//        
//        confirmPasswordTF.setTopTo(con: passwordTF.bottom(), by: 4)
//        confirmPasswordTF.constrainInView(view: containerView , top: nil, left: 0, right: 0, bottom: nil)
//        confirmPasswordTF.delegate = self
//        passwordCon = confirmPasswordTF.setHeightTo(constant: 0)
    }
    
    var activityIndicator = UIActivityIndicatorView()

    func signingInUser(completed: Bool){
        if activityIndicator.superview == nil{
            activityIndicator.frame = CGRect(origin: view.center, size: CGSize(width: 50, height: 50))
            activityIndicator.center = view.center
            view.addSubview(activityIndicator)
        }
        DispatchQueue.main.async {
        
        self.activityIndicator.alpha = completed ? 0 : 1
        if completed{
            self.activityIndicator.stopAnimating()
        }else{
            self.activityIndicator.startAnimating()
        }
        self.view.isUserInteractionEnabled =  completed ? true: false
        }
    }

    var firstName : String{
        return firstNameTF.text!
    }
    
    var lastName: String{
        return lastNameTF.text!
    }
    
    var email: String{
       return emailTF.text!
    }
    
    var password: String{
        return passwordTF.text!
    }
    
    var confirmPassword: String {
       return confirmPasswordTF.text!
    }
    
    var dismissKeyboardGesture: UITapGestureRecognizer?
    var newUserFromResetVC: Bool = false
    var newUserSignIn: Bool = false
    var userGender: String = ""
    
    let backgroundImage : UIImageView = {
        let iv = UIImageView()
            iv.image = #imageLiteral(resourceName: "gymmieSignIn")
            iv.contentMode = .scaleAspectFill
            iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let name_EmailSeparator: UIView = {
        let v = UIView()
            v.backgroundColor = createColor(220, green: 220, blue: 220)
            v.translatesAutoresizingMaskIntoConstraints = false
            v.clipsToBounds = true
            v.alpha = 0
        return v
    }()
    
    let email_GenderSeparator: UIView = {
        let v = UIView()
            v.backgroundColor = createColor(220, green: 220, blue: 220)
            v.clipsToBounds = true
            v.alpha = 0
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let confirmPasswordSeparator: UIView = {
        let v = UIView()
            v.backgroundColor = createColor(220, green: 220, blue: 220)
            v.translatesAutoresizingMaskIntoConstraints = false
            v.alpha = 0
            v.clipsToBounds = true
        return v
    }()

    let lastNameTF : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Last Name"
        field.textAlignment = .left
        field.clipsToBounds = true
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    
    let containerView: UIView = {
        let v = UIView()
            v.backgroundColor = UIColor.white
            v.clipsToBounds = true
            v.layer.cornerRadius = 8.0
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let firstNameTF : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "First Name"
        field.textAlignment = .left
        field.clipsToBounds = true
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    
    let emailTF : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Email"
        field.textAlignment = .left
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    
    let passwordTF : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Password"
        field.textAlignment = .left
        field.isSecureTextEntry = true
        //field.backgroundColor = UIColor.blue
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    
    let confirmPasswordTF : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Confirm Password"
        field.textAlignment = .left
        field.clipsToBounds = true
        field.isSecureTextEntry = true
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    
    let signInDialogue: UITextView = {
        let v = UITextView()
        v.textColor = UIColor.lightText
        v.textAlignment = .left
        let dialogue = "We don't post anything to Facebook. By signing in you agree to our Terms of Service and Privacy Policy."
        let rangeOfPolicy = NSString(string: dialogue).range(of: "Terms of Service and Privacy Policy.")
        let atts: [NSAttributedString.Key:Any] = [NSAttributedString.Key.underlineStyle: 1,NSAttributedString.Key.link:"https://www.gymmieapp.com/privacy-policy/"]
        var dialogueAttText = NSMutableAttributedString(string: dialogue , attributes: [.foregroundColor:UIColor.lightText])
            dialogueAttText.addAttributes(atts, range: rangeOfPolicy)
        v.attributedText = dialogueAttText
        v.backgroundColor = UIColor.clear
        v.alpha = 0.9
        v.isEditable = false 
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Sign In!", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .light),.foregroundColor: UIColor.white])
        let title2 = NSAttributedString(string: "Sign Up!", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .light),.foregroundColor: UIColor.white])
            button.setAttributedTitle(title, for: .normal)
            button.setAttributedTitle(title2, for: .selected)
            button.backgroundColor = UIColor.red
            button.layer.cornerRadius = 8.0
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signInFBButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Sign In With Facebook", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .light),.foregroundColor: UIColor.white])
            button.setAttributedTitle(title, for: .normal)
            button.backgroundColor = createColor(59, green: 89, blue: 152)
            button.layer.cornerRadius = 8.0
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forgotPasswordButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Forgot Password?", attributes: [.font: UIFont.systemFont(ofSize: 10, weight: .light),.foregroundColor: UIColor.white])
            button.setAttributedTitle(title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let newUserButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "New User? Sign Up Here!", attributes: [.font: UIFont.systemFont(ofSize: 10, weight: .light),.foregroundColor: UIColor.white])
        let title2 = NSAttributedString(string: "Go Back", attributes: [.font: UIFont.systemFont(ofSize: 10, weight: .light),.foregroundColor: UIColor.white])
            button.setAttributedTitle(title, for: .normal)
            button.setAttributedTitle(title2 , for: .selected)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let maleGenderButton : UIButton = {
        let button = UIButton()
            button.setTitle("Male", for: .normal)
            button.setTitleColor(gymmieOrange(), for: .normal)
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let femaleGenderButton : UIButton = {
        let button = UIButton()
        
            button.setTitle("Female", for: .normal)
            button.clipsToBounds = true
            button.setTitleColor(gymmieOrange(), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var userNameCon = NSLayoutConstraint()
    var genderCon = NSLayoutConstraint()
    var passwordCon = NSLayoutConstraint()
    var containerCon = NSLayoutConstraint()
    let signInScreen: UIView = {
        let v = UIView()
            v.backgroundColor = UIColor.lightGray
            v.alpha = 0
        return v
    }()

    var keyboardOffsetCon = NSLayoutConstraint()
    
    
    func showScreen(){
        signInScreen.frame = view.bounds
        view.insertSubview(signInScreen, belowSubview: containerView)
            UIView.animate(withDuration: 0.25, animations: {
                self.signInScreen.alpha = 0.5
            })
    }
    
    func removeScreen(){
        UIView.animate(withDuration: 0.5, animations: {
            self.signInScreen.alpha = 0
            }, completion: {_ in
                self.signInScreen.removeFromSuperview()
        })
    }
    
    func handleSignUp(show: Bool){
            newUserButton.isSelected = show
            signUpButton.isSelected = show
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: [], animations: {
            self.name_EmailSeparator.alpha = show ? 1 : 0
            self.email_GenderSeparator.alpha = show ? 1 : 0
            self.confirmPasswordSeparator.alpha = show ? 1 : 0
            self.containerCon.constant = show ? 130 : 60
            self.genderCon.constant = show ? 25 : 0
            self.userNameCon.constant =  show ? 18 : 0
            self.passwordCon.constant = show ? 18 : 0
            self.forgotPasswordButton.alpha = show ? 0 : 1
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    func removeCurrentAuth(){
        let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "authCode")
    }
    
    func pressedSignIn(_ sender: UIButton){
        if email.isEmpty || password.isEmpty{
               alert(title: "Umm..", message: "Think you're missing a step buddy.")
            return
        }
        
        if newUserSignIn{
            if firstName.contains(" ") || lastName.contains(" "){
                alert(title: "Oops", message: "Umm, you're name's got a space. We don't like spaces...")
                return
            }
            //perform sign up for new user
            if password == confirmPassword{
            signingInUser(completed: false)
            let database = AppDatabase()
            database.signUpDelegate = self
                database.createUserWithCredentails(firstName: firstName,lastName: lastName, email: email, password: password,gender:userGender)
            }else{
                alert(title: "Ugh Oooh!", message: "Passwords do not match!")
            }
        }else{
            signingInUser(completed: false)
           //perform sign in for returning user
                let database = AppDatabase()
                database.signUpDelegate = self
                let returningUser = GymmieUser()
                    returningUser.email = email
                    returningUser.password = password
                database.authenticate(returningUser)
        }
    }

    
    func getFBUserData(){
//        let fbController = FBController(delegate: self)
//        signingInUser(completed: false)
//            fbController.getUser()
    }
    
    func selectedMaleGender( _ sender: UIButton){
            userGender = "Male"
            sender.isSelected = !sender.isSelected
            sender.backgroundColor = gymmieOrange().withAlphaComponent(0.8)
            sender.setTitleColor(UIColor.white , for: .normal)
            femaleGenderButton.backgroundColor = UIColor.white
            femaleGenderButton.setTitleColor(gymmieOrange(), for: .normal)
            femaleGenderButton.isSelected = false
    }
    
    func selectedFemaleGender(_ sender: UIButton){
            userGender = "Female"
            sender.backgroundColor = gymmieOrange().withAlphaComponent(0.8)
            sender.setTitleColor(UIColor.white, for: .normal)
            maleGenderButton.backgroundColor = UIColor.white
            maleGenderButton.setTitleColor(gymmieOrange(), for: .normal)
    }
    
    func pressedNewUser(_ sender: AnyObject){
        newUserSignIn = !newUserSignIn
        handleSignUp(show: newUserSignIn)
    }
    
    @objc func pressedSignInFB(_ sender: UIButton){
         //removeCurrentAuth()
        print("started signing in with fb")
//        DispatchQueue.main.async(execute: {
//            let loginManager = LoginManager()
//            loginManager.logOut()
//
//            loginManager.logIn(readPermissions: [.email,.publicProfile], viewController: self , completion: {
//                result in
//                switch result{
//                case .failed(let error):
//                    print(error.localizedDescription)
//                    self.alert(title:"Ugh....oh!", message: "Something went wrong with sign up, try again.")
//                case .cancelled:
//                    self.signingInUser(completed: true)
//                case .success(grantedPermissions: let granted, declinedPermissions: let declined , token: let token):
//                    print(FBSDKAccessToken.current().appID)
//                    print(granted)
//                    print(declined)
//                    self.getFBUserData()
//                }
//
//            })
//        })
//
//
        //manager.logIn(withReadPermissions: FBPermissions.gymmiePermissions, handler: fbLoginHandler)
    }
    
    func pressedForgotPassword(_ sender: UIButton){
//        let resetVC = ResetPasswordVC()
//            present(resetVC , animated: true , completion: nil)
    }
 
    func toHomeHandler(_ action: UIAlertAction!){
        let home = HomeVC()
        let homeNav = UINavigationController(rootViewController: home)
        if let window = UIApplication.shared.keyWindow{
            window.rootViewController = homeNav
            window.makeKeyAndVisible()
        }
    }

}

extension SignInVC: DatabaseSignUpDelegate{
   
    func unauthorizedSignUp(){
        signingInUser(completed: true)
        alert(title: "Sign In Error", message: "There seems to have been an error with your sign Up")
    }
    
    func fbUserSignInSucceeded(){
        if UserDefaults.standard.bool(forKey: "viewedPrimer"){
            OperationQueue.main.addOperation({
                let home = HomeVC()
                let homeNav = UINavigationController(rootViewController: home)
                if let window = UIApplication.shared.keyWindow{
                    window.rootViewController = homeNav
                    window.makeKeyAndVisible()
                }
            })
        }else{
            showPushPrimer()
        }
       
        
    }
    
    func userSignInSucceeded(){
        
        OperationQueue.main.addOperation({
            let home = HomeVC()
            let homeNav = UINavigationController(rootViewController: home)
            if let window = UIApplication.shared.keyWindow{
                window.rootViewController = homeNav
                window.makeKeyAndVisible()
            }
        })
        
    }
    func fbUserSignUpSucceeded(){
        if UserDefaults.standard.bool(forKey: "viewedPrimer"){
            OperationQueue.main.addOperation({
                let home = HomeVC()
                let homeNav = UINavigationController(rootViewController: home)
                if let window = UIApplication.shared.keyWindow{
                    window.rootViewController = homeNav
                    window.makeKeyAndVisible()
                }
            })
        }else{
            showPushPrimer()
        }
       
        
    }
      func userSignUpSucceeded(){

       // alert("Welcome", message: "Welcome to Gymmie \(user.name!)")
       
        OperationQueue.main.addOperation({
            let onboard = OnboardVC()
             self.present(onboard , animated: true, completion: nil)
        })
       
        
    }
    func connectionFailed(){
        alert(title:"Doh", message: "Your connection failed")
        signingInUser(completed: true)
    }
    func failedToGetData() {
        
    }
   
}


extension SignInVC: UITextFieldDelegate{
   
    func moveSignIn(byOffset offSet: CGFloat,withDuration duration: Double){
        let signInY = containerView.frame.maxY
        if offSet < signInY{
            let difference = offSet-signInY
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
                self.keyboardOffsetCon.constant = -offSet
                self.view.layoutIfNeeded()
                }, completion: nil)
            return
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
            self.keyboardOffsetCon.constant = offSet
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @objc func dismissKeyboard(_ gesture: UITapGestureRecognizer){
        if emailTF.isFirstResponder{
            emailTF.resignFirstResponder()
        }else if passwordTF.isFirstResponder{
            passwordTF.resignFirstResponder()
        }else if confirmPasswordTF.isFirstResponder{
            confirmPasswordTF.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case emailTF:
            //emailTF.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        case passwordTF:
            
            if newUserSignIn{
            confirmPasswordTF.becomeFirstResponder()
            }else{
                passwordTF.resignFirstResponder()
            }
        case confirmPasswordTF:
            confirmPasswordTF.resignFirstResponder()
        default:
            break
        }
        return true
    }

    @objc func keyBoardWillShow(_ notification: Foundation.Notification){
        setKeyboardGesture(true)
        showScreen()
    let keyBoardEndRect = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let endY = keyBoardEndRect.origin.y
        print(endY)
        let signInY = containerView.frame.maxY
    let durationNumber = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let duration = Double(durationNumber)
    //if the containers bottom is going to be lower than the top origin of the keyboard frame
    if signInY > endY{
        //find out how much higher
        let offSet = signInY - endY
        // make the keyboardOffset constant equal the offset +-
        moveSignIn(byOffset: offSet+20, withDuration: duration)
    }
        //let offSet = view.frame.height - height
    
    
    }
    
    func setKeyboardGesture(_ set: Bool){
        if set{
        if dismissKeyboardGesture == nil{
            dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(SignInVC.dismissKeyboard(_:)))
           signInScreen.addGestureRecognizer(dismissKeyboardGesture!)
        }
        }else{
            if dismissKeyboardGesture != nil{
                signInScreen.removeGestureRecognizer(dismissKeyboardGesture!)
                dismissKeyboardGesture = nil
            }
        }
    }
    
    @objc func keyBoardWillHide(_ notification: Foundation.Notification){
        setKeyboardGesture(false)
        removeScreen()
        let keyBoardEndRect = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = keyBoardEndRect.origin.y
        //print(y)
        let durationNumber = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let duration = Double(durationNumber)
        moveSignIn(byOffset: 16, withDuration: duration)
        }
    
    func setKeyBoardNotification(){
//        NotificationCenter.default.addObserver(self, selector: #selector(SignInVC.KeyBoardWillShow(_:)), name: NSNotification.Name.KeyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(SignInVC.KeyBoardWillHide(_:)), name: NSNotification.Name.KeyboardWillHideNotification, object: nil)
    }
}

extension SignInVC: FBControllerDelegate{
    
    func failedToFindUser(error: String){
        signingInUser(completed: true)
        alert(title: "Oops", message: error)
    }
    
    func foundCurrentUser(user: GymmieUser){
        let defaults = UserDefaults.standard
            defaults.set(user.email, forKey: "currentUser")
        
        let data = AppDatabase()
        data.signUpDelegate = self
        data.validate(user)
       
    }
    
    func foundNewUser(user: GymmieUser){
        let data = AppDatabase()
            data.signUpDelegate = self
            data.validate(user)
           // data.validateFBUserWithCredentials(email: user.email!, fbID: user.fbID!, firstName: user.firstName!, lastName: user.lastName!)
//        data.createFBUserWithCredentails(firstName: user.firstName!, lastName: user.lastName!, email: user.email, fbID:user.fbID!,fbURL:user.fbURL!,gender:user.gender!,image:user.imageURL ?? "")
        
    }
    
    func setSwitchFalse(){}
    func setSwitchTrue(){}
    func placeName(name:String){}
    func permissionRemoved(){}
    func postError(error: NSError){}
    func postSuccessful(){}
}
extension SignInVC{
    func showPushPrimer(){
        OperationQueue.main.addOperation {
            let primer = PushPrimer()
            self.present(primer , animated: true, completion: nil)
        }
      
      
    }
    
}
