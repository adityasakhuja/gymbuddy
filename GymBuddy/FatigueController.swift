//
//  FatigueController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 10/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation
import GLKit

class FatigueController {
    
    init()
    {
        status.fatigue.value = 3
        let notifer = NSNotificationCenter.defaultCenter()
        // Posted whenever the user does a Sync Gesture, and the Myo is calibrated
        notifer.addObserver(self, selector: "didRecognizeArm:", name: TLMMyoDidReceiveArmSyncEventNotification, object: nil)
        // Posted whenever Myo loses its calibration (when Myo is taken off, or moved enough on the user's arm)
        notifer.addObserver(self, selector: "didLoseArm:", name: TLMMyoDidReceiveArmUnsyncEventNotification, object: nil)
        // Notifications for EMG event are posted at a rate of 50 Hz.
        notifer.addObserver(self, selector: "didReceiveEmgEvent:", name: TLMMyoDidReceiveEmgEventNotification, object: nil)
    }
    
    func didRecognizeArm(notification: NSNotification) {
        let eventData = notification.userInfo as! Dictionary<NSString, TLMArmSyncEvent>
        let armEvent = eventData[kTLMKeyArmSyncEvent]!
        
        var arm = armEvent.arm == .Right ? "Right" : "Left"
        var direction = armEvent.xDirection == .TowardWrist ? "Towards Wrist" : "Toward Elbow"
        print("SYNCED: Arm: \(arm) X-Direction: \(direction)")
        
        armEvent.myo!.vibrateWithLength(.Short)
    }
    
    func didLoseArm(notification: NSNotification) {
        print("Perform the Sync Gesture")
    }
    
    func didReceiveEmgEvent(notification: NSNotification) {
        let eventData = notification.userInfo as! Dictionary<NSString, TLMEmgEvent>
        let emgEvent = eventData[kTLMKeyEMGEvent]!
        
        let emg = 1
    }
}