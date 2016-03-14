//
//  StatusViewController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 09/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation
import UIKit
import Bond
import MBCircularProgressBar

class StatusViewController: UIViewController {
    
    var timer = 0
    var emgEnabled = false
    var resting = false
    
    // Status labels
    @IBOutlet weak var fatigueText: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var speedText: UILabel!
    @IBOutlet weak var correctnessLabel: UILabel!
    @IBOutlet weak var correctnessText: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var speedLabelC: MBCircularProgressBarView!
    @IBOutlet weak var fatigueLabelC: MBCircularProgressBarView!
    
    @IBOutlet weak var endButton: UIButton!
    
    // Resting labels
    @IBOutlet weak var repsNextLabel: UILabel!
    @IBOutlet weak var weightsLabel: UILabel!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var nextSetLabel: UILabel!
    
    // Debugging labels
    @IBOutlet weak var connectedLabel: UILabel!
    @IBOutlet weak var aMagLabel: UILabel!
    @IBOutlet weak var aXLabel: UILabel!
    @IBOutlet weak var aYLabel: UILabel!
    @IBOutlet weak var aZLabel: UILabel!
    @IBOutlet weak var emg1: UILabel!
    @IBOutlet weak var emg2: UILabel!
    @IBOutlet weak var emg3: UILabel!
    @IBOutlet weak var emg4: UILabel!
    @IBOutlet weak var emg5: UILabel!
    @IBOutlet weak var emg6: UILabel!
    @IBOutlet weak var emg7: UILabel!
    @IBOutlet weak var emg8: UILabel!
    @IBOutlet weak var helloLabel: UILabel!
    
    @IBAction func endButtonPressed(sender: AnyObject) {
        if resting
        {
            //Show status labels
            fatigueText.hidden = false
            repsLabel.hidden = false
            correctnessLabel.hidden = false
            correctnessText.hidden = false
            speedText.hidden = false
            speedLabelC.hidden = false
            fatigueLabelC.hidden = false
            
            // Hide resting labels
            repsNextLabel.hidden = true
            weightsLabel.hidden = true
            restLabel.hidden = true
            nextSetLabel.hidden = true
            
            // Change the Button
            endButton.backgroundColor = UIColor.redColor()
            endButton.setTitle("End exercise", forState: .Normal)
            
            // Reset timer
            timer = 0
            
            // Update system state
            resting = false
        }
        else
        {
//            // Print center value
//            print("CENTER VALUE:")
//            NSLog("%@", centerGlobal)
//            // Print the first unadjusted orientation
//            print("First orientation:")
//            NSLog("%@", orientationGlobal[0])
//            // Adjust orientation array
            var orientationNew: [Float] = []
            for orientation in orientationGlobal
            {
                orientationNew.append(orientation.w)
            }
            // Print new orientation array
            NSLog("%@", orientationNew)
            
            // Initialise RestController
            let _ = RestController()
            
            //Hide status labels
            fatigueText.hidden = true
            repsLabel.hidden = true
            correctnessLabel.hidden = true
            correctnessText.hidden = true
            speedText.hidden = true
            speedLabelC.hidden = true
            fatigueLabelC.hidden = true
            
            // Show resting labels
            repsNextLabel.hidden = false
            weightsLabel.hidden = false
            restLabel.hidden = false
            nextSetLabel.hidden = false
            
            // Change the Button
            endButton.backgroundColor = UIColor.blueColor()
            endButton.setTitle("Continue", forState: .Normal)
            
            // Update system state
            resting = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialise the controllers
        let _ = FatigueController()
        let _ = CorrectnessController()
        
        // Bind labels to Status model
        status.fatigue.observe { value in
            if value < 3 || value == 4
            {
                self.fatigueLabelC.progressColor = UIColor.yellowColor()
            }
            else if value == 3
            {
                self.fatigueLabelC.progressColor = UIColor.greenColor()
            }
            else
            {
                self.fatigueLabelC.progressColor = UIColor.redColor()
            }
            
            self.fatigueLabelC.value = CGFloat(value)
        }
        
        rest.time.observe { value in
            self.timer = value
        }
        
        status.reps
            .map {"\($0) Reps"}
            .bindTo(repsLabel.bnd_text)
        
        status.speed.observe { value in
            var val = 0
            if value < 0
            {
                self.speedLabelC.progressColor = UIColor.greenColor()
                self.speedLabelC.emptyLineColor = UIColor.redColor()
            }
            else
            {
                self.speedLabelC.progressColor = UIColor.redColor()
                self.speedLabelC.emptyLineColor = UIColor.greenColor()
            }
            
            if value > 40
            {
                val = 40
            }
            else
            {
                val = value
            }
            self.speedLabelC.value = CGFloat(val)
        }
        
        status.correctness
            .map {"\($0)"}
            .bindTo(correctnessLabel.bnd_text)
        
        // Bind labels to rest
        status.weight
            .map {"Use \($0) KG weights"}
            .bindTo(weightsLabel.bnd_text)
        
        rest.reps
            .map {"Do \($0) reps"}
            .bindTo(repsNextLabel.bnd_text)
        
        // Start the timer
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerDidFire", userInfo: nil, repeats: true)
        
        //TLMMyo.setStreamEmg(.Enabled)
        
        // Myo notifications
        let notifer = NSNotificationCenter.defaultCenter()
        notifer.addObserver(self, selector: "didDisconnectDevice:", name: TLMHubDidDisconnectDeviceNotification, object: nil)
        // Posted whenever the user does a Sync Gesture, and the Myo is calibrated
        notifer.addObserver(self, selector: "didRecognizeArm:", name: TLMMyoDidReceiveArmSyncEventNotification, object: nil)
        // Posted whenever Myo loses its calibration (when Myo is taken off, or moved enough on the user's arm)
        notifer.addObserver(self, selector: "didLoseArm:", name: TLMMyoDidReceiveArmUnsyncEventNotification, object: nil)
        // Notifications for EMG event are posted at a rate of 50 Hz.
        notifer.addObserver(self, selector: "didRecieveEmgEvent:", name: TLMMyoDidReceiveEmgEventNotification, object: nil)
        // Notifications accelerometer event are posted at a rate of 50 Hz.
        notifer.addObserver(self, selector: "didRecieveAccelerationEvent:", name: TLMMyoDidReceiveAccelerometerEventNotification, object: nil)
        // Notifications for orientation event are posted at a rate of 50 Hz.
        notifer.addObserver(self, selector: "didRecieveOrientationEvent:", name: TLMMyoDidReceiveOrientationEventNotification, object: nil)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func didDisconnectDevice(notification: NSNotification) {
        print("disconnected =(")
    }
    
    func didRecognizeArm(notification: NSNotification) {
        let eventData = notification.userInfo as! Dictionary<NSString, TLMArmSyncEvent>
        let armEvent = eventData[kTLMKeyArmSyncEvent]!
        
        armEvent.myo!.vibrateWithLength(.Short)
        if !emgEnabled
        {
            armEvent.myo!.setStreamEmg(.Enabled)
            emgEnabled = true
        }
        
        connectedLabel.text = "Synced"
        connectedLabel.backgroundColor = UIColor.blueColor()
    }
    
    func didLoseArm(notification: NSNotification) {
        print("Perform the Sync Gesture")
        connectedLabel.text = "Unsynced"
        connectedLabel.backgroundColor = UIColor.redColor()
    }
    
    func didRecieveEmgEvent(notification: NSNotification) {
        let eventData = notification.userInfo as! Dictionary<NSString, TLMEmgEvent>
        let emgEvent = eventData[kTLMKeyEMGEvent]!
        let emgData = emgEvent.rawData as! [Double]
        
        // Store EMG data globally
        emgDataGlobal = shiftPushArray(emgDataGlobal, element: emgData, maxSize: 100)
        
        emg1.text = "\(Int(emgData[0]))"
        emg2.text = "\(Int(emgData[1]))"
        emg3.text = "\(Int(emgData[2]))"
        emg4.text = "\(Int(emgData[3]))"
        emg5.text = "\(Int(emgData[4]))"
        emg6.text = "\(Int(emgData[5]))"
        emg7.text = "\(Int(emgData[6]))"
        emg8.text = "\(Int(emgData[7]))"
    }
    
    func didRecieveAccelerationEvent(notification: NSNotification) {
        let eventData = notification.userInfo as! Dictionary<NSString, TLMAccelerometerEvent>
        let accelerometerEvent = eventData[kTLMKeyAccelerometerEvent]!
        
        let mag = TLMVector3Length(accelerometerEvent.vector)
        let xVal = accelerometerEvent.vector.x
        let yVal = accelerometerEvent.vector.y
        let zVal = accelerometerEvent.vector.z
        
        accXGlobal = shiftPush(accXGlobal, element: Double(xVal), maxSize: 50)
        accYGlobal = shiftPush(accYGlobal, element: Double(yVal), maxSize: 50)
        accZGlobal = shiftPush(accZGlobal, element: Double(zVal), maxSize: 50)
        
        aMagLabel.text = "Mag: \(mag)"
        aXLabel.text = "X: \(xVal)"
        aYLabel.text = "Y: \(yVal)"
        aZLabel.text = "Z: \(zVal)"
        
        if !emgEnabled
        {
            accelerometerEvent.myo!.setStreamEmg(.Enabled)
            emgEnabled = true
        }
    }
    
    func didRecieveOrientationEvent(notification: NSNotification) {
        if !resting
        {
            let eventData = notification.userInfo as! Dictionary<NSString, TLMOrientationEvent>
            let orientationEvent = eventData[kTLMKeyOrientationEvent]!
            
            let angles = TLMEulerAngles(quaternion: orientationEvent.quaternion)
            
            let pitch = CGFloat(angles.pitch.radians)
            let yaw = CGFloat(angles.yaw.radians)
            let roll = CGFloat(angles.roll.radians)
            
            // Append global orientation array
            orientationGlobal.append(TLMQuaternionMultiply(orientationEvent.quaternion, centerGlobal))
            
            let rotationAndPerspectiveTransform:CATransform3D = CATransform3DConcat(CATransform3DConcat(CATransform3DRotate (CATransform3DIdentity, pitch, -1.0, 0.0, 0.0), CATransform3DRotate(CATransform3DIdentity, yaw, 0.0, 1.0, 0.0)), CATransform3DRotate(CATransform3DIdentity, roll, 0.0, 0.0, -1.0))
            
            // Apply the rotation and perspective transform to helloLabel.
            helloLabel.layer.transform = rotationAndPerspectiveTransform
        }
    }
    
    func timerDidFire()
    {
        if resting{
            timer--
        }
        else
        {
            timer++
        }
        
        if timer > 0
        {
            //calculate the minutes in elapsed time.
            let minutes = Int(floor(Double(timer)/Double(60)))
            var minutesText = "\(minutes)"
            if minutes < 10
            {
                minutesText = "0\(minutes)"
            }
            
            //calculate the seconds in elapsed time.
            let seconds = timer % 60
            var secondsText = "\(seconds)"
            if seconds < 10
            {
                secondsText = "0\(seconds)"
            }
            
            // Display the time
            timerLabel.text = "\(minutesText):\(secondsText)"
            timerLabel.textColor = UIColor.blackColor()
        }
        else
        {
            timerLabel.text = "00:00"
            timerLabel.textColor = UIColor.redColor()
        }
    }
}