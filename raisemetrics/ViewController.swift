//
//  ViewController.swift
//  raisemetrics
//
//  Created by Stanislav Rastvorov on 10.06.16.
//  Copyright © 2016 Stanislav Rastvorov. All rights reserved.
//

import UIKit

var version = "1.0.2"

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        button1.layer.cornerRadius = 16.0
        button2.layer.cornerRadius = 16.0
        button3.layer.cornerRadius = 16.0
        button4.layer.cornerRadius = 16.0
        
//        let langId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
//        let countryId = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
//        let language = "\(langId)           -\(countryId)" // en-US on my machine
//        print(language)
        
//        print(NSLocale.currentLocale().localeIdentifier)
        
        
//        let language = NSLocale.preferredLanguages()[0]
//        print(language)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func build102ButtonPressed(sender: AnyObject) {
        version = "1.0.2"
        performSegueWithIdentifier("showNotesVC", sender: self)
    }
    
    @IBAction func build103buttonPressed(sender: AnyObject) {
        version = "1.0.3"
        performSegueWithIdentifier("showNotesVC", sender: self)
    }
    
    @IBAction func onboardingButtonPressed(sender: AnyObject) {
        version = "onboarding"
        performSegueWithIdentifier("showNotesVC", sender: self)
    }
    
    @IBAction func onboardingWithParallaxButtonPressed(sender: AnyObject) {
        version = "onboardingWithParallax"
        performSegueWithIdentifier("showNotesVC", sender: self)
    }
}

