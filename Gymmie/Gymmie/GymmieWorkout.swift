//
//  GymmieWorkout.swift
//  Gymmie
//
//  Created by Blake Rogers on 10/23/16.
//  Copyright © 2016 T3. All rights reserved.
//

import Foundation


/*
 "type": "Cardio",
 "start_date": "2016-10-02T18:11:53.000Z",
 "end_date": "2016-10-02T19:11:53.000Z",
 "gym": "UVFC",
 "frequency": null
 */
class GymmieWorkout: NSObject{
    var id: NSNumber?
    var type: String?
    var start_date: String?
    var end_date: String?
    var gym: String?
   
    var frequency: NSNumber?
    
    convenience init(id: NSNumber?, type: String?, startDate: String?, endDate: String?, gym: String?,frequency: NSNumber?) {
        self.init()
        self.id = id
        self.type = type
        self.start_date = startDate
        self.end_date = endDate
        self.gym = gym
        self.frequency = frequency
    }
    var timeStart: Date{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let start = start_date!.characters.dropLast(5)
       formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: String(start))!
    }
    var timeStartString: String{
          return MyCalendar.timeSinceEvent(onDate: timeStart)
      
    }
    var timeEnd: Date{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let end = end_date!.characters.dropLast(5)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: String(end))!
    }
    var timeEndString: String {
        return MyCalendar.timeSinceEvent(onDate: timeEnd)
    }
    var user_id: NSNumber?
    var workout_type_id: NSNumber?
    var gym_id: NSNumber?
    var created_at: String?
    var updated_at: String?
    var user: String?
    var workout_type: String?
    var url: String?
   
}
