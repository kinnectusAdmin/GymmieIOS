//
//  WorkoutGeneratorVC.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/6/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
//import FBSDKCoreKit

class WorkoutGeneratorVC: UIViewController {

    override func viewDidLoad() {
        UIApplication.shared.statusBarStyle = .lightContent
        super.viewDidLoad()
        //setDummyGyms_Workouts()
        setViews()
        workoutDetailTV.delegate = self
        workoutDetailTV.dataSource = self
        workoutDetailTV.register(ExerciseDetailCell.self, forCellReuseIdentifier: "ExerciseDetailCell")
        workoutDetailTV.register(WorkoutDetailCell.self , forCellReuseIdentifier: "WorkoutDetailCell")
        workoutDetailTV.rowHeight = 40
        // Do any additional setup after loading the view.
        setKeyBoardNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var editingWorkout: Bool = false
    
    func addFadeGradient(){
        let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: 150)
            //gradient.bounds = view.bounds
            let colors = [ UIColor(white: 0.2, alpha: 1).cgColor,UIColor.clear.cgColor]
            gradient.colors = colors
            gradient.locations = [0.0,0.5]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 0, y: 1)
        view.layer.addSublayer(gradient)
    }
    let blur: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let v = UIVisualEffectView(effect: effect)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    func setViews(){
        setDismissGesture()
        //addExerciseView.delegate = self
        
        view.backgroundColor = UIColor.clear//UIColor(white: 0.2, alpha: 1)
        view.add(views:blur,workoutContainerView)
//        addExerciseView.translatesAutoresizingMaskIntoConstraints = false
//        addExerciseView.setWidthTo(constant: view.frame.width*0.9)
//        addExerciseView.setXTo(con: view.x(), by: 0)
//        exerciseYCon = addExerciseView.setYTo(con: view.y(), by: 0)
//        addExerciseView.heightAnchor.constraint(equalToConstant: 410).isActive = true
//        addExerciseView.alpha = 0.0

//        let count = workout.exercises.filter({$0.isEmpty == false}).count
//        let extra: CGFloat =  count > 0 ? count > 1 ? 80 : 40 : 0
//        let heightRatio = (346 + extra)/view.frame.height
        blur.constrainWithMultiplier(view: view , width: 1, height: 1)
        let heightRatio = 215/view.frame.height
        workoutContainerView.constrainWithMultiplier(view: view , width: 0.9, height: heightRatio)
        workoutContainerView.add(views:createLabel,workoutDetailTV,addExerciseButton,createButton,cancelButton)
        
        createLabel.constrainInView(view: workoutContainerView, top: -10, left: -10, right: 10, bottom: nil)
        createLabel.setHeightTo(constant: 50)
        
        createButton.constrainInView(view: workoutContainerView, top: nil, left: 0, right: nil, bottom: 0)
        createButton.setRightTo(con: workoutContainerView.x(), by: -4)
        createButton.addTarget(self , action: #selector(WorkoutGeneratorVC.pressedSubmitWorkout(_:)), for: .touchUpInside)
        
        cancelButton.constrainInView(view: workoutContainerView, top: nil, left: nil, right: 0, bottom: 0)
        cancelButton.setLeftTo(con: workoutContainerView.x(), by: 4)
        cancelButton.addTarget(self , action: #selector(WorkoutGeneratorVC.pressedCancelWorkout(_:)), for: .touchUpInside)
        
//        addExerciseButton.constrainInView(view: workoutContainerView, top: nil, left: 0, right: 0, bottom: nil)
//        addExerciseButton.setBottomTo(con: createButton.top(), by: -8)
//        addExerciseButton.addTarget(self , action: #selector(WorkoutGeneratorVC.pressedAddExercises(_:)), for: .touchUpInside)
        
        workoutDetailTV.setTopTo(con: createLabel.bottom(), by: 8)
        workoutDetailTV.constrainInView(view: workoutContainerView, top: nil, left: 0, right: 0, bottom: 0)
       // workoutDetailTV.setBottomTo(con: addExerciseButton.top(), by: -8)
    }
    
    lazy var tableGradient: UIView = {
        let v = UIView(frame: CGRect(x: self.workoutDetailTV.frame.origin.x, y: self.workoutDetailTV.frame.maxY-40, width: self.workoutDetailTV.frame.width , height: 40))
            v.backgroundColor = UIColor.clear
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: 0, y: 1.0)
        let colors: [CGColor] = [UIColor.white.withAlphaComponent(0.1).cgColor,UIColor.white.cgColor]
        let grad = CAGradientLayer()
            grad.bounds = self.workoutDetailTV.frame
            grad.frame = CGRect(x: 0, y: 0, width: v.frame.width, height: v.frame.height)
            grad.colors = colors
            grad.locations = [0.0,0.4]
            grad.startPoint = start
            grad.endPoint = end
        v.layer.addSublayer(grad)
        return v
    }()
    
    lazy var createLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = self.editingWorkout ? "Edit Your Workout".localizedUppercase : "Create A Workout".localizedUppercase
        label.textAlignment = .center
        label.backgroundColor = gymmieOrange()
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let workoutDetailTV:UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor.white
        tv.backgroundView = nil
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let addExerciseButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Add Exercises?".localizedUppercase, attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = gymmieOrange()
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var  weekdays: [String]{
        return ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    }
    lazy var createButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: self.editingWorkout ? "SAVE":"CREATE", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title , for: .normal)
        button.backgroundColor = gymmieOrange()
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "CANCEL", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = gymmieOrange()
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
 
   
    var workouts: [Workout]?{
        didSet{
            //print("got workouts")
            typePicker.reloadAllComponents()
        }
    }
    var workoutContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    var containerView = UIView()
    var workout = Event(){
        didSet{
            workoutDetailTV.reloadData()
        }
    }
    var addExerciseView = AddExerciseView()
    var option = "None"
    var setTimePicker = UIDatePicker()
    var typePicker = UIPickerView()
    var dayToWorkout = String()
    var exerciseYCon = NSLayoutConstraint()
    var dismissGesture: UITapGestureRecognizer?
    var dismissExerciseGesture: UITapGestureRecognizer?
    var offset: CGFloat = 0
    var gyms: [Gym]?
   
  
   
}
extension WorkoutGeneratorVC: AddExerciseDelegate{
    func cancelExercises(){
        UIView.animate(withDuration: 0.5, animations: {
            self.addExerciseView.alpha = 0.0
            //show tableview again
            self.workoutContainerView.alpha = 1
        })
         tableGradient.alpha = workout.exercises.count > 0 ? 1.0 : 0.0
    }
    
