//
//  MyFeedbackViewCell.swift
//  TEXLUXE-DRIVER
//
//  Created by Excellent WebWorld on 02/08/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class MyFeedbackViewCell: UITableViewCell {

    @IBOutlet var viewCell: UIView!
    
    @IBOutlet var lblDateTime: UILabel!
    
    @IBOutlet var viewRating: HCSStarRatingView!
    @IBOutlet var lblPassengerName: UILabel!
    
    @IBOutlet var lblComments: UILabel!
    
    @IBOutlet var lblPickUpAddress: UILabel!
    
    @IBOutlet var lblDropUpAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
