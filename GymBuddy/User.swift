//
//  User.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 09/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
    // MARK: Properties
    var age: Int
    var heightU: Int
    var sex: Int
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("user")
    
    // MARK: Initialization
    
    init(age: Int, heightU: Int, sex: Int) {
        self.age = age
        self.heightU = heightU
        self.sex = sex
        
        super.init()
    }
    
    // MARK: Types
    struct PropertyKey {
        static let ageKey = "age"
        static let heightUKey = "heightU"
        static let sexKey = "sex"
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(age, forKey: PropertyKey.ageKey)
        aCoder.encodeInteger(heightU, forKey: PropertyKey.heightUKey)
        aCoder.encodeInteger(sex, forKey: PropertyKey.sexKey)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let age = aDecoder.decodeIntegerForKey(PropertyKey.ageKey)
        let heightU = aDecoder.decodeIntegerForKey(PropertyKey.heightUKey)
        let sex = aDecoder.decodeIntegerForKey(PropertyKey.sexKey)
        
        // Must call designated initializer.
        self.init(age: age, heightU: heightU, sex: sex)
    }
}