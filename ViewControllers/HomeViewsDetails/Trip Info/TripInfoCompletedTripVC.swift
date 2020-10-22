//
//  TripInfoCompletedTripVC.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 06/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class TripInfoCompletedTripVC: UIViewController {
    var delegate: CompleterTripInfoDelegate!
        var strNotAvailable: String = "N/A"
    var dictData = NSDictionary()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

//        if Singletons.sharedInstance.pasengerFlightNumber == "" {
//            stackViewFlightNumber.isHidden = true
//        }
//        else {
//            lblFlightNumber.text = Singletons.sharedInstance.pasengerFlightNumber
//            stackViewFlightNumber.isHidden = false
//        }
//
//        if Singletons.sharedInstance.passengerNote == "" {
//            stackViewNote.isHidden = true
//        }
//        else {
//            lblNote.text = Singletons.sharedInstance.passengerNote
//            stackViewNote.isHidden = false
//        }
        
        setData()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        btnViewCompleteTripData.layer.cornerRadius = 10
//        btnViewCompleteTripData.layer.masksToBounds = true
//
        
        btnOK.layer.cornerRadius = 20
        btnOK.layer.masksToBounds = true
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    /*
    @IBOutlet weak var lblTripFare: UILabel!     // as Base Fare
    @IBOutlet weak var lblDistanceFare: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblNightFare: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    
    
    
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropOffLocation: UILabel!
    
    @IBOutlet weak var lblTollFree: UILabel!
    @IBOutlet weak var lblBookingCharge: UILabel!
    
    @IBOutlet var btnViewCompleteTripData: UIView!
    
    
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    @IBOutlet weak var lblFlightNumber: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    
    @IBOutlet weak var stackViewFlightNumber: UIStackView!
    @IBOutlet weak var stackViewNote: UIStackView!
    
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblTripDistance: UILabel!
    @IBOutlet weak var lblDiatnceFare: UILabel!
    @IBOutlet weak var lblWaitingTime: UILabel!
    @IBOutlet weak var lblWaitingTimeCost: UILabel!
    
    @IBOutlet weak var lblSpecialExtraCharge: UILabel!
    @IBOutlet weak var stackViewSpecialExtraCharge: UIStackView!
    
    */
    
    
    
    @IBOutlet weak var stackVwPlusExtraCharge: UIStackView!
    @IBOutlet weak var stackVwAirportPickup: UIStackView!
    @IBOutlet weak var stackVwAirportDropoff: UIStackView!
    @IBOutlet weak var stackVwSoilingDamage: UIStackView!
    @IBOutlet weak var stackVwOtherCharges: UIStackView!
    @IBOutlet weak var stackVwCancelationCharge: UIStackView!
    @IBOutlet weak var  stackVwNotes: UIStackView!
    //==================================
    
    @IBOutlet var lblMileageCost: UILabel!
    @IBOutlet var lblAirportPickUp: UILabel!
    @IBOutlet var lblAirportDropOf: UILabel!
    @IBOutlet var lblSoilingDamage: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet var lblCancellationCharge: UILabel!
    
   
    
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

     @IBOutlet weak var lblPromoCreditUsed: UILabel!
    @IBOutlet weak var lblDriverEarnings: UILabel!
    @IBOutlet weak var lblIncludingTax: UILabel!
    @IBOutlet weak var lblPromoCreditTitle: UILabel!
    @IBOutlet weak var lblLessTitle: UILabel!
    
    @IBOutlet weak var imgVwMap: UIImageView!
    
    var strNoAmount = "0.0"

    //===============================
    
    // ------------------------------------------------------------
    
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setData() {
     
        dictData = NSMutableDictionary(dictionary: (dictData.object(forKey: "details") as! NSDictionary))
        
        
        lblPassengerName.text = dictData.object(forKey: "PassengerFullName") as? String
        
        //        cell.lblDropoffLocation.text = data.object(forKey: "PassengerName") as? String
        lblDropoffLocationDescription.text = dictData.object(forKey: "DropoffLocation") as? String // DropoffLocation
        lblBooingId.text = "Booking ID : \(dictData.object(forKey: "Id") as? String ?? strNotAvailable)"
        
       lblPickupLocationDesc.text = dictData.object(forKey: "PickupLocation") as? String // PickupLocation
        
        let strBookingDate = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "AcceptedTime", isNotHave: strNotAvailable)
        
        if strBookingDate == strNotAvailable {
            lblDateAndTime.text = strBookingDate
        } else {
            lblDateAndTime.text = setTimeStampToDateDropTime(timeStamp: strBookingDate)
//           lblDateAndTime.text = Utilities.formattedDateFromStringPost(dateString: strBookingDate, withFormat: "dd-MM-yyyy")
            
        }
        
        //        cell.lblpassengerEmail.text = data.object(forKey: "PassengerEmail") as? String //my change
        //        cell.lblPassengerNo.text = data.object(forKey: "PassengerMobileNo") as? String
        //                cell.lblPickupTime.text = data.object(forKey: "PickupTime") as? String
        
        let strNotes = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "Notes", isNotHave: strNotAvailable)
        
        //        cell.lblpassengerEmail.text = data.object(forKey: "PassengerEmail") as? String //my change
        //        cell.lblPassengerNo.text = data.object(forKey: "PassengerMobileNo") as? String
        //                cell.lblPickupTime.text = data.object(forKey: "PickupTime") as? String
        
        if strNotes == strNotAvailable {
            self.stackVwNotes.isHidden = true
        } else {
            self.stackVwNotes.isHidden = false
            //            cell.lblDateAndTime.text = setTimeStampToDate(timeStamp: strBookingDate)
            self.lblNotes.text = strNotes
            
        }
        
        let pickupTime = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "PickupTime", isNotHave: strNotAvailable)
        let strDropoffTime = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "DropTime", isNotHave: strNotAvailable)
        
        
        
        if pickupTime == strNotAvailable {
            lblPickupTime.text = pickupTime
        } else {
            
//            pickupTime = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "PickupTime", isNotHave: strNotAvailable)
            
            if pickupTime == strNotAvailable {
                lblPickupTime.text = pickupTime
            } else {
                
                lblPickupTime.text = setTimeStampToDateDropTime(timeStamp: pickupTime)
            }
        }
        
        if strDropoffTime == strNotAvailable {
            lblDropOffTimeDesc.text = strDropoffTime
        } else {
            lblDropOffTimeDesc.text = setTimeStampToDateDropTime(timeStamp: strDropoffTime)
        }
        
        let strLblBokingChargeDesc = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "BookingCharge", isNotHave: "$0.0")
        let strLblWaitingTimeCostDesc = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "WaitingTimeCost", isNotHave: "$0.0")
        let strLblAirportPickUp = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "AirportPickUpCharge", isNotHave: "$0.0")
        let strLblAirportDropOf = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "AirportDropOffCharge", isNotHave: "$0.0")
        let strLblSoilingDamage = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "SoilDamageCharge", isNotHave: strNoAmount)
        let strLblMileageCost = String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "DistanceFare", isNotHave: strNoAmount)) ?? 0.0)
        let strLblDriverEarnings = String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "CompanyAmount", isNotHave: strNoAmount)) ?? 0.0)
        
        
        lblBokingChargeDesc.text = currency + checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "BookingCharge", isNotHave: "$0.0") // data.object(forKey: "BookingCharge") as? String
        if strLblBokingChargeDesc == strNotAvailable {
            lblBokingChargeDesc.text = strNotAvailable
        }
        
        lblTripFareDesc.text = currency + checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "TripFare", isNotHave: "0.0") //  data.object(forKey: "TripFare") as? String
        
        
        lblWaitingTimeCostDesc.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "WaitingTimeCost", isNotHave: "0.0")) ?? 0.0) //  data.object(forKey: "WaitingTimeCost") as? String
//        if strLblWaitingTimeCostDesc == strNotAvailable {
//            lblWaitingTimeCostDesc.text = strNotAvailable
//        }
//         String(format: "%.2f",Double(damageCharge))
        lblSubTotalDesc.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "SubTotal", isNotHave: "0")) ?? 0.0) // data.object(forKey: "SubTotal") as? String
        
        lblAirportPickUp.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "AirportPickUpCharge", isNotHave: "0.0")) ?? 0.0)
//        if strLblAirportPickUp == strNotAvailable {
//            lblAirportPickUp.text = strNotAvailable
//        }
        
        lblAirportDropOf.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "AirportDropOffCharge", isNotHave: "0.0")) ?? 0.0)
//        if strLblAirportDropOf == strNotAvailable {
//            lblAirportDropOf.text = strNotAvailable
//        }
        
        lblSoilingDamage.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "SoilDamageCharge", isNotHave: strNoAmount)) ?? 0.0)
        if strLblSoilingDamage == strNoAmount {
            lblSoilingDamage.text = strNoAmount
        }
        
        lblCancellationCharge.text = currency + checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "CancellationFee", isNotHave: "0")
        
        
        
        
        
        //Change Hide fields
        let strAirportPickupEmpty = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "AirportPickUpCharge", isNotHave: "")
        let strAirportDropupEmpty = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "AirportDropOffCharge", isNotHave: "")
        let strSoilDamageEmpty = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "SoilDamageCharge", isNotHave: "")
        let strCancelationEmpty = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "CancellationFee", isNotHave: "")
        
        if (strAirportPickupEmpty.isEmptyOrWhitespace() || strAirportPickupEmpty == "0" || strAirportPickupEmpty == "0.0") {
           stackVwAirportPickup.isHidden = true
        }else {
            stackVwAirportPickup.isHidden = false
        }
        
        if (strAirportDropupEmpty.isEmptyOrWhitespace() || strAirportDropupEmpty == "0" || strAirportDropupEmpty  == "0.0" ) {
           stackVwAirportDropoff.isHidden = true
        }else {
            stackVwAirportDropoff.isHidden = false
        }
        
        if (strSoilDamageEmpty.isEmptyOrWhitespace() || strSoilDamageEmpty == "0") {
            stackVwSoilingDamage.isHidden = true
        }else {
            stackVwSoilingDamage.isHidden = false
        }
        
        if (strAirportPickupEmpty.isEmptyOrWhitespace() || strAirportPickupEmpty == "0") && (strAirportDropupEmpty.isEmptyOrWhitespace() || strAirportDropupEmpty == "0")  && (strSoilDamageEmpty.isEmptyOrWhitespace() || strSoilDamageEmpty == "0") {
            stackVwPlusExtraCharge.isHidden = true
        }else {
            stackVwPlusExtraCharge.isHidden = false
        }
        
        if strCancelationEmpty.isEmptyOrWhitespace() || strCancelationEmpty == "0" {
            stackVwOtherCharges.isHidden = true
            stackVwCancelationCharge.isHidden = true
        }else {
            stackVwOtherCharges.isHidden = false
            stackVwCancelationCharge.isHidden = false
        }
        
        ////////////////
        
        
        lblGrandTotalDesc.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "GrandTotal", isNotHave: "0")) ?? 0.0)
        
        lblDistanceTravelled.text =  String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "TripDistance", isNotHave: strNoAmount)) ?? 0.0 ) + " km"
       
        let tripDuration = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "TripDuration", isNotHave: strNotAvailable)
        var strWaitingTime = String()
        
        if tripDuration == strNotAvailable {
            lblTripDuration.text = tripDuration
        }else {
            let WaitingTimeIs = ConvertSecondsToHoursMinutesSeconds(seconds: Int(tripDuration) ?? 0)
            if WaitingTimeIs.0 == 0 {
                if WaitingTimeIs.1 == 0 {
                    if "\(WaitingTimeIs.2)".count == 1 {
                        strWaitingTime = "00:00:0\(WaitingTimeIs.2)"
                    }
                    else {
                        strWaitingTime = "00:00:\(WaitingTimeIs.2)"
                    }
                } else {
                    strWaitingTime = "00:\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
                }
            } else {
                strWaitingTime = "\(WaitingTimeIs.0):\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
            }
        }
            
        lblTripDuration.text = strWaitingTime
        
        lblMileageCost.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "DistanceFare", isNotHave: strNoAmount)) ?? 0.0)
        if strLblMileageCost == strNoAmount {
            lblMileageCost.text = strNoAmount
        }
        
        lblDriverEarnings.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "CompanyAmount", isNotHave: strNoAmount)) ?? 0.0)
        if strLblDriverEarnings == strNoAmount {
            lblDriverEarnings.text = strNoAmount
        }
        
        let strTaxReceipt = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "ReceiptType", isNotHave: strNotAvailable)
        lblIncludingTax.isHidden =  (strTaxReceipt == "Tax Invoice") ? false : true
        
        let strDiscount = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "Discount", isNotHave: strNotAvailable)
        
        if strDiscount == strNotAvailable  || strDiscount == "0" {
            lblLessTitle.isHidden = true
            lblPromoCreditUsed.isHidden = true
            lblPromoCreditTitle.isHidden = true
        }else {
            lblLessTitle.isHidden = false
            lblPromoCreditUsed.isHidden = false
            lblPromoCreditTitle.isHidden = false
            let strCouponTitle = checkDictionaryHaveValue(dictData: dictData as! [String : AnyObject], didHaveValue: "PromoCode", isNotHave: strNotAvailable)
            lblPromoCreditTitle.text = strCouponTitle + " Promo Applied"
            lblPromoCreditUsed.text = strDiscount
        }
        
        if let strUrl = dictData["MapUrl"] as? String {
            imgVwMap.sd_setImage(with: URL.init(string: strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), placeholderImage: UIImage.init(named: ""))
        }
        /*
        lblPickupLocation.text = dictData.object(forKey: "PickupLocation") as? String
        lblDropOffLocation.text = dictData.object(forKey: "DropoffLocation") as? String
        lblTollFree.text = dictData.object(forKey: "TollFee") as? String
        lblGrandTotal.text = dictData.object(forKey: "GrandTotal") as? String
        lblBaseFare.text = dictData.object(forKey: "TripFare") as? String
        lblTripDistance.text = dictData.object(forKey: "TripDistance") as? String
        lblDiatnceFare.text = dictData.object(forKey: "DistanceFare") as? String
      //  lblWaitingTime.text = dictData.object(forKey: "WaitingTime") as? String
        lblWaitingTimeCost.text = dictData.object(forKey: "WaitingTimeCost") as? String
        
        lblBookingCharge.text = dictData.object(forKey: "BookingCharge") as? String
        lblTax.text = dictData.object(forKey: "Tax") as? String
        
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int((dictData.object(forKey: "WaitingTime") as? String)!) ?? 0)
        
        lblWaitingTime.text = "\(getStringFrom(seconds: h)):\(getStringFrom(seconds: m)):\(getStringFrom(seconds: s))"
        
        var strSpecial = String()
        
        if let special = dictData.object(forKey: "Special") as? String {
            strSpecial = special
        } else if let special = dictData.object(forKey: "Special") as? Int {
            strSpecial = String(special)
        }
        
        stackViewSpecialExtraCharge.isHidden = true
        if strSpecial == "1" {
            stackViewSpecialExtraCharge.isHidden = false
            
            if let SpecialExtraCharge = dictData.object(forKey: "SpecialExtraCharge") as? String {
                lblSpecialExtraCharge.text = SpecialExtraCharge
            } else if let SpecialExtraCharge = dictData.object(forKey: "SpecialExtraCharge") as? Double {
                lblSpecialExtraCharge.text = String(SpecialExtraCharge)
            }
            
            
        }
        */
        
    }
    func setTimeStampToDateDropTime(timeStamp: String) -> String {
        
        let unixTimestamp = Double(timeStamp)
        //        let date = Date(timeIntervalSince1970: unixTimestamp)
        
        let date = Date(timeIntervalSince1970: unixTimestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system //TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd/MM/yyyy" //Specify your format that you want
        let strDate: String = dateFormatter.string(from: date)
        
        return strDate
    }
//    func setTimeStampToDate(timeStamp: String) -> String {
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
//        let date = dateFormatter.date(from: timeStamp) //according to date format your date string
//        print(date ?? "")
//
//        dateFormatter.locale = Locale.current
//        dateFormatter.dateFormat = "HH:mm yyyy-MM-dd" //Specify your format that you want
//        let strDate: String = dateFormatter.string(from: date!)
//
//        return strDate
//    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    @IBOutlet weak var btnOK: UIButton!
    
    @IBAction func btnOK(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
        if Singletons.sharedInstance.passengerType == "other" || Singletons.sharedInstance.passengerType == "others"
        {
//            self.completeTripInfo()
        }
        else
        {
            self.delegate.didRatingCompleted()

        }
         Singletons.sharedInstance.passengerType = ""
        
        
    }
    
}
