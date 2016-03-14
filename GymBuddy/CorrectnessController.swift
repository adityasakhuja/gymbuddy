//
//  CorrectnessController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 10/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation

infix operator ^^ { }
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

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
    
    func DTW()
    {
        let x = [1, 1, 2, 3, 2, 0]
        let y = [0, 1, 1, 2, 3, 2, 1]
        var distances = [[Int]](count: y.count, repeatedValue: [Int](count: x.count, repeatedValue: 0))
        for(var i=0; i<y.count; i++)
        {
            for(var j=0; j<x.count; j++)
            {
                distances[i][j] = (x[j]-y[i])^^2
            }
        }
        
        
        var accumulatedCost = [[Int]](count: y.count, repeatedValue: [Int](count: x.count, repeatedValue: 0))
        accumulatedCost[0][0] = distances[0][0]
        
        for(var i=1; i<x.count; i++)
        {
            accumulatedCost[0][i] = distances[0][i] + accumulatedCost[0][i-1]
        }
        
        for(var i=1; i<y.count; i++)
        {
            accumulatedCost[i][0] = distances[i][0] + accumulatedCost[i-1][0]
        }
        
        for(var i=1; i<y.count; i++)
        {
            for(var j=1; j<x.count; j++)
            {
                accumulatedCost[i][j] = min(accumulatedCost[i-1][j-1], accumulatedCost[i-1][j], accumulatedCost[i][j-1]) + distances[i][j]
            }
        }
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