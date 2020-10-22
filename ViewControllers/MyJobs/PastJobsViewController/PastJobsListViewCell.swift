//
//  PastJobsListTableViewCell.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 15/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class PastJobsListViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    // First View height is : 86.5
    
    // Total cell Height is : 301.5
    
    @IBOutlet var lblServiceType: UILabel!
    
    @IBOutlet var lblTotalPassenger: UILabel!
    @IBOutlet var lblTotalChild: UILabel!
    @IBOutlet var lblLuggaugeCount: UILabel!
    @IBOutlet var lblSKI: UILabel!
    @IBOutlet var lblHandicapAccess: UILabel!
    @IBOutlet var lblSnowboard: UILabel!
    @IBOutlet weak var lblWaitingTime: UILabel!
    @IBOutlet var lblPassangerID: UILabel!
    

    @IBOutlet weak var lblTripID: UILabel!
    
    @IBOutlet weak var lblDropoffLocation: UILabel!
    
    

    @IBOutlet weak var lblpassengerEmail: UILabel!
    @IBOutlet weak var lblPassengerNo: UILabel!

    @IBOutlet weak var lblTripDistanceDesc: UILabel!
    @IBOutlet weak var lbltripDurationDesc: UILabel!
    @IBOutlet weak var lblCarModelDesc: UILabel!
 
    @IBOutlet weak var lblNightFareDesc: UILabel!
  
    @IBOutlet weak var lblExtraCharges: UILabel!//  lblWaitingTimeCostDesc
    @IBOutlet weak var lblTollFeeDesc: UILabel!
 
    @IBOutlet weak var lblTaxDesc: UILabel!
    @IBOutlet weak var lblDiscountDesc: UILabel!

    
    @IBOutlet weak var txtPaymentType: UILabel!
    @IBOutlet weak var lblFlightNumber: UILabel!
    
    @IBOutlet weak var lblTripStatus: UILabel!
    
    
    
    @IBOutlet var lblDispatcherName: UILabel!
    @IBOutlet var lblDispatcherEmail: UILabel!
    @IBOutlet var lblDispatcherNumber: UILabel!
    
    @IBOutlet var lblDispatcherNameTitle: UILabel!
    @IBOutlet var lblDispatcherEmailTitle: UILabel!
    @IBOutlet var lblDispatcherNumberTitle: UILabel!
    
    @IBOutlet var stackViewEmail: UIStackView!
    @IBOutlet var stackViewName: UIStackView!
    @IBOutlet var stackViewNumber: UIStackView!

    //past jobs change
    
    @IBOutlet weak var conVwMapHeight: NSLayoutConstraint!
    
    @IBOutlet weak var stackVwPickupTime: UIStackView!
    @IBOutlet weak var stackVwDropofTime: UIStackView!
    @IBOutlet weak var stackVwBaseFare: UIStackView!
    @IBOutlet weak var stackVwBookingFee: UIStackView!
    @IBOutlet weak var stackVwMileageCost: UIStackView!
    @IBOutlet weak var stackVwTimeCost: UIStackView!
    @IBOutlet weak var stackVwSubtotal: UIStackView!
    @IBOutlet weak var stackVwLess: UIStackView!
    @IBOutlet weak var stackVwPromoCredit: UIStackView!
    @IBOutlet weak var stackVwGrandTotal: UIStackView!
    @IBOutlet weak var stackVwIncludingTax: UIStackView!
    @IBOutlet weak var stackVwMyEarnings: UIStackView!
    @IBOutlet weak var stackVwDistanceTravelled: UIStackView!
    @IBOutlet weak var stackVwTripDuration: UIStackView!

    
    
    @IBOutlet weak var stackVwPlusExtraCharge: UIStackView!
    @IBOutlet weak var stackVwAirportPickup: UIStackView!
    @IBOutlet weak var stackVwAirportDropoff: UIStackView!
    @IBOutlet weak var stackVwSoilingDamage: UIStackView!
    @IBOutlet weak var stackVwOtherCharges: UIStackView!
    @IBOutlet weak var stackVwCancelationCharge: UIStackView!
    @IBOutlet weak var stackVwPaymentStatus: UIStackView!
    
    //
    
    @IBOutlet var lblMileageCost: UILabel!
    @IBOutlet var lblAirportPickUp: UILabel!
    @IBOutlet var lblAirportDropOf: UILabel!
    @IBOutlet var lblSoilingDamage: UILabel!
    
    @IBOutlet weak var lblDropoffTitle: UILabel!
    @IBOutlet var lblCancellationCharge: UILabel!
    
    @IBOutlet weak var lblCancelMessage: UILabel!
    @IBOutlet weak var lblPromoCreditUsed: UILabel!
    
    @IBOutlet weak var lblDistanceTravelled: UILabel!
    @IBOutlet weak var lblBokingChargeDesc: UILabel!
    @IBOutlet weak var lblTripDuration: UILabel!
    @IBOutlet weak var lblSubTotalDesc: UILabel!
    @IBOutlet weak var lblGrandTotalDesc: UILabel!
    
    @IBOutlet weak var lblBooingId: UILabel!
    @IBOutlet var viewCell: UIView!
    @IBOutlet weak var lblPassengerName: UILabel!
    @IBOutlet weak var lblPickupTime: UILabel!
    @IBOutlet weak var lblDropOffTimeDesc: UILabel!
    @IBOutlet weak var lblDropoffLocationDescription: UILabel!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var viewAllDetails: UIView! // HEIGHT IS : 215
    @IBOutlet weak var lblPickupLocationDesc: UILabel!
    @IBOutlet weak var lblWaitingTimeCostDesc: UILabel!
    @IBOutlet weak var lblTripFareDesc: UILabel!
    
    @IBOutlet weak var imgVwMap:  UIImageView!
    
    @IBOutlet weak var lblDriverEarnings: UILabel!
    @IBOutlet weak var lblIncludingTax: UILabel!
    @IBOutlet weak var lblPromoCreditTitle: UILabel!
    
    @IBOutlet weak var lblLessTitle: UILabel!
    
    @IBOutlet weak var btnShareReciept: UIButton!
    @IBOutlet var stackVwNotes: UIStackView!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var btnViewReciept: UIButton!
    
}
