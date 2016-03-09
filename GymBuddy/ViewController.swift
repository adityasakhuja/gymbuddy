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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let controller = TLMSettingsViewController.settingsInNavigationController()
        presentViewController(controller, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