    func submitExercises(exercises: [String]) {
        cancelExercises()
        workout.exercises = exercises
        workoutDetailTV.reloadData()
        tableGradient.alpha = workout.exercises.count > 0 ? 1.0 : 0.0
    }
}

extension WorkoutGeneratorVC{
    func setDismissGesture(){
        if dismissGesture == nil{
            dismissGesture = UITapGestureRecognizer(target: self, action: #selector(WorkoutGeneratorVC.dismissKeyboard(_:)))
            blur.addGestureRecognizer(dismissGesture!)
            //addExerciseView.addGestureRecognizer(dismissGesture!)
        }else{
            blur.removeGestureRecognizer(dismissGesture!)
            //addExerciseView.removeGestureRecognizer(dismissGesture!)
            dismissGesture == nil
        }
    }
    func dismissKeyboard(){
        var notChangingName: Bool = true
        if let textCell = workoutDetailTV.cellForRow(at: IndexPath(row: 0, section: 0)) as? WorkoutDetailCell{
            if textCell.nameField.isFirstResponder{
                notChangingName = false
                textCell.nameField.resignFirstResponder()
            }
        }
        if notChangingName{
            cancel()
        }
//        if let fields = addExerciseView.subviews.filter({$0.isKind(of:UITextField.self)}) as? [UITextField]{
//            for field in fields{
//                if field.isFirstResponder{
//                    field.resignFirstResponder()
//                }
//            }
//        }
    }
    @objc func dismissKeyboard(_ gesture: UITapGestureRecognizer){
        dismissKeyboard()
    }
    
    func save() {
        if workout.workoutName.characters.count > 13{
            alert(title: "Whoaaa!", message: "Workout name too long, buddy.")
            return
        }
        if workout.workoutName.isEmpty{
            alert(title: "Whoaaa!", message: "What do you call YOUR workout?")
            return
        }
        //update workout in database 
        let data = AppDatabase()
            data.updateEvent(event: workout)
        if let matchNav = presentingViewController as? UINavigationController{
            if let  matchVC = matchNav.topViewController as? MatchProfileVC{
                    matchVC.workout = workout
                    matchVC.matchInfoCV.reloadData()
            }
        }
        
        cancel()
    }
    
    func cancel() {
        let title = UIApplication.shared.keyWindow?.viewWithTag(13)
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0
             title?.alpha = 1.0
            },completion:{_  in
                self.dismiss(animated: true , completion: nil)
                self.removeFromParent()
                self.view.removeFromSuperview()
                self.setDismissGesture()
                NotificationCenter.default.removeObserver(self)
                UIApplication.shared.statusBarStyle = .default
        })
       
    }
    
    func create(workout: Event) {
        if workout.workoutName.characters.count > 13{
            alert(title: "Whoaaa!", message: "Workout name too long, buddy")
            return
        }
        
        if workout.workoutName.isEmpty{
            alert(title: "Whoaaa!", message: "What do you call YOUR workout?")
            return
        }
        
        
        scheduleWorkout(workout: workout)
        if let appDel = UIApplication.shared.delegate as? AppDelegate{
//            appDel.createdWorkout(workout: workout)
        }
    }
    func scheduleWorkout(workout: Event){
        guard let id = GymmieUser.currentUser()?.userID else { return }
        let database = AppDatabase()
            database.workoutDelegate = self 
            database.scheduleEvent(event: workout , for: id)
        // add this workout to the scheduledWorkouts array
    }
    
   
    func toMatchesHandler(action: UIAlertAction!){
        let matchVC = MatchProfileVC()
            matchVC.workout = workout
        let homeVC = HomeVC()
        let nav = UINavigationController()
            nav.setViewControllers([homeVC,matchVC], animated: false)
        if let window = UIApplication.shared.keyWindow{
            setDismissGesture()
            NotificationCenter.default.removeObserver(self)
            if let title = window.viewWithTag(13){
                DispatchQueue.main.async(execute: {
                    UIView.animate(withDuration: 0.25, animations: {
                        window.bringSubviewToFront(title)
                        title.alpha = 1.0
                    })
                })
               
            }
            UIApplication.shared.statusBarStyle = .default
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }else{
            cancel()
        }
        
        
    }
    func makeSelection(for option: String){
        if self.option != "None" {
            return
        }
        self.option = option
        let doneButtonFrame = CGRect(x: view.frame.width*0.80, y: 10, width: view.frame.width*0.20, height: 30)
        
        let doneButton = UIButton(type: .custom)
            doneButton.frame = doneButtonFrame
        doneButton.setTitle("Done", for: UIControl.State())
        doneButton.setTitleColor(UIColor.darkGray, for: UIControl.State())
            doneButton.addTarget(self, action: #selector(WorkoutGeneratorVC.takeAction(_:)), for: .touchUpInside)
        let containerFrame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height*0.4)
        
        containerView = UIView(frame: containerFrame)
        containerView.layer.borderColor = UIColor.darkGray.cgColor
        containerView.layer.borderWidth = 1.0
        containerView.backgroundColor = createColor(204, green: 204, blue: 210)
        view.addSubview(containerView)
        
        
        let pickerFrame = CGRect(x: 0, y: -20, width: view.frame.width, height: view.frame.height*0.4)
        typePicker = UIPickerView()
        typePicker.frame = pickerFrame
        typePicker.backgroundColor = UIColor.clear
        typePicker.tintColor = UIColor.white
        typePicker.delegate = self
        typePicker.dataSource = self
        containerView.addSubview(typePicker)
        containerView.addSubview(doneButton)
        UIView.animate(withDuration: 0.5, animations: {
            self.containerView.frame.origin.y -= self.containerView.frame.height
        })
        
    }
    
    @objc func pressedCancelWorkout(_ sender:UIButton){
        cancel()
    }
    
   
    @objc func pressedSubmitWorkout(_ sender:UIButton){
        if workout.workoutName.isEmpty{
            if let workoutCell = workoutDetailTV.cellForRow(at: IndexPath(row: 0, section: 0)) as? WorkoutDetailCell{
                if workoutCell.nameField.isFirstResponder{
                    workoutCell.nameField.resignFirstResponder()
                }
                if let name = workoutCell.nameField.text{
                    workout.workoutName =  name.isEmpty ? "\(workout.dayOfWorkout) Workout" : name
                }
            }
        }
       
        if editingWorkout{

              sender.isEnabled = false
            save()
        }else{
              sender.isEnabled = false
            create(workout: workout)
        }
    }
    
    func pressedAddExercises(_ sender: UIButton){
        addExerciseView.exercises = workout.exercises
        UIView.animate(withDuration: 0.5, animations: {
            //hide the tableView some how
            self.workoutContainerView.alpha = 0
            self.addExerciseView.alpha = 1.0
        })
    }
}

