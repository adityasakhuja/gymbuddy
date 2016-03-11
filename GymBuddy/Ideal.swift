//
//  Ideal.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 11/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation

class Ideal {
    var exerciseList = [String: Exercise]()
    
    init() {
        let bicepsCurl = Exercise(speed: 40)
        exerciseList["bicepsCurl"] = bicepsCurl
    }
}

class Exercise {
    var speed = 0
    
    init(speed: Int)
    {
        self.speed = speed
    }
}