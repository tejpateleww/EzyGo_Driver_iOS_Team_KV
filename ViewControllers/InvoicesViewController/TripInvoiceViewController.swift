//
//  TripInvoiceViewController.swift
//  ezygo-Driver
//
//  Created by Apple on 15/11/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class TripInvoiceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,FilterReceiptDelegate {
    
    var strNotAvailable: String = "N/A"
    var aryData = NSMutableArray()
    var aryPastJobs = NSMutableArray()
    var strNoAmount = "0.0"
    var selectedCellIndexPath: IndexPath?
    let selectedCellHeight: CGFloat = 350.5
    let unselectedCellHeight: CGFloat = 86.5
    var thereIsCellTapped = false
    var selectedRowIndex = -1
    
    @IBOutlet var tblView: UITableView!
    
    
    var expandedCellPaths = Set<IndexPath>()
    var labelNoData = UILabel()
    
    
    var PageLimit:Int = 10
    var NeedToReload:Bool = false
    var PageNumber:Int = 1
    
    var ReceiptID:String = ""
    var startDate:String = ""
    var endDate:String = ""
    
    @IBOutlet weak var conNavigationHeight: NSLayoutConstraint!
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
        self.labelNoData.text = "Results not found"
        self.labelNoData.textAlignment = .center
        self.view.addSubview(self.labelNoData)
//        self.tblView.isHidden = true
        
        self.tblView.tableFooterView = UIView()
        
        
        self.tblView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        self.tblView.addSubview(self.refreshControl)
        self.ReloadNewData()
//        self.webserviceofPendingJobs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        conNavigationHeight.constant = self.navigationController!.navigationBar.frame.height + 20.0
        self.view.layoutIfNeeded()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false

    }
    @IBAction func btnCall(_ sender: Any) {
        
        let contactNumber = helpLineNumber
        
        if contactNumber == "" {
            Utilities.showAlert("", message: "Contact number is not available", vc: self)
//            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
//            }
        }
        else
        {
            callNumber(phoneNumber: contactNumber)
        }
    }
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
//    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//
//        //        aryPastJobs.removeAllObjects()
//
//        webserviceofPendingJobs()
//
//        tblView.reloadData()
//
//
//    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.startDate = ""
        self.endDate = ""
        self.ReceiptID = ""
        self.ReloadNewData()
        //        webserviewOfMyReceipt()
        //
        //        tableView.reloadData()
        //        refreshControl.endRefreshing()
        
    }
    
    @objc func ReloadNewData(){
        self.PageNumber = 1
        self.NeedToReload = false
        self.aryData.removeAllObjects()
        self.tblView.reloadData()
        self.webserviewOfMyReceipt()
    }
    
    func reloadMoreHistory() {
        self.PageNumber += 1
        self.webserviewOfMyReceipt()
    }
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnFilter(_ sender: Any) {
        
        let TripViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptFilterViewController") as! ReceiptFilterViewController
        TripViewController.FilterDelegate = self
        self.present(TripViewController, animated: true, completion: nil)
        //        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(TripViewController, animated: true, completion: nil)
    }
    
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        
        return aryPastJobs.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripInoviceCell") as! PastJobsListViewCell
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
        
        cell.lblPassengerName.text = data.object(forKey: "PassengerName") as? String
        
        //        cell.lblDropoffLocation.text = data.object(forKey: "PassengerName") as? String
        cell.lblDropoffLocationDescription.text = data.object(forKey: "DropoffLocation") as? String // DropoffLocation
        cell.lblBooingId.text = "Booking ID : \(data.object(forKey: "Id") as? String ?? strNotAvailable)"
        
        cell.lblPickupLocationDesc.text = data.object(forKey: "PickupLocation") as? String // PickupLocation
        
        let strBookingDate = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AcceptedTime", isNotHave: strNotAvailable)
        
        if strBookingDate == strNotAvailable {
            cell.lblDateAndTime.text = strBookingDate
        } else {
            //            cell.lblDateAndTime.text = setTimeStampToDate(timeStamp: strBookingDate)
            cell.lblDateAndTime.text = Utilities.formattedDateFromStringPost(dateString: strBookingDate, withFormat: "dd/MM/yyyy")
            
        }
        
        //        cell.lblpassengerEmail.text = data.object(forKey: "PassengerEmail") as? String //my change
        //        cell.lblPassengerNo.text = data.object(forKey: "PassengerMobileNo") as? String
        //                cell.lblPickupTime.text = data.object(forKey: "PickupTime") as? String
        
        
        let pickupTime = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PickupTime", isNotHave: strNotAvailable)
        let strDropoffTime = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "DropTime", isNotHave: strNotAvailable)
        
        
        if pickupTime == strNotAvailable {
            cell.lblPickupTime.text = pickupTime
        } else {
            cell.lblPickupTime.text = setTimeStampToDateDropTime(timeStamp: pickupTime)
        }
        
        if strDropoffTime == strNotAvailable {
            cell.lblDropOffTimeDesc.text = strDropoffTime
        } else {
            cell.lblDropOffTimeDesc.text = setTimeStampToDateDropTime(timeStamp: strDropoffTime)
        }
        
        
        cell.lblBokingChargeDesc.text = "\(currency)\(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "BookingCharge", isNotHave: strNoAmount))" // data.object(forKey: "BookingCharge") as? String

        
//        cell.lblBokingChargeDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "BookingCharge", isNotHave: strNotAvailable) // data.object(forKey: "BookingCharge") as? String
        
        cell.lblTripFareDesc.text = currency + checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "TripFare", isNotHave: "0.0") //  data.object(forKey: "TripFare") as? String
        
        
        if let strUrl = data["MapUrl"] as? String {
            cell.imgVwMap.sd_setImage(with: URL.init(string: strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), placeholderImage: UIImage.init(named: ""))
            
        }
        cell.lblWaitingTimeCostDesc.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "WaitingTimeCost", isNotHave: strNoAmount)) ?? 0.0 ) //  data.object(forKey: "WaitingTimeCost") as? String
        
        
        cell.lblSubTotalDesc.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "SubTotal", isNotHave: strNoAmount)) ?? 0.0 ) // data.object(forKey: "SubTotal") as? String
        
//        cell.lblAirportPickUp.text = currency + checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AirportPickUpCharge", isNotHave: strNoAmount)
//
//        cell.lblAirportDropOf.text = currency + checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AirportDropOffCharge", isNotHave: strNoAmount)
        
        cell.lblAirportPickUp.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AirportPickUpCharge", isNotHave: "0.0")) ?? 0.0)
        
        
        cell.lblAirportDropOf.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AirportDropOffCharge", isNotHave: "0.0")) ?? 0.0)
        
        cell.lblSoilingDamage.text = currency + checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "SoilDamageCharge", isNotHave: strNoAmount)
        
        
        
        
      
        
        
        cell.lblCancellationCharge.text = currency + checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "CancellationFee", isNotHave: "0")
        
        
        
        
        //change
        let strAirportPickupEmpty = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AirportPickUpCharge", isNotHave: "")
        let strAirportDropupEmpty = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AirportDropOffCharge", isNotHave: "")
        let strSoilDamageEmpty = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "SoilDamageCharge", isNotHave: "")
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
        
        
        
//        if (strAirportPickupEmpty.isEmptyOrWhitespace()) {
//            cell.stackVwAirportPickup.isHidden = true
//        }else {
//            cell.stackVwAirportPickup.isHidden = false
//        }
//
//        if (strAirportDropupEmpty.isEmptyOrWhitespace()) {
//            cell.stackVwAirportDropoff.isHidden = true
//        }else {
//            cell.stackVwAirportDropoff.isHidden = false
//        }
        
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
        //
        
        
        
        cell.lblGrandTotalDesc.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "GrandTotal", isNotHave: "0")) ?? 0.0 )
        
        cell.lblDistanceTravelled.text = String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "TripDistance", isNotHave: strNoAmount)) ?? 0.0 ) + " km"
        
        
        
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
        
        
        
        
        
        
        let duration =  checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "TripDuration", isNotHave: strNotAvailable)
        
        if duration != strNotAvailable {
            
            let intDuration = Double(duration)
            cell.lblTripDuration.text = UtilityClass.timeString(time: intDuration ?? 0.0)
            
        }else {
            cell.lblTripDuration.text = "00:00:00"
        }
        
        //        cell.lblTripDuration.text = strTripDuration
        
        cell.lblMileageCost.text = currency + String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "DistanceFare", isNotHave: strNoAmount)) ?? 0.0)
//        cell.lblMileageCost.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "DistanceFare", isNotHave: strNotAvailable)
        
        cell.lblDriverEarnings.text = currency +  String(format: "%.2f",Double(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "CompanyAmount", isNotHave: strNoAmount)) ?? 0.0)
        
        let strTaxReceipt = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "ReceiptType", isNotHave: strNotAvailable)
        cell.lblIncludingTax.isHidden =  (strTaxReceipt == "Tax Invoice") ? false : true
        
//        let strDiscount = currency + checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Discount", isNotHave: strNotAvailable)
        
        
        
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
//        if strDiscount == currency + strNotAvailable || strDiscount == strNotAvailable {
//            cell.lblLessTitle.isHidden = true
//            cell.lblPromoCreditUsed.isHidden = true
//            cell.lblPromoCreditTitle.isHidden = true
//        } else {
//            cell.lblLessTitle.isHidden = false
//            cell.lblPromoCreditUsed.isHidden = false
//            cell.lblPromoCreditTitle.isHidden = false
//            let strCouponTitle = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PromoCode", isNotHave: strNotAvailable)
//            cell.lblPromoCreditTitle.text = strCouponTitle + " Promo Applied"
//            cell.lblPromoCreditUsed.text = strDiscount
//        }
        
        cell.btnShareReciept.tag = indexPath.row
        cell.btnShareReciept.addTarget(self, action: #selector(shareRecieptClick(_:)), for: .touchUpInside)
        
        
        cell.btnViewReciept.tag = indexPath.row
        cell.btnViewReciept.addTarget(self, action: #selector(openRecieptUrl(_:)), for: .touchUpInside)
        
        if self.NeedToReload == true && indexPath.row == self.aryData.count - 1  {
            self.reloadMoreHistory()
        }
        return cell
    
        
    }
    
    //MARK: shareReceipt
    @IBAction func shareRecieptClick(_ sender: UIButton) {
        let data = aryPastJobs[sender.tag] as! NSDictionary
        let strShareUrl = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "ShareUrl", isNotHave: strNotAvailable)
        if strShareUrl != strNotAvailable {            
            Utilities.shareUrl(strShareUrl)
        }
    }
    @IBAction func openRecieptUrl(_ sender: UIButton) {
        let data = aryPastJobs[sender.tag] as! NSDictionary
        let strShareUrl = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "ShareUrl", isNotHave: strNotAvailable)
        if strShareUrl != strNotAvailable {
            let vwTripInvoice = self.storyboard?.instantiateViewController(withIdentifier: "ShowTripViewController") as! ShowTripViewController
            vwTripInvoice.URLString = strShareUrl
            self.navigationController?.pushViewController(vwTripInvoice, animated: true)
//            Utilities.shareUrl(strShareUrl)
        }
    }
    func setTimeStampToDate(timeStamp: String) -> String {
        
//        let unixTimestamp = Double(timeStamp)
//        //        let date = Date(timeIntervalSince1970: unixTimestamp)
//
//        let date = Date(timeIntervalSince1970: unixTimestamp!)
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = NSTimeZone.system //TimeZone(abbreviation: "GMT") //Set timezone that you want
//        dateFormatter.locale = NSLocale.current
//        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss" //Specify your format that you want
//        let strDate: String = dateFormatter.string(from: date)
        
        return timeStamp
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
    
    /*
    func webserviceofPendingJobs() {
        
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
        
        
    }
    */
    
    func getPostJobs() {
        
        aryPastJobs.removeAllObjects()
        
        refreshControl.endRefreshing()
        for i in 0..<aryData.count {
            
            let dataOfAry = (aryData.object(at: i) as! NSDictionary)
            
//            let strHistoryType = dataOfAry.object(forKey: "HistoryType") as? String
              let strHistoryType = dataOfAry.object(forKey: "Status") as? String
            
            if strHistoryType == "completed" {
                self.aryPastJobs.add(dataOfAry)
            }
            
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var newAryData:[[String:Any]] = []

    
    func webserviewOfMyReceipt() {
        
        let dictParams = NSMutableDictionary()
        let driverID = Singletons.sharedInstance.strDriverID
        
        dictParams.setObject(driverID, forKey: "DriverId" as NSCopying)
        if PageNumber != 0 {
            dictParams.setObject(PageNumber, forKey: "Page" as NSCopying)
        }
        
        if startDate != "" {
            dictParams.setObject(startDate, forKey: "StartBookingDate" as NSCopying)
        }
        
        if endDate != "" {
            dictParams.setObject(endDate, forKey: "EndBookingDate" as NSCopying)
        }
        
        if ReceiptID != "" {
            dictParams.setObject(ReceiptID, forKey: "BookingId" as NSCopying)
        }
        
        if PageNumber == 1 {
            self.aryData.removeAllObjects()
            self.aryPastJobs = self.aryData
            //            self.arrFilteredData = self.aryData
            self.tblView.reloadData()
        }
        
        webserviceForBookingHistory(dictParams as AnyObject) { (result, status) in
            
            if (status) {
                //                self.aryData = (result as! [String:Any])["history"] as! [[String:Any]]
                //                self.newAryData = []
                
                let arrResult = ((result as! NSDictionary).object(forKey: "history") as! NSArray)
                let arrHistory: NSMutableArray = arrResult.mutableCopy() as! NSMutableArray
                //                    (result as! [String:Any])["history"] as! [[String:Any]]
                
                if arrHistory.count == 10 {
                    self.NeedToReload = true
                } else {
                    self.NeedToReload = false
                }
                
                if self.aryData.count == 0 {
                    self.aryData = arrHistory
                } else {

                    self.aryData.addObjects(from: arrHistory as! [Any])
                    //                    self.aryData.append(contentsOf: arrHistory)
                }
                
                self.refreshControl.endRefreshing()
              
                self.aryPastJobs = self.aryData
                
                if self.aryData.count == 0 {
                    self.labelNoData.isHidden = false
                }else {
                    self.labelNoData.isHidden = true
                }
                self.tblView.reloadData()
                
            }
            else {
                print(result)
                
                if let res = result as? String {
                    Utilities.showAlert("", message: res, vc: self)
                    //                    UtilityClass.setCustomAlert(title: alertTitle, message: res) { (index, title) in
                    //                    }
                }
                else if let resDict = result as? NSDictionary {
                    Utilities.showAlert("", message: resDict.object(forKey: "message") as! String, vc: self)
                    //                    UtilityClass.setCustomAlert(title: alertTitle, message: resDict.object(forKey: "message") as! String) { (index, title) in
                    //                    }
                }
                else if let resAry = result as? NSArray {
                    Utilities.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                    //                    UtilityClass.setCustomAlert(title: alertTitle, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                }
            }
        }
    }
    // Filter Delegate Methods
    
    func filterByBookId(BookingId: String) {
        self.startDate = ""
        self.endDate = ""
        self.PageNumber = 1
        self.ReceiptID = BookingId
        self.webserviewOfMyReceipt()
        
        //        let DatePredicate = NSPredicate(format: "%K == %@", "Id", BookingId)
        //        let tempArr = self.newAryData.filter({ return DatePredicate.evaluate(with: $0)})
        //        self.arrFilteredData = tempArr
        //        self.tableView.reloadData()
    }
    
    func filterByDate(FromDate: Date, ToDate: Date) {
        //    func filterByDate(FromDate: String, ToDate: String) {
        self.startDate = ""
        self.endDate = ""
        self.ReceiptID = ""
        self.PageNumber = 1
        //        self.webserviewOfMyReceipt()
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "dd-MM-yyyy"
        //
        myDateFormatter.locale = Locale(identifier: Locale.current.identifier)
        
        self.startDate = "\(myDateFormatter.string(from: FromDate))"
        self.endDate = "\(myDateFormatter.string(from: ToDate))"
        self.webserviewOfMyReceipt()
        //
        //
        //        let FilterDateFormatter: DateFormatter = DateFormatter()
        //        FilterDateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        //        FilterDateFormatter.locale = Locale(identifier: Locale.current.identifier)
        //        let startDate = FilterDateFormatter.date(from: FromDateString)
        //        let endDate = FilterDateFormatter.date(from: ToDateString)
        //
        //        var FinalArr:[[String:Any]] = []
        //        for SingleReceipt in self.newAryData {
        //            if let ReceiptDate:String = SingleReceipt["CreatedDate"] as? String {
        //                let receiptDate = FilterDateFormatter.date(from: ReceiptDate)
        //                if receiptDate?.compare(startDate!) == .orderedDescending && receiptDate?.compare(endDate!) == .orderedAscending {
        //                    FinalArr.append(SingleReceipt)
        //                }
        //            }
        //        }
        
        //        let FilterDateFormatter: DateFormatter = DateFormatter()
        //        FilterDateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        //
        ////        let startDate = FilterDateFormatter.date(from: FromDateString)
        ////        let endDate = FilterDateFormatter.date(from: ToDateString)
        //
        //        var FinalArr:[[String:Any]] = []
        //        for SingleReceipt in self.newAryData {
        //            if let ReceiptDate:String = SingleReceipt["CreatedDate"] as? String {
        ////                let receiptDate = FilterDateFormatter.date(from: ReceiptDate)
        //                if ReceiptDate >= FromDateString && ReceiptDate <= ToDateString {
        //                    FinalArr.append(SingleReceipt)
        //                }
        //            }
        //        }
        //
        
        
        /*
         let DatePredicate = NSPredicate(format: "(CreatedDate >= %@) AND (CreatedDate <= %@)", argumentArray: [FromDate,ToDate])
         //            NSPredicate(format: "CreatedDate >= %@ AND CreatedDate <= %@",FromDateString, ToDateString)
         //        let GreaterDatePredicate = NSPredicate(format: "%K >= %@", "CreatedDate", FromDateString)
         //        let LessDatePredicate = NSPredicate(format: "%K <= %@", "CreatedDate", ToDateString)
         //        let tempArr = self.newAryData.filter { ($0["CreatedDate"] ?? "") > nowString }
         //            self.newAryData.filter({ return GreaterDatePredicate.evaluate(with: $0)})
         let FinalArr = self.newAryData.filter{ DatePredicate.evaluate(with: $0) }
         //            tempArr.filter({ return LessDatePredicate.evaluate(with: $0)})
         */
        //        self.arrFilteredData = FinalArr
        //        self.tableView.reloadData()
        
    }
    
}
