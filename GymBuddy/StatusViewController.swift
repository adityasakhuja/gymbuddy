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

class StatusViewController: UIViewController {
    
    var timer = 0
    
    @IBOutlet weak var fatigueLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var correctnessLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bind labels to Status model
        status.fatigue
            .map {"\($0)"}
            .bindTo(fatigueLabel.bnd_text)
        status.reps
            .map {"\($0) Reps"}
            .bindTo(repsLabel.bnd_text)
        status.speed
            .map {"\($0)"}
            .bindTo(speedLabel.bnd_text)
        status.correctness
            .map {"\($0)"}
            .bindTo(correctnessLabel.bnd_text)
        
        // Start the timer
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerDidFire", userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func timerDidFire()
    {
        timer++
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
    }
}