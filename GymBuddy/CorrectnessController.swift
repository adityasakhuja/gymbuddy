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
    var correctnessCount = NSTimer()
    let ideal = Ideal()
    var reps: [Int] = []
    var repsNumCount = 0
    
    override init()
    {
        super.init()
        // Calculate number of reps every 0.5 s
        timerCount = NSTimer(timeInterval: 0.5, target: self, selector: "calculateRepsNum", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timerCount, forMode: NSRunLoopCommonModes)
        
        // Calculate orientation correctness every 5 s
        correctnessCount = NSTimer(timeInterval: 5, target: self, selector: "calculateCorrectness", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(correctnessCount, forMode: NSRunLoopCommonModes)
    }
    
    func calculateCorrectness()
    {
        var costs: [Int] = []
        let repsArr = splitByReps()
        for rep in repsArr
        {
            costs.append(DTW((ideal.exerciseList[status.exercise.value]?.orientations)!, y: rep.map {Int($0*100)}))
        }
        
        if !costs.isEmpty
        {
            status.correctness.value = max(100-Int(costs.last!/500), 0)
            //print(costs)
            //print(status.correctness.value)
        }
        //print()
    }
    
    func splitByReps() -> [ArraySlice<Float>]
    {
        let orientations = orientationGlobal
        orientationGlobal.removeAll()
        
        var repsArr: [ArraySlice<Float>] = []
        
        let (points, isMax) = findTurningPoints(orientations)
        for(var i=0; i<points.count-2; i++)
        {
            if isMax[i] && !isMax[i+1] && isMax[i+2]
            {
                repsArr.append(orientations[points[i]...points[i+2]])
                i++
            }
        }
        //print(repsArr)
        return repsArr
    }
    
    func findTurningPoints(inputOrig: [Float]) -> ([Int], [Bool])
    {
        // This is probably a leftover from debugging, and needs to be removed
        var input = [Float](count: inputOrig.count, repeatedValue: 0)
        for(var i=0; i<inputOrig.count; i++)
        {
            input[i] = inputOrig[i]
        }
        
        var points: [Int] = []
        var isMax: [Bool] = []
        let frame = 10
        for(var i=frame; i<input.count-frame; i++)
        {
            if(input[i]>input[i-frame] && input[i]>input[i+frame] && (input[i]-input[i-frame])>0.01)
            {
                let turn = input[i-frame...i+frame]
                let maxVal = turn.maxElement()
                let maxInd = turn.indexOf(maxVal!)
                points.append(maxInd!)
                isMax.append(true)
                i += frame
            }
            else if(input[i]<input[i-frame] && input[i]<input[i+frame] && (input[i-frame] - input[i])>0.01)
            {
                let turn = input[i-frame...i+frame]
                let minVal = turn.minElement()
                let minInd = turn.indexOf(minVal!)
                points.append(minInd!)
                isMax.append(false)
                i += frame
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
        var orientations = orientationRepsGlobal
        orientationRepsGlobal.removeAll()
        var repsNum = 0
        
        for i in 1...orientations.count-1
        {
            if(orientations[i-1] >= 0.8 && orientations[i] < 0.8)
            {
                repsNum++
            }
        }
        
        status.reps.value += repsNum
        
        reps = shiftPush(reps, element: repsNum, maxSize: 10)
        if reps.count > 9
        {
            checkSpeed(reps.reduce(0, combine: +)*12)
        }
    }
    
    func checkSpeed(speed: Int)
    {
        let speedDev = speed - (ideal.exerciseList[status.exercise.value]?.speed)!
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
    
    func stop()
    {
        timerCount.invalidate()
        correctnessCount.invalidate()
    }
    
    func resume()
    {
        // Calculate number of reps every 0.5 s
        timerCount = NSTimer(timeInterval: 0.5, target: self, selector: "calculateRepsNum", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timerCount, forMode: NSRunLoopCommonModes)
        
        // Calculate orientation correctness every 5 s
        correctnessCount = NSTimer(timeInterval: 5, target: self, selector: "calculateCorrectness", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(correctnessCount, forMode: NSRunLoopCommonModes)
    }
}