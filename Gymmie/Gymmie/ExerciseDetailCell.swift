//
//  ExerciseDetailCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/6/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//
protocol WorkoutGenDelegate{
    func editExercises()
    func setDetail(detail: String)
}
import UIKit

class ExerciseDetailCell: UITableViewCell {

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
    var number = Int(){
        didSet{
            exerciseLabel.text = "Exercise \(number+1):"
        }
    }
    var delegate: WorkoutGenDelegate?
    var name = String(){
        didSet{
            let title = NSAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 15),.foregroundColor: UIColor.black])
            exerciseButton.setAttributedTitle(title , for: .normal)
        }
    }
    var exerciseLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let exerciseButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "", attributes: [.font: UIFont.systemFont(ofSize: 18),.foregroundColor: UIColor.black])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = createColor(230, green: 230, blue: 230)
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func handleEdit(_ sender: UIButton){
        delegate?.editExercises()
    }
    func setViews(){
        contentView.addSubview(exerciseButton)
        contentView.addSubview(exerciseLabel)
        //constrain exercise label
        exerciseLabel.constrainInView(view: contentView, top: 0, left: 0, right: nil, bottom: 0)
        exerciseLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
        //constrain exerciseName Field 
        exerciseButton.centerYAnchor.constraint(equalTo: exerciseLabel.centerYAnchor).isActive = true
        exerciseButton.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true 
        exerciseButton.leftAnchor.constraint(equalTo: exerciseLabel.rightAnchor, constant: 8).isActive = true
        exerciseButton.addTarget(self , action: #selector(ExerciseDetailCell.handleEdit(_:)), for: .touchUpInside)
        
    }
}
