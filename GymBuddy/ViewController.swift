//
//  ViewController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 09/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import UIKit
import SwiftSpinner
import CoreData

class ViewController: UIViewController {
    
    var connected = false
    var isSaved = false
    
    // Historical data
    let debug = false
    var exerciseHistorical: [Int] = []
    var speed: [[Int]] = []
    var correctness: [[Int]] = []

    @IBAction func connectButton(sender: AnyObject) {
        if let savedMyo = NSKeyedUnarchiver.unarchiveObjectWithFile(Myo.ArchiveURL.path!) as! Myo?
        {
            isSaved = true
            SwiftSpinner.show("Connecting...")
            let myo = savedMyo.myo
            TLMHub.sharedHub().attachByIdentifier(myo)
        }
        else
        {
            let controller = TLMSettingsViewController.settingsInNavigationController()
            presentViewController(controller, animated: true, completion: nil)
            //TLMHub.sharedHub().attachToAdjacent()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(debug)
        {
            getHistorical()
        }
        
        let notifer = NSNotificationCenter.defaultCenter()
        // Data notifications are received through NSNotificationCenter.
        notifer.addObserver(self, selector: "didConnectDevice:", name: TLMHubDidConnectDeviceNotification, object: nil)
        notifer.addObserver(self, selector: "didDisconnectDevice:", name: TLMHubDidDisconnectDeviceNotification, object: nil)
//        // Posted whenever the user does a Sync Gesture, and the Myo is calibrated
//        notifer.addObserver(self, selector: "didRecognizeArm:", name: TLMMyoDidReceiveArmSyncEventNotification, object: nil)
//        // Posted whenever Myo loses its calibration (when Myo is taken off, or moved enough on the user's arm)
//        notifer.addObserver(self, selector: "didLoseArm:", name: TLMMyoDidReceiveArmUnsyncEventNotification, object: nil)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func didConnectDevice(notification: NSNotification) {
        // Show a list of exercises
        print("Connected")
        connected = true
        if isSaved
        {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("CalibrationViewController") as UIViewController
            let window = UIApplication.sharedApplication().windows[0] as UIWindow;
            window.rootViewController = vc;
        }
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
    
    func getHistorical()
    {
        // Fetch data from CoreData
        var exerciseDatas = [NSManagedObject]()
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "ExerciseData")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            exerciseDatas = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        // Save data to local arrays
        for data in exerciseDatas
        {
            var arrString = data.valueForKey("speed") as? String
            print(arrString)
            var arr = arrString!.characters.split{$0 == "-"}.map(String.init).map {Int($0)!}
            speed.append(arr)
            arrString = data.valueForKey("correctness") as? String
            arr = arrString!.characters.split{$0 == "-"}.map(String.init).map {Int($0)!}
            correctness.append(arr)
            exerciseHistorical.append((data.valueForKey("exercise") as? Int)!)
        }
        //print(exerciseHistorical)
        //print(speed)
        //print(correctness)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

}

