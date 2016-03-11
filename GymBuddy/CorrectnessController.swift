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
    
    override init()
    {
        super.init()
        // Calculate number of reps every 0.5 s
        timerCount = NSTimer(timeInterval: 0.5, target: self, selector: "calculateRepsNum", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timerCount, forMode: NSRunLoopCommonModes)
    }
    
    func calculateRepsNum()
    {
        let accX = accXGlobal
        var xPrev = -1.00
        var repsNum = 0
        
        for x in accX
        {
            if xPrev >= 0 && x <= 0
            {
                repsNum++
            }
            xPrev=x
        }
        status.reps.value += repsNum
    }
}