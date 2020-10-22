
//  MeterViewController.swift
//  PickNGo-Driver
//
//  Created by Mayur iMac on 21/02/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit
import DropDown
import CoreLocation



class MeterViewController: ParentViewController,didSelectAllOptions {


    
//    @IBOutlet weak var lblDistanceSymbol: UILabel!
//    @IBOutlet weak var lblDistanceInMeters: UILabel!
    @IBOutlet weak var lblFare: UILabel!
    @IBOutlet weak var lblHireCost: UILabel!
//    @IBOutlet weak var lblWaitingTime: UILabel!
//    @IBOutlet weak var lblWaitingCost: UILabel!
//    @IBOutlet weak var lblSpeed: UILabel!
//    @IBOutlet weak var btnPauseTrip : UIButton!
    var floatMainTime = CGFloat()
    
    @IBOutlet weak var lblTripDuration: UILabel!
    @IBOutlet weak var constraintHeightOfStartTrip: NSLayoutConstraint! // 51
    @IBOutlet weak var constraintHeightOfChooseVehicle: NSLayoutConstraint! // 50
    
    @IBOutlet weak var vwFare: UIView!
    
    var isFromHome = Bool()
    var vehicleID = Int()
    var waitingTime = Double()
    var isPaused = true
    var timer = Timer()

    var strSpeed = ""
    var baseFare = Double()
    var minKM = Double()
    var perKMCharge = Double()
    var waitingChargePerMinute = Double()
    var bookingFee = Double()
    
    //    var counter = 0.0
    
    var startTime = TimeInterval()
    let chooseArticleDropDown = DropDown()
    var arrOfTaxis = [[String:AnyObject]]()
    
    var vehicleModelID = Int()
    var strVehicleName = String()

    var strPaymentType = String()
    var strAirpotInCharge = String()
    var strAirpotOutCharge = String()



    var strWaitingTime = String()
    //    @IBOutlet weak var btnWaiting: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnChoosevehicle: UIButton!
//    @IBOutlet weak var viewKM: UIView!

    var arrMeterModels = [[String:AnyObject]]()
    
    var strStartTripLocation = String()
    var strEndTripLocation = String()
    
    // MARK: - View Cycle Methods -
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //My Side changes
        if Singletons.sharedInstance.arrVehicleClass.count != 0 {
            vehicleID = Singletons.sharedInstance.arrVehicleClass.firstObject as? Int ?? 0
            var dictdata = SingletonsForMeter.sharedInstance.arrCarModels[vehicleID-1]

            if(Singletons.sharedInstance.isBookNowOrBookLater == true )
            {
                dictdata = SingletonsForMeter.sharedInstance.arrMeterCarModels[vehicleID-1]
            }


            strVehicleName = dictdata["Name"] as! String



            self.btnChoosevehicle.setTitle(strVehicleName, for: .normal)
            self.vehicleModelID = Singletons.sharedInstance.arrVehicleClass[0] as! Int

            SingletonsForMeter.sharedInstance.vehicleModelID = (self.vehicleModelID)
            self.calculateDistanceAndPrice()
        }
        
        //
        
        
        
        if IS_IPHONE_4_OR_LESS || IS_IPAD {
            constraintHeightOfStartTrip.constant = 35
            constraintHeightOfChooseVehicle.constant = 40
        }
        
      //  self.btnPauseTrip.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel), name: NSNotification.Name(rawValue: "updateDistanceInMeters"), object: nil)
        
        

        if(Singletons.sharedInstance.MeterStatus == "")
        {
            Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterStop
        }
        
        if(Singletons.sharedInstance.MeterStatus != meterStatus.kIsMeterStop)
        {
            //            self.btnWaiting.isHidden = false
        //    self.btnPauseTrip.isHidden = false
            if (Singletons.sharedInstance.MeterStatus == meterStatus.kIsMeterOnHolding)
            {
                self.btnStart.isSelected = true
                //                self.btnWaiting.isSelected = true
                
        //        viewKM.backgroundColor = UIColor(hex: "#CCCCCC")
                
                
                self.updateLabel()
                
                if strVehicleName != ""
                {
                    self.btnChoosevehicle.setTitle(strVehicleName, for: .normal)
                }
                if App_Delegate.WaitingTime != ""
                {
                //    self.lblWaitingTime.text = App_Delegate.WaitingTime
                }
                else
                {
              //      self.lblWaitingTime.text = "00:00:00"
             //       self.lblSpeed.text = "0.0 km/hr"
                }
                if App_Delegate.DistanceKiloMeter != ""
                {
          //          self.lblDistanceInMeters.text = App_Delegate.DistanceKiloMeter
                }
                else
                {
         //           self.lblDistanceInMeters.text = "0.00"
        //            self.lblSpeed.text = "0.0 km/hr"
                }
            }
            else
            {
                //                self.btnWaiting.isSelected = false
                self.btnStart.isSelected = true
                self.setupAmountDropDown()
                self.updateLabel()
           //     viewKM.backgroundColor = UIColor(hex: "#FFA300")
                if(SingletonsForMeter.sharedInstance.arrCarModels.count == 0)
                {
                    webserviceCallToGetFare()
                }
                else
                {
                    if strVehicleName != ""
                    {
                        self.btnChoosevehicle.setTitle(strVehicleName, for: .normal)
                    }
                    if App_Delegate.WaitingTime != ""
                    {
          //              self.lblWaitingTime.text = App_Delegate.WaitingTime
                    }
                    else
                    {
         //               self.lblWaitingTime.text = "00:00:00"
         //               self.lblSpeed.text = "0.0 km/hr"
                    }
                    if App_Delegate.DistanceKiloMeter != ""
                    {
          //              self.lblDistanceInMeters.text = App_Delegate.DistanceKiloMeter
                    }
                    else
                    {
           //             self.lblDistanceInMeters.text = "0.00"
           //             self.lblSpeed.text = "0.0 km/hr"
                    }
                    self.calculateDistanceAndPrice()
                }
            }
            
        }
        else
        {
            lblFare.text = ""
          //  lblDistanceInMeters.text = "0.0 KM"
            lblHireCost.text = "\(kCurrencyForMeter) 0.0"
            self.lblTripDuration.text = "00:00:00"

         //   lblWaitingTime.text = "00:00:00"
         //   lblWaitingCost.text = "\(kCurrencyForMeter) 0.0"
            Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterStop
            self.btnChoosevehicle.setTitle(strVehicleName.isEmptyOrWhitespace() ? "Choose Vehicle" : strVehicleName , for: .normal)
            if !strVehicleName.isEmptyOrWhitespace() {
                self.calculateDistanceAndPrice()
            }
            
            //            self.btnWaiting.isHidden = true
            webserviceCallToGetFare()
        }
        //        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let colorTopGradient =  UIColor(red: 67/255, green: 3/255, blue: 3/255, alpha: 1)
    let colorBottomGradient = UIColor(red: 102/255, green: 18/255, blue: 1/255, alpha: 1)
    
  
    
    @IBAction func goBack()
    {
        if(isFromHome) {
            self.dismiss(animated: true, completion: {
                
            })
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func updateLabel() {
   //     self.lblDistanceInMeters.text = String(format:"%.2f", Singletons.sharedInstance.distanceTravelledThroughMeter)
    //    self.lblSpeed.text = "\(SingletonsForMeter.sharedInstance.strSpeed) km/hr"
   //     self.lblWaitingTime.text =  App_Delegate.WaitingTime;
        App_Delegate.DistanceKiloMeter = String(format:"%.2f", Singletons.sharedInstance.distanceTravelledThroughMeter)
  //      print("update label from meter view controller :: ===== \(String(describing: self.lblDistanceInMeters.text))")
        self.calculateDistanceAndPrice()
    }
    func calculateDistanceAndPrice() {
        var vehicleID = Int()
        
        for i in 0..<SingletonsForMeter.sharedInstance.arrCarModels.count {
            if ((SingletonsForMeter.sharedInstance.arrCarModels[i]["Id"] as! NSString).integerValue == SingletonsForMeter.sharedInstance.vehicleModelID)
            {
                vehicleID = i
            }
        }
        var dictdata = SingletonsForMeter.sharedInstance.arrCarModels[vehicleID]
        
        if(Singletons.sharedInstance.isBookNowOrBookLater == true)
        {
            dictdata = SingletonsForMeter.sharedInstance.arrMeterCarModels[vehicleID]
        }
        
        
        strVehicleName = dictdata["Name"] as! String
        baseFare = (dictdata["BaseFare"]! as! NSString).doubleValue// as! Double!
        minKM = (dictdata["MinKm"]! as! NSString).doubleValue//self.arrOfTaxis[0]["MinKm"] as! Double!
        perKMCharge = (dictdata["AbovePerKmCharge"]! as! NSString).doubleValue//self.arrOfTaxis[0]["AbovePerKmCharge"] as! Double!
        //        let nightCharge = self.arrOfTaxis[0]["NightCharge"]
        waitingChargePerMinute = (dictdata["WaitingTimePerMinuteCharge"]! as! NSString).doubleValue//self.arrOfTaxis[0]["WaitingTimePerMinuteCharge"] as! Double!
        bookingFee = (dictdata["BookingFee"]! as! NSString).doubleValue//self.arrOfTaxis[0]["BookingFee"] as! Double!
        
        var total = 0.0
        
        if(Singletons.sharedInstance.MeterStatus != meterStatus.kIsMeterOnHolding && Singletons.sharedInstance.distanceTravelledThroughMeter <= minKM) {
            total = baseFare + bookingFee
        } else {
            if (Singletons.sharedInstance.distanceTravelledThroughMeter <= minKM) {
                total = (Singletons.sharedInstance.distanceTravelledThroughMeter.rounded(toPlaces: 2) * perKMCharge) + baseFare + bookingFee
            }else {
                total = ((Singletons.sharedInstance.distanceTravelledThroughMeter - minKM) * perKMCharge) + baseFare + bookingFee
            }
        }
        
        var waitingMinutes = String()
        
        waitingMinutes  = "0.0"
        
        var waitingSeconds = String()
        
        waitingSeconds  = "0.0"
        var waitingCost = Double()
        
//        if (self.lblWaitingTime.text?.count != 0)
//        {
//            waitingMinutes = (self.lblWaitingTime.text?.components(separatedBy: ":")[1])!
//            waitingSeconds = (self.lblWaitingTime.text?.components(separatedBy: ":")[2])!
//
//            if (waitingMinutes != "")
//            {
//                total = total + (Double((Double(waitingMinutes)! * 60) + Double(waitingSeconds)!) * waitingChargePerMinute/60)
//                //                print("The waiting cost is \(Double((Double(waitingMinutes)! * 60) + Double(waitingSeconds)!) * waitingChargePerMinute/60)")
//                waitingCost = Double((Double(waitingMinutes)! * 60) + Double(waitingSeconds)!) * waitingChargePerMinute/60
//            }
//        }

        self.lblFare.text = String(format:"\(currency) %.2f", total)
        lblHireCost.text = "\(currency) \(String(format:"%.2f",baseFare))"
     //   lblWaitingCost.text = "\(currency) \(String(format:"%.2f", waitingCost))"
        
    }
    
    @IBAction func btnChooseVehicle(_ sender: Any) {
        if(Singletons.sharedInstance.MeterStatus == meterStatus.kIsMeterStop || Singletons.sharedInstance.MeterStatus == "") {
            chooseArticleDropDown.show()
        }
    }
    
    
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    @IBAction func btnCallHelpLine(_ sender: Any) {
        CallButtonClicked()
    }
    
//    func CallButtonClicked()     //  Call Button
//    {
//        let contactNumber = helpLineNumber
//        
//        if contactNumber == "" {
//            
//            UtilityClass.showAlertWithCompletion(appName.kAPPName, message: "Contact number is not available", vc: self, completionHandler: {_ in
//            })
//        }
//        else
//        {
//            callNumber(phoneNumber: contactNumber)
//        }
//    }
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    func updateTime()
    {
        
        
       // self.lblWaitingTime.text = App_Delegate.WaitingTime
        
        
        print("hello")
        
    }
    
    
    func setupAmountDropDown() {
        chooseArticleDropDown.anchorView = btnChoosevehicle
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: btnChoosevehicle.bounds.height)
        
        
        let profile: NSMutableDictionary = NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary))
        let Vehicle: NSMutableDictionary = NSMutableDictionary(dictionary: profile.object(forKey: "Vehicle") as! NSDictionary )
        
        let carType = Vehicle.object(forKey: "VehicleClass") as? String
        
        
        chooseArticleDropDown.dataSource = (carType?.components(separatedBy: ","))!
        
        chooseArticleDropDown.selectionAction = { [weak self] (index, item) in
            self?.btnChoosevehicle.setTitle(item, for: .normal)
            self?.vehicleModelID = Singletons.sharedInstance.arrVehicleClass[index] as! Int
            
            SingletonsForMeter.sharedInstance.vehicleModelID = (self?.vehicleModelID)!
            self?.calculateDistanceAndPrice()
        }
    }
    
    // MARK: - IBAction
    
    
    @IBAction func btnStart(_ sender: UIButton)
    {
      
        if ( SingletonsForMeter.sharedInstance.vehicleModelID != 0)
        {
            
            sender.isSelected = !sender.isSelected
            
            
            
            if (sender.isSelected)
            {
                self.startTrip()
                /*
                  var textData = String()
                let alert = UIAlertController(title: appName.kAPPName, message: "Enter Passenger mobile number", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.placeholder = "Passenger mobile number"
                    
//                    textData = textField.text!
                    
                }
                
                let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                    let textField = alert.textFields![0] // Force unwrapping because we know it exists.

                    UserDefaults.standard.set(textField.text!, forKey: passengerData.kPassengerMobileNunber)

                    self.startTrip()
                    
                })
                
                let Cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { ACTION in
                    
                    self.startTrip()
                })
                
                alert.addAction(OK)
                alert.addAction(Cancel)
                
                present(alert, animated: true, completion: nil)
                */
            } else {
                getAddressFromLatLon(Latitude: "\(Singletons.sharedInstance.latitude)", withLongitude: "\(Singletons.sharedInstance.longitude)", type: actionTypeCase.EndTrip.rawValue)
                
                
                NotificationCenter.default.removeObserver("updateDistanceInMeters")
                Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterStop
          //      self.btnPauseTrip.isHidden = true
                self.timer.invalidate()
                App_Delegate.RoadPickupTimer.invalidate()
                tripEnded()
            }
        } else{
            UtilityClass.showAlertAnother(appName.kAPPName, message: "Please select a car type", vc: self)
        }
        
    }
    
    func startTrip()  {
        
 
        getAddressFromLatLon(Latitude: "\(Singletons.sharedInstance.latitude)", withLongitude: "\(Singletons.sharedInstance.longitude)", type: actionTypeCase.StartTrip.rawValue)
        App_Delegate.RoadPickupTimer.invalidate()

        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:  #selector(MeterViewController.updateMainTime), userInfo: nil, repeats: true)
        
        Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterStart
        UtilityClass.showAlertAnother(appName.kAPPName, message: "Please stay connected to the app, untill the trip is finished! may be you can loose your data.", vc: self)
    //    self.btnPauseTrip.isHidden = false
        if (self.navigationController?.viewControllers[0].childViewControllers.count != 0)
        {
            let  homeVC = self.navigationController?.viewControllers[0].childViewControllers[0] as? HomeViewController
            homeVC?.manager.startUpdatingLocation()
            
        }
        else
        {
            let homeVC = self.navigationController?.viewControllers[1].childViewControllers[0].childViewControllers[0].childViewControllers[0] as? HomeViewController
            homeVC?.manager.startUpdatingLocation()
            
        }
        
        self.calculateDistanceAndPrice()
        
    }
    
    @IBAction func PauseResumeHoldMeter(_ sender: UIButton) {
        
        SingletonsForMeter.sharedInstance.isMeterOnHold = !sender.isSelected
        
        if(!sender.isSelected)
        {
            Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterOnHolding
            
        }
        else
        {
            Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterStart
            
        }
        
        
        
        if (self.navigationController?.viewControllers[0].childViewControllers.count != 0)
        {
            let  homeVC = self.presentingViewController?.childViewControllers.last?.childViewControllers.first?.childViewControllers.first as? HomeViewController
            homeVC?.btnHoldWaiting((homeVC?.btnWaiting)!)
            
        }
        else
        {
            let homeVC = self.navigationController?.viewControllers[1].childViewControllers[0].childViewControllers[0].childViewControllers[0] as? HomeViewController
            homeVC?.btnHoldWaiting((homeVC?.btnWaiting)!)
            
        }
        
        sender.isSelected = !sender.isSelected
        
    }

    
    @IBAction func btnWaiting(_ sender: UIButton)
    {
        
        if (Singletons.sharedInstance.MeterStatus != meterStatus.kIsMeterStop && Singletons.sharedInstance.MeterStatus != "" )
        {
            if (Singletons.sharedInstance.driverDuty == "0")
            {
                if (SingletonsForMeter.sharedInstance.vehicleModelID != 0)
                {
                    sender.isSelected = !sender.isSelected
                    
                    if (sender.isSelected)
                    {
                        
                        Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterOnHolding
                        let homeVC = self.navigationController?.viewControllers[0].childViewControllers[0] as? HomeViewController
                        homeVC?.btnHoldWaiting((homeVC?.btnWaiting)!)
 //                       viewKM.backgroundColor = UIColor(hex: "#CCCCCC")
                        
                    }
                    else
                    {
    //                    viewKM.backgroundColor = UIColor(hex: "#FFA300")
                        Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterStart
                        let homeVC = self.navigationController?.viewControllers[0].childViewControllers[0] as? HomeViewController
                        homeVC?.btnHoldWaiting((homeVC?.btnWaiting)!)
                    }
                }
                else
                {
                    UtilityClass.showAlertAnother(appName.kAPPName, message: "Please select a car type", vc: self)
                }
            }
            else
            {
                if (SingletonsForMeter.sharedInstance.vehicleModelID != 0)
                {
                    sender.isSelected = !sender.isSelected
                    
                    if (sender.isSelected)
                    {
                        Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterOnHolding
                        let homeVC = self.navigationController?.viewControllers[0].childViewControllers[0] as? HomeViewController
                        homeVC?.btnHoldWaiting((homeVC?.btnWaiting)!)
   //                     viewKM.backgroundColor = UIColor(hex: "#CCCCCC")
                        
                    }
                    else
                    {
                        Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterStart
                        let homeVC = self.navigationController?.viewControllers[0].childViewControllers[0] as? HomeViewController
                        homeVC?.btnHoldWaiting((homeVC?.btnWaiting)!)
               //         viewKM.backgroundColor = UIColor(hex: "#FFA300")
                        
                    }
                }
            }
        }
        else
        {
            UtilityClass.showAlertAnother(appName.kAPPName, message: "To start waiting time the trip should on", vc: self)
            
        }
        
    }
    //MARK :- Webservice Call after trip end

    func presentSelectionVC()
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectionViewController") as! SelectionViewController
        viewController.delegate = self

        var vehicleID = Int()
        var dictdata = [String:AnyObject]()
        if Singletons.sharedInstance.isTripContinue {
            for i in 0..<SingletonsForMeter.sharedInstance.arrCarModels.count
            {
                if ((SingletonsForMeter.sharedInstance.arrCarModels[i]["Id"] as! NSString).integerValue == SingletonsForMeter.sharedInstance.vehicleModelID)
                {
                    vehicleID = i
                }
            }
             dictdata = SingletonsForMeter.sharedInstance.arrCarModels[vehicleID]
        }else {
            for i in 0..<SingletonsForMeter.sharedInstance.arrMeterCarModels.count
            {
                if ((SingletonsForMeter.sharedInstance.arrMeterCarModels[i]["Id"] as! NSString).integerValue == SingletonsForMeter.sharedInstance.vehicleModelID)
                {
                    vehicleID = i
                }
            }
             dictdata = SingletonsForMeter.sharedInstance.arrMeterCarModels[vehicleID]
        }
        /*
        for i in 0..<SingletonsForMeter.sharedInstance.arrCarModels.count
        {
            if ((SingletonsForMeter.sharedInstance.arrCarModels[i]["Id"] as! NSString).integerValue == SingletonsForMeter.sharedInstance.vehicleModelID)
            {
                vehicleID = i
            }
        }
        let dictdata = SingletonsForMeter.sharedInstance.arrCarModels[vehicleID]
        
        */
        viewController.vehicleDetails = dictdata
        self.present(viewController, animated: false, completion: nil)
    }

    func selectOptions(dictData: [String : String]) {

        strAirpotInCharge = dictData["AirportIn"] ?? ""
        strAirpotOutCharge = dictData["AirportOut"] ?? ""
        strPaymentType = dictData["PaymentType"] ?? ""
        webserviceCallForTripEnd()
    }


    func webserviceCallForTripEnd()
    {
        var dictParam = [String:AnyObject]()
        dictParam["ModelId"] = SingletonsForMeter.sharedInstance.vehicleModelID as AnyObject
        dictParam["EstimateKM"] = Singletons.sharedInstance.distanceTravelledThroughMeter as AnyObject
//        dictParam["WaitingCost"] = lblWaitingCost.text?.replacingOccurrences(of: "\(kCurrencyForMeter) ", with: "") as AnyObject

        if (UserDefaults.standard.object(forKey: passengerData.kPassengerMobileNunber) != nil)
        {
            dictParam["MobileNo"] = UserDefaults.standard.object(forKey: passengerData.kPassengerMobileNunber) as AnyObject

        }

        dictParam["PaymentType"] = strPaymentType as AnyObject
        dictParam["AirpotInCharge"] = strAirpotInCharge as AnyObject
        dictParam["AirpotOutCharge"] = strAirpotOutCharge as AnyObject
        dictParam["TripDuration"] = floatMainTime as AnyObject

        webserviceForGetFareWithKm(dictParam as AnyObject) { (result, status) in
            if(status == true)
            {
                
                let dictResult = result["estimate_fare"] as? [String:AnyObject]
                
                var fareAfterTripModel: FareAfterTrip?
                
                // --------------------------------------------
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: dictResult ?? "", options: .prettyPrinted)
                    let faredataAfterTrip = try? JSONDecoder().decode(FareAfterTrip.self, from: jsonData)
                    fareAfterTripModel = faredataAfterTrip
                }
                catch {
                    print(error.localizedDescription)
                }
                
//                let bookingFee ,perKMCharge,total: Double?
//                let name: String?
//                let  id, sort : Int?
//                let waitingCost,baseFare, tripFare, km: String?
                // ------------------------------------------------------------------------
                //                let totalKm = Double(fareAfterTripModel!.km!)?.rounded(toPlaces: 2)
                let doubleStr = String(format: "%.2f", Double(fareAfterTripModel!.km!)!) // "3.14"
                let doubleTripFareStr = String(format: "%.2f", Double(fareAfterTripModel!.tripFare!)!) // "3.14"
                let doubleGrandTotaleStr = String(format: "%.2f", Double(fareAfterTripModel!.total!)) // "3.14"

                var msg : String!
                var strTipDuration : String!
                strTipDuration = self.getMin()

                msg = "Car Type : \(fareAfterTripModel?.name ?? "") \n Base Fare : \(fareAfterTripModel?.baseFare ?? "") \n Total km : \(doubleStr) \n Trip Fare : \(doubleTripFareStr) \n Trip Duration :\(strTipDuration ?? "00:00:00")"

                if((dictResult?["AirpotInCharge"]) != nil) {
                    msg = msg + "\nAirport Pickup Charge : \(Double(dictResult?["AirportPickUpCharge"] as? String ?? "0.0") ?? 0.0)"
                    
                }
                if((dictResult?["AirpotOutCharge"]) != nil) {
                    msg = msg + "\nAirport Dropoff Charge : \(Double(dictResult?["AirportDropOffCharge"] as? String ?? "0.0") ?? 0.0)"

                }

                msg = msg + "\n --------------------------------------- Grand Total : \(doubleGrandTotaleStr)"
//                else
//                {
//                    msg = "Car Type : \(fareAfterTripModel?.name ?? "") \n Base Fare : \(fareAfterTripModel?.baseFare ?? "") \n Total km : \(doubleStr) \n Trip Fare : \(doubleTripFareStr) \n Airport In Charge : \(dictResult?["AirpotInCharge"] ?? "" as AnyObject) \n Airport Out Charge : \(dictResult?["AirpotInCharge"] ?? "" as AnyObject) \n --------------------------------------- \n Grand Total : \(doubleGrandTotaleStr)"
//                }

                // msg = "Car Type : \(fareAfterTripModel?.name ?? "") \n Base Fare : \(fareAfterTripModel?.baseFare ?? "") \n Per km Charge : \(fareAfterTripModel?.perKMCharge ?? 0.0) \n Total km : \(doubleStr) \n Trip Fare : \(fareAfterTripModel?.tripFare ?? "0.0") \n Waiting Cost : \(fareAfterTripModel?.waitingCost ?? "0.0") \n Booking Fee : \(fareAfterTripModel?.bookingFee ?? 0.0) \n --------------------------------------- Grand Total : \(fareAfterTripModel?.total ?? 0.0)"
                
                
                let carModelName: String = (self.btnChoosevehicle.titleLabel?.text!)!
                var dict = [String:AnyObject]()
                dict["DriverId"] = Singletons.sharedInstance.strDriverID as AnyObject
                dict["PickupLocation"] = self.strStartTripLocation as AnyObject
                dict["DropoffLocation"] = self.strEndTripLocation as AnyObject
                dict["ModelId"] = SingletonsForMeter.sharedInstance.vehicleModelID as AnyObject
                dict["ModelName"] = carModelName as AnyObject
                dict["GrandTotal"] = fareAfterTripModel?.total as AnyObject
                dict["KM"] = Singletons.sharedInstance.distanceTravelledThroughMeter as AnyObject
                dict["BaseFare"] = fareAfterTripModel?.baseFare as AnyObject
//                dict["WaitingTime"] = String(describing: self.lblWaitingTime.text!) as AnyObject
                dict["WaitingCost"] = fareAfterTripModel?.waitingCost as AnyObject
                dict["NightCharge"] = "0" as AnyObject
                dict["MobileNo"] = UserDefaults.standard.object(forKey: passengerData.kPassengerMobileNunber) as AnyObject
                dict["PaymentType"] = dictResult?["PaymentType"] as AnyObject
                dict["AirpotInCharge"] = dictResult?["AirpotInCharge"] as AnyObject
                dict["AirpotOutCharge"] = dictResult?["AirpotOutCharge"] as AnyObject
                dict["WaitingTimeCost"] = dictResult?["WaitingTimeCost"] as AnyObject

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: {  //change 2 second to 0
                    
                    self.webserviceOFPrivateMeterBooking(param: dict, message: msg)
                    
                })
               
//                UtilityClass.showAlert(appName.kAPPName, message: msg, vc: self)
            
            }
            
        }
    }

    @objc func updateMainTime()
    {
        floatMainTime = floatMainTime + 1.0
        lblTripDuration.text = self.getMin()
    }
    
    // MARK: - Webservice Call For getting fare of Taxis
    
    func webserviceCallToGetFare()
    {
        webserviceForGetTaxiModelPricing("" as AnyObject) { (result, status) in
            if(status)
            {
                if ((result as AnyObject)["model_cat1"] != nil)
                {
                    self.arrOfTaxis = (result["model_cat1"] as? [[String:AnyObject]])!
                    self.arrMeterModels = (result["meter_model"] as? [[String:AnyObject]])!
                    SingletonsForMeter.sharedInstance.arrCarModels = self.arrOfTaxis
                    SingletonsForMeter.sharedInstance.arrMeterCarModels = self.arrMeterModels
                    self.setupAmountDropDown()
                }
                else
                {
                    UtilityClass.showAlert(appName.kAPPName, message: "Something went wrong", vc: self)
                }
            }
            else
            {
                UtilityClass.showAlert(appName.kAPPName, message: "Something went wrong", vc: self)
            }
        }
    }
    
//    DriverId:9
//    PickupLocation:208 Siya Info sundram arcate, Sola, Ahmedabad, Gujarat 380060, India
//    DropoffLocation:208 Siya Info sundram arcate, Sola, Ahmedabad, Gujarat 380060, India
//    ModelId:5
//    ModelName:Tuk Tuk
//    GrandTotal:132.01
//    KM:2.96
//    BaseFare:60
//    WaitingTime:40.0
//    WaitingCost:2.33
//    NightCharge:0
//    MobileNo:0773282020
    
    
    
    func webserviceOFPrivateMeterBooking(param: [String:AnyObject], message: String) {
    
        webserviceForPrivateMeterBooking(param as AnyObject) { (result, status) in
            
            if (status) {
                print(#function)
                print(result)
                
                UtilityClass.showAlertWithCompletion(appName.kAPPName, message: message, vc: self, completionHandler: { (status) in
                    if(status) {
                        self.navigationController?.popViewController(animated: true)
                        
                        self.lblFare.text = ""
                        self.lblHireCost.text = "\(kCurrencyForMeter) 0.0"
//                        self.lblWaitingCost.text = "\(kCurrencyForMeter) 0.0"
//                        self.lblDistanceInMeters.text = "0.00"
//                        self.lblWaitingTime.text = "00:00:00"
//                        self.lblSpeed.text = "0.0 km/hr"
                        self.lblTripDuration.text = "00:00:00"
                        self.floatMainTime = 0;
                        self.btnChoosevehicle.setTitle("Choose Vehicle", for: .normal)
                        App_Delegate.WaitingTimeCount = 0
                        SingletonsForMeter.sharedInstance.vehicleModelID = 0
                        App_Delegate.WaitingTime = "00:00:00"
                    }
                })
            }
            else {
                print(#function)
                print(result)
                
                
                if let res = result as? String {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }
    }
    
    
    func tripEnded()
    {
        
        self.calculateDistanceAndPrice()
        if(Singletons.sharedInstance.isBookNowOrBookLater == true)
        {
            
            var homeVC = self.navigationController!.viewControllers[0].childViewControllers[0] as? HomeViewController
            
            
            if homeVC == nil
            {
                homeVC = (self.navigationController!.viewControllers[1].childViewControllers[0].childViewControllers[0].childViewControllers[0] as? HomeViewController)!
            }
            
//            let homeVC =?
            homeVC?.btnCompleteTrip(UIButton())
        }
        else
        {
            // webserviceCallForTripEnd()
            presentSelectionVC()
        }

    }
    let baseUrlForGetAddress = "https://maps.googleapis.com/maps/api/geocode/json?"
    let apikey = googlPlacesApiKey
    
    enum actionTypeCase: String {
        case StartTrip = "Start Trip"
        case EndTrip = "End Trip"
    }

    func getMin() -> String
    {
        let WaitingTimeIs = Utilities.ConvertSecondsToHoursMinutesSeconds(seconds: Int(self.floatMainTime))
        if WaitingTimeIs.0 == 0 {
            if WaitingTimeIs.1 == 0 {
                if "\(WaitingTimeIs.2)".count == 1
                {
                    return "00:00:0\(WaitingTimeIs.2)"
                }
                else
                {
                    return "00:00:\(WaitingTimeIs.2)"
                }
            }
            else
            {
                return "00:\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
            }
        }
        else
        {
            return "\(WaitingTimeIs.0):\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
        }
    }
    
    
    func getAddressFromLatLon(Latitude: String, withLongitude Longitude: String, type: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Singletons.sharedInstance.latitude

        //21.228124
        let lon: Double = Singletons.sharedInstance.longitude
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                
                if placemarks != nil {
                    if let pm = placemarks! as? [CLPlacemark] {
                        if pm.count > 0 {
                            let pm = placemarks![0]
                            
                            var addressString : String = ""
                            if pm.subLocality != nil {
                                addressString = addressString + pm.subLocality! + ", "
                            }
                            if pm.thoroughfare != nil {
                                addressString = addressString + pm.thoroughfare! + ", "
                            }
                            if pm.locality != nil {
                                addressString = addressString + pm.locality! + ", "
                            }
                            if pm.country != nil {
                                addressString = addressString + pm.country! + ", "
                            }
                            if pm.postalCode != nil {
                                addressString = addressString + pm.postalCode! + " "
                            }
                            
                            print(addressString)
                            
                            if type == actionTypeCase.StartTrip.rawValue {
                                self.strStartTripLocation = addressString
                            } else {
                                self.strEndTripLocation = addressString
                            }
                        }
                    }
                }
                
        })
        
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

struct FareAfterTrip: Codable {
    var bookingFee ,perKMCharge,total: Double?
    var name : String?
    var  id, sort : Int?
    var waitingCost,baseFare, tripFare, km: String?
    
    enum CodingKeys: String, CodingKey {
        case baseFare = "base_fare"
        case bookingFee = "booking_fee"
        case id, km, name
        case perKMCharge = "per_km_charge"
        case sort, total
        case tripFare = "trip_fare"
        case waitingCost = "waiting_cost"
    }

    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = checkParam(values: values, str: .name)
        km = checkParam(values: values, str: .km)
        tripFare = checkParam(values: values, str: .tripFare)
        baseFare = checkParam(values: values, str: .baseFare)
        waitingCost = checkParam(values: values, str: .waitingCost)
        
        
        bookingFee = checkParamForDouble(values: values, str: .bookingFee)
        perKMCharge = checkParamForDouble(values: values, str: .perKMCharge)
        total = checkParamForDouble(values: values, str: .total)
      
        id = checkParamForInt(values: values, str: .id)
        sort = checkParamForInt(values: values, str: .sort)
        
    }
    
 
    mutating func checkParam(values: KeyedDecodingContainer<FareAfterTrip.CodingKeys>, str: CodingKeys) -> String {
        
        var strData = String()
        
        do {
            strData = (try values.decodeIfPresent(String.self, forKey: str))!
        }
        catch {
            do {
                let intStrData = (try values.decodeIfPresent(Int.self, forKey: str))!
                strData = "\(intStrData)"
            }
            catch {
                do {
                    let doubleStrData = (try values.decodeIfPresent(Double.self, forKey: str))!
                    strData = "\(doubleStrData)"
                }
                catch {
                    strData = ""
                }
            }
        }
        return strData
    }
    mutating func checkParamForInt(values: KeyedDecodingContainer<FareAfterTrip.CodingKeys>, str: CodingKeys) -> Int {
        
        var strData = Int()
        
        do {
            strData = (try values.decodeIfPresent(Int.self, forKey: str))!
        }
        catch {
            do {
                let intStrData = (try values.decodeIfPresent(String.self, forKey: str))!
                strData = Int(intStrData) ?? 0
            }
            catch {
                do {
                    let doubleStrData = (try values.decodeIfPresent(Double.self, forKey: str))!
                    strData = Int(doubleStrData)
                }
                catch {
                    strData = 0
                }
            }
        }
        return strData
    }
    mutating func checkParamForDouble(values: KeyedDecodingContainer<FareAfterTrip.CodingKeys>, str: CodingKeys) -> Double {
        
        var strData = Double()
        
        do {
            strData = (try values.decodeIfPresent(Double.self, forKey: str))!
        }
        catch {
            do {
                let intStrData = (try values.decodeIfPresent(Int.self, forKey: str))!
                strData = Double(intStrData)
            }
            catch {
                do {
                    let doubleStrData = (try values.decodeIfPresent(String.self, forKey: str))!
                    strData = Double(doubleStrData) ?? 0.0
                }
                catch {
                    strData = 0.0
                }
            }
        }
        return strData
    }
}


