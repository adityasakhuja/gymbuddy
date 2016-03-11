//
//  CorrectnessController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 10/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation

class CorrectnessController: NSObject {
    
    var timerCount = NSTimer()
    let ideal = Ideal()
    var reps = 0
    var repsNumCount = 0
    
    override init()
    {
        super.init()
        // Calculate number of reps every 0.5 s
        timerCount = NSTimer(timeInterval: 1, target: self, selector: "calculateRepsNum", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timerCount, forMode: NSRunLoopCommonModes)
    }
    
    func calculateRepsNum()
    {
        repsNumCount++
        var accX = accXGlobal
        var repsNum = 0
        
        // Detect reps
        for(var i=1; i<accX.count; i++)
        {
            // Waveform smoothing
            accX[i] = calcMA([accX[i], accX[i-1]])
            if(accX[i-1] >= 0.00 && accX[i] < 0.00)
            {
                repsNum++
            }
        }
        status.reps.value += repsNum
        
        reps += repsNum
        if repsNumCount % 5 == 0
        {
            checkSpeed(reps*12)
            reps = 0
        }
    }
    
    func checkSpeed(speed: Int)
    {
        let speedDev = speed - (ideal.exerciseList["bicepsCurl"]?.speed)!
        status.speed.value = speedDev
    }
    
    func calcMA(lastN: [Double]) -> Double
    {
        var total: Double = 0
        for element in lastN {
            total+=element
        }
        return total/Double(lastN.count)
    }
}