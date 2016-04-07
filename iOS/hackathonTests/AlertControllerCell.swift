//
//  AlertControllerCell.swift
//  hackathon
//
//  Created by yann breleur on 07/04/2016.
//  Copyright © 2016 julien hamon. All rights reserved.
//

import UIKit

public class AlertControllerCell: UITableViewCell {

    @IBOutlet weak var Titre: UILabel!
    @IBOutlet weak var bouttonDroite: UIButton!
    @IBOutlet weak var bouttonGauche: UIButton!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(text: String, index: Int) {
        switch index {
        case 1:
            self.textLabel?.text = text
            self.Titre?.text = "Etes vous en sécurité"
            
        case 2:
            self.textLabel?.text = text
            self.Titre?.text = "Informations"
            self.bouttonDroite?.hidden = true;
            self.bouttonGauche?.hidden = true;
            
        default:
            self.textLabel?.hidden = true;
            self.Titre?.hidden = true;
            self.bouttonDroite?.hidden = true;
            self.bouttonGauche?.hidden = true;
        }
    }

}