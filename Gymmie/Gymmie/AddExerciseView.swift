//
//  AddExerciseView.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/6/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
protocol AddExerciseDelegate {
    func cancelExercises()
    func submitExercises(exercises: [String])
}
class AddExerciseView: UIView {

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

    
    var delegate: AddExerciseDelegate?
    var createLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "Create A Workout".localizedUppercase
        label.textAlignment = .center
        label.backgroundColor = gymmieOrange()
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    let submitButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "SUBMIT", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = gymmieOrange()
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let cancelButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "CANCEL", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .light),.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = gymmieOrange()
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var exercises = [String](){
        didSet{
            for (index,exercise) in exercises.enumerated(){
                for sub in subviews{
                    if let field = sub as? UITextField{
                        if field.tag == index{
                            field.text = exercise
                        }
                    }
                }
            }
        }
    }
    func addExerciseViews(at line: Int){
        let exerciseLabel = UILabel()
            exerciseLabel.text = "Exercise \(line+1):"
            exerciseLabel.textColor = UIColor.black
            exerciseLabel.textAlignment = .right
            exerciseLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
            exerciseLabel.adjustsFontSizeToFitWidth = true 
            exerciseLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let exerciseNameField = UITextField()
            exerciseNameField.translatesAutoresizingMaskIntoConstraints = false
            exerciseNameField.placeholder = "Exercise"
            exerciseNameField.tag = line
            exerciseNameField.adjustsFontSizeToFitWidth = true 
            exerciseNameField.backgroundColor = createColor(230, green: 230, blue: 230)
            exerciseNameField.textAlignment = .center
            exerciseNameField.font = UIFont.systemFont(ofSize: 18)
            exerciseNameField.layer.cornerRadius = 8.0
            //exerciseNameField.tag = line+10
            exerciseNameField.delegate = delegate as? WorkoutGeneratorVC
        
        let clearButton = UIButton()
            clearButton.setImage(#imageLiteral(resourceName: "xButton@75"), for: .normal)
            clearButton.tag = line
            clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        add(views: exerciseLabel,exerciseNameField,clearButton)
        
       //constrain label
        exerciseLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor, constant: 0).isActive = true
        exerciseLabel.topAnchor.constraint(equalTo: createLabel.bottomAnchor, constant: CGFloat(16+line*50)).isActive = true
        
        //constrain clear button
        clearButton.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
        clearButton.centerYAnchor.constraint(equalTo: exerciseLabel.centerYAnchor, constant: 0).isActive = true
        //clearButton.tag = line+10
        clearButton.addTarget(self , action: #selector(AddExerciseView.clear(_:)), for: .touchUpInside)
        //constrain name
        exerciseNameField.centerYAnchor.constraint(equalTo: exerciseLabel.centerYAnchor).isActive = true
        exerciseNameField.leftAnchor.constraint(equalTo: exerciseLabel.rightAnchor, constant: 8).isActive = true
        exerciseNameField.rightAnchor.constraint(equalTo: clearButton.leftAnchor, constant: -8).isActive = true
        exerciseNameField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setViews(){
        add(views: createLabel,submitButton,cancelButton)
        backgroundColor = UIColor.white
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
        //constrainCreateLabel
        createLabel.constrainInView(view: self, top: -10, left: -20, right: 20, bottom: nil)
        createLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //constrain submit button
        submitButton.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor, constant: 0).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        submitButton.rightAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor, constant: -8).isActive = true
        submitButton.addTarget(self , action: #selector(AddExerciseView.submit(_:)), for: .touchUpInside)
        //constrain cancel Button
        cancelButton.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor, constant: 8).isActive = true
        cancelButton.addTarget(self , action: #selector(AddExerciseView.cancel(_:)), for: .touchUpInside)
        for i in 0...5{
            addExerciseViews(at: i)
        }
   
    }
    @objc func clear(_ sender: UIButton){
        
        if let fields = subviews.filter({$0.isKind(of:UITextField.self)}) as? [UITextField]{
            for field in fields{
                if field.tag == sender.tag{
                    field.text = ""
                }
            }
        }

    }
    @objc func cancel(_ sender: UIButton){
        delegate?.cancelExercises()
    }
    @objc func submit(_ sender: UIButton){
       var workouts = [String]()
        for view in subviews{
            if let field = view as? UITextField{
                if !field.text!.isEmpty{
                workouts.append(field.text!)
                }
            }
        }
        delegate?.submitExercises(exercises: workouts)
    }
}


