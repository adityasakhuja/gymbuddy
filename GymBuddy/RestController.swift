//
//  RestController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 11/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation

class RestController: NSObject {
    
    override init()
    {
        super.init()
        
        calculateRestingTime()
        calculateNextReps()
        calculateNextWeight()
    }
    
    func calculateRestingTime()
    {
        // Get previous fatigues array [Int]
        let fatigues = fatigueGlobal
        
        // Do magic
        
        // Return resting time in seconds
        rest.time.value = 240
        
        // Flush the global array when you are done
        fatigueGlobal = []
    }
    
    func calculateNextReps()
    {
        // Get previous reps
        let repsPrev = status.reps.value
        
        // Do magic
        
        // Reset the status reps
        status.reps.value = 0
    }
    
    func calculateNextWeight()
    {
        // Get previous weight
        let weightPrev = status.weight.value
        
        // Do magic
        
        // Set the new weight
        status.weight.value = 3
    }
}