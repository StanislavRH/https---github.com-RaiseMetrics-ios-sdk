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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
}

