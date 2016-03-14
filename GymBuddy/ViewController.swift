//
//  ViewController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 09/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import UIKit
//import GLKit

class ViewController: UIViewController {
    
    var connected = false

    @IBAction func connectButton(sender: AnyObject) {
        //let controller = TLMSettingsViewController.settingsInNavigationController()
        //presentViewController(controller, animated: true, completion: nil)
        print("Looking for MYO.............")
        TLMHub.sharedHub().attachToAdjacent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notifer = NSNotificationCenter.defaultCenter()
        // Data notifications are received through NSNotificationCenter.
        notifer.addObserver(self, selector: "didConnectDevice:", name: TLMHubDidConnectDeviceNotification, object: nil)
        notifer.addObserver(self, selector: "didDisconnectDevice:", name: TLMHubDidDisconnectDeviceNotification, object: nil)
        // Posted whenever the user does a Sync Gesture, and the Myo is calibrated
        notifer.addObserver(self, selector: "didRecognizeArm:", name: TLMMyoDidReceiveArmSyncEventNotification, object: nil)
        // Posted whenever Myo loses its calibration (when Myo is taken off, or moved enough on the user's arm)
        notifer.addObserver(self, selector: "didLoseArm:", name: TLMMyoDidReceiveArmUnsyncEventNotification, object: nil)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func didConnectDevice(notification: NSNotification) {
        // Show a list of exercises
        print("Connected")
        connected = true
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("CalibrationViewController") as UIViewController
        let window = UIApplication.sharedApplication().windows[0] as UIWindow;
        window.rootViewController = vc;
    }
    
    func didDisconnectDevice(notification: NSNotification) {
        print("disconnected =(")
        connected = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if connected
        {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("CalibrationViewController") as UIViewController
            let window = UIApplication.sharedApplication().windows[0] as UIWindow;
            window.rootViewController = vc;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didRecognizeArm(notification: NSNotification) {
        syncedGlobal = true
    }
    
    func didLoseArm(notification: NSNotification) {
        syncedGlobal = false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

}

