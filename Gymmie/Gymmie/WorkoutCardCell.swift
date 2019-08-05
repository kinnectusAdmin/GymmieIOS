//
//  WorkoutCardCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 12/1/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit

class WorkoutCardCell: UICollectionViewCell {
 
   
    var event: Event?{
        didSet{
            if event?.isMatched ?? false{
                matchedCardView.workout = event
                contentView.addSubview(matchedCardView)
                matchedCardView.constrainWithMultiplier(view: contentView, width: 0.8, height: 1)
            }else{
                unmatchedCardView.workout = event
                contentView.addSubview(unmatchedCardView)
                unmatchedCardView.constrainWithMultiplier(view: contentView, width: 0.8, height: 1)
            }
        }
    }
   var gradient = CAGradientLayer()
    
    let matchedCardView: WorkoutCardView_Matched = {
        let v = WorkoutCardView_Matched()
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let unmatchedCardView: WorkoutCardView_UnMatched = {
        let v = WorkoutCardView_UnMatched()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
   
}
