//
//  FatigueController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 10/03/2016.
//  Edited by Lorraine Choi on 15/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//


import Foundation
import Accelerate


class FatigueController: NSObject {

/***************************************************** Variables Declaration *****************************************************/
    
    // declare variables for feature extraction
    
    var power = [[Double]](count: lengthOfArray-1, repeatedValue: [Double](count: 8, repeatedValue: 0))
    var meanAvgVal: [[Double]] = []
    var rootMeanSqr: [[Double]] = []
    var meanFreq: [[Double]] = []
    var medFreq: [[Double]] = []
    
    
    // create classifier for linear SVM
    
    let svm = SVMModel(problemType: .C_SVM_Classification, kernelSettings: KernelParameters(type: .RadialBasisFunction, degree: 0, gamma: 0.5, coef0: 0.0))
    
    
    // declare variables for timer
    
    var timerMain = NSTimer()
    var timerFreq = NSTimer()
    var timerClass = NSTimer()
    
    
    
/********************************************** Initialisation & Classifier Training **********************************************/
    
    override init() {
        
        super.init()
        
        // Wait 1 seconds to get enough EMG values
        timerMain = NSTimer(timeInterval: 0.5, target: self, selector: "begin", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timerMain, forMode: NSRunLoopCommonModes)
        
        
        //  Training Data Set (Hard coded for the moment)
        let data = DataSet(dataType: .Classification, inputDimension: 9, outputDimension: 1)
        do {
            try data.addDataPoint(input: [3, 0.001173104, 0.007631439, 0.031712211, -0.021567225, 0, 21, 180, 0], output: 3)
            try data.addDataPoint(input: [1, -0.000719089, 0.00468727, -0.032869121, -0.068182464, 1, 21, 180, 0], output: 1)
            try data.addDataPoint(input: [1, -0.000719089, 0.00468727, -0.032869121, -0.068182464, 1, 21, 180, 0], output: 1)
            try data.addDataPoint(input: [1, -0.000322312, 0.014690526, 0.005981156, 0.029004059, 1, 21, 180, 0], output: 2)
            try data.addDataPoint(input: [1, -0.000885524, 0.081820265, 0.005479816, -0.021607259, 1, 22, 163, 1], output: 2)
            try data.addDataPoint(input: [1, 0.040771325, -0.281170456, -0.014685101, 0.004057098, 1, 22, 173, 0], output: 1)
            try data.addDataPoint(input: [1, 0.002121423, -0.0700006, -0.01070245, -0.034723813, 0, 22, 173, 0], output: 1)
            try data.addDataPoint(input: [1, 0.000462629, 0.007324156, 0.005829766, -0.007897787, 0, 21, 180, 0], output: 2)
            try data.addDataPoint(input: [1, -0.000473187, -0.018664546, -0.03018981, -0.078475502, 0, 21, 180, 0], output: 2)
            try data.addDataPoint(input: [1, 0.001282856, 0.048438239, 0.104563229, 0.135358525, 0, 22, 173, 0], output: 1)
            try data.addDataPoint(input: [1, 0.000334537, 0.030982638, 0.01834821, 0.012111998, 1, 21, 180, 0], output: 1)
            try data.addDataPoint(input: [3, -0.000304807, -0.028227045, -0.024541665, -0.028231806, 1, 21, 180, 0], output: 3)
            try data.addDataPoint(input: [1, -0.000195332, -0.140779306, 0.007071685, -0.026655012, 1, 22, 163, 1], output: 2)
            try data.addDataPoint(input: [3, -0.001151709, 0.096620984, 0.020024965, 0.070076199, 0, 22, 173, 0], output: 3)
            try data.addDataPoint(input: [3, 0.006342317, 0.106066379, -0.012565635, -0.051444696, 1, 22, 163, 1], output: 4)
            try data.addDataPoint(input: [3, 0.006793554, 0.118, -0.037886043, -0.06643887, 0, 22, 173, 0], output: 3)
            try data.addDataPoint(input: [1, -0.000195332, -0.140779306, 0.007071685, -0.026655012, 1, 22, 163, 1], output: 2)
            try data.addDataPoint(input: [1, -0.002152265, 0.074173092, -0.069017188, -0.151414409, 1, 22, 163, 1], output: 2)
            try data.addDataPoint(input: [3, -0.008981939, 0.328058722, -0.019111973, -0.072560965, 1, 22, 163, 1], output: 4)
            try data.addDataPoint(input: [1, 0.000467352, 0.053605089, -0.08927517, -0.096826192, 1, 22, 173, 0], output: 1)
            try data.addDataPoint(input: [3, -0.041826341, 0.417015659, -0.058003878, -0.084288148, 0, 22, 173, 0], output: 3)
            try data.addDataPoint(input: [1, -0.00039761, -0.110644129, 0.051822401, 0.092599853, 0, 22, 173, 0], output: 1)
            try data.addDataPoint(input: [1, -0.000629619, 0.000101885, -0.042533874, -0.032741216, 0, 21, 180, 0], output: 2)
            try data.addDataPoint(input: [1, 0.000115588, 0.079854825, 0.053098621, 0.057113061, 0, 22, 173, 0], output: 1)
            try data.addDataPoint(input: [3, 0.027151431, -0.360684362, -0.028818981, -0.046312624, 1, 22, 173, 0], output: 3)
            try data.addDataPoint(input: [3, 0.000654071, 0.03716309, -0.082459408, -0.118064747, 1, 22, 173, 0], output: 3)
            try data.addDataPoint(input: [3, -0.0000531, -0.069840758, 0.194374432, 0.325177386, 0, 22, 173, 0], output: 3)
            try data.addDataPoint(input: [1, 0.00050264, 0.067183504, -0.235980557, -0.387696631, 1, 22, 173, 0], output: 1)
            try data.addDataPoint(input: [1, -0.002152265, 0.074173092, -0.069017188, -0.151414409, 1, 22, 163, 1], output: 2)
            try data.addDataPoint(input: [1, 0.040771325, -0.281170456, -0.014685101, 0.004057098, 1, 22, 173, 0], output: 1)
            try data.addDataPoint(input: [1, 0.006756043, -0.090906349, -0.009979441, -0.024488204, 1, 22, 163, 1], output: 2)
            try data.addDataPoint(input: [3, -0.000791331, -0.041808096, -0.06220704, -0.105681159, 1, 21, 180, 0], output: 3)
            try data.addDataPoint(input: [3, -0.001689636, 0.169280062, 0.010720175, -0.001402356, 1, 22, 163, 1], output: 4)
            try data.addDataPoint(input: [3, -0.0000461, -0.052514472, 0.006716297, 0.014653391, 1, 21, 180, 0], output: 3)
            try data.addDataPoint(input: [3, -0.000745207, 0.042119099, -0.037762489, -0.075457864, 1, 22, 173, 0], output: 3)
            try data.addDataPoint(input: [1, 0.000319255, 0.059092202, 0.017204205, 0.000761568, 1, 22, 163, 1], output: 2)
            try data.addDataPoint(input: [3, 0.00115032, -0.165028411, -0.024015341, -0.032585656, 1, 22, 173, 0], output: 3)
            try data.addDataPoint(input: [1, 0.000776605, 0.048045757, 0.025565621, 0.049461845, 0, 22, 173, 0], output: 1)
            try data.addDataPoint(input: [1, 0.000121145, -0.037367684, -0.041524546, -0.025620337, 1, 21, 180, 0], output: 1)
            try data.addDataPoint(input: [1, 0.000997221, -0.016173131, -0.018267151, -0.057714981, 0, 22, 163, 1], output: 2)
            try data.addDataPoint(input: [1, -0.000065, 0.046859491, -0.004158608, 0.013931415, 0, 22, 173, 0], output: 1)
            try data.addDataPoint(input: [1, -0.000322312, 0.014690526, 0.005981156, 0.029004059, 1, 21, 180, 0], output: 2)
            try data.addDataPoint(input: [1, 0.000115588, 0.079854825, 0.053098621, 0.057113061, 0, 22, 173, 0], output: 1)
            try data.addDataPoint(input: [3, -0.01185357, 0.060401602, -0.034648735, -0.065873656, 1, 22, 173, 0], output: 3)
            try data.addDataPoint(input: [1, -0.018441234, 0.172263906, -0.013812801, 0.007845391, 0, 22, 163, 1], output: 2)
            try data.addDataPoint(input: [1, 0.000818005, 0.148217537, -0.050171947, -0.124967486, 1, 21, 180, 0], output: 1)
            try data.addDataPoint(input: [1, 0.001312587, 0.040178348, -0.061665405, -0.087243574, 0, 22, 173, 0], output: 1)
            try data.addDataPoint(input: [3, 0.039636844, -0.691036845, -0.028075948, -0.027117761, 0, 22, 173, 0], output: 3)
            try data.addDataPoint(input: [3, 0.000246457, -0.043039689, -0.046187438, -0.047258585, 1, 21, 180, 0], output: 3)
            try data.addDataPoint(input: [3, 0.001325924, 0.008909675, -0.050132098, -0.117717746, 0, 21, 180, 0], output: 3)
            try data.addDataPoint(input: [3, 0.014925813, 0.007199415, -0.160275703, -0.289807673, 0, 22, 173, 0], output: 3)
            try data.addDataPoint(input: [3, -0.004854404, 0.419946435, -0.050989335, -0.052855586, 0, 22, 173, 0], output: 3)
            try data.addDataPoint(input: [3, -0.041826341, 0.417015659, -0.058003878, -0.084288148, 0, 22, 173, 0], output: 3)
            try data.addDataPoint(input: [3, 0.001683245, 0.014990907, 0.111434564, 0.199417178, 0, 22, 163, 1], output: 4)
            try data.addDataPoint(input: [1, -0.000350653, 0.015738589, -0.041343916, -0.134845712, 0, 21, 180, 0], output: 2)
            try data.addDataPoint(input: [1, -0.004607947, -0.235514116, 0.190341767, 0.152452474, 1, 22, 173, 0], output: 1)
            try data.addDataPoint(input: [1, 0.000714643, 0.015704626, 0.011145589, 0.039235416, 1, 21, 180, 0], output: 2)
            try data.addDataPoint(input: [1, -0.000194221, 0.060621779, 0.000485652, 0.037859629, 1, 21, 180, 0], output: 1)
        }
        catch {
            print("Invalid data set created")
        }
        
        //  Train SVM Classifier
        svm.train(data)
    }
    
  
    
/********************************************** Timer Function **********************************************/
    
    func begin() {
        
        // Calculate MAV, RMS, MNF, MDF every 0.64 seconds (128 samples)
        
        timerFreq = NSTimer(timeInterval: 0.64, target: self, selector: "parametersCalculation", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timerFreq, forMode: NSRunLoopCommonModes)
        
        // Perform classification every 30 seconds (47 samples of MAV, RMS, MNF, MDF)
        
        timerClass = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "classify", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timerClass, forMode: NSRunLoopCommonModes)
    }
    
 

/********************************************** Parameters Extraction **********************************************/
     
     // calculates MAV, RMS, MNF, MDF every 0.64s (128 samples of EMG signal amplitudes)
    
    func parametersCalculation() {
        
        // Fetch EMG signal
        let emgData = emgDataGlobal
        
        // time domain parameters
        calMeanAverageValue(emgData)
        calRootMeanSquare(emgData)
        
        // frequency domain parameters
        computeFFT(emgData)
        calMeanFreq(power)
        calMedFreq(power)
        
    }
    
    

/********************************************** Features Extraction **********************************************/
     
     // compute rate of change of MAV, RMS, MNF, MDF every 30s (47 samples of MAV/RMS/MNF/MDF)
    
    func featuresExtraction() {
        
        let mav_rate = calRateOfChange(meanAvgVal)                              // rate of change of mean average value MAV
        let rms_rate = calRateOfChange(rootMeanSqr)                             // rate of change of root mean square RMS
        let mnf_rate = calRateOfChange(meanFreq)                                // rate of change of mean frequency MNF
        let mdf_rate = calRateOfChange(medFreq)                                 // rate of change of meian frequency MDF
        
        //let user_age = [Int](count: 8, repeatedValue: User.age)                 // age of user
        //let user_height = [Int](count: 8, repeatedValue: User.heightU)          // height of user
        //let user_sex = [Int](count: 8, repeateValue: User.sex)                  // sex of user
        //let load = [Int](count: 8, repeaedValue: Status.weight)                 // weight of dumbbell used
        //let activity = [Int](count: 8, repeaedValue: Status.exercise)           // fitness activity in occurance (forearm/bicep curls)
        
        /* MISSING USER WEIGHT AND DOMINANT HAND */
    }
    
    
    
/********************************************** Prediction/Classification **********************************************/
     
     // predict fatigue level and pass index to Recommendation module
    func classify() {
        
        // Extract features from EMG (rate of changes)
        featuresExtraction()
        
        // Feed in data and classify
        let testData = DataSet(dataType: .Classification, inputDimension: 9, outputDimension: 1)
        
        do {
            // CHANGE VARIABLE ASSIGNMENTS ????
            let age = user.age
            let height = user.height
            let sex = user.sex
            let dumbbellWeight = status.weight
            let fitnessActivity = status.exercise
            
            for i in 1...8 {
                try testData.addTestDaPoint(input: [mav_rate[i-1], rms_rate[i-1], mnf_rate[i-1], mdf_rate[i-1], age, height, sex, weight, exercise])
            }
        }
        catch {
            print("Invalid data set created")
        }
        
        //  Predict on the test data
        svm.predictValues(testData)
        
        var classLabel : Int
        var fatigueIndex = [Double]()
        
        do {
            for i in 1...8 {
                try classLabel = testDaa.getClass(i-1)
                fatiueIndex.append(Double(classLabel))
            }
        }
        catch {
            print("Error in Prediction")
        }
        
        
        // Update fatigue index
        status.fatigue.value = Int(mean(fatigueIndex))
        
        // Pass index to Recommendation module
        fatigueGlobal.append(status.fatigue.value)
    }

    
    
