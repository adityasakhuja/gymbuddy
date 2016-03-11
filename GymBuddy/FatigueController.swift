//
//  FatigueController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 10/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation

class FatigueController: NSObject {
    
    var meanFs: [Double] = []
    var timerFreq = NSTimer()
    var timerClass = NSTimer()
    
    override init()
    {
        super.init()
        // Calculate mean frequency every 0.5 seconds
        timerFreq = NSTimer(timeInterval: 0.5, target: self, selector: "calculateMeanFrequency", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timerFreq, forMode: NSRunLoopCommonModes)
        
        // Perform classification every 30 seconds
        timerClass = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "classify", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timerClass, forMode: NSRunLoopCommonModes)
    }
    
    func calculateMeanFrequency()
    {
        // Grab EMG data
        let emgData = emgDataGlobal
        
        // Calculate mean frequency
        var meanF = 0.00
        for emg in emgData
        {
            meanF += emg.reduce(0, combine: +)
        }
        
        // Add to meanFs array
        meanFs = shiftPush(meanFs, element: meanF, maxSize: 60)
    }
    
    func classify()
    {
        // Perform classification using meanFs array
        
        // Update fatigue index (randomly for now)
        status.fatigue.value = Int.random(1...5)
        
        // For Guang's controller
        fatigueGlobal.append(status.fatigue.value)
    }
}