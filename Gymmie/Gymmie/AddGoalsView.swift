//
//  AddGoalsView.swift
//  Gymmie
//
//  Created by Blake Rogers on 1/14/17.
//  Copyright © 2017 kinnectus. All rights reserved.
//

import UIKit
protocol AddGoalsDelegate {
    func cancelGoals()
    func submitGoals(goals: [String])
    func goalTooLong()
}
class AddGoalsView: UIView {
   
    override func layoutSubviews() {
        setViews()
        goalsTV.delegate = self
        goalsTV.dataSource = self
        goalsTV.register(GoalsCell.self , forCellReuseIdentifier: "GoalsCell")
    }
    
    var delegate: AddGoalsDelegate?
    
    var createLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "Goals".localizedUppercase
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
   
    let goalsTV:UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor.white
        tv.backgroundView = nil
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var goals = [String]()
    
    func setViews(){
        add(views: createLabel,goalsTV,submitButton,cancelButton)
        backgroundColor = UIColor.white
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
        //constrainCreateLabel
        createLabel.constrainInView(view: self, top: -10, left: -20, right: 20, bottom: nil)
        createLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //constrain goalsTV
        goalsTV.constrainInView(view: self , top: nil, left: -10, right: 10, bottom: nil)
        goalsTV.setTopTo(con: createLabel.bottom(), by: 10)
        goalsTV.setBottomTo(con: submitButton.top(), by: 0)
        //constrain submit button
        submitButton.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor, constant: 0).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        submitButton.rightAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor, constant: -8).isActive = true
        submitButton.addTarget(self , action: #selector(AddGoalsView.submit(_:)), for: .touchUpInside)
        //constrain cancel Button
        cancelButton.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor, constant: 8).isActive = true
        cancelButton.addTarget(self , action: #selector(AddGoalsView.cancel(_:)), for: .touchUpInside)
     
    }
   
    @objc func cancel(_ sender: UIButton){
        delegate?.cancelGoals()
    }
    
    @objc func submit(_ sender: UIButton){
        if let cells = goalsTV.visibleCells as? [GoalsCell]{
            let goals = cells.map({$0.goalNameField.text}).filter({$0 != ""})
            delegate?.submitGoals(goals: goals as! [String])
        }
    }
}

extension AddGoalsView: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.characters.count > 25{
            textField.text = ""
            delegate?.goalTooLong()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddGoalsView : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalsCell", for: indexPath) as! GoalsCell
            let userGoals = goals + ["","","","","",""]
            cell.goalsLabel.text = "Goal \(indexPath.row + 1):"
            cell.goalNameField.text = userGoals[indexPath.row]
            cell.goalNameField.delegate = self
        return cell
    }
}