/********************************************** Computational Functions **********************************************/
    
     // function to extract a column array from 2D array
    
    func extractCol(array: [[Double]], electrode: Int) -> [Double] {
        var colVector: [Double] = []
        for i in 0...(array.count-1) {
            colVector.append(array[i][electrode-1])
        }
        return colVector
    }
    
    
    // function to compute mean of array
    
    func mean(x: [Double]) -> Double {
        var result: Double = 0.0
        vDSP_meanvD(x, 1, &result, vDSP_Length(x.count))
        return result
    }
    
    
    // function for element-wise multiplication
    
    func mul(x: [Double], y: [Double]) -> [Double] {
        var results = [Double](count: x.count, repeatedValue: 0.0)
        vDSP_vmulD(x, 1, y, 1, &results, 1, vDSP_Length(x.count))
        return results
    }


    
/********************************************** Time Domain Functions **********************************************/
    
    // function to calculate MAV
    
    func calMeanAverageValue(input: [[Double]]) {
        var row = [Double]()
        for i in 1...8 {
            row.append(mean(extractCol(input, electrode: i)))
        }
        meanAvgVal.append(row)
    }
   
    
    // function to calculate RMS
    
    func calRootMeanSquare(data: [[Double]]) {
        var row = [Double]()

        for i in 1...8 {
            let tempVec = extractCol(data, electrode: i)
            let sq_amp = mul(tempVec, y: tempVec)
            let sum = sq_amp.reduce(0, combine: +)
            
            row.append(sqrt(sum/Double(tempVec.count)))
        }
        rootMeanSqr.append(row)
    }
    
 
    
/********************************************** Freq Domain Functions **********************************************/
    
    // function to perform FFT
    // length of input vector has to be power of 2 (128 for Gymbuddy, i.e. around 30s)
    // returns POWER i.e. square of FFT magnitudes
    
    func fft(input: [Double]) -> [Double] {
        
        var real = [Double](input)
        var imaginary = [Double](count: input.count, repeatedValue: 0.0)
        var splitComplex = DSPDoubleSplitComplex(realp: &real, imagp: &imaginary)       // store Re and Im parts in separate arrays
        
        let length = vDSP_Length(floor(log2(Float(input.count))))                       // numbers of elements in arrays
        let radix = FFTRadix(kFFTRadix2)                                                // size of the FFT decomposition; Radix = 2
        let weights = vDSP_create_fftsetupD(length, radix)                              // builds data structure for FFT functions
        
        // computes in-place double-precision complex DFT from the time domain to the frequency domain (forward)
        vDSP_fft_zipD(weights, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))
        
        var magnitudes = [Double](count: input.count, repeatedValue: 0.0)
        vDSP_zvmagsD(&splitComplex, 1, &magnitudes, 1, vDSP_Length(input.count))        // returns complex vector magnitudes SQUARED
        
        vDSP_destroy_fftsetupD(weights)                                                 // frees existing FFT data structure
        
        return magnitudes                                                               // returns array of power (magnitude^2)
    }
    
    
    // function to compute power array
    
    func computeFFT(array: [[Double]]) {
        
        var tempVec: [Double] = []
        var tempVec_fft: [Double] = []
        
        for i in 1...8 {
            tempVec = extractCol(array, electrode: i)
            tempVec_fft = fft(tempVec)
            
            // remove peak at 0
            tempVec_fft.removeAtIndex(0)
            
            for j in 0..<(lengthOfArray-1) {
                power[j][i-1] = tempVec_fft[j]
            }
            
            tempVec.removeAll()
            tempVec_fft.removeAll()
        }
    }
    
    
    // function to compute mean freq
    
    func calMeanFreq(power_array: [[Double]]) {
        
        // freq = 0: (fs/100) : nyquist
        // mean freq = sum(freq .* power)/sum(power)
        // single sided power spectrum used to calculate MNF
        
        var tempVec: [Double] = []
        var sumPower = 0.0
        var sumFreqPower = 0.0
        var row = [Double]()
        let tempFreq = (0..<lengthOfArray/2).map{i in i*2}
        let freq = tempFreq.map({Double($0)})
        var results = [Double](count: lengthOfArray/2, repeatedValue: 0.0)
        
        for i in 1...8 {
            
            tempVec = extractCol(power_array, electrode: i)
            let truncatedVec = Array(tempVec[0...63])           // extract single-sided power spectrum
            results = mul(truncatedVec, y: freq)                // element-wise multiplication of power and frequency array
            
            sumFreqPower = results.reduce(0, combine:+)         // summation of freq.*power
            sumPower = truncatedVec.reduce(0, combine:+)        // summation of power
            row.append(sumFreqPower/sumPower)                   // append MNF (= sum(freq*power)/sum(power))
            
            sumFreqPower = 0.0
            sumPower = 0.0
        }
        meanFreq.append(row)
    }
    

    // function to compute median power freq
    
    func calMedFreq(power_array: [[Double]]) {
        
        // freq = 0: (fs/100) : nyquist
        // med freq = 0.5 * sum(power)
        // single sided power spectrum used to calculate MDF
        
        var tempVec: [Double] = []
        var tempSum = 0.0
        var row = [Double]()
        let tempFreq = (0..<lengthOfArray/2).map{i in i*2}
        let freq = tempFreq.map({Double($0)})
        var cumSum = 0.0
        var mdfIndex = -1
        
        for i in 1...8 {
            
            tempVec = extractCol(power_array, electrode: i)
            let truncatedVec = tempVec[0...63]                  // extract single-sided power spectrum
            tempSum = truncatedVec.reduce(0, combine:+)/(2.0)   // half of total signal power
            cumSum = 0.0
            mdfIndex = -1
            
            while cumSum < tempSum {                            // find frequency where the cumulated signal power is half to total signal power
                mdfIndex += 1
                cumSum += tempVec[mdfIndex]
            }
            
            let temp = (tempSum-(cumSum-tempVec[mdfIndex]))/(tempVec[mdfIndex])
            row.append(Double(freq[mdfIndex])+(2.0*temp)-1.0)
        }
        medFreq.append(row)
    }
    
    

/********************************************** Regression Functions **********************************************/
     
    // function to find slope of linear regression line (i.e. rate of change)
    
    func calRateOfChange(value_array: [[Double]]) -> [Double] {
        
        var tempVec: [Double] = []
        let tempCountVec = Array(0..<value_array.count)
        let countVec = tempCountVec.map({Double($0)})
        var row: [Double] = []
        
        for i in 1...8{
            
            tempVec = extractCol(value_array, electrode: i)
            
            let meanx = mean(countVec)
            let meany = mean(tempVec)
            let meanxy = mean(mul(tempVec, y: countVec))
            let meanxx = mean(mul(countVec, y: countVec))
            
            let ror = (meanx * meany - meanxy) / (meanx * meanx - meanxx)
            row.append(ror)
        }
        
        return row
    }
    

}





