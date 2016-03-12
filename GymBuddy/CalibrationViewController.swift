//
//  CalibrationViewController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 12/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation
import Bond

class CalibrationViewController: UIViewController {
    
    var orientation: [[Double]] = []
    var currentPose: TLMPose!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Myo notifications
        let notifer = NSNotificationCenter.defaultCenter()
        // Notifications for orientation event are posted at a rate of 50 Hz.
        notifer.addObserver(self, selector: "didRecieveOrientationEvent:", name: TLMMyoDidReceiveOrientationEventNotification, object: nil)
        // Posted when one of the pre-configued geatures is recognized (e.g. Fist, Wave In, Wave Out, etc)
        notifer.addObserver(self, selector: "didChangePose:", name: TLMMyoDidReceivePoseChangedNotification, object: nil)
        // Posted whenever the user does a Sync Gesture, and the Myo is calibrated
        notifer.addObserver(self, selector: "didRecognizeArm:", name: TLMMyoDidReceiveArmSyncEventNotification, object: nil)
        // Posted whenever Myo loses its calibration (when Myo is taken off, or moved enough on the user's arm)
        notifer.addObserver(self, selector: "didLoseArm:", name: TLMMyoDidReceiveArmUnsyncEventNotification, object: nil)
        TLMHub.sharedHub().lockingPolicy = .None
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func didRecieveOrientationEvent(notification: NSNotification) {
        let eventData = notification.userInfo as! Dictionary<NSString, TLMOrientationEvent>
        let orientationEvent = eventData[kTLMKeyOrientationEvent]!
        
        let angles = TLMEulerAngles(quaternion: orientationEvent.quaternion)
        
        let pitch = CGFloat(angles.pitch.radians)
        let yaw = CGFloat(angles.yaw.radians)
        let roll = CGFloat(angles.roll.radians)
        
        // Append global orientation array
        orientation.append([Double(pitch), Double(yaw), Double(roll)])
    }
    
    func didChangePose(notification: NSNotification) {
        let eventData = notification.userInfo as! Dictionary<NSString, TLMPose>
        currentPose = eventData[kTLMKeyPose]!
        
        switch (currentPose.type) {
        case .Fist:
            centerGlobal = orientation.last!
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ProfileViewController") as UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        default: break // .Rest or .Unknown
        }
    }
    
    func didRecognizeArm(notification: NSNotification) {
        topLabel.text = "Your Myo is now synced!"
        middleLabel.text = "Now you need to calibrate your Myo. To do this, follow the graphic below:"
    }
    
    func didLoseArm(notification: NSNotification) {
        topLabel.text = "Your Myo is now unsynced! =("
        middleLabel.text = "You need to sync your Myo again. To do this, follow the graphic below:"
    }
}