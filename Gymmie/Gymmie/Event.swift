//
//  Event.swift
//  Gymmie
//
//  Created by Blake Rogers on 7/31/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class Event: NSObject, NSCoding{
 
    var eventURL: String?
    var partner: GymmieUser?
    var dayOfWorkout = String()
    var workoutName = String()
    var exercises = [String]()
    var startHour = String()
    var endHour = String()
    var workout = Workout()
    var gym = Gym()
    var eventID = Int()
    var isMatched: Bool = false
    var planner: GymmieUser?
    var convoID = String()
    var locationDetail: String{ return "@ \(gym.name)"}
    var scheduleDetail: String{
        return startHour.isEmpty || endHour.isEmpty || dayOfWorkout.isEmpty ? "" : "\(dayOfWorkout) \n \(startHour) - \(endHour)"
    }
    func dateForEvent()->Date{
        let time = self.startHour
        guard let colonRange = time.characters.index(of: ":") else{ return Date()}
        let hour = time.substring(to: colonRange)
        let minute = time.substring(from: colonRange).replacingOccurrences(of: "PM", with: "").replacingOccurrences(of: "AM", with: "").replacingOccurrences(of: ":", with: "").replacingOccurrences(of: " ", with: "")
        let inTheMorning = time.contains("AM")
        let inTheEvening = time.contains("PM")
        guard let dayInt = Calendar.current.weekdaySymbols.index(of: self.dayOfWorkout), let hourInt = Int(hour) else { return Date()}

        var comps = DateComponents()
            comps.day = dayInt + 1
            comps.hour = hourInt + (inTheEvening ? 12 : 0)
            comps.minute = Int(minute)
            comps.month = MyCalendar.thisMonthInt
            comps.year = MyCalendar.thisYear
        return Calendar.current.date(from: comps) ?? Date()
    
    }
    override init() {}
    convenience init(day:String, start: String, end: String,workout: Workout,gym: Gym){
        self.init()
        self.dayOfWorkout = day
        self.startHour = start
        self.endHour = end
        self.workout = workout
        self.gym = gym
    }
    
  required  init?(coder aDecoder: NSCoder) {
    self.dayOfWorkout = aDecoder.decodeObject(forKey: "day") as? String ?? ""
    self.startHour = aDecoder.decodeObject(forKey: "startHour") as? String ?? ""
    self.endHour = aDecoder.decodeObject(forKey: "endHour") as? String ?? ""
    self.eventURL = aDecoder.decodeObject(forKey: "eventURL")as? String
    self.workout = aDecoder.decodeObject(forKey: "workout") as? Workout  ?? Workout()
    self.eventID = aDecoder.decodeInteger(forKey: "eventID")
    self.gym = aDecoder.decodeObject(forKey: "gym") as? Gym ?? Gym()
    self.partner = aDecoder.decodeObject(forKey: "partner") as? GymmieUser
    self.isMatched = aDecoder.decodeBool(forKey: "isMatched")
    self.workoutName = aDecoder.decodeObject(forKey: "workoutName") as? String ?? ""
    self.exercises = aDecoder.decodeObject(forKey: "exercises") as? [String] ?? []
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(workoutName, forKey: "workoutName")
        aCoder.encode(partner , forKey: "partner")
        aCoder.encode(gym , forKey: "gym")
        aCoder.encode(workout , forKey: "workout")
        aCoder.encode(eventURL, forKey: "eventURL")
        aCoder.encode(eventID , forKey: "eventID")
        aCoder.encode(isMatched, forKey: "isMatched")
        aCoder.encode(dayOfWorkout, forKey: "day")
        aCoder.encode(startHour, forKey: "startHour")
        aCoder.encode(endHour, forKey: "endHour")
        aCoder.encode(exercises, forKey: "exercises")
    }
  
}
