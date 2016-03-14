//
//  Status.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 10/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation
import Bond

class Status: NSObject {
    var fatigue:Observable<Int> = Observable((0))
    var reps:Observable<Int> = Observable((0))
    var speed:Observable<Int> = Observable((0))
    var correctness:Observable<Int> = Observable((0))
    var weight:Observable<Int> = Observable((0))
    var exercise:Observable<Int> = Observable((0))
    var repLimit: Observable<Int> = Observable((0))
    var setLimit: Observable<Int> = Observable((0))
    
    init(fatigue: Int, reps: Int, speed: Int, correctness: Int, weight: Int, exercise: Int, repLimit: Int, setLimit: Int) {
        self.fatigue.value = fatigue
        self.reps.value = reps
        self.speed.value = speed
        self.correctness.value = correctness
        self.weight.value = weight
        self.exercise.value = exercise
        self.repLimit.value = repLimit
        self.setLimit.value = setLimit
    }
}