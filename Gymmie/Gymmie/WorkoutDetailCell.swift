//
//  WorkoutDetailCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 2/7/17.
//  Copyright © 2017 kinnectus. All rights reserved.
//

import UIKit
class WorkoutDetailCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        setViews()
    }
    var delegate: WorkoutGenDelegate?
    var detail = String(){
        didSet{
            detailButton.alpha = detail == "setName" ? 0 : 1
            switch detail{
                case "setName":
                  detailLabel.text = "Type:"
             
                case "setLocation":
                  detailLabel.text = "Location:"
                  
                   detailButton.setAttributedTitle(attributedTitle(with: workout?.gym.name ?? "SRC"), for: .normal)
                case "setWeekday":
                  detailLabel.text = "Day:"
                  let day = workout == nil ?  MyCalendar.weekday(forDate: Date()) : workout!.dayOfWorkout
                   detailButton.setAttributedTitle(attributedTitle(with: day), for: .normal)
                case "setTime":
                  detailLabel.text = "Availability:"
                 
                  let workoutTime = workout == nil ? "Select a Time" : "\(workout!.startHour)-\(workout! .endHour)"
                    detailButton.setAttributedTitle(attributedTitle(with: workoutTime ), for: .normal)
                case "setWorkoutType":
                  detailLabel.text = "Type:"
                  
                detailButton.setAttributedTitle(attributedTitle(with: workout?.workout.type ?? "Cardio"), for: .normal)
            default: break
            }
        }
    }
    var workout: Event?{
        didSet{
            nameField.text = workout?.workoutName
        }
    }
    func attributedTitle(with title: String)->NSAttributedString{
        let title = NSAttributedString(string: title , attributes: [.font: UIFont.systemFont(ofSize: 15),.foregroundColor: UIColor.black])
        return title
    }
    let nameField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = ""
        field.text = ""
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    
    var name = String(){
        didSet{
            let title = NSAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 15),.foregroundColor: UIColor.black])
            detailButton.setAttributedTitle(title , for: .normal)
        }
    }
    
    var detailLabel: UILabel = {
        let label = UILabel()
            label.textColor = UIColor.black
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 15, weight: .light)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "", attributes: [.font: UIFont.systemFont(ofSize: 18),.foregroundColor: UIColor.black])
            button.setAttributedTitle(title, for: .normal)
            button.backgroundColor = createColor(230, green: 230, blue: 230)
            button.layer.cornerRadius = 8.0
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func handleDetail(_ sender: UIButton){
        if let generatorVC = delegate as? WorkoutGeneratorVC{
            if let textCell = generatorVC.workoutDetailTV.cellForRow(at: IndexPath(row: 0, section: 0)) as? WorkoutDetailCell{
                if textCell.nameField.isFirstResponder{
                    textCell.nameField.resignFirstResponder()
                }
            }
        }
        delegate?.setDetail(detail: detail)
    }
    func setViews(){
        contentView.add(views: nameField,detailButton)
        contentView.addSubview(detailLabel)
        //constrain detail label
        detailLabel.constrainInView(view: contentView, top: 0, left: 0, right: nil, bottom: 0)
        detailLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
        //constrain nameField
        nameField.centerYAnchor.constraint(equalTo: detailLabel.centerYAnchor).isActive = true
        nameField.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        nameField.leftAnchor.constraint(equalTo: detailLabel.rightAnchor, constant: 8).isActive = true
        //constrain detailName Field
        detailButton.centerYAnchor.constraint(equalTo: detailLabel.centerYAnchor).isActive = true
        detailButton.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        detailButton.leftAnchor.constraint(equalTo: detailLabel.rightAnchor, constant: 8).isActive = true
        detailButton.addTarget(self , action: #selector(WorkoutDetailCell.handleDetail(_:)), for: .touchUpInside)
    }
}

