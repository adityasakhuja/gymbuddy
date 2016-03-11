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

class StatusViewController: UIViewController {
    
    var timer = 0
    var emgEnabled = false
    
    // Status labels
    @IBOutlet weak var fatigueLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var correctnessLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialise the controllers
        let _ = FatigueController()
        let _ = CorrectnessController()
        
        // Bind labels to Status model
        status.fatigue
            .map {"\($0)"}
            .bindTo(fatigueLabel.bnd_text)
        status.reps
            .map {"\($0) Reps"}
            .bindTo(repsLabel.bnd_text)
        status.speed
            .map {"\($0)"}
            .bindTo(speedLabel.bnd_text)
        status.correctness
            .map {"\($0)"}
            .bindTo(correctnessLabel.bnd_text)
        
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
        
        let acceleration = GLKitPolyfill.getAcceleration(accelerometerEvent);
        
        accXGlobal = shiftPush(accXGlobal, element: Double(acceleration.x), maxSize: 25)
        accYGlobal = shiftPush(accYGlobal, element: Double(acceleration.y), maxSize: 25)
        accZGlobal = shiftPush(accZGlobal, element: Double(acceleration.z), maxSize: 25)
        
        aMagLabel.text = "Mag: \(acceleration.magnitude)"
        aXLabel.text = "X: \(acceleration.x)"
        aYLabel.text = "Y: \(acceleration.y)"
        aZLabel.text = "Z: \(acceleration.z)"
        
        if !emgEnabled
        {
            accelerometerEvent.myo!.setStreamEmg(.Enabled)
            emgEnabled = true
        }
    }
    
    func didRecieveOrientationEvent(notification: NSNotification) {
        let eventData = notification.userInfo as! Dictionary<NSString, TLMOrientationEvent>
        let orientationEvent = eventData[kTLMKeyOrientationEvent]!
        
        let angles = GLKitPolyfill.getOrientation(orientationEvent)
        let pitch = CGFloat(angles.pitch.radians)
        let yaw = CGFloat(angles.yaw.radians)
        let roll = CGFloat(angles.roll.radians)
        let rotationAndPerspectiveTransform:CATransform3D = CATransform3DConcat(CATransform3DConcat(CATransform3DRotate (CATransform3DIdentity, pitch, -1.0, 0.0, 0.0), CATransform3DRotate(CATransform3DIdentity, yaw, 0.0, 1.0, 0.0)), CATransform3DRotate(CATransform3DIdentity, roll, 0.0, 0.0, -1.0))
        
        // Apply the rotation and perspective transform to helloLabel.
        helloLabel.layer.transform = rotationAndPerspectiveTransform
    }
    
    func timerDidFire()
    {
        timer++
        
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
    }
}