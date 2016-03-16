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
import CoreData
import MSSimpleGauge

class StatusViewController: UIViewController {
    
    var timer = 0
    var emgEnabled = false
    var resting = false
    
    // Gauges
    var fatigueGauge = MSRangeGauge()
    var speedGauge = MSRangeGauge()
    var correctnessGauge = MSSimpleGauge()
    
    // Status labels
    @IBOutlet weak var fatigueText: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var speedText: UILabel!
    @IBOutlet weak var correctnessText: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var endButton: UIButton!
    
    // Resting labels
    @IBOutlet weak var repsNextLabel: UILabel!
    @IBOutlet weak var weightsLabel: UILabel!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var nextSetLabel: UILabel!
    
    // Initialise the controllers
    let fC = FatigueController()
    let cC = CorrectnessController()
    
    @IBAction func endButtonPressed(sender: AnyObject) {
        if resting
        {
            //Show status labels
            fatigueText.hidden = false
            repsLabel.hidden = false
            setLabel.hidden = false
            correctnessText.hidden = false
            speedText.hidden = false
            fatigueGauge.hidden = false
            speedGauge.hidden = false
            correctnessGauge.hidden = false
            
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
            
            //Reset reps
            status.reps.value = 0
            
            // Update system state
            resting = false
            
            // Resume controllers
            cC.resume()
        }
        else
        {
            
            // Stop the controllers
            cC.stop()
            
            // Store data in CoreData
            var exerciseDatas = [NSManagedObject]()
            //1
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            //2
            let entity =  NSEntityDescription.entityForName("ExerciseData",
                inManagedObjectContext:managedContext)
            
            let exerciseData = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext)
            
            //3
            exerciseData.setValue(fatigueGlobal.map {"\($0)"}.joinWithSeparator("-"), forKey: "fatigues")
            exerciseData.setValue(status.reps.value, forKey: "reps")
            exerciseData.setValue(status.weight.value, forKey: "weights")
            exerciseData.setValue(status.exercise.value, forKey: "exercise")
            
            //4
            do {
                try managedContext.save()
                //5
                exerciseDatas.append(exerciseData)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            //Hide status labels
            fatigueText.hidden = true
            repsLabel.hidden = true
            setLabel.hidden = true
            correctnessText.hidden = true
            speedText.hidden = true
            fatigueGauge.hidden = true
            speedGauge.hidden = true
            correctnessGauge.hidden = true
            
            //Increment set
            if (status.sets.value < status.setLimit.value) {
                status.sets.value++
                // Show resting labels
                repsNextLabel.hidden = false
                weightsLabel.hidden = false
                restLabel.hidden = false
                nextSetLabel.hidden = false
                
                // Change the Button
                endButton.backgroundColor = UIColor.blackColor()
                endButton.setTitle("Continue", forState: .Normal)
            } else {
                status.sets.value = 1
                status.repLimit.value = 0
                endButton.hidden = true
                timerLabel.hidden = true
                let alertController = UIAlertController(title: "Sets Complete", message: "You have successfully completed the required sets for this exercise. Please continue with the next exercise.", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction) -> Void in self.pickExercise() }))
                presentViewController(alertController, animated: true, completion: nil)
            }
            // Initialise RestController
            let rc = RestController()
            rc.calculateNextReps()
            
            // Update system state
            resting = true
        }
    }
    
    @IBAction func pickExercise() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("InstructionViewController") as UIViewController
        let window = UIApplication.sharedApplication().windows[0] as UIWindow;
        window.rootViewController = vc;

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beganExercise = true
        status.reps.value = 0
        
        // Initialise the gauges
        speedGauge=MSRangeGauge( frame: CGRectMake(self.view.frame.size.width/2-30, 260, 200, 175) )
        speedGauge.minValue = 0
        speedGauge.maxValue = 80
        speedGauge.upperRangeValue = 50;
        speedGauge.lowerRangeValue = 30;
        //bigGauge.fillArcFillColor = UIColor.redColor()
        speedGauge.backgroundColor = UIColor.clearColor()
        //bigGauge.backgroundArcFillColor = UIColor.redColor()
        //bigGauge.fillArcStrokeColor = UIColor.clearColor()
        //bigGauge.backgroundArcStrokeColor = UIColor.clearColor()
        speedGauge.rangeFillColor = UIColor.greenColor()
        speedGauge.backgroundGradient = nil
        
        speedGauge.startAngle = 0
        speedGauge.endAngle = 180
        speedGauge.value = 40
        
        self.view.addSubview(speedGauge)
        
        fatigueGauge=MSRangeGauge( frame: CGRectMake(self.view.frame.size.width/2-30, 120, 200, 175) )
        fatigueGauge.minValue = 0
        fatigueGauge.maxValue = 100
        fatigueGauge.upperRangeValue = 70;
        fatigueGauge.lowerRangeValue = 30;
        //bigGauge.fillArcFillColor = UIColor.redColor()
        fatigueGauge.backgroundColor = UIColor.clearColor()
        //bigGauge.backgroundArcFillColor = UIColor.redColor()
        //bigGauge.fillArcStrokeColor = UIColor.clearColor()
        //bigGauge.backgroundArcStrokeColor = UIColor.clearColor()
        fatigueGauge.rangeFillColor = UIColor.greenColor()
        fatigueGauge.backgroundGradient = nil
        
        fatigueGauge.startAngle = 0
        fatigueGauge.endAngle = 180
        fatigueGauge.value = 50
        
        self.view.addSubview(fatigueGauge)
        
        correctnessGauge=MSSimpleGauge( frame: CGRectMake(self.view.frame.size.width/2-30, 400, 200, 175) )
        correctnessGauge.minValue = 0
        correctnessGauge.maxValue = 100
        correctnessGauge.fillArcFillColor = UIColor.greenColor()
        correctnessGauge.backgroundColor = UIColor.clearColor()
        //correctnessGauge.backgroundArcFillColor = UIColor.grayColor()
        correctnessGauge.fillArcStrokeColor = UIColor.clearColor()
        correctnessGauge.backgroundArcStrokeColor = UIColor.clearColor()
        correctnessGauge.backgroundGradient = nil
        
        correctnessGauge.startAngle = 0
        correctnessGauge.endAngle = 180
        correctnessGauge.value = 80
        
        self.view.addSubview(correctnessGauge)
        
        // Bind labels to Status model
        status.fatigue.observe { value in
            var val = 0
            switch value {
            case 1:
                val = 0
            case 2:
                val = 25
            case 3:
                val = 50
            case 4:
                val = 75
            case 5:
                val = 100
            default:
                break
            }
            
            self.fatigueGauge.value = Float(val)
        }
        
        rest.time.observe { value in
            self.timer = value
        }
        
        status.reps
            .map {"\(status.repLimit.value-$0) Reps left"}
            .bindTo(repsLabel.bnd_text)
        
        status.sets
            .map {"\($0-1) of \(status.setLimit.value) Sets completed"}
            .bindTo(setLabel.bnd_text)
        
        status.speed.observe { value in
            var val = 0
            
            if value > 40
            {
                val = 40
            }
            else if value < -40
            {
                val = -40
            }
            else
            {
                val = value
            }
            
            val += 40
            
            self.speedGauge.value = Float(val)
        }
        
        status.correctness.observe { value in
            if value < 50
            {
                self.correctnessGauge.fillArcFillColor = UIColor.redColor()
            }
            else if value < 80
            {
                self.correctnessGauge.fillArcFillColor = UIColor.yellowColor()
            }
            else
            {
                self.correctnessGauge.fillArcFillColor = UIColor.greenColor()
            }
            
            self.correctnessGauge.value = Float(value)
        }
        
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
    }
    
    func didLoseArm(notification: NSNotification) {
        print("Perform the Sync Gesture")
    }
    
    func didRecieveEmgEvent(notification: NSNotification) {
        let eventData = notification.userInfo as! Dictionary<NSString, TLMEmgEvent>
        let emgEvent = eventData[kTLMKeyEMGEvent]!
        let emgData = emgEvent.rawData as! [Double]
        
        // Store EMG data globally
        emgDataGlobal = shiftPushArray(emgDataGlobal, element: emgData, maxSize: 128)
    }
    
    func didRecieveAccelerationEvent(notification: NSNotification) {
        let eventData = notification.userInfo as! Dictionary<NSString, TLMAccelerometerEvent>
        let accelerometerEvent = eventData[kTLMKeyAccelerometerEvent]!
        
//        let mag = TLMVector3Length(accelerometerEvent.vector)
//        let xVal = accelerometerEvent.vector.x
//        let yVal = accelerometerEvent.vector.y
//        let zVal = accelerometerEvent.vector.z
//        
//        accXGlobal = shiftPush(accXGlobal, element: Double(xVal), maxSize: 50)
//        accYGlobal = shiftPush(accYGlobal, element: Double(yVal), maxSize: 50)
//        accZGlobal = shiftPush(accZGlobal, element: Double(zVal), maxSize: 50)
        
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
            
            // Append global orientation array
            orientationGlobal.append(TLMQuaternionMultiply(orientationEvent.quaternion, centerGlobal).w)
            orientationRepsGlobal.append(TLMQuaternionMultiply(orientationEvent.quaternion, centerGlobal).w)
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
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}