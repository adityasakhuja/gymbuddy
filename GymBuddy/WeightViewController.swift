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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}