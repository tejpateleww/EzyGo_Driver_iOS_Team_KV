//
//  SideMenuTableViewCell.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 11/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // SideMenuIDriverProfile
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet var lblContactNumber: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var btnUpdateProfile: UIButton!
    
    // SideMenuItemsList
    @IBOutlet var imgItems: UIImageView!
    @IBOutlet var lblItemNames: UILabel!
    
}
