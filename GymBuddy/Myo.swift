//
//  Myo.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 14/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation

class Myo: NSObject, NSCoding {
    
    // MARK: Properties
    var myo: NSUUID!
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("myo")
    
    // MARK: Initialization
    
    init(myo: NSUUID!) {
        self.myo = myo
        
        super.init()
    }
    
    // MARK: Types
    struct PropertyKey {
        static let myoKey = "myo"
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(myo, forKey: PropertyKey.myoKey)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let myo = aDecoder.decodeObjectForKey(PropertyKey.myoKey) as! NSUUID
        
        // Must call designated initializer.
        self.init(myo: myo)
    }
}