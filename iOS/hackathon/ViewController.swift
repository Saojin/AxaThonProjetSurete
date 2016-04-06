//
//  ViewController.swift
//  hackathon
//
//  Created by julien hamon on 06/04/2016.
//  Copyright © 2016 julien hamon. All rights reserved.
//

import UIKit
import PeanutHandler

class ViewController: UIViewController,PeanutManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let peanutHandler = PeanutManager.sharedInstance()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func peanutManagerDidDiscoverPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler) {
        print("Discore Peanut\(peanutHandler)")
    }


}

