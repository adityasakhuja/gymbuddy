//
//  CalibrationViewController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 12/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation
import Bond
import SwiftGifOrigin

class CalibrationViewController: UIViewController {
    
    var orientation: [TLMQuaternion] = []
    var currentPose: TLMPose!
    var isSaved = false
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = NSKeyedUnarchiver.unarchiveObjectWithFile(Myo.ArchiveURL.path!) as! Myo?
        {
            isSaved = true
        }
        
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

        var syncGif: UIImage!
        
        if syncedGlobal
        {
            topLabel.text = "Your Myo is now synced!"
            middleLabel.text = "Now you need to calibrate your Myo. To do this, follow the graphic below:"
            syncGif = UIImage.gifWithName("callibrate")
        }
        else {
            syncGif = UIImage.gifWithName("sync")
        }
        
        let gesture = UIImageView(image: syncGif)
        self.view.addSubview(gesture)
        gesture.frame = CGRectMake(self.view.frame.size.width/2 - 150, self.view.frame.size.height/2 , 300, 300)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func didRecieveOrientationEvent(notification: NSNotification) {
        let eventData = notification.userInfo as! Dictionary<NSString, TLMOrientationEvent>
        let orientationEvent = eventData[kTLMKeyOrientationEvent]!
        
        // Append local orientation array
        orientation.append(orientationEvent.quaternion)
        
        if !isSaved
        {
            isSaved = true
            let myo = Myo(myo: orientationEvent.myo!.identifier)
            let _ = NSKeyedArchiver.archiveRootObject(myo, toFile: Myo.ArchiveURL.path!)
        }
    }
    
    func didChangePose(notification: NSNotification) {
        if syncedGlobal
        {
            let eventData = notification.userInfo as! Dictionary<NSString, TLMPose>
            currentPose = eventData[kTLMKeyPose]!
            
            switch (currentPose.type) {
            case .Fist:
                centerGlobal = TLMQuaternionInvert(orientation.last!)
                let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ProfileViewController") as UIViewController
                let window = UIApplication.sharedApplication().windows[0] as UIWindow;
                window.rootViewController = vc;
            default: break // .Rest or .Unknown
            }
        }
    }
    
    func didRecognizeArm(notification: NSNotification) {
        topLabel.text = "Your Myo is now synced!"
        middleLabel.text = "Now you need to calibrate your Myo. To do this, follow the graphic below:"
        syncedGlobal = true
    }
    
    func didLoseArm(notification: NSNotification) {
        topLabel.text = "Your Myo is now unsynced! =("
        middleLabel.text = "You need to sync your Myo again. To do this, follow the graphic below:"
        syncedGlobal = false
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}