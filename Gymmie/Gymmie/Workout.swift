//
//  Workouts.swift
//  Gymmie
//
//  Created by Blake Rogers on 8/5/16.
//  Copyright © 2016 T3. All rights reserved.
//

import Foundation

class Workout: NSObject, NSCoding {
    
static    let workoutTypes = ["Cardio","Weight Training",
                        "Upper Body",
                        "Lower Body",
                        "Core","Aquatics",
                        "Full Body",
                        "Yoga",
                        "Sports","Any"]
    
static    let frequencies = ["Once",
                       "Weekly",
                       "Every Other Week",
                       "Nightly"]
        var type = ""
        var id = Int()
    
    
    override init(){
        
    }
    convenience init(type: String, id: Int){
        self.init()
        self.type = type
        self.id = id
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id , forKey: "id")
        aCoder.encode(type , forKey: "type")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInt64(forKey: "id") as? Int ?? 1
        self.type = aDecoder.decodeObject(forKey: "type") as? String ?? ""
    }
    
}
