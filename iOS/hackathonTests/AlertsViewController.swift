//
//  AlertsViewController.swift
//  hackathon
//
//  Created by yann breleur on 07/04/2016.
//  Copyright © 2016 julien hamon. All rights reserved.
//

import UIKit

class AlertsViewController: UIViewController {
    @IBOutlet weak var ViewQuestion: UIView!
    @IBOutlet weak var btnEnRisque: UIButton!
    @IBOutlet weak var titreQuestion: UILabel!
    @IBOutlet weak var btnEnSurete: UIButton!
    @IBOutlet weak var messageOk: UILabel!
    
    
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var titreMessage: UILabel!
    @IBOutlet weak var descriptionMEssage: UILabel!
    
    @IBOutlet
    var alertsTableView: UITableView!
    var items: [String] = ["Bonjour, un incident majeur a eu lieu au sein de votre périmètre d’habitation. Merci de nous confirmer que vous êtes en sécurité.", "Le 'niveau alerte attentat' est maintenu en Ile-de-France et la vigilance renforcée continue de s'appliquer sur le reste du territoire.  Le ministère demande à chacune et chacun de les respecter afin d'améliorer le niveau de sécurité "]
    var identifientCell = "cellulle"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageOk.text = self.items[0]
        self.descriptionMEssage.text = self.items[1]
    }

    @IBAction func clicLogo(sender: AnyObject) {
        PeanutsManager().launchNotification()
    }
}