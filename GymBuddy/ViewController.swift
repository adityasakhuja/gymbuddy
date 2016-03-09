//
//  ViewController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 09/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import UIKit
import GLKit

class ViewController: UIViewController {

    @IBAction func connectButton(sender: AnyObject) {
        let controller = TLMSettingsViewController.settingsInNavigationController()
        presentViewController(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notifer = NSNotificationCenter.defaultCenter()
        // Data notifications are received through NSNotificationCenter.
        notifer.addObserver(self, selector: "didConnectDevice:", name: TLMHubDidConnectDeviceNotification, object: nil)
        notifer.addObserver(self, selector: "didDisconnectDevice:", name: TLMHubDidDisconnectDeviceNotification, object: nil)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func didConnectDevice(notification: NSNotification) {
        // Show a list of exercises
        print("Connected")
    }
    
    func didDisconnectDevice(notification: NSNotification) {
        print("disconnected =(")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

