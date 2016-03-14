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
        let bicepsCurl = Exercise(speed: 40, orientations: [95, 95, 95, 95, 95, 95, 95, 95, 95, 95, 95, 95, 95, 95, 95, 94, 94, 94, 94, 94, 93, 93, 93, 92, 91, 90, 89, 88, 86, 84, 83, 81, 79, 76, 74, 72, 69, 66, 64, 61, 58, 54, 51, 48, 44, 41, 37, 34, 30, 27, 24, 21, 18, 16, 13, 11, 9, 8, 7, 6, 5, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 7, 8, 9, 10, 11, 13, 15, 19, 22, 24, 27, 30, 33, 36, 39, 42, 45, 47, 50, 53, 56, 58, 61, 63, 66, 68, 74, 75, 77, 79, 80, 82, 83, 85, 86, 87, 88, 89, 90, 91, 92, 92, 93, 93, 94, 94, 94, 94, 94, 94, 95, 95, 95, 95, 95, 95, 95, 95, 95, 95, 95, 94, 94, 94])
        exerciseList["bicepsCurl"] = bicepsCurl
    }
}

class Exercise {
    var speed = 0
    var orientations: [Int] = []
    
    init(speed: Int, orientations: [Int])
    {
        self.speed = speed
        self.orientations = orientations
    }
}