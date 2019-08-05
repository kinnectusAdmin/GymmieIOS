//
//  MatchRatingCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/4/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit

class MatchRatingCell: UICollectionViewCell {

    override func layoutSubviews() {
        setViews()
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = gymmieOrange()
        label.backgroundColor = createColor(230, green: 230, blue: 230)
        label.textAlignment = .center
        label.text = "Partner Rating"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.layer.borderColor = createColor(210, green: 210, blue: 210).cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    func setRating(for rating: Double){
        let size = 50
        for i in 0...4{
                let placeInView = Int((contentView.frame.width - CGFloat(size*5))/2)
                let starView = UIView()
                let portion = Double(i+2)
                let difference = (portion - 1 - rating)/1
                let calculatedWidth =  Int((difference * 60 + 60))
                let frame = CGRect(x: placeInView + i*size, y: 8, width: portion <= rating ?  size : portion-1 > rating ? 0 : calculatedWidth, height: size)
                
            let backgrounds = [UIColor.yellow,UIColor.blue,UIColor.brown, UIColor.cyan,UIColor.green]
                starView.frame = frame
                starView.backgroundColor = gymmieOrange()
                
                contentView.addSubview(starView)
            let rect = CGSize(width: size-10, height: size-10)
            let starPath = UIBezierPath()
            let xTranslation1:CGFloat = 0.133
            let xTranslation2:CGFloat = 0.066
            let xTranslation3:CGFloat = 0.083

            let point1 = CGPoint(x: rect.width/2, y: 0)
            let point2 = point1.applying(CGAffineTransform(translationX: rect.width*xTranslation1, y:rect.height*0.33))
            let point3 = point2.applying(CGAffineTransform(translationX: rect.width/2-10, y: 0))
            let point4 = point2.applying(CGAffineTransform(translationX: rect.width*xTranslation2, y: rect.height*0.32))
            let point5 =  point3.applying(CGAffineTransform(translationX: -rect.width*xTranslation3, y: rect.height*0.63))
            let point6 =  point1.applying(CGAffineTransform(translationX: 0, y: rect.height*0.8))
            let point10 = point1.applying(CGAffineTransform(translationX: -rect.width*xTranslation1, y: rect.height*0.33))
            let point9 = point10.applying(CGAffineTransform(translationX: -rect.width/2+10, y: 0))
            let point8 = point10.applying(CGAffineTransform(translationX: -rect.width*xTranslation2, y: rect.height*0.32))
            let point7 = point9.applying(CGAffineTransform(translationX: rect.width*xTranslation3, y: rect.height*0.63))
            let points = [point2,point3,point4,point5,point6,point7,point8,point9,point10]
                starPath.move(to: point1)
                
                for point in points{
                    starPath.addLine(to: point)
                }
                
                starPath.close()
                
                starPath.lineWidth = 1
                starPath.stroke()
                
                let starLayer = CAShapeLayer()
                //starLayer.bounds = starView.layer.frame
                    starLayer.frame = CGRect(x: 5 , y: 5, width: 50, height: 50)
                    starLayer.fillColor = UIColor.orange.cgColor
                    starLayer.strokeColor = UIColor.blue.cgColor
                    starLayer.path = starPath.cgPath
                //starView.layer.addSublayer(starLayer)
                starView.layer.mask = starLayer
                let innerStar = CAShapeLayer()
                let innerPath = starPath
                    innerPath.apply(CGAffineTransform(scaleX: 0.99, y: 0.99))
                    innerStar.path = innerPath.cgPath
                    innerStar.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
                    innerStar.fillColor = UIColor.clear.cgColor
                    innerStar.strokeColor = UIColor.red.cgColor
                
                let coverView = UIView()
                    coverView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
                    coverView.backgroundColor = gymmieOrange()
                    coverView.layer.mask = innerStar
                starView.addSubview(coverView)
            }
    }
    func setViews(){
//        contentView.addSubview(titleLabel)
//        titleLabel.constrainInView(view: contentView, top: -10, left: -10, right: 10, bottom: nil)
//        titleLabel.setHeightTo(constant: 30)
    }
}
