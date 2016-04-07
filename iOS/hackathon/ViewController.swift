//
//  ViewController.swift
//  hackathon
//
//  Created by julien hamon on 06/04/2016.
//  Copyright © 2016 julien hamon. All rights reserved.
//

import UIKit

class ViewController: UIViewController,PeanutsManagerDelegate {
    
    var peanutsManager:PeanutsManager = PeanutsManager()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        peanutsManager.delegatePeanuts = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func stopScanningAction(sender: AnyObject) {
        peanutsManager.StopScanning()
    }
    
    @IBAction func clickScanningAction(sender: AnyObject) {
        peanutsManager.LaunchScanning()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startBuzzer(sender: AnyObject) {
        peanutsManager.startBuzzer()
    }
    
    @IBAction func disconnectAction(sender: AnyObject) {
        peanutsManager.disconnect()
    }
    
    @IBAction func launchNotificationAction(sender: AnyObject) {
        peanutsManager.launchNotification()
    }
    func connectedPeanut() {
        //displayAlertView("Peanuts Connecté")
    }
    
    func peanutsManagerTouchDetected() {
        displayAlertView("Envoie de votre Etat Confirmé.")
    }
    
    func displayAlertView(title:String){
        dispatch_async(dispatch_get_main_queue(),{
            let alert = UIAlertController(title: "Alert", message: title, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
        
    }

}

