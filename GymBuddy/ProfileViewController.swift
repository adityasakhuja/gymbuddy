//
//  ProfileViewController.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 09/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation
import UIKit
import IGLDropDownMenu

class ProfileViewController: UIViewController, IGLDropDownMenuDelegate {
    
    let sexMenu = IGLDropDownMenu()
    var dataImage:NSArray = ["male.png", "female.png", "trans.png"]
    var dataTitle:NSArray = ["Male","Female","Unknown"]
    
    var height: Int = 0
    var age: Int = 0
    var sex: Int = 0
    
    var loaded = false
    
    var tap: UITapGestureRecognizer = UITapGestureRecognizer()
    
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var heightText: UITextField!
    
    
    @IBAction func ageEditing(sender: AnyObject) {
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func heightEditing(sender: AnyObject) {
        view.addGestureRecognizer(tap)
    }
    
    
    @IBAction func buttonPressed(sender: AnyObject) {
        age = Int(ageText.text!)!
        height = Int(heightText.text!)!
        let user = User(age: age, heightU: height, sex: sex)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(user, toFile: User.ArchiveURL.path!)
        if isSuccessfulSave {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ListViewController") as UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    }
    
    func setupMenu() {
        
        var dropdownItems:NSMutableArray = NSMutableArray()
        
        for i in 0...(dataTitle.count-1) {
            let item = IGLDropDownItem()
            item.iconImage = UIImage(named: "\(dataImage[i])")
            item.text = "\(dataTitle[i])"
            dropdownItems.addObject(item)
        }
        
        sexMenu.menuText = "Sex"
        sexMenu.type = IGLDropDownMenuType.Stack
        sexMenu.gutterY = 5
        sexMenu.itemAnimationDelay = 0.1
        sexMenu.rotate = IGLDropDownMenuRotate.Random
        sexMenu.dropDownItems = dropdownItems as [AnyObject]
        sexMenu.paddingLeft = 15
        sexMenu.frame = CGRectMake((self.view.frame.size.width/2) - 100, 300, 200, 45)
        if loaded
        {
            sexMenu.menuText = "\(dataTitle[sex])"
            sexMenu.menuIconImage = UIImage(named: "\(dataImage[sex])")
        }
        sexMenu.delegate = self
        sexMenu.reloadView()
        
        self.view.addSubview(self.sexMenu)
    }
    
    func dropDownMenu(dropDownMenu: IGLDropDownMenu!, selectedItemAtIndex index: Int)
    {
        sex = index
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let savedUser = NSKeyedUnarchiver.unarchiveObjectWithFile(User.ArchiveURL.path!) as! User?
        {
            ageText.text = "\(savedUser.age)"
            heightText.text = "\(savedUser.heightU)"
            sex = savedUser.sex
            loaded = true
        }
        
        setupMenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        view.removeGestureRecognizer(tap)
    }
    
    
}