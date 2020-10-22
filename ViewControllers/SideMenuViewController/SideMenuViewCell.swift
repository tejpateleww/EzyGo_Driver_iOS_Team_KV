//
//  SideMenuViewCell.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 10/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class SideMenuViewCell: UITableViewCell {

    @IBOutlet var viewCell: UIView!
    
    @IBOutlet var iconMenuItem: UIImageView!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnTermsofUse: UIButton!
    @IBOutlet var btnPrivacyPolicy: UIButton!
    @IBOutlet var btnContactUs: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
