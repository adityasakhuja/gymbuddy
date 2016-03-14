//
//  WeightViewController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 12/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation

class WeightViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBAction func sliderValueChanged(sender: AnyObject) {
        let weight = Int(slider.value)
        status.weight.value = weight
        weightLabel.text = "\(weight) KG"
    }
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var exerciseInstructions: UILabel!
    
    var exercises: [String] = ["Forearm curl", "Bicep curl", "Bench press"]
    
    @IBAction func instructUser() {
        var repsCount = status.repLimit.value
        var setCount = status.setLimit.value
        var exerciseIndex = status.exercise.value
        var exerciseSelected = exercises[exerciseIndex]
        exerciseInstructions = "Let's start with " + repsCount + " reps of " + exerciseSelected + " for a total of " + setCount + " sets."
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
}