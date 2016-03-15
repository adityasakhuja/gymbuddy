//
//  WeightViewController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 12/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation

class WeightViewController: UIViewController {
    
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
    
    var exercises: [String] = ["Forearm curl", "Bicep curl"]
    
    @IBAction func instructUser() {
        let exerciseIndex = status.exercise.value
        let exerciseSelected = exercises[exerciseIndex]
        exerciseInstructions.text = "Let's start with \(status.repLimit.value) reps of  \(exerciseSelected) for a total of \(status.setLimit.value)  sets."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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