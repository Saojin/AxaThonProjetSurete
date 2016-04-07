//
//  AlertsViewController.swift
//  hackathon
//
//  Created by yann breleur on 07/04/2016.
//  Copyright © 2016 julien hamon. All rights reserved.
//

import UIKit

class AlertsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet
    var alertsTableView: UITableView!
    var items: [String] = ["Bonjour, un incident majeur a eu lieu au sein de votre périmètre d’habitation. Merci de nous confirmer que vous êtes en sécurité.", "Le 'niveau alerte attentat' est maintenu en Ile-de-France et la vigilance renforcée continue de s'appliquer sur le reste du territoire.  Le ministère demande à chacune et chacun de les respecter afin d'améliorer le niveau de sécurité "]
    var identifientCell = "cellulle"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return basicCellAtIndexPath(indexPath)
    }
    
    func basicCellAtIndexPath(indexPath:NSIndexPath) -> AlertControllerCell {
        let cell = self.alertsTableView.dequeueReusableCellWithIdentifier(identifientCell)! as! AlertControllerCell
        cell.configure(self.items[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
}