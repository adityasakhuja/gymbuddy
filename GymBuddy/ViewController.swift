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
    
    var connected = false

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
        connected = true
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
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ListViewController") as UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            
            
//            let listViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ListViewController") as! ListViewController
//            self.navigationController?.pushViewController(listViewController, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

