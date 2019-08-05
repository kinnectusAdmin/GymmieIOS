//
//  EditDetailView.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/31/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
protocol EditDetailDelegate{
    func saveInfo(info: String)
}

class EditDetailView: UIView {

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
    
    func setViews(){
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        backgroundColor = UIColor.white
        add(views: detailLabel,detailTextView)
        detailLabel.constrainInView(view: self , top: -8, left: -10, right: 10, bottom: nil)
        detailLabel.setHeightTo(constant: 30)
        detailTextView.constrainInView(view: self , top: nil, left: -4, right: 10, bottom: 0)
        detailTextView.setTopTo(con: detailLabel.bottom(), by: -4)
        detailTextView.delegate = self 
    }
    
    var delegate: EditDetailDelegate?
    
    var detail = String(){
        didSet{
            detailLabel.text = detail
        }
    }
    
    var detailInfo = String(){
        didSet{
            detailTextView.text = detailInfo
        }
    }
    
    var detailLabel: UILabel = {
        let label = UILabel()
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18, weight: .light)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = gymmieOrange()
        return label
    }()
    let detailTextView: UITextView = {
        let v = UITextView()
            v.textColor = UIColor.darkGray
            v.textAlignment = .left
            v.backgroundColor = UIColor.clear
            v.translatesAutoresizingMaskIntoConstraints = false
            v.font = UIFont.gymmieProfileFont()
        return v
    }()
}
extension EditDetailView: UITextViewDelegate{
   
    func textViewDidEndEditing(_ textView: UITextView) {
        if let info = textView.text {
            delegate?.saveInfo(info: info)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        let textHeight = textView.text.rectForText(width:frame.width,textSize: 20).height - 40
        if frame.size.height < textHeight{
            UIView.animate(withDuration: 0.25, animations: {
                self.frame.size.height = textHeight
            })
        }
        return true
    }
}
