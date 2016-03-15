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
    var timerMain = NSTimer()
    var timerFreq = NSTimer()
    var timerClass = NSTimer()
    
    override init()
    {
        super.init()
        
        // Wait 1 seconds to get enough EMG values
        timerMain = NSTimer(timeInterval: 0.5, target: self, selector: "begin", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timerMain, forMode: NSRunLoopCommonModes)
        
        
        //  Create a data set
        let data = DataSet(dataType: .Classification, inputDimension: 2, outputDimension: 1)
        do {
            try data.addDataPoint(input: [0.0, 1.0], output:1)
            try data.addDataPoint(input: [0.0, 0.9], output:1)
            try data.addDataPoint(input: [0.1, 1.0], output:1)
            try data.addDataPoint(input: [1.0, 0.0], output:0)
            try data.addDataPoint(input: [1.0, 0.1], output:0)
            try data.addDataPoint(input: [0.9, 0.0], output:0)
        }
        catch {
            print("Invalid data set created")
        }
        
        //  Create an SVM classifier and train
        let svm = SVMModel(problemType: .C_SVM_Classification, kernelSettings:
            KernelParameters(type: .RadialBasisFunction, degree: 0, gamma: 0.5, coef0: 0.0))
        svm.train(data)
        
        //  Create a test dataset
        let testData = DataSet(dataType: .Classification, inputDimension: 2, outputDimension: 1)
        do {
            try testData.addTestDataPoint(input: [0.0, 0.1])    //  Expect 1
            try testData.addTestDataPoint(input: [0.1, 0.0])    //  Expect 0
            try testData.addTestDataPoint(input: [1.0, 0.9])    //  Expect 0
            try testData.addTestDataPoint(input: [0.9, 1.0])    //  Expect 1
            try testData.addTestDataPoint(input: [0.5, 0.4])    //  Expect 0
            try testData.addTestDataPoint(input: [0.5, 0.6])    //  Expect 1
        }
        catch {
            print("Invalid data set created")
        }
        
        //  Predict on the test data
        svm.predictValues(testData)
    }
    
    func begin()
    {
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