//
//  RestController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 11/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation
import CoreData

class RestController: NSObject {
    
    var fatiguesHistorical: [[Int]] = []
    var weightsHistorical: [Int] = []
    var repsHistorical: [Int] = []
    var exerciseHistorical: [Int] = []
    
    override init()
    {
        super.init()
        
        // Fetch data from CoreData
        var exerciseDatas = [NSManagedObject]()
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "ExerciseData")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            exerciseDatas = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        // Save data to local arrays
        for data in exerciseDatas
        {
            let arrString = data.valueForKey("fatigues") as? String
            let arr = arrString!.characters.split{$0 == "-"}.map(String.init).map {Int($0)!}
            fatiguesHistorical.append(arr)
            weightsHistorical.append((data.valueForKey("weights") as? Int)!)
            repsHistorical.append((data.valueForKey("reps") as? Int)!)
            exerciseHistorical.append((data.valueForKey("exercise") as? Int)!)
        }
        
        calculateNextReps()
    }
    
    func calculateNextReps()
    {
        var fatigues = fatigueGlobal// Get previous fatigues array [Int]
        let repsPrev = status.reps.value// Get previous reps
        let weightPrev = status.weight.value// Get previous weight
        let restPrev = rest.time.value
        
        // Failsafe for when fatigueGlobal is empty
        if fatigues.isEmpty
        {
            fatigues = [3]
        }
        
        print("input: fatigues: \(fatigues),\t reps: \(repsPrev),\t Weight: \(weightPrev),\t rest: \(restPrev)")
        
        let fatigue_curr = fatigues[fatigues.endIndex - 1]
        let fatigue_init = fatigues[0]
        
        //CONSTANTS
        let weight_threshold = 10
        let tiredness_threshold = 3
        let max_rest_time = 300
        
        var rest_time = restPrev
        var status_weight = weightPrev
        var status_rep = repsPrev
        
        switch fatigue_curr {
            case 1:
                if(repsPrev >= 8){
                    if(status_weight > weight_threshold){
                        status_weight += 1
                    }else{
                        status_weight += 2
                    }
                    status_rep = 8
                } else {
                    status_rep += 3
                }
                rest_time = 30 // should start immediately
            case 2:
                if(repsPrev >= 8){
                    status_weight += 1
                    status_rep = 8
                } else {
                    status_rep += 2
                }
                rest_time = 30 // should start immediately
            case 3:
                if(fatigue_init == tiredness_threshold){
                    rest_time += 30
                    if(rest_time >= max_rest_time){
                        rest_time = max_rest_time
                        if(repsPrev > 8){
                            status_rep = 8
                        }else{
                            status_rep -= 1
                        }
                    }
                }
            case 4:
                if(restPrev >= max_rest_time){
                    status_weight -= 1
                }else {
                    if (repsPrev > 8){
                        status_rep = 8
                    }
                    if(fatigue_init >= tiredness_threshold ){
                        rest_time += 30
                    } else if(fatigue_init == 1){
                        rest_time -= 30
                    }
                }
            case 5:
                if(restPrev >= max_rest_time){
                    status_weight -= 1
                    status_rep = 8
                    if(status_weight > weight_threshold){
                        if(fatigue_init < tiredness_threshold){
                            status_weight -= 1
                        }
                    }
                }else {
                    if (repsPrev > 8){
                        status_rep = 8
                        rest_time += 30
                    }else{
                        if(fatigue_init < tiredness_threshold){
                            status_rep -= 1
                        }else{
                            status_rep -= 1
                            rest_time += 30
                        }
                    }
                }
            default:
                // do nothing
                print("default")
        }
        
        print("rest time: \(rest_time),\t weight: \(status_weight),\t reps: \(status_rep) \n")
        
        rest.time.value = rest_time// Return resting time in seconds
        status.weight.value = status_weight// Set the new weight
        rest.reps.value = status_rep// Reset the status reps
        fatigueGlobal = []// Flush the global array when you are done
    }
}
