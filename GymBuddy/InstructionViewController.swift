//
//  InstructionViewController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 16/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation
import SwiftGifOrigin

class InstructionViewController: UIViewController {
    
    @IBAction func beginButtonPressed(sender: AnyObject) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("StatusViewController") as UIViewController
        let window = UIApplication.sharedApplication().windows[0] as UIWindow;
        window.rootViewController = vc;
    }
    @IBOutlet weak var slider: UISlider!
    @IBAction func sliderValueChanged(sender: AnyObject) {
        let weight = Int(slider.value)
        status.weight.value = weight
        weightLabel.text = "\(weight) KG"
    }
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var exerciseInstructions: UILabel!
    
    var exercises: [String] = ["forearm curls", "bicep curls"]
    
    @IBAction func instructUser() {
        let exerciseIndex = status.exercise.value
        let exerciseSelected = exercises[exerciseIndex]
        var startStr = "start"
        if beganExercise
        {
            startStr = "continue"
        }
        exerciseInstructions.text = "Let's \(startStr) with \(status.repLimit.value) reps of \(exerciseSelected) for a total of \(status.setLimit.value) sets. You should use \(status.weight.value) KG dumbbells"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rc = RestController()
        if !beganExercise
        {
            rc.initExercise()
        }
        else
        {
            rc.nextExercise()
        }
        var syncGif: UIImage!
        syncGif = UIImage.gifWithName("\(status.exercise.value)")
        let gesture = UIImageView(image: syncGif)
        self.view.addSubview(gesture)
        gesture.frame = CGRectMake(self.view.frame.size.width/2 - 150, self.view.frame.size.height/2-100 , 300, 300)
        instructUser()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}