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
    var currentPose: TLMPose!
    var currentEmg: TLMEmgEvent!
    
    @IBOutlet weak var fatigueLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var correctnessLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
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
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func didDisconnectDevice(notification: NSNotification) {
        print("disconnected =(")
    }
    
    func didRecognizeArm(notification: NSNotification) {
        let eventData = notification.userInfo as! Dictionary<NSString, TLMArmSyncEvent>
        let armEvent = eventData[kTLMKeyArmSyncEvent]!
        
        var arm = armEvent.arm == .Right ? "Right" : "Left"
        var direction = armEvent.xDirection == .TowardWrist ? "Towards Wrist" : "Toward Elbow"
        print("SYNCED: Arm: \(arm) X-Direction: \(direction)")
        
        armEvent.myo!.vibrateWithLength(.Short)
        armEvent.myo!.setStreamEmg(.Enabled)
    }
    
    func didLoseArm(notification: NSNotification) {
        print("Perform the Sync Gesture")
    }
    
    func didRecieveEmgEvent(notification: NSNotification) {
        let eventData = notification.userInfo as! Dictionary<NSString, TLMEmgEvent>
        let emgEvent = eventData[kTLMKeyEMGEvent]!
        
        let emg = 1
    }
    
    func didRecieveAccelerationEvent(notification: NSNotification) {
        let eventData = notification.userInfo as! Dictionary<NSString, TLMAccelerometerEvent>
        let accelerometerEvent = eventData[kTLMKeyAccelerometerEvent]!
        
        let acceleration = GLKitPolyfill.getAcceleration(accelerometerEvent);
        print("\(acceleration.magnitude)")
        
        // Uncomment to show direction of acceleration
        print("x: \(acceleration.x)")
        print("y: \(acceleration.y)")
        print("z: \(acceleration.z)")
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