//
//  PastJobsListVC.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 14/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit



class PastJobsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var strNotAvailable: String = "N/A"
    var strNoAmount = "0.0"
    var aryData = NSArray()
    var aryPastJobs = NSMutableArray()
    
    var selectedCellIndexPath: IndexPath?
    let selectedCellHeight: CGFloat = 350.5
    let unselectedCellHeight: CGFloat = 86.5
    var thereIsCellTapped = false
    var selectedRowIndex = -1
    
    @IBOutlet var tblView: UITableView!
    
    
    var expandedCellPaths = Set<IndexPath>()
    var labelNoData = UILabel()
    
    override func loadView() {
        super.loadView()
        
        //        let activityData = ActivityData()
        //        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Global Declaration
    //-------------------------------------------------------------
    
    
    
        lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:
                #selector(self.handleRefresh(_:)),
                                     for: UIControlEvents.valueChanged)
            refreshControl.tintColor = ThemeYellowColor
    
            return refreshControl
        }()
    
    
    func dismissSelf() {
        
        self.navigationController?.popViewController(animated: true)
        
        
        //        self.dismiss(animated: true, completion: nil)
    }
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate = self
        
        self.labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.labelNoData.text = "Loading..."
        self.labelNoData.textAlignment = .center
        self.view.addSubview(self.labelNoData)
        self.tblView.isHidden = true
        
        self.tblView.tableFooterView = UIView()
        
        
        self.tblView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        self.tblView.addSubview(self.refreshControl)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        aryPastJobs.removeAllObjects()
        webserviceOfPastbookingpagination(index: 1)
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        //        aryPastJobs.removeAllObjects()
        
//        webserviceofPendingJobs()
//
//        tblView.reloadData()
        
        aryPastJobs.removeAllObjects()
        webserviceOfPastbookingpagination(index: 1)
        tblView.reloadData()
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    
    
    
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if section == 0 {
        //
        //            if aryPastJobs.count == 0 {
        //                 return 1
        //            }
        //            else {
        //                return aryPastJobs.count
        //            }
        //        }
        //        else {
        //            return 1
        //        }
        
        return aryPastJobs.count
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (self.aryPastJobs.count - 5) {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo = self.pageNo + 1
                webserviceOfPastbookingpagination(index: self.pageNo)
            }
        }
    }
    var isDataLoading:Bool=false
    var pageNo:Int = 0
    var didEndReached:Bool=false
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PastJobsListViewCell") as! PastJobsListViewCell
        //        let cell2 = tableView.dequeueReusableCell(withIdentifier: "NoDataFound") as! PastJobsListTableViewCell
        
        cell.selectionStyle = .none
        cell.viewCell.layer.cornerRadius = 10
        cell.viewCell.clipsToBounds = true
        cell.viewCell.layer.shadowRadius = 3.0
        cell.viewCell.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        cell.viewCell.layer.shadowOffset = CGSize (width: 1.0, height: 1.0)
        cell.viewCell.layer.shadowOpacity = 1.0
//
        cell.viewAllDetails.isHidden = !expandedCellPaths.contains(indexPath)
        
        //        cell2.selectionStyle = .none
        
        let data = aryPastJobs.object(at: indexPath.row) as! NSDictionary
        
        //        cell.viewAllDetails.isHidden = true
        //                cell.selectionStyle = .none
        
        cell.lblPassengerName.text = "Passenger Name : \(data.object(forKey: "PassengerName") as? String ?? "")"
        
        //        cell.lblDropoffLocation.text = data.object(forKey: "PassengerName") as? String
        cell.lblDropoffLocationDescription.text = data.object(forKey: "DropoffLocation") as? String // DropoffLocation
        cell.lblBooingId.text = "Booking ID : \(data.object(forKey: "Id") as? String ?? strNotAvailable)"
        
        cell.lblPickupLocationDesc.text = data.object(forKey: "PickupLocation") as? String // PickupLocation
        
        let strBookingDate = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AcceptedTime", isNotHave: strNotAvailable)
        
        if strBookingDate == strNotAvailable {
             cell.lblDateAndTime.text = strBookingDate
        } else {
//            cell.lblDateAndTime.text = setTimeStampToDate(timeStamp: strBookingDate)
            cell.lblDateAndTime.text = Utilities.formattedDateFromStringPost(dateString: strBookingDate, withFormat: "dd/MM/yyyy hh:mm")
            
        }
        
        
        cell.lblCancellationCharge.text = currency + checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "CancellationFee", isNotHave: strNoAmount)
        
        let statusTrip =  checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Status", isNotHave: "").lowercased()
        
         let unpaidStatus =  checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "UnpaidDriverStatus", isNotHave: "").lowercased()
        if unpaidStatus == "0" {
            cell.stackVwPaymentStatus.isHidden = false
        }else {
            cell.stackVwPaymentStatus.isHidden = true
        }
        if statusTrip == "canceled" {
            cell.stackVwNotes.isHidden = true
            cell.stackVwPickupTime.isHidden = true
            cell.stackVwDropofTime.isHidden = true
            cell.lblCancelMessage.isHidden = false
//            cell.lblDropoffTitle.isHidden = true
//            cell.lblDropOffTimeDesc.isHidden = true
            cell.stackVwBaseFare.isHidden = true
            cell.stackVwBookingFee.isHidden = true
            cell.stackVwMileageCost.isHidden = true
            cell.stackVwTimeCost.isHidden = true
            cell.stackVwSubtotal.isHidden = true
            cell.stackVwPlusExtraCharge.isHidden = true
            cell.stackVwAirportPickup.isHidden = true
            cell.stackVwAirportDropoff.isHidden = true
            cell.stackVwSoilingDamage.isHidden = true
            cell.stackVwOtherCharges.isHidden = true
            cell.stackVwCancelationCharge.isHidden = true
            cell.stackVwLess.isHidden = true
            cell.stackVwPromoCredit.isHidden = true
            cell.stackVwGrandTotal.isHidden = true
            cell.stackVwIncludingTax.isHidden = true
            cell.stackVwMyEarnings.isHidden = true
            cell.stackVwDistanceTravelled.isHidden = true
            cell.stackVwTripDuration.isHidden = true
            cell.conVwMapHeight.constant = 0
            cell.layoutIfNeeded()
            
            
            let cancelBy =  checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "CancelBy", isNotHave: "").lowercased()
            
            let strNotes = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Notes", isNotHave: strNotAvailable)
            
            //        cell.lblpassengerEmail.text = data.object(forKey: "PassengerEmail") as? String //my change
            //        cell.lblPassengerNo.text = data.object(forKey: "PassengerMobileNo") as? String
            //                cell.lblPickupTime.text = data.object(forKey: "PickupTime") as? String
            
            if strNotes == strNotAvailable {
                cell.stackVwNotes.isHidden = true
            } else {
                cell.stackVwNotes.isHidden = false
                //            cell.lblDateAndTime.text = setTimeStampToDate(timeStamp: strBookingDate)
                cell.lblNotes.text = strNotes
                
            }
            
            if !cancelBy.isEmptyOrWhitespace() {
                if cancelBy == "passenger" {
                    cell.lblCancelMessage.text = "Cancelled By Passenger. No Charge."
                }else {
                    
                    let paymentType =  checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PaymentType", isNotHave: "").lowercased()
                    let cancellationCharge =  checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "CancellationFee", isNotHave: "")
                    if paymentType == "cash" {
                        cell.lblCancelMessage.text = "Cancelled By Driver. Cancel Charge Not Paid."
                    }else if paymentType == "wallet"{
                        cell.lblCancelMessage.text = "Cancelled By Driver. $\(cancellationCharge) Paid By Wallet"

                    }else if paymentType == "card" {
                        cell.lblCancelMessage.text = "Cancelled By Driver. $\(cancellationCharge) Paid By Credit Card"

                    }
                    
                    if cancellationCharge.isEmptyOrWhitespace() {
                        cell.stackVwOtherCharges.isHidden = true
                        cell.stackVwCancelationCharge.isHidden = true
                    }else {
                        cell.stackVwOtherCharges.isHidden = false
                        cell.stackVwCancelationCharge.isHidden = false
                    }
                }
            }
            
        }else {
            //change 3rd jan
            cell.lblCancelMessage.isHidden = true
            cell.stackVwNotes.isHidden = false
            cell.stackVwPickupTime.isHidden = false
                        cell.stackVwDropofTime.isHidden = false
//            cell.lblDropoffTitle.isHidden = false
//            cell.lblDropOffTimeDesc.isHidden = false
            cell.stackVwBaseFare.isHidden = false
            cell.stackVwBookingFee.isHidden = false
            cell.stackVwMileageCost.isHidden = false
            cell.stackVwTimeCost.isHidden = false
            cell.stackVwSubtotal.isHidden = false
            cell.stackVwPlusExtraCharge.isHidden = false
            cell.stackVwAirportPickup.isHidden = false
            cell.stackVwAirportDropoff.isHidden = false
            cell.stackVwSoilingDamage.isHidden = false
//            cell.stackVwOtherCharges.isHidden = false
//            cell.stackVwCancelationCharge.isHidden = false
            cell.stackVwLess.isHidden = false
            cell.stackVwPromoCredit.isHidden = false
            cell.stackVwGrandTotal.isHidden = false
            cell.stackVwIncludingTax.isHidden = false
            cell.stackVwMyEarnings.isHidden = false
            cell.stackVwDistanceTravelled.isHidden = false
            cell.stackVwTripDuration.isHidden = false
            cell.conVwMapHeight.constant = 250
            cell.layoutIfNeeded()
            
            
            let strNotes = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Notes", isNotHave: strNotAvailable)
            
            //        cell.lblpassengerEmail.text = data.object(forKey: "PassengerEmail") as? String //my change
            //        cell.lblPassengerNo.text = data.object(forKey: "PassengerMobileNo") as? String
            //                cell.lblPickupTime.text = data.object(forKey: "PickupTime") as? String
            
            if strNotes == strNotAvailable {
                cell.stackVwNotes.isHidden = true
            } else {
                cell.stackVwNotes.isHidden = false
                //            cell.lblDateAndTime.text = setTimeStampToDate(timeStamp: strBookingDate)
                cell.lblNotes.text = strNotes
                
            }
            
            let pickupTime = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PickupTime", isNotHave: strNotAvailable)
            let strDropoffTime = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "DropTime", isNotHave: strNotAvailable)
            
            
            if pickupTime == strNotAvailable {
                cell.lblPickupTime.text = pickupTime
            } else {
                cell.lblPickupTime.text = setTimeStampToDate(timeStamp: pickupTime)
            }
            
            if strDropoffTime == strNotAvailable {
                cell.lblDropOffTimeDesc.text = strDropoffTime
            } else {
                cell.lblDropOffTimeDesc.text = setTimeStampToDateDropTime(timeStamp: strDropoffTime)
            }
            
            let lblBokingChargeDesc = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "BookingCharge", isNotHave: strNotAvailable)
            let lblWaitingTimeCostDesc = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "WaitingTimeCost", isNotHave: strNotAvailable)
//            let lblSubTotalDesc = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "SubTotal", isNotHave: strNotAvailable)
//            let lblAirportPickUp = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AirportPickUpCharge", isNotHave: strNoAmount)
//            let lblAirportDropOf = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AirportDropOffCharge", isNotHave: strNoAmount)
//            let lblSoilingDamage = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "SoilDamageCharge", isNotHave: strNoAmount)
//            let lblCancellationCharge = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "CancellationFee", isNotHave: strNoAmount)
//            let lblGrandTotalDesc = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "GrandTotal", isNotHave: strNoAmount)
            let lblMileageCost = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "DistanceFare", isNotHave: strNoAmount)
//            let lblDriverEarnings = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "CompanyAmount", isNotHave: strNoAmount)
//
            
            cell.lblBokingChargeDesc.text = "\(currency)\(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "BookingCharge", isNotHave: strNotAvailable))" // data.object(forKey: "BookingCharge") as? String
            if lblBokingChargeDesc == strNotAvailable {
                cell.lblBokingChargeDesc.text = strNotAvailable
            }
            
            cell.lblTripFareDesc.text = currency + checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "TripFare", isNotHave: "0") //  data.object(forKey: "TripFare") as? String
            
            
            if let strUrl = data["MapUrl"] as? String {
//                cell.imgVwMap.sd_setImage(with: URL.init(string: strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), placeholderImage: UIImage.init(named: ""))
                cell.imgVwMap.sd_setImage(with: URL.init(string: strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")) { (img, erorr, SDImageCacheTypeNone, url) in
                    if (img == nil) {
                        cell.conVwMapHeight.constant = 0
                        cell.layoutIfNeeded()
                    }
                }
                
            }
            
            cell.lblWaitingTimeCostDesc.text = "\(currency)\(String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "WaitingTimeCost", isNotHave: "0.0")) ?? 0.0))" //  data.object(forKey: "WaitingTimeCost") as? String
            if lblWaitingTimeCostDesc == strNotAvailable {
                cell.lblWaitingTimeCostDesc.text = strNotAvailable
            }
            
            cell.lblSubTotalDesc.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "SubTotal", isNotHave: "0.0")) ?? 0.0)
          
            
            cell.lblAirportPickUp.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AirportPickUpCharge", isNotHave: "0.0")) ?? 0.0)

            
            cell.lblAirportDropOf.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AirportDropOffCharge", isNotHave: "0.0")) ?? 0.0)

//            cell.lblSoilingDamage.text = currency + checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "SoilDamageCharge", isNotHave: strNoAmount)
            
            //        if lblSoilingDamage == strNoAmount {
            //            cell.lblSoilingDamage.text = strNoAmount
            //        }
            
            
            cell.lblSoilingDamage.text =  data.object(forKey: "SoilDamageChargeNote") as? String //dictData.object(forKey: "SoilDamageChargeNote") as? String
            
            let strAirportPickupEmpty = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AirportPickUpCharge", isNotHave: "")
            let strAirportDropupEmpty = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AirportDropOffCharge", isNotHave: "")
            let strSoilDamageEmpty = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "SoilDamageChargeNote", isNotHave: "")
            let strCancelationEmpty = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "CancellationFee", isNotHave: "")
            
            if (strAirportPickupEmpty.isEmptyOrWhitespace() || strAirportPickupEmpty == "0" || strAirportPickupEmpty == "0.0" ) {
                cell.stackVwAirportPickup.isHidden = true
            }else {
                cell.stackVwAirportPickup.isHidden = false
            }
            
            if (strAirportDropupEmpty.isEmptyOrWhitespace() || strAirportDropupEmpty == "0" || strAirportDropupEmpty == "0.0" ) {
                cell.stackVwAirportDropoff.isHidden = true
            }else {
                cell.stackVwAirportDropoff.isHidden = false
            }
            
            if (strSoilDamageEmpty.isEmptyOrWhitespace() || strSoilDamageEmpty == "0") {
                cell.stackVwSoilingDamage.isHidden = true
            }else {
                cell.stackVwSoilingDamage.isHidden = false
            }
            
            if (strAirportPickupEmpty.isEmptyOrWhitespace() || strAirportPickupEmpty == "0") && (strAirportDropupEmpty.isEmptyOrWhitespace() || strAirportDropupEmpty == "0")  && (strSoilDamageEmpty.isEmptyOrWhitespace() || strSoilDamageEmpty == "0"){
                cell.stackVwPlusExtraCharge.isHidden = true
            }else {
                cell.stackVwPlusExtraCharge.isHidden = false
            }
            
            if strCancelationEmpty.isEmptyOrWhitespace() || strCancelationEmpty == "0" {
                cell.stackVwOtherCharges.isHidden = true
                cell.stackVwCancelationCharge.isHidden = true
            }else {
                cell.stackVwOtherCharges.isHidden = false
                cell.stackVwCancelationCharge.isHidden = false
            }
            
            
            //////
            //        if lblCancellationCharge == strNoAmount {
            //            cell.lblCancellationCharge.text = strNoAmount
            //        }
            
            cell.lblGrandTotalDesc.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "GrandTotal", isNotHave: strNoAmount)) ?? 0.0 )
            
            //        if lblGrandTotalDesc == strNoAmount {
            //            cell.lblGrandTotalDesc.text = strNoAmount
            //        }
            
            cell.lblDistanceTravelled.text = String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "TripDistance", isNotHave: strNoAmount)) ?? 0.0 ) + " km"
            
            
            let duration =  checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "TripDuration", isNotHave: strNotAvailable)
            
            if duration != strNotAvailable {
                
                let intDuration = Double(duration)
                cell.lblTripDuration.text = UtilityClass.timeString(time: intDuration ?? 0.0)
                
            }else {
                cell.lblTripDuration.text = "00:00:00"
            }
            
            //        cell.lblTripDuration.text = strTripDuration
            cell.lblMileageCost.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "DistanceFare", isNotHave: strNoAmount)) ?? 0.0)
            if lblMileageCost == strNoAmount {
                cell.lblMileageCost.text = strNoAmount
            }
            
            cell.lblDriverEarnings.text = currency +  String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "CompanyAmount", isNotHave: strNoAmount)) ?? 0.0)
            
            
            //        cell.lblDriverEarnings.text = currency + checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "CompanyAmount", isNotHave: strNotAvailable)
            //        if lblDriverEarnings == strNoAmount  || currency + strNoAmount {
            //            cell.lblDriverEarnings.text = strNoAmount
            //        }
            
            let strTaxReceipt = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "ReceiptType", isNotHave: strNotAvailable)
            cell.lblIncludingTax.isHidden =  (strTaxReceipt == "Tax Invoice") ? false : true
            
            let strDiscount = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Discount", isNotHave: "")
            
            if strDiscount == currency + strNoAmount || strDiscount == strNoAmount || strDiscount.isEmptyOrWhitespace() || strDiscount == "0" {
                cell.lblLessTitle.isHidden = true
                cell.lblPromoCreditUsed.isHidden = true
                cell.lblPromoCreditTitle.isHidden = true
            }else {
                cell.lblLessTitle.isHidden = false
                cell.lblPromoCreditUsed.isHidden = false
                cell.lblPromoCreditTitle.isHidden = false
                let strCouponTitle = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PromoCode", isNotHave: strNotAvailable)
                cell.lblPromoCreditTitle.text = strCouponTitle + " Promo Applied"
                cell.lblPromoCreditUsed.text = currency +  strDiscount
            }
        }
        
        
         return cell
        //mileage cost
        //                if let pickupTime = data.object(forKey: "PickupTime") as? String {
        //                    if pickupTime == "" {
        //                        cell.lblPickupTime.isHidden = true
        ////                        cell.stackViewPickupTime.isHidden = true
        //                    }
        //                    else {
        //                        cell.lblPickupTime.text = setTimeStampToDate(timeStamp: pickupTime)
        //                    }
        //                }
        ////                cell.lblDropOffTimeDesc.text = data.object(forKey: "DropTime") as? String
        //                if let DropoffTime = data.object(forKey: "DropTime") as? String {
        //                    if DropoffTime == "" {
        //                        cell.lblDropOffTimeDesc.isHidden = true
        //        //                cell.stackViewDropoffTime.isHidden = true
        //                    }
        //                    else {
        //                        cell.lblDropOffTimeDesc.text = setTimeStampToDate(timeStamp: DropoffTime)
        //                    }
        //                }
        /*
        var strTripDistance = String()
        if let TripDistance = data.object(forKey: "TripDistance") as? String {
            strTripDistance = TripDistance
        } else if let TripDistance = data.object(forKey: "TripDistance") as? Int {
            strTripDistance = "\(TripDistance)"
        } else if let TripDistance = data.object(forKey: "TripDistance") as? Double {
            strTripDistance = "\(TripDistance)"
        }
        
        if strTripDistance == "" {
            strTripDistance = strNotAvailable
        }
        
        
        let duration = convertAnyToStringFromDictionary(dictData: data as! [String : AnyObject], shouldConvert: "TripDuration")
        
        var strTripDuration: String = "00:00:00"
        if duration != "" {
            let intDuration = Int(duration)
            let durationIs = ConvertSecondsToHoursMinutesSeconds(seconds: intDuration!)
            if durationIs.0 == 0 {
                if durationIs.1 == 0 {
                    strTripDuration = "00:00:\(durationIs.2)"
                } else {
                    strTripDuration = "00:\(durationIs.1):\(durationIs.2)"
                }
            } else {
                strTripDuration = "\(durationIs.0):\(durationIs.1):\(durationIs.2)"
            }
        }
        
        let waitingTime = convertAnyToStringFromDictionary(dictData: data as! [String : AnyObject], shouldConvert: "WaitingTime")
        
        var strWaitingTime: String = "00:00:00"
        if waitingTime != "" {
            let intWaitingTime = Int(waitingTime)
            let WaitingTimeIs = ConvertSecondsToHoursMinutesSeconds(seconds: intWaitingTime!)
            if WaitingTimeIs.0 == 0 {
                if WaitingTimeIs.1 == 0 {
                    strWaitingTime = "00:00:\(WaitingTimeIs.2)"
                } else {
                    strWaitingTime = "00:\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
                }
            } else {
                strWaitingTime = "\(WaitingTimeIs.0):\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
            }
        }
        */
      
        
        /*
        cell.lblTripDistanceDesc.text = strTripDistance // data.object(forKey: "TripDistance") as? String
        cell.lbltripDurationDesc.text = strTripDuration // data.object(forKey: "TripDuration") as? String
        cell.lblCarModelDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Model", isNotHave: strNotAvailable) //  data.object(forKey: "Model") as? String
        cell.lblNightFareDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "NightFare", isNotHave: strNotAvailable) //  data.object(forKey: "NightFare") as? String
      
        cell.lblTollFeeDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "TollFee", isNotHave: strNotAvailable) // data.object(forKey: "TollFee") as? String
       
        cell.lblTaxDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Tax", isNotHave: strNotAvailable) // data.object(forKey: "Tax") as? String
        cell.lblDiscountDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Discount", isNotHave: strNotAvailable) // data.object(forKey: "Discount") as? String
      
        cell.lblGrandTotalDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "GrandTotal", isNotHave: strNotAvailable) // data.object(forKey: "GrandTotal") as? String
        cell.txtPaymentType.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PaymentType", isNotHave: strNotAvailable) // data.object(forKey: "PaymentType") as? String
        cell.lblTripStatus.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Status", isNotHave: strNotAvailable) // (data.object(forKey: "Status") as? String)?.uppercased()
        cell.lblFlightNumber.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "FlightNumber", isNotHave: strNotAvailable) // data.object(forKey: "FlightNumber") as? String
        cell.lblNotes.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Notes", isNotHave: strNotAvailable) //data.object(forKey: "Notes") as? String
        cell.txtPaymentType.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PaymentType", isNotHave: strNotAvailable) //data.object(forKey: "PaymentType") as? String
        
        cell.lblWaitingTime.text = strWaitingTime // data.object(forKey: "WaitingTime") as? String
        
        cell.viewAllDetails.isHidden = !expandedCellPaths.contains(indexPath)
        
        
        cell.lblDispatcherName.text = ""
        cell.lblDispatcherEmail.text = ""
        cell.lblDispatcherNumber.text = ""
        cell.lblDispatcherNameTitle.text = ""
        cell.lblDispatcherEmailTitle.text = ""
        cell.lblDispatcherNumberTitle.text = ""
        
        
        cell.stackViewEmail.isHidden = true
        cell.stackViewName.isHidden = true
        cell.stackViewNumber.isHidden = true
        
        if((data.object(forKey: "DispatcherDriverInfo")) != nil)
        {
            print("There is driver info and passengger name is \(String(describing: cell.lblPassengerName.text))")
            
            cell.lblDispatcherName.text = (data.object(forKey: "DispatcherDriverInfo") as? [String:AnyObject])!["Email"] as? String
            cell.lblDispatcherEmail.text = (data.object(forKey: "DispatcherDriverInfo") as? [String:AnyObject])!["Fullname"] as? String
            cell.lblDispatcherNumber.text = (data.object(forKey: "DispatcherDriverInfo") as? [String:AnyObject])!["MobileNo"] as? String
            cell.lblDispatcherNameTitle.text = "DISPACTHER NAME"
            cell.lblDispatcherEmailTitle.text = "DISPATCHER EMAIL"
            cell.lblDispatcherNumberTitle.text = "DISPATCHER TITLE"
            
            cell.stackViewEmail.isHidden = false
            cell.stackViewName.isHidden = false
            cell.stackViewNumber.isHidden = false
        }
        */
       
        //        }
        //        else {
        //
        //            cell2.frame.size.height = self.tableView.frame.size.height
        //
        ////            return cell2
        //        }
        
    }
    
   
    func setTimeStampToDate(timeStamp: String) -> String {
        
        let unixTimestamp = Double(timeStamp)
        //        let date = Date(timeIntervalSince1970: unixTimestamp)

        let date = Date(timeIntervalSince1970: unixTimestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system //TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss" //Specify your format that you want
        let strDate: String = dateFormatter.string(from: date)
        
        return strDate
    }
    func setTimeStampToDateDropTime(timeStamp: String) -> String {
        
        let unixTimestamp = Double(timeStamp)
        //        let date = Date(timeIntervalSince1970: unixTimestamp)
        
        let date = Date(timeIntervalSince1970: unixTimestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system //TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss" //Specify your format that you want
        let strDate: String = dateFormatter.string(from: date)
        
        return strDate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        if indexPath.section == 0 {
        //
        //            if aryPastJobs.count != 0 {
        //

        if let cell = tableView.cellForRow(at: indexPath) as? PastJobsListViewCell {
            cell.viewAllDetails.isHidden = !cell.viewAllDetails.isHidden
            if cell.viewAllDetails.isHidden {
                expandedCellPaths.remove(indexPath)
            } else {
                expandedCellPaths.insert(indexPath)
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            //            tableView.deselectRow(at: indexPath, animated: true)
        }
        //            }
        //        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOfPastbookingpagination(index: Int) {
        
        let driverId = Singletons.sharedInstance.strDriverID + "/" + "\(index)"
        
        webserviceForPastBooking(driverId as AnyObject, isLoading: false) { (result, status) in
            if (status) {
                DispatchQueue.main.async {
                    
                    let tempPastData = ((result as! NSDictionary).object(forKey: "history") as! NSArray)
                    
                    for i in 0..<tempPastData.count {
                        
                        let dataOfAry = (tempPastData.object(at: i) as! NSDictionary)
                        
                        let strHistoryType = dataOfAry.object(forKey: "HistoryType") as? String
                        
                        if strHistoryType == "Past" {
                            self.aryPastJobs.add(dataOfAry)
                        }
                    }
                    
                    if(self.aryPastJobs.count == 0) {
                        self.labelNoData.text = "No data found."
                        self.tblView.isHidden = true
                    }
                    else {
                        self.labelNoData.removeFromSuperview()
                        self.tblView.isHidden = false
                    }
                    
                    //                    self.getPostJobs()
                    self.refreshControl.endRefreshing()
                    self.tblView.reloadData()
                    
                    UtilityClass.hideACProgressHUD()
                }
            }
            else {
//                Utilities.showAlert("", message: result as! String, vc: self)
//                UtilityClass.showAlertOfAPIResponse(param: result, vc: self)
            }
        }
    }
    func webserviceofPendingJobs() {
        /*
        Utilities.showActivityIndicator()
        let driverID = Singletons.sharedInstance.strDriverID
        //        UtilityClass.showHUD()
        
        webserviceForBookingHistry(driverID as AnyObject) { (result, status) in
            
            if (status) {
                //                print(result)
                
                self.aryData = ((result as! NSDictionary).object(forKey: "history") as! NSArray)
                
                
                if(self.aryData.count == 0)
                {
                    self.labelNoData.text = "There are no data"
                    self.tblView.isHidden = true
                }
                else
                {
                    self.labelNoData.removeFromSuperview()
                    self.tblView.isHidden = false
                }
                
                self.getPostJobs()
                self.tblView.reloadData()
                self.refreshControl.endRefreshing()
                Utilities.hideActivityIndicator()
                //               UtilityClass.hideHUD()
                //                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            else {
                //                print(result)
                //               UtilityClass.hideHUD()
                //                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                Utilities.hideActivityIndicator()
            }
        }
        
        */
    }
    
    func getPostJobs() {
        
        aryPastJobs.removeAllObjects()
        
        refreshControl.endRefreshing()
        for i in 0..<aryData.count {
            
            let dataOfAry = (aryData.object(at: i) as! NSDictionary)
            
            let strHistoryType = dataOfAry.object(forKey: "HistoryType") as? String
            
            if strHistoryType == "Past" {
                self.aryPastJobs.add(dataOfAry)
            }
            
        }
    }
    
    
}
