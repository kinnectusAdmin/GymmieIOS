//
//  Gym.swift
//  Gymmie
//
//  Created by Blake Rogers on 8/21/16.
//  Copyright © 2016 T3. All rights reserved.
//

import Foundation

class Gym: NSObject,NSCoding{
    var id = Int()
    var name = String()
    
    convenience init(name: String,id: Int){
        self.init()
        self.name = name
        self.id = id
    }
    
    override init(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInt64(forKey: "id") as? Int ?? 1
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id , forKey: "id")
        aCoder.encode(name , forKey: "name")
    }
    
}
