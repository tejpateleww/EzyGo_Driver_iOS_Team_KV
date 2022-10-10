//
//  FutureBookingVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 16/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class FutureBookingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var strNotAvailable: String = "N/A"
    
    
    //    let hView = HeaderView()
    
    var dataPatam = [String:AnyObject]()
    var aryData = NSMutableArray()
    var expandedCellPaths = Set<IndexPath>()
    
   
    var selectedCellIndexPath: IndexPath?
    let selectedCellHeight: CGFloat = 205
    let unselectedCellHeight: CGFloat = 105
    
    var drieverId = String()
    var bookingID = String()
    
    
    @IBOutlet var tblView: UITableView!
    
    var labelNoData = UILabel()
    
        lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:
                #selector(self.handleRefresh(_:)),
                                     for: UIControlEvents.valueChanged)
            refreshControl.tintColor = ThemeYellowColor
    
            return refreshControl
        }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tblView.dataSource = self
        tblView.delegate = self
        
        tblView.tableFooterView = UIView()
        
        labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.labelNoData.text = "Loading..."
        labelNoData.textAlignment = .center
        self.view.addSubview(labelNoData)
        self.tblView.isHidden = true
        
        
        self.tblView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        self.tblView.addSubview(self.refreshControl)
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.webserviceOFFurureBooking(showHud: true)
        
    }
    override func loadView()
    {
        super.loadView()
        
        //        let activityData = ActivityData()
        //        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.webserviceOFFurureBooking(showHud: true)
        tblView.reloadData()
        
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if section == 0 {
        //
        //            if aryData.count == 0 {
        //                return 1
        //            }
        //            else {
        //                return aryData.count
        //            }
        //        }
        //        else {
        //            return 1
        //        }
        
        return aryData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FutureBookingViewCell") as! FutureBookingViewCell
        //        let cell2 = tableView.dequeueReusableCell(withIdentifier: "NoDataFound") as! FutureBookingTableViewCell
        
        cell.selectionStyle = .none
        
        cell.viewCell.layer.cornerRadius = 10
        cell.viewCell.clipsToBounds = true
        cell.viewCell.layer.shadowRadius = 3.0
        cell.viewCell.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        cell.viewCell.layer.shadowOffset = CGSize (width: 1.0, height: 1.0)
        cell.viewCell.layer.shadowOpacity = 1.0
        
//        cell.viewSecond.isHidden = !expandedCellPaths.contains(indexPath)
//        cell.viewCell.isHidden = !expandedCellPaths.contains(indexPath)
        
        cell.viewAllDetails.isHidden = !expandedCellPaths.contains(indexPath)
        
        //        cell2.selectionStyle = .none
        
        let data = aryData.object(at: indexPath.row) as! NSDictionary
        
        //        cell.viewAllDetails.isHidden = true
        //                cell.selectionStyle = .none
        
//        cell.lblPassengerName.text = data.object(forKey: "PassengerName") as? String
        cell.lblPassengerName.text = "Passenger Name : \(data.object(forKey: "PassengerName") as? String ?? "")"
        //        cell.lblDropoffLocation.text = data.object(forKey: "PassengerName") as? String
        cell.lblDropoffLocationDescription.text = data.object(forKey: "DropoffLocation") as? String // DropoffLocation
        cell.lblBooingId.text = "Booking ID : \(data.object(forKey: "Id") as? String ?? strNotAvailable)"
        
        cell.lblPickupLocationDesc.text = data.object(forKey: "PickupLocation") as? String // PickupLocation
        
        let strBookingDate = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PickupDateTime", isNotHave: strNotAvailable)
        
        if strBookingDate == strNotAvailable {
            cell.lblDateAndTime.text = strBookingDate
        } else {
            //            cell.lblDateAndTime.text = setTimeStampToDate(timeStamp: strBookingDate)
            cell.lblDateAndTime.text = Utilities.formattedDateFromStringPost(dateString: strBookingDate, withFormat: "dd/MM/yyyy hh:mm")
            
        }
        
        //        cell.lblpassengerEmail.text = data.object(forKey: "PassengerEmail") as? String //my change
        //        cell.lblPassengerNo.text = data.object(forKey: "PassengerMobileNo") as? String
        //                cell.lblPickupTime.text = data.object(forKey: "PickupTime") as? String
        
        
        let pickupTime = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PickupDateTime", isNotHave: strNotAvailable)
        let strDropoffTime = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "DropTime", isNotHave: strNotAvailable)
        
        
        if pickupTime == strNotAvailable {
            cell.lblPickupTime.text = pickupTime
        } else {
            cell.lblPickupTime.text = setTimeStampToDate(timeStamp: pickupTime)
        }
        
        if strDropoffTime == strNotAvailable {
            cell.lblDropOffTimeDesc.text = strDropoffTime
        } else {
            cell.lblDropOffTimeDesc.text = setTimeStampToDate(timeStamp: strDropoffTime)
        }
        
        
        /*
        let strStatus = data.object(forKey: "Status") as! String
        //        Singletons.sharedInstance.DriverTripCurrentStatus = strStatus
        
        if strStatus == kAcceptTripStatus  || strStatus == kPendingJob
        {
            cell.btnStartTrip.isHidden = false
            cell.btnStartTrip.tag = Int((data.object(forKey: "Id") as? String)!)!
            cell.btnStartTrip.addTarget(self, action: #selector(self.strtTrip(sender:)), for: .touchUpInside)
        }
        else
        {
            cell.btnStartTrip.isHidden = true
        }
        */
        cell.btnAction.tag = Int((data.object(forKey: "Id") as? String)!)!
        // Changes  Accepte Future booking button show
        cell.btnAction.accessibilityValue = ("\(indexPath.row)")
      //  cell.btnAction.isHidden = true
        cell.btnAction.addTarget(self, action: #selector(self.btnActionForSelectRecord(sender:)), for: .touchUpInside)
        
        if let strUrl = data["MapUrl"] as? String {
            cell.imgVwMap.sd_setImage(with: URL.init(string: strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), placeholderImage: UIImage.init(named: ""))

        }
        
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
        
        cell.lblBokingChargeDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "BookingCharge", isNotHave: strNotAvailable) // data.object(forKey: "BookingCharge") as? String
        
        cell.lblTripFareDesc.text = currency + checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "TripFare", isNotHave: "0") //  data.object(forKey: "TripFare") as? String
        
        
        
        cell.lblWaitingTimeCostDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "WaitingTimeCost", isNotHave: strNotAvailable) //  data.object(forKey: "WaitingTimeCost") as? String
        cell.lblSubTotalDesc.text = currency + checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "SubTotal", isNotHave: "0") // data.object(forKey: "SubTotal") as? String
        
        cell.lblAirportPickUp.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AirportPickUpCharge", isNotHave: strNotAvailable)
        
        cell.lblAirportDropOf.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "AirportDropOffCharge", isNotHave: strNotAvailable)
        
        cell.lblSoilingDamage.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "SoilDamageCharge", isNotHave: strNotAvailable)
        
        cell.lblCancellationCharge.text = currency + checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "CancellationFee", isNotHave: "0")
        
        cell.lblGrandTotalDesc.text = currency + checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "GrandTotal", isNotHave: "0")
        
        cell.lblDistanceTravelled.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "TripDistance", isNotHave: strNotAvailable)
        
        cell.lblTripDuration.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "TripDuration", isNotHave: strNotAvailable)
        
        cell.lblMileageCost.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "DistanceFare", isNotHave: strNotAvailable)
        
        //        cell2.selectionStyle = .none
        
        //        if aryData.count != 0 {
        
        //            if indexPath.section == 0 {
        //
        /*
        let data = aryData.object(at: indexPath.row) as! NSDictionary
        print(data)
        //        let dataInfo = data.object(forKey: "LuggageInfo") as! NSDictionary
        
        cell.lblServiceType.text = (data.object(forKey: "ServiceType") as? String)!
        
        print("serviceType responce: \(String(describing: cell.lblServiceType.text))")
        //        if let Passengers = dataInfo.object(forKey: "NoOfPassenger") as? NSNumber {
        //            cell.lblTotalPassenger.text = Passengers.stringValue
        //        }
        //        else if let Passengers = dataInfo.object(forKey: "NoOfPassenger") as? String {
        //            cell.lblTotalPassenger.text = Passengers
        //        }
        //        cell.lblSKI.text = "NO"
        //        if let SKI = dataInfo.object(forKey: "Ski") as? NSNumber
        //        {
        //            if SKI == 1
        //            {
        //                cell.lblSKI.text = "YES"
        //            }
        //
        //        }
        //        else if let SKI = dataInfo.object(forKey: "Ski") as? String
        //        {
        //            if SKI == "1"
        //            {
        //                cell.lblSKI.text = "YES"
        //            }
        //        }
        //
        //        cell.lblSnowboard.text = "NO"
        //        if let Snowboard = dataInfo.object(forKey: "Snowboard") as? NSNumber
        //        {
        //            if Snowboard == 1
        //            {
        //                cell.lblSnowboard.text = "YES"
        //            }
        //        }
        //        else if let Snowboard = dataInfo.object(forKey: "Snowboard") as? String
        //        {
        //            if Snowboard == "1"
        //            {
        //                cell.lblSnowboard.text = "YES"
        //            }
        //        }
        //
        //
        //        if let Luggauge = dataInfo.object(forKey: "LuggageCount") as? NSNumber
        //        {
        //            cell.lblLuggaugeCount.text = Luggauge.stringValue
        //        }
        //        else if let Luggauge = dataInfo.object(forKey: "LuggageCount") as? String
        //        {
        //            cell.lblLuggaugeCount.text = Luggauge
        //        }
        //
        //        if let Childs = dataInfo.object(forKey: "ChildCount") as? NSNumber
        //        {
        //            cell.lblTotalChild.text = Childs.stringValue
        //        }
        //        else if let Childs = dataInfo.object(forKey: "ChildCount") as? String
        //        {
        //            cell.lblTotalChild.text = Childs
        //        }
        //        cell.lblHandicapAccess.text = "NO"
        //
        //        if let Handicap = dataInfo.object(forKey: "Handicape") as? NSNumber
        //        {
        //            if Handicap == 1
        //            {
        //                cell.lblHandicapAccess.text = "YES"
        //            }
        //        }
        //        else if let Handicap = dataInfo.object(forKey: "Handicape") as? String
        //        {
        //            if Handicap == "1"
        //            {
        //                cell.lblHandicapAccess.text = "YES"
        //            }
        //        }
        //
        
        cell.lblPassengerName.text = data.object(forKey: "PassengerName") as? String
        
        
        if let TimeAndDate = data.object(forKey: "PickupDateTime") as? String {
            cell.lblTimeAndDateAtTop.text = setTimeStampToDate(timeStamp: TimeAndDate)
        }
        else {
            cell.lblTimeAndDateAtTop.text = "Not available"
        }
        
        
        cell.lblDropOffLocationDesc.text = (!Utilities.isEmpty(str: (data.object(forKey: "PickupLocation") as? String))) ? (data.object(forKey: "PickupLocation") as? String) : "-" // DropoffLocation
        
        let strDate = data.object(forKey: "PickupDateTime") as! String
        let arrDate = strDate.components(separatedBy: " ")
        
        cell.lblDateAndTime.text = arrDate[0]//(!Utilities.isEmpty(str: (data.object(forKey: "PickupDateTime") as? String))) ? (data.object(forKey: "PickupDateTime") as? String) : "-"
        cell.lblPickupLocation.text = (!Utilities.isEmpty(str: (data.object(forKey: "DropoffLocation") as? String))) ? (data.object(forKey: "DropoffLocation") as? String) : "-"  // PickupLocation
        cell.lblPassengerNoDesc.text = (!Utilities.isEmpty(str: (data.object(forKey: "PassengerContact") as? String))) ? (data.object(forKey: "PassengerContact") as? String) : "-"
        cell.lblTripDestanceDesc.text = (!Utilities.isEmpty(str: (data.object(forKey: "TripDistance") as? String))) ? (data.object(forKey: "TripDistance") as? String) : "-"
        cell.lblCarModelDesc.text = (!Utilities.isEmpty(str: (data.object(forKey: "Model") as? String))) ? (data.object(forKey: "Model") as? String) : "-"
        cell.lblBookingID.text = data.object(forKey: "Id") as? String
        cell.btnAction.tag = Int((data.object(forKey: "Id") as? String)!)!
        cell.btnRejectFutureBooking.tag = Int((data.object(forKey: "Id") as? String)!)!
        
        
        cell.btnAction.addTarget(self, action: #selector(self.btnActionForSelectRecord(sender:)), for: .touchUpInside)
        cell.btnRejectFutureBooking.addTarget(self, action: #selector(self.btnRejectFutureBookingClicked(_:)), for: .touchUpInside)
        cell.lblFlightNumber.text = (!Utilities.isEmpty(str: (data.object(forKey: "FlightNumber") as? String))) ? (data.object(forKey: "FlightNumber") as? String) : "-"
        cell.lblNotes.text = (!Utilities.isEmpty(str: (data.object(forKey: "Notes") as? String))) ? (data.object(forKey: "Notes") as? String) : "-"
        cell.lblPaymentType.text = (!Utilities.isEmpty(str: (data.object(forKey: "PaymentType") as? String))) ? (data.object(forKey: "PaymentType") as? String) : "-"
        cell.viewSecond.isHidden = !expandedCellPaths.contains(indexPath)
        
        //            }
        
        
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
        return cell
 
        //        }
        //        else {
        //
        //            cell2.frame.size.height = self.tableView.frame.size.height
        //
        //            return cell2
        //        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //
        //        if aryData.count != 0 {
        //
        //            if indexPath.section == 0 {
        //
            if let cell = tableView.cellForRow(at: indexPath) as? FutureBookingViewCell {
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
    
    
    @objc func btnActionForSelectRecord(sender: UIButton)
    {
        
        bookingID = String((sender.tag))
        
        webserviceOfFutureAcceptDispatchJobRequest(Int(sender.accessibilityValue!) ?? 0)
      
    }
    
    @objc func btnRejectFutureBookingClicked(_ sender: UIButton)
    {
        
        let alert = UIAlertController(title: appName.kAPPName,
                                      message: "Are you sure you want to cancel the trip?",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
            Utilities.showActivityIndicator()
            
            let strBookingID = String((sender.tag))
            
            var dictParam = [String: AnyObject]()
            dictParam["DriverId"] = Singletons.sharedInstance.strDriverID as AnyObject
            dictParam["BookingId"] = strBookingID as AnyObject
            dictParam["BookingType"] = "BookLater" as AnyObject
            
            
            webserviceForCancelTrip(dictParam as AnyObject) { (result, status) in
                if (status) {
                    print(result)
                    Utilities.hideActivityIndicator()
                    //                self.resetMapView()
//                    self.webserviceOFFurureBooking(showHud: false)
                    if let resDict = result as? NSDictionary
                    {
                        
                        Utilities.showAlertWithCompletion(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self, completionHandler: { (result) in
                            
                            
                        })
                    }
                    self.bookingID = ""

                }
                else {
                    Utilities.hideActivityIndicator()
                    if let res = result as? String {
                        Utilities.showAlert(appName.kAPPName, message: res, vc: self)
                    }
                    else if let resDict = result as? NSDictionary {
                        Utilities.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
                    }
                    else if let resAry = result as? NSArray {
                        Utilities.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                    }
                }
            }
            
        })
        
        
        let cancelAction = UIAlertAction(title: "No",
                                         style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
//        Utilities.presentPopupOverScreen(alert)
        self.present(alert, animated: true, completion: nil)
       
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setTimeStampToDate(timeStamp: String) -> String {
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
        
        return timeStamp
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOFFurureBooking(showHud : Bool) {
        if showHud
        {
        Utilities.showActivityIndicator()
        }
        let id = Singletons.sharedInstance.strDriverID
        
        webserviceForFutureBooking(id as AnyObject) { (result, status) in
            
            if (status) {
                print("FutureBooking Responce : \(result)")
                
               let arrData = ((result as! NSDictionary).object(forKey: "dispath_job") as! NSArray)
                
                self.aryData = NSMutableArray.init(array: arrData)
                if(self.aryData.count == 0) {
                    self.labelNoData.text = "No upcoming jobs available." 
                    self.tblView.isHidden = true
                    self.view.addSubview(self.labelNoData)
                }
                else {
                    self.labelNoData.removeFromSuperview()
                    self.tblView.isHidden = false
                }
                
                self.refreshControl.endRefreshing()
                self.tblView.reloadData()
                Utilities.hideActivityIndicator()
            }
            else {
                //                print(result)
                Utilities.hideActivityIndicator()
            }
        }
    }
    
    var audioPlayer:AVAudioPlayer!
    
    func playSound(strName : String) {
        
        guard let url = Bundle.main.url(forResource: strName, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.numberOfLoops = 1
            audioPlayer.play()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        
        guard let url = Bundle.main.url(forResource: "\(RingToneSound)", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.stop()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    
    func webserviceOfFutureAcceptDispatchJobRequest(_ selectedIndex: Int)
    {
        
        Utilities.showActivityIndicator()
        drieverId = Singletons.sharedInstance.strDriverID
        
        let sendParam = drieverId + "/" + bookingID
        
        webserviceForFutureAcceptDispatchJobRequest(sendParam as AnyObject) { (result, status) in
            
            if (status)
            {
                print("before Remove\(self.aryData)")
                self.aryData.removeObject(at: selectedIndex)
                
                self.tblView.reloadData()
                print("after Remove\(self.aryData)")
                print(result)
                let alert = UIAlertController(title: "Booking Accepted", message: "", preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                    
                    Utilities.showActivityIndicator()
                    self.webserviceOFFurureBooking(showHud: false)
                    
                    if let VC = self.parent as? MyJobsViewController
                    {
                        if let VCPending = self.parent?.childViewControllers[1] as? PendingJobsViewController
                        {
                            VCPending.webserviceofPendingJobs()
                        }
                        VC.btnPendingJobsClicked(VC.btnPendingJobs)
                    }
                })
                
                alert.addAction(OK)
                self.present(alert, animated: true, completion: nil)
                Utilities.hideActivityIndicator()
            }
            else
            {
                print(result)
                
                Utilities.hideActivityIndicator()
                if let res = result as? String {
                    Utilities.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    Utilities.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    Utilities.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }
        
    }
    
    
    
}