extension WorkoutGeneratorVC: WorkoutGenDelegate{
   
    func editExercises() {
        addExerciseView.exercises = workout.exercises
        UIView.animate(withDuration: 0.5, animations: {
            //hide the tableView some how
            self.workoutContainerView.alpha = 0
            self.addExerciseView.alpha = 1.0
        })
    }
    func setDetail(detail: String) {
        makeSelection(for: detail)
    }
    func getWorkoutsAndGyms(){
        let data = AppDatabase()
        data.workoutDelegate = self
        data.getWorkouts()
        data.getLocations()
    }
    
    func setDummyGyms_Workouts(){
        let g1 = Gym(name : "ODU SRC",id:1)
        let g2 = Gym(name : "UV Fitness Center",id:2)
        let g3 = Gym(name: "Other", id: 3)
        gyms = [g1,g2,g3]
        
        workouts = Workout.workoutTypes.map({type -> Workout in
            let id = Int(Workout.workoutTypes.index(of: type)!)
            
            let workout = Workout(type: type, id: id+1)
            return workout
        })
    }

    @objc func takeAction(_ sender: UIButton){
        print("option is \(option)")
        switch option {
        case "setTime":
            dismissPicker()
        case "setWeekDay":
            dayToWorkout = "Day"
            dismissPicker()
        case "setLocation":
            dismissPicker()
        case "setWorkoutType":
            dismissPicker()
        default:
            dismissPicker()
        }
       option = "None"
    }
    
    func dismissPicker(){
            UIView.animate(withDuration: 0.5, animations: {
                self.containerView.frame.origin.y = self.view.frame.height
                }, completion: {_ in
//                    for view in containerView.subviews{
//                        view.removeFromSuperview()
//                    }
                    self.containerView.removeFromSuperview()
                    
            })
    }
}

extension WorkoutGeneratorVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch option {
        case "setTime":
            return 6
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch option {
        case "setLocation":
           return gyms!.count
        case "setWorkoutType":
            return workouts!.count
        case "setWeekday":
            return weekdays.count
        case "setTime":
            let count = [12,4,2,12,4,2]
            return count[component]
        default:
          return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let text = UILabel()
            text.textColor = UIColor.white
            text.textAlignment = .center
        let options : String = {
            switch option {
            case "setLocation":
                return gyms![row].name
            case "setWorkoutType":
                return workouts![row].type
            case "setWeekday":
                return weekdays[row]
            case "setTime":
                let hours = ["12","1","2","3","4","5","6","7","8","9","10","11"]
                let minutes = [":00",":15",":30",":45"]
                let noonNight = ["AM","PM"]
                let timeData = [hours,minutes,noonNight,hours,minutes,noonNight]
                return timeData[component][row]
            default:
                return "Not Set"
            }
        }()
        text.text = options
        
        return text
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
   
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch option {
        case "setLocation":
            let gym = gyms![row]
            workout.gym = gym
           
        case "setWorkoutType":
            let typeOfWorkout = workouts![row]
            workout.workout = typeOfWorkout
           
        case "setWeekday":
            
            workout.dayOfWorkout = weekdays[row]
        case "setTime":
            let hours = ["12","1","2","3","4","5","6","7","8","9","10","11"]
            let minutes = ["",":15",":30",":45"]
            let noonNight = ["AM","PM"]
            let fromHour = hours[pickerView.selectedRow(inComponent: 0)]
            let fromMinute = minutes[pickerView.selectedRow(inComponent: 1)]
            let fromDay = noonNight[pickerView.selectedRow(inComponent: 2)]
            let toHour = hours[pickerView.selectedRow(inComponent: 3)]
            let toMinute = minutes[pickerView.selectedRow(inComponent: 4)]
            let toDay = noonNight[pickerView.selectedRow(inComponent: 5)]
            let fromTime = "\(fromHour)\(fromMinute) \(fromDay)"
            let toTime = "\(toHour)\(toMinute) \(toDay)"
            workout.startHour = fromTime
            workout.endHour = toTime
        default:
            break
        }
        workoutDetailTV.reloadData()
    }
}
extension WorkoutGeneratorVC: DatabaseWorkoutDelegate{
    func fetchedInvites(invites: [Invite]) {}
    func createdWorkout(workout: Event) {
        
            self.workout = workout
            showAlert(style: .alert , alertTitle: "Good Job!", alertMessage: "You created a workout! Now find a Match!", actionTitles: ["Okay"], actions: [toMatchesHandler], completion: nil)
    }
    func gymCollection(gyms: [Gym]) {
        self.gyms = gyms
    }
    
    func fetchedPartnerWorkouts(workouts: [Event]){}
    
    func failedToGetData() {
        
    }
    
    func connectionFailed() {
        
    }
    
    func workoutCollection(workouts: [Workout]) {
        self.workouts = workouts
    }
    func workoutList(workouts: [Event]){
        
    }
    func fetchedUserWorkouts(workouts: [Event]) {}
    
}
extension WorkoutGeneratorVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let exercises = workout.exercises.filter({$0 != ""})
        return section == 0 ? 3 : exercises.count
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false 
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let textCell = workoutDetailTV.cellForRow(at: IndexPath(row: 0, section: 0)) as? WorkoutDetailCell{
            if textCell.nameField.isFirstResponder{
                textCell.nameField.resignFirstResponder()
            }
        }
    }
    
    func exerciseCell(at indexPath: IndexPath)->ExerciseDetailCell{
        let cell = workoutDetailTV.dequeueReusableCell(withIdentifier: "ExerciseDetailCell", for: indexPath) as! ExerciseDetailCell
        let exercises = workout.exercises.filter({$0 != ""})
        if !exercises.isEmpty{
            let exercise = exercises[indexPath.row]
            cell.number = indexPath.row
            cell.name = exercise
            cell.delegate = self
        }
        
        return cell
    }
    
    func workoutDetailCell(at indexPath: IndexPath)->WorkoutDetailCell{
        let cell = workoutDetailTV.dequeueReusableCell(withIdentifier: "WorkoutDetailCell", for: indexPath)  as! WorkoutDetailCell
       // let details = ["setName","setLocation","setWeekday","setTime","setWorkoutType"]
        let details = ["setName","setWeekday","setTime"]
        cell.workout = workout
        cell.detail = details[indexPath.row]
        cell.delegate = self
        cell.nameField.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            return workoutDetailCell(at: indexPath)
        case 1:
            return exerciseCell(at: indexPath)
        default:
            return UITableViewCell()
        }
    }
}

extension WorkoutGeneratorVC: UITextFieldDelegate{
    func moveChat(byOffset offSet: CGFloat,withDuration duration: Double){
        
    }
    
    func keyBoardWillShow(_ notification: Foundation.Notification){
        let keyBoardEndRect = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        offset = keyBoardEndRect.minY
        let durationNumber = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let duration = Double(durationNumber)
    }
    
    func keyBoardWillHide(_ notification: Foundation.Notification){
        let durationNumber = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let duration = Double(durationNumber)
        moveChat(byOffset: 0, withDuration: duration)
    }
    
    func setKeyBoardNotification(){
//        NotificationCenter.default.addObserver(self, selector: #selector(WorkoutGeneratorVC.keyBoardWillShow(_:)), name: NSNotification.Name.UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(WorkoutGeneratorVC.keyBoardWillHide(_:)), name: NSNotification.Name.UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if addExerciseView.alpha == 1.0{
            let fieldFrame = view.convert(textField.frame , to: view)
            if fieldFrame.maxY + fieldFrame.height > offset && offset > 0{
                
                exerciseYCon.constant = -abs((fieldFrame.maxY + fieldFrame.height*2) - offset)
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if addExerciseView.alpha == 1.0{
            exerciseYCon.constant = 0
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
        if workoutContainerView.alpha == 1.0{
            if let name = textField.text{
                workout.workoutName = name
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
    
}
extension WorkoutGeneratorVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset.y
//        print(offset)
//        let contentHeight = CGFloat(workout.exercises.count * 30)
//        print(contentHeight)
//        let alpha = offset <= 0 ? 1.0 : offset/contentHeight
//        print(alpha)
//        if workout.exercises.count > 0 {
//        tableGradient.alpha = alpha
//        }
    }
   
}
