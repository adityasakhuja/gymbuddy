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
        timerCount = NSTimer(timeInterval: 5, target: self, selector: "calculateCorrectness", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timerCount, forMode: NSRunLoopCommonModes)
    }
    
    func calculateCorrectness()
    {
        let orientations = orientationGlobal
        orientationGlobal = []
        print(orientations)
        
        //NSLog("%@", orientations)
//        var costs: [Int] = []
//        let repsArr = splitByReps()
//        for rep in repsArr
//        {
//            costs.append(DTW((ideal.exerciseList["bicepsCurl"]?.orientations)!, y: rep.map {Int($0*100)}))
//        }
        print("here")
    }
    
    func splitByReps() -> [ArraySlice<Float>]
    {
        let orientations = orientationGlobal
        orientationGlobal = []
        
        var repsArr: [ArraySlice<Float>] = []
        
        let (points, isMax) = findTurningPoints(orientations)
        for(var i=0; i<points.count-2; i++)
        {
            if !isMax[i] && isMax[i+1] && !isMax[i+2]
            {
                repsArr.append(orientations[points[i]...points[i+2]])
                i++
            }
        }
        
        return repsArr
    }
    
    func findTurningPoints(inputOrig: [Float]) -> ([Int], [Bool])
    {
        var input = inputOrig
        for(var i=10; i<input.count; i++)
        {
            // Waveform smoothing
            input[i] = calcMA(inputOrig[i-10...i])
        }
        
        var points: [Int] = []
        var isMax: [Bool] = []
        
        for(var i=5; i<input.count-5; i++)
        {
            if(input[i]>input[i-5] && input[i]>input[i+5])
            {
                points.append(i)
                isMax.append(true)
            }
            else if(input[i]<input[i-5] && input[i]<input[i+5])
            {
                points.append(i)
                isMax.append(false)
            }
        }
        
        return (points, isMax)
    }
    
    func DTW(x: [Int], y: [Int]) -> Int
    {
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
        
        let (path, cost) = pathCost(x, y: y, accumulatedCost: accumulatedCost, distances: distances)
        
        return cost
        
//        for point in path{
//            print("\(point[0]) \(x[point[0]]) : \(point[1]) \(y[point[1]])")
//        }
//        
//        print(path)
//        print("\(cost)")
    }
    
    func pathCost(x: [Int], y: [Int], accumulatedCost: [[Int]], distances: [[Int]]) -> ([[Int]], Int)
    {
        var cost = 0
        var path: [[Int]] = []
        path.append([x.count-1, y.count-1])
        var i = y.count-1
        var j = x.count-1
        while(i>0 && j>0)
        {
            if i == 0
            {
                j = j - 1
            }
            else if j == 0
            {
                i = i - 1
            }
            else
            {
                if(accumulatedCost[i-1][j] == min(accumulatedCost[i-1][j-1], accumulatedCost[i-1][j], accumulatedCost[i][j-1]))
                {
                    i = i - 1
                }
                else if(accumulatedCost[i][j-1] == min(accumulatedCost[i-1][j-1], accumulatedCost[i-1][j], accumulatedCost[i][j-1]))
                {
                    j = j-1
                }
                else
                {
                    i = i - 1
                    j = j - 1
                }
            }
            path.append([j, i])
        }
        path.append([0, 0])
        
        for point in path
        {
            cost += distances[point[1]][point[0]]
        }
        return (path, cost)
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
    
    func calcMA(lastN: ArraySlice<Float>) -> Float
    {
        var total: Float = 0
        for element in lastN {
            total+=element
        }
        return total/Float(lastN.count)
    }
}