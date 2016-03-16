//
//  Ideal.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 11/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation

class Ideal {
    var exerciseList = [Int: Exercise]()
    
    init() {
        let bicepsCurl = Exercise(speed: 40, orientations: [97, 96, 96, 95, 95, 94, 93, 92, 91, 89, 88, 87, 85, 83, 81, 78, 76, 73, 71, 68, 65, 61, 58, 54, 51, 47, 43, 36, 32, 26, 23, 20, 18, 16, 14, 12, 11, 10, 8, 8, 7, 7, 6, 6, 7, 7, 9, 10, 12, 14, 16, 18, 21, 24, 30, 34, 37, 41, 44, 48, 51, 54, 58, 61, 65, 68, 70, 73, 76, 78, 80, 82, 84, 86, 87, 89, 90, 92, 93, 94, 95, 95, 96, 96, 96, 96, 97, 97, 97, 97])

        exerciseList[1] = bicepsCurl
        
        let forearmCurl = Exercise(speed: 20, orientations: [82, 82, 82, 82, 82, 81, 81, 80, 79, 78, 77, 76, 75, 73, 72, 70, 68, 66, 64, 62, 59, 56, 54, 51, 49, 46, 44, 41, 39, 37, 35, 34, 32, 31, 30, 29, 28, 27, 27, 27, 26, 26, 26, 26, 26, 26, 27, 27, 27, 27, 27, 27, 27, 28, 28, 28, 28, 29, 29, 30, 31, 32, 34, 35, 37, 38, 40, 42, 44, 46, 49, 51, 53, 55, 57, 59, 61, 63, 65, 67, 69, 70, 72, 73, 74, 76, 77, 78, 79, 80, 81, 81, 82, 82, 83, 83, 83, 83])
        
        exerciseList[0] = forearmCurl
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