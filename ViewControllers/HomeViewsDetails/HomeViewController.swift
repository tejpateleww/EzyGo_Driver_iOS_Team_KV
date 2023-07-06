//
//  ContentViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 11/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SideMenuController
import GooglePlaces
//import GooglePlacePicker
import GoogleMaps
import CoreLocation
import SocketIO
import SRCountdownTimer
import NVActivityIndicatorView
import MarqueeLabel
import Alamofire
import UserNotifications

//-------------------------------------------------------------
// MARK: - Protocol
//-------------------------------------------------------------

@objc protocol ReceiveRequestDelegate
{
    func didAcceptedRequest()
    func didRejectedRequest()
}

protocol CompleterTripInfoDelegate {
    func didRatingCompleted()
}

@objc protocol CancelRequestClick {
     func didCancelRequestSuccess()
     func didRejectRequestSuccess()
}

@objc protocol delegateForDamageCharge {
    
    @objc optional func didEnterDamageCharge(cost: String)
}

// ------------------------------------------------------------

class HomeViewController: ParentViewController, CLLocationManagerDelegate,ARCarMovementDelegate, SRCountdownTimerDelegate, ReceiveRequestDelegate,GMSMapViewDelegate,CompleterTripInfoDelegate,UITabBarControllerDelegate, delegateRatingIsSubmitSuccessfully,CancelRequestClick, delegateForDamageCharge
{
   
    
    
    
    //-------------------------------------------------------------
    // MARK: - Global Decelaration
    //-------------------------------------------------------------
    var arrivedRoutePath: GMSPath?

    @IBOutlet weak var btnStartTrip: UIButton!
    @IBOutlet weak var btnArrived: UIButton!
    @IBOutlet weak var btnCancelTrip: UIButton!
    @IBOutlet weak var lblTimerForCancelTrip: UILabel!
    
    var countDown5Minutes = Singletons.sharedInstance.intArrivalTimeInSeconds
    
    var isArrivedDriver = false {
     
        didSet {
//            btnArrived.isEnabled = false
//            btnStartTrip.isHidden = true
            btnArrived.backgroundColor = UIColor.init(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
           
            if isArrivedDriver == true {
                btnArrived.backgroundColor = UIColor.init(red: 236/255, green: 126/255, blue: 41/255, alpha: 1.0)
                btnArrived.isEnabled = true
            }
        }
    }
    
    
    var window: UIWindow?
    
    var switchControl = UISwitch()
    var moveMent: ARCarMovement!
    
    
    static let numberFormatter: NumberFormatter =  {
        let mf = NumberFormatter()
        mf.minimumFractionDigits = 0
        mf.maximumFractionDigits = 0
        return mf
    }()
    
    
    let socket = (UIApplication.shared.delegate as! AppDelegate).Socket
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    var oldCoordinate: CLLocationCoordinate2D!
    var placesClient: GMSPlacesClient!
    let manager = CLLocationManager()
    var mapView : GMSMapView!
    var originMarker = GMSMarker()
    var zoomLevel: Float = 15
    var defaultLocation = CLLocation()
    var aryPassengerData = NSArray()
    var bookingID = String()
    var advanceBookingID = String()
    var driverID = String()
    @IBOutlet var btnMeter : UIButton!
    
    var strSpeed = String()
    
    var selectedRoute: Dictionary<String, AnyObject>!
    var overviewPolyline: Dictionary<String, AnyObject>!
    
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    var arrLocationHistory = [CLLocation]()
    
    var sumOfFinalDistance = Double()
    var dictCompleteTripData = NSDictionary()
    
    weak var delegateOfRequest: ReceiveRequestDelegate!
    
    var strPickupLocation = String()
    var strDropoffLocation = String()
    var strPassengerName = String()
    var strPassengerMobileNo = String()
    
    var aryBookingData = NSArray()
    
    var driverMarker: GMSMarker!
    var isAdvanceBooking = Bool()
    var isNowBooking = Bool()
    
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var startDate: Date!
    var traveledDistance: Double = 0
    var isCashBooking = false
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet weak var btnCurrentlocation: UIButton!
    
    @IBOutlet weak var BottomButtonView: UIView!
    @IBOutlet var lblLocationOnMap: MarqueeLabel!
    @IBOutlet var subMapView: UIView!
    @IBOutlet var viewLocationDetails: UIView!
    @IBOutlet weak var StartTripView: UIView!
    
    @IBOutlet weak var vwStartTrip: UIView!
    @IBOutlet weak var vwMyJobs: UIView!
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        test()
        
        btnCurrentlocation.layer.cornerRadius = 5
        btnCurrentlocation.layer.masksToBounds = true
//        viewLocationDetails.layer.cornerRadius = 5
        
        btnArrived.isEnabled = false
        btnArrived.isHidden = false
        btnCancelTrip.isHidden = true
        lblTimerForCancelTrip.isHidden = true
        BottomButtonView.isHidden = true
        StartTripView.isHidden = true
        btnStartTrip.isHidden = true
        vwStartTrip.isHidden = btnStartTrip.isHidden
        isAdvanceBooking = false
        Singletons.sharedInstance.isFirstTimeDidupdateLocation = true;
        moveMent = ARCarMovement()
        moveMent.delegate = self
        
          
        NotificationCenter.default.addObserver(self, selector: #selector(btnHoldWaiting(_:)), name: NSNotification.Name(rawValue: "HoldCurrentTrip"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(btnCompleteTrip(_:)), name: NSNotification.Name(rawValue: "endTrip"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.webserviceOfRunningTripTrack), name: NotificationTrackRunningTrip, object: nil)
        
        
        btnCancelTrip.backgroundColor = UIColor.init(red: 236/255, green: 126/255, blue: 41/255, alpha: 1.0)
        btnStartTrip.backgroundColor = btnCancelTrip.backgroundColor
        btnCompleteTrip.backgroundColor = btnCancelTrip.backgroundColor
        setCar()
        
        if(SingletonsForMeter.sharedInstance.arrCarModels.count == 0)
        {
            self.webserviceCallToGetFare()
        }
        UtilityClass.showACProgressHUD()
        
        self.tabBarController?.delegate = self
        
        let profile: NSMutableDictionary = NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as? NSDictionary)!)
        let Vehicle: NSMutableDictionary = NSMutableDictionary(dictionary: profile.object(forKey: "Vehicle") as! NSDictionary)
        
        
        let stringOFVehicleModel: String = Vehicle.object(forKey: "VehicleModel") as! String
        
        let stringToArrayOFVehicleModel = stringOFVehicleModel.components(separatedBy: ",")
        
        Singletons.sharedInstance.arrVehicleClass = NSMutableArray(array: stringToArrayOFVehicleModel.map { Int($0)!})
        
        driverID = Vehicle.object(forKey: "DriverId") as! String
        
        placesClient = GMSPlacesClient.shared()
        
        manager.delegate = self
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if (manager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) || manager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)))
            {
                if manager.location != nil
                {
                    manager.startUpdatingLocation()
                    manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                    manager.activityType = .automotiveNavigation
                    manager.startMonitoringSignificantLocationChanges()
                    manager.allowsBackgroundLocationUpdates = true
                    //                    manager.distanceFilter = //
                }
                
            }
        }
        
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), camera: camera)
        
        mapView.isHidden = true
        subMapView.addSubview(mapView)
        
//        getCurrentPlace()  //Change 21st January Top label change
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.lblLocationOnMap.text = "Getting Current location..."
            self.tempGetAddressFromGeoCode()
        }
        
      /*  if let reqAccepted: Bool = UserDefaults.standard.bool(forKey: tripStatus.kisRequestAccepted) as? Bool {
//            Singletons.sharedInstance.isRequestAccepted = reqAccepted
        }
        
        if let holdingTrip: Bool = UserDefaults.standard.bool(forKey: holdTripStatus.kIsTripisHolding) as? Bool {
//            Singletons.sharedInstance.isTripHolding = holdingTrip
        }
        */
        if Singletons.sharedInstance.isTripHolding {
            
            btnWaiting.setTitle("Stop (Waiting)",for: .normal)
        }
        else {
            btnWaiting.setTitle("Hold (Waiting)",for: .normal)
        }
        //TODO: uncomment in production
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.webserviceOfCurrentBooking()
        }
        
       runTimer()
      /*  if(Singletons.sharedInstance.driverDuty == "1")
        {
            Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (timer) in
                self.UpdateDriverLocation()
            }
//            Timer.scheduledTimer(timeInterval: 15, target: self,   selector: (#selector(self.UpdateDriverLocation)), userInfo: nil, repeats: true)
//            self.UpdateDriverLocation() //changee 5th november
        }
        */
    }
    
    var aryLat = [Double]()
    var aryLng = [Double]()
    
    func test() {
        
        aryLat = [ 23.056105, 23.055942, 23.055749, 23.055331, 23.054966, 23.054759, 23.054186, 23.053726, 23.053331,  23.052837, 23.052423, 23.051791, 23.051156, 23.050721, 23.050366, 23.049966, 23.049300, 23.050057, 23.050452, 23.050373, 23.050531, 23.050404, 23.050167, 23.049930, 23.050004, 23.050064, 23.050246 ]
        
        aryLng = [ 72.519245, 72.519169, 72.519153, 72.519015, 72.518972, 72.518897, 72.518768, 72.518641, 72.518513, 72.518362, 72.518126, 72.517955, 72.517816, 72.517559, 72.517430, 72.517331, 72.517044, 72.513594, 72.511362, 72.509731, 72.508272, 72.507388, 72.506315, 72.505586, 72.505079, 72.504564, 72.503354 ]
        
    }
    
    
    
    var timerForUpdateCurrentLocation = Timer()
    //MARK: - Current Location Label Update
    
    func runTimer() {
          DispatchQueue.global(qos: .background).sync {
            self.timerForUpdateCurrentLocation = Timer.scheduledTimer(timeInterval: 15, target: self,   selector: (#selector(self.tempGetAddressFromGeoCode)), userInfo: nil, repeats: true)
//            self.timerForUpdateCurrentLocation = Timer.scheduledTimer(timeInterval: 15, target: self,   selector: (#selector(self.updateCurrentLocationLabel)), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateCurrentLocationLabel() {
        
        if defaultLocation.coordinate.latitude != 0 && defaultLocation.coordinate.longitude != 0 {
            getAddressForLatLng(latitude: "\(defaultLocation.coordinate.latitude)", longitude: "\(defaultLocation.coordinate.longitude)")
        }
    }
    @objc func tempGetAddressFromGeoCode() {
        if defaultLocation.coordinate.latitude != 0 && defaultLocation.coordinate.longitude != 0 {
            getAddressFromLatLongUsingAppleReverseGeocodeLocation(Latitude: "\(defaultLocation.coordinate.latitude)", withLongitude: "\(defaultLocation.coordinate.longitude)")
        }
        
    }
    func getAddressFromLatLongUsingAppleReverseGeocodeLocation(Latitude: String, withLongitude Longitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        let lat: Double = Double("\(Latitude)")! // -43.5304616
        let lon: Double = Double("\(Longitude)")! // 172.6276278
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil) {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                
                if placemarks != nil {
                    if placemarks?.count != 0 {
                        
                        let pm = placemarks! as [CLPlacemark]
                        
                        if pm.count > 0 {
                            let pm = placemarks![0]
                            
                            if pm.addressDictionary != nil {
                                if let masterAddress = pm.addressDictionary {
                                    if let TempAddress = masterAddress["FormattedAddressLines"] as? [String] {
                                        
                                        var fullAddress = TempAddress.map{"\($0), "}.joined()
                                        fullAddress.removeLast()
                                        self.lblLocationOnMap.text = fullAddress + "  "
                                    }
                                }
                            }
                        }
                    }
                }
        })
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    // TODO: - My Changes
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        /*
        print(viewController)
        if(viewController.isKind(of: PayViewController.self))
        {
            if(Singletons.sharedInstance.isPasscodeON)
            {
                if Singletons.sharedInstance.setPasscode == ""
                {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
                    viewController.modalPresentationStyle = .formSheet
                    self.present(viewController, animated: false, completion: nil)
                }
                else
                {
                    
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
                    self.present(viewController, animated: false, completion: nil)
                    
                }
            }
            
        }
        */
    }
    
    // MARK:-
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    @IBAction func btnSidemenuClicked(_ sender: Any)
    {
        sideMenuController?.toggle()
    }
    
    @objc func btnRightSideClicked(_ sender:Any)
    {
        //        if sender.isOn
        //        {
        //            webserviceForChangeDutyStatus()
        //            print("on")
        //        } else{
        //            webserviceForChangeDutyStatus()
        //            print("off")
        //        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // print ("\(#function) -- \(self)")
        Singletons.sharedInstance.isFromNotification = true
    }
    
    // ------------------------------------------------------------
    
    //MARK:- Location delegate methods
    
    var driverIDTimer : String!
    var passengerIDTimer : String!
    var timerToGetDriverLocation : Timer!
    
    func sendPassengerIDAndDriverIDToGetLocation(driverID : String , passengerID: String) {
        
        driverIDTimer = driverID
        passengerIDTimer = passengerID
        if timerToGetDriverLocation == nil {
//            timerToGetDriverLocation = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(HomeViewController.getDriverLocation), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if timerToGetDriverLocation != nil {
            timerToGetDriverLocation.invalidate()
            timerToGetDriverLocation = nil
        }
    }
    
    @objc func getDriverLocation() {
        //        let myJSON = ["PassengerId" : passengerIDTimer,  "DriverId" : driverIDTimer] as [String : Any]
        //        socket.emit(SocketData.kSendDriverLocationRequestByPassenger , with: [myJSON])
    }
    //MARK: Driver Current location update
    @objc func getDriverLocation(_ lat: String , _ lng : String)
        
    {
        print("crashed  \(#function)")
        //        if socket?.status == SocketIOStatus.connected {
        let BookingInfo : NSDictionary!
        if (self.aryPassengerData.count != 0) {
            if((((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) == nil)
            {
                if (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSArray) != nil {
                    BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as? NSDictionary
                    
                    if let strPassengerID = BookingInfo!.object(forKey: "PassengerId") as? String {
                        passengerIDTimer = strPassengerID
                    }else if let strPassengerID = BookingInfo!.object(forKey: "PassengerId") as? Int {
                        passengerIDTimer = ("\(strPassengerID)")
                    }
                }
            }
            else
            {
                if  (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) != nil {
                    BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
                    
                    
                    if let strPassengerID = BookingInfo!.object(forKey: "PassengerId") as? String {
                        passengerIDTimer = strPassengerID
                    }else if let strPassengerID = BookingInfo!.object(forKey: "PassengerId") as? Int {
                        passengerIDTimer = ("\(strPassengerID)")
                    }
                }
                
            }
            
            
            
            //        passengerIDTimer = strPassengerID
            if passengerIDTimer != nil && passengerIDTimer != ""
            {
                let myJSON = ["PassengerId" : passengerIDTimer!,  "DriverId" : Singletons.sharedInstance.strDriverID, "Lat": "\(lat)","Lng": "\(lng)"] as [String : Any]
                //            let myJSON = ["PassengerId" : "26",  "DriverId" : "2", "Lat": "\(lat)","Lng": "\(lng)"] as [String : Any]
                print("socketApiKeys.kSendDriverLocationRequestByPassenger: \(myJSON)")
                socket?.emit(socketApiKeys.kSendDriverLocationRequestByPassenger , with: [myJSON])
            }
            
            
            if (self.arrivedRoutePath != nil && !(GMSGeometryIsLocationOnPathTolerance(self.driverMarker.position, self.arrivedRoutePath!, true, 100)))
            {
                //print("reDraw")
                self.reRoute(DriverCordinate: defaultLocation.coordinate)
            }
        }
        
        //        }
        
    }
    
    func reRoute(DriverCordinate: CLLocationCoordinate2D)
    {
        self.mapView.clear()

        if self.driverMarker == nil {
            self.driverMarker = GMSMarker(position: DriverCordinate)
            driverMarker.tracksViewChanges = false
            self.driverMarker.map = self.mapView
            self.driverMarker.icon = UIImage(named: "dummyCar")
        }

        //Rahul
        if(Singletons.sharedInstance.dictDriverProfile.count != 0) {
            
            var dropOffCoordinate = CLLocationCoordinate2D()
            var dictDataOfBookingInfo = NSDictionary()
            
           if let dictDataOfBookingInfo2 = (((self.aryPassengerData as NSArray).object(at: 0) as? NSDictionary)?.object(forKey: "BookingInfo") as? NSArray)?.firstObject as? NSDictionary
            {
               dictDataOfBookingInfo = dictDataOfBookingInfo2
           }
            else if let dictDataOfBookingInfo2 = ((self.aryPassengerData as NSArray).object(at: 0) as? NSDictionary)?.object(forKey: "BookingInfo") as? NSDictionary
            {
                dictDataOfBookingInfo = dictDataOfBookingInfo2

            }
            
            let status = (dictDataOfBookingInfo.object(forKey: "Status") as? String ?? "")
            let dropSecondLat = Double("\(dictDataOfBookingInfo.object(forKey: "DropOffLat2") as? String ?? "")")
            let dropSecondLng = Double("\(dictDataOfBookingInfo.object(forKey: "DropOffLon2") as? String ?? "")")

            if ((status == "pending" || status == "accepted") && Singletons.sharedInstance.isTripContinue == false)
            {
                let pickupLat = Double("\(dictDataOfBookingInfo.object(forKey: "PickupLat") as? String ?? "")")
                let pickupLng = Double("\(dictDataOfBookingInfo.object(forKey: "PickupLng") as? String ?? "")")
                
                dropOffCoordinate = CLLocationCoordinate2D(latitude: pickupLat ?? 0.0, longitude: pickupLng ?? 0.0)
            }
            else if(Singletons.sharedInstance.isTripContinue == true && self.btnArrived.isHidden == false && (dropSecondLat != 0.0 && dropSecondLng != 0.0))
            {
                let dropFirstLat = Double("\(dictDataOfBookingInfo.object(forKey: "DropOffLat") as? String ?? "")")
                let dropFirstLng = Double("\(dictDataOfBookingInfo.object(forKey: "DropOffLon") as? String ?? "")")
                
                dropOffCoordinate = CLLocationCoordinate2D(latitude: dropFirstLat ?? 0.0, longitude: dropFirstLng ?? 0.0)
            }
            else if (dropSecondLat != 0.0 && dropSecondLng != 0.0)
            {
                let dropFirstLat = Double("\(dictDataOfBookingInfo.object(forKey: "DropOffLat") as? String ?? "")")
                let dropFirstLng = Double("\(dictDataOfBookingInfo.object(forKey: "DropOffLon") as? String ?? "")")
                
                dropOffCoordinate = CLLocationCoordinate2D(latitude: dropFirstLat ?? 0.0, longitude: dropFirstLng ?? 0.0)

            }
            else
            {
                let dropFirstLat = Double("\(dictDataOfBookingInfo.object(forKey: "DropOffLat") as? String ?? "")")
                let dropFirstLng = Double("\(dictDataOfBookingInfo.object(forKey: "DropOffLon") as? String ?? "")")
                
                dropOffCoordinate = CLLocationCoordinate2D(latitude: dropFirstLat ?? 0.0, longitude: dropFirstLng ?? 0.0)

            }
            let PickupLat = DriverCordinate.latitude  // Double("\(strLat )")
            let PickupLng = DriverCordinate.longitude // Double("\(strLng )")

            let DropOffLat = dropOffCoordinate.latitude
            let DropOffLon = dropOffCoordinate.longitude
            
//            let tempLat = Double("\(aryFilterData.first?["PickupLat"]! ?? "0")")
//            let tempLon = Double("\(aryFilterData.first?["PickupLng"]! ?? "0")")

            let originalLoc: String = "\(PickupLat ),\(PickupLng)"
            var destiantionLoc: String = "\(DropOffLat ),\(DropOffLon)"

            if !Singletons.sharedInstance.isTripContinue {
                destiantionLoc = "\(DropOffLat),\(DropOffLon)"
            }
            

            let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: PickupLat , longitude: PickupLng ), coordinate: CLLocationCoordinate2D(latitude: DropOffLat, longitude: DropOffLon))
            let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(zoomLevel))

            self.mapView.animate(with: update)
            self.mapView.moveCamera(update)

            DispatchQueue.main.async {
                self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, completionHandler: nil)
                    
            }
        }

        // ***********************************************
        // ***********************************************
    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
    
        let location: CLLocation = locations.last!
        
        let state = UIApplication.shared.applicationState
        if state == .background {
            print("The location we are getting in background mode is \(location)")
        }
        defaultLocation = location
        
//        if(Singletons.sharedInstance.isFirstTimeDidupdateLocation == true)
//        {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: 17)
            mapView.camera = camera
//            Singletons.sharedInstance.isFirstTimeDidupdateLocation = false
//        }
        
        arrLocationHistory.append(location)
        userDefault.set(NSKeyedArchiver.archivedData(withRootObject: arrLocationHistory), forKey: "locationHistory")
        
        
        Singletons.sharedInstance.latitude = defaultLocation.coordinate.latitude
        Singletons.sharedInstance.longitude = defaultLocation.coordinate.longitude
        
       
        if(Singletons.sharedInstance.isRequestAccepted)
        {
            let strLAT = String(defaultLocation.coordinate.latitude as Double)
            let strLNG = String(defaultLocation.coordinate.longitude as Double)
            self.getDriverLocation(strLAT, strLNG)
            
            if(oldCoordinate == nil)
            {
                oldCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            }
            
            if(driverMarker == nil)
            {
                driverMarker = GMSMarker(position: oldCoordinate)
                driverMarker.icon = UIImage(named: Singletons.sharedInstance.strSetCar)
                driverMarker.map = mapView
            }
            
            //            calculateDistance()
            
            let newCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(Singletons.sharedInstance.latitude), CLLocationDegrees(Singletons.sharedInstance.longitude))
            self.moveMent.ARCarMovement(marker: driverMarker, oldCoordinate: oldCoordinate, newCoordinate: newCoordinate, mapView: mapView, bearing: Float(Singletons.sharedInstance.floatBearing))
            oldCoordinate = newCoordinate
            
        }
        
        // To track Meter
        if(Singletons.sharedInstance.MeterStatus != meterStatus.kIsMeterStop && Singletons.sharedInstance.MeterStatus != "")
        {
            if startLocation == nil {
                startLocation = locations.first
            } else if let location = locations.last {
                
                if(SingletonsForMeter.sharedInstance.isMeterOnHold == false)
                {
                    traveledDistance += lastLocation.distance(from: location)
                    print("Traveled Distance:",  traveledDistance)
                    Singletons.sharedInstance.distanceTravelledThroughMeter = (traveledDistance/1000)
                    
                    //                    print("Straight Distance:", startLocation.distance(from: locations.last!))
                    if(SingletonsForMeter.sharedInstance.arrCarModels.count != 0)
                    {
                        self.calculateDistanceAndPrice()
                    }
                }
                else
                {
                    lastLocation = defaultLocation
                    startLocation = defaultLocation
                    
                    print("meter is on hold")
                    //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateWaitingTime"), object: nil)
                }
                
            }
            lastLocation = locations.last
            
            // To get Speed
            
            //        if(location.speed > 0) {
            var kmh = location.speed / 1000.0 * 60.0 * 60.0
            if(kmh < 0)
            {
                kmh = 0
            }
            
//            if let speed = HomeViewController.numberFormatter.string(from: NSNumber(value: kmh)) {
//                strSpeed = "\(speed)"
//                SingletonsForMeter.sharedInstance.strSpeed = strSpeed
//
//                if (kmh < 5 && Singletons.sharedInstance.MeterStatus == meterStatus.kIsMeterStart)
//                {
//                    Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterOnHolding
//                    self.btnHoldWaiting((self.btnWaiting)!)
//                }
//                else if (kmh > 5)
//                {
//                    Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterStart
//                    self.btnHoldWaiting((self.btnWaiting)!)
//                }
//            }
//            else
//            {
//                SingletonsForMeter.sharedInstance.strSpeed = "0.0 km/hr"
//            }
            
        }
        else
        {
            traveledDistance = 0;
        }
        
        
        //        }
        //        else {
        //            strSpeed = "\(0.0)"
        //            if (Singletons.sharedInstance.MeterStatus == meterStatus.kIsMeterStart && Singletons.sharedInstance.MeterStatus != "")
        //            {
        //                Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterOnHolding
        //                self.btnHoldWaiting((self.btnWaiting)!)
        //            }
        //        }
        
        //
        
        if mapView.isHidden
        {
            mapView.isHidden = false
            self.view.bringSubview(toFront: self.viewLocationDetails)
            self.view.bringSubview(toFront: self.btnCurrentlocation)
            self.view.bringSubview(toFront: self.btnMeter)
            self.mapView.settings.rotateGestures = false
            self.mapView.settings.tiltGestures = false
            self.socketMethods()
        }
        else
        {
            if(oldCoordinate == nil)
            {
                oldCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            }
            
            if(driverMarker == nil)
            {
                driverMarker = GMSMarker(position: oldCoordinate)
                //                driverMarker.position = oldCoordinate
                driverMarker.icon = UIImage(named: Singletons.sharedInstance.strSetCar)
                driverMarker.map = mapView
            }
            
            if(!Singletons.sharedInstance.isRequestAccepted)
            {
                
                let newCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(Singletons.sharedInstance.latitude), CLLocationDegrees(Singletons.sharedInstance.longitude))
                self.moveMent.ARCarMovement(marker: driverMarker, oldCoordinate: oldCoordinate, newCoordinate: newCoordinate, mapView: mapView, bearing: Float(Singletons.sharedInstance.floatBearing))
                oldCoordinate = newCoordinate
            }
            
            if(Singletons.sharedInstance.driverDuty == "1")
            {
                self.UpdateDriverLocation() //changee 5th november
            }
 
        }
        
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        if(newLocation.speed > 0) {
            let kmh = newLocation.speed / 1000.0 * 60.0 * 60.0
            
            if let speed = HomeViewController.numberFormatter.string(from: NSNumber(value: kmh)) {
                strSpeed = "\(speed)"
                SingletonsForMeter.sharedInstance.strSpeed = strSpeed
                if (kmh < 5)
                {
                    Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterOnHolding
                    self.btnHoldWaiting((self.btnWaiting)!)
                }
                else if (kmh > 5)
                {
                    self.btnHoldWaiting((self.btnWaiting)!)
                }
                
            }
        }
        else {
            strSpeed = "\(newLocation.speed)"
            SingletonsForMeter.sharedInstance.strSpeed = strSpeed
            if (Singletons.sharedInstance.MeterStatus != meterStatus.kIsMeterOnHolding)
            {
                Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterOnHolding
                self.btnHoldWaiting((self.btnWaiting)!)
            }
        }
        
    }
    
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted: break
        case .denied:
            mapView.isHidden = false
        case .notDetermined: break
        case .authorizedAlways: break
//            manager.startUpdatingLocation()
            
        case .authorizedWhenInUse: break
//            manager.startUpdatingLocation()
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // print (error)
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    var strCompleteTripLocation = String()
    
    func getCurrentLocationForCompleteTrip() {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if error != nil {
                // print ("Pick Place error: \(error.localizedDescription)")
                self.getCurrentLocationForCompleteTrip()
                return
            }
           
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
                    self.strCompleteTripLocation = place.formattedAddress ?? "\(self.lblLocationOnMap.text ?? "")"
                }
            }
            
            
            self.completeTripFinalSubmit()
        })
    }
    
    func getCurrentLocationForFare() {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if error != nil {
                // print ("Pick Place error: \(error.localizedDescription)")
                self.getCurrentLocationForCompleteTrip()
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
                    self.strCompleteTripLocation = place.formattedAddress ?? "\(self.lblLocationOnMap.text ?? "")"
                }
            }
            
            
//            self.completeTripFinalSubmit()
        })
    }
    // ------------------------------------------------------------
    
    
    func calculateDistance()
    {
        
        let decoded  = UserDefaults.standard.object(forKey: "locationHistory") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded)! as! [CLLocation]
        //
        print("location history is \(String(describing: decodedTeams.count))")
        
        for i in 0..<decodedTeams.count
        {
            let location0 = decodedTeams[i]
//            var location1 : CLLocation!
//            if(decodedTeams.count - 1 > i)
//            {
//                location1 = decodedTeams[i+1]
//            }
            
            if startLocation == nil {
                startLocation = location0
            } else
            {
                let location = location0
                
                traveledDistance += lastLocation.distance(from: location)
                print("Traveled Distance:",  traveledDistance/1000)
                
            }
            lastLocation = location0
        }
    }
    
    var nameLabel = String()
    var addressLabel = String()
    
    
    func getCurrentPlace()
    {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if error != nil {
                // print ("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel = "No current place"
            self.addressLabel = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel = place.name ?? ""
                    self.addressLabel = (place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n"))!
                }
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
                    print(#line, #function,place.formattedAddress)
                    self.lblLocationOnMap.text = place.formattedAddress
                    
                    
                }
            }
            
        })
        
    }
    
    // ------------------------------------------------------------
    //-------------------------------------------------------------
    // MARK: - Socket Methods
    //-------------------------------------------------------------
    
    var strTempBookingId = String()
    
    func socketMethods()
    {
        
        var isSocketConnected = Bool()
        if (isSocketConnected == false) {
            isSocketConnected = true
            self.methodsAfterConnectingToSocket()
            
        }
        
        socket?.on(clientEvent: .disconnect) { (data, ack) in
            print ("socket is disconnected please reconnect")
        }
        
        socket?.on(clientEvent: .reconnect) { (data, ack) in
            print ("socket is reconnected please reconnect")
        }
        
        socket?.on(clientEvent: .connect) {data, ack in
            print ("socket connected")
            
            //            self.socket.on(socketApiKeys.kReceiveBookingRequest, callback: { (data, ack) in
            //                // print ("data is \(data)")
            //                print ("kReceiveBookingRequest : \(data)")
            //
            //                if let bookingType = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingType") as? String {
            //
            //                    Singletons.sharedInstance.passengerType = bookingType
            //                    Singletons.sharedInstance.strBookingType = bookingType
            //                }
            //
            //                if Singletons.sharedInstance.firstRequestIsAccepted == true {
            //
            //                    self.strTempBookingId = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingId") as! String
            //
            //                    self.BookingRejected()
            //                    return
            //                }
            //
            //                self.isAdvanceBooking = false
            //                self.bookingID = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingId") as! String
            //
            //
            //                let next = self.storyboard?.instantiateViewController(withIdentifier: "ReceiveRequestViewController") as! ReceiveRequestViewController
            //                next.delegate = self
            //
            //                if let grandTotal = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "GrandTotal") as? String {
            //                    if grandTotal == "" {
            //                        next.strGrandTotal = "0"
            //                    }
            //                    else {
            //                        next.strGrandTotal = grandTotal
            //                    }
            //
            //                }
            //                else {
            //                    next.strGrandTotal = "0"
            //                }
            //                if let PickupLocation = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "PickupLocation") as? String {
            //                    next.strPickupLocation = PickupLocation
            //                }
            //
            //                if let DropoffLocation = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DropoffLocation") as? String {
            //                    next.strDropoffLocation = DropoffLocation
            //                }
            //                self.playSound(strName: "\(RingToneSound)")
            //
            //
            //                self.addLocalNotification()
            //
            //                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: { ACTION in
            //                    Singletons.sharedInstance.firstRequestIsAccepted = true
            //                    //                    self.stopSound()
            //                })
            //
            //            })
        }
        
        socket?.connect()
    }
    
    func methodsAfterConnectingToSocket()
    {
        if defaultLocation.coordinate.latitude == 0 || defaultLocation.coordinate.longitude == 0 {
            UtilityClass.showAlert("Missing", message: "Latitude or Longitude", vc: self)
        }else {
            self.socketCallForReceivingBookingRequest()                 // ReceiveBookingRequest
            self.UpdateDriverLocation()                                 // UpdateDriverLocation
            self.ReceiveBookLaterBookingRequest()                       // AriveAdvancedBookingRequest
            self.CancelBookLaterTripByCancelNotification()      // AdvancedBookingDriverCancelTripNotification
            self.GetBookingDetailsAfterBookingRequestAccepted()         // BookingInfo
            self.GetAdvanceBookingDetailsAfterBookingRequestAccepted()  // AdvancedBookingInfo
            self.cancelTripByPassenger()                                // DriverCancelTripNotification
            self.NewBookLaterRequestArrivedNotification()   // AdvancedBookingDriverCancelTripNotification
            self.getNotificationForReceiveMoneyNotify()     // ReceiveMoneyNotify
            self.onSessionError()                           // SessionError
      //      self.getTimeOfStartTrip()                       // StartTripTimeError
            
            self.onAdvancedBookingPickupPassengerNotification() // AdvancedBookingPickupPassengerNotification
            
            self.onDriverArrivedAtPickupLocation() // DriverArrivedAtPickupLocation
            self.onAdvanceBookingArrivedAtPickupLocation() //  AdvanceBookingArrivedAtPickupLocation
        }
        
    }
    
    func socketCallForReceivingBookingRequest() {
        self.socket?.on(socketApiKeys.kReceiveBookingRequest, callback: { (data, ack) in
            // print ("data is \(data)")
            print ("kReceiveBookingRequest : \(data)")
            
            self.isAdvanceBooking = false
            self.isNowBooking = true
            
            print("crashed  \(#function)")
            self.bookingID = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingId") as! String
            
            if let rideType = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "RideType") as? String {
                
                Singletons.sharedInstance.strRideTypeFromAcceptRequest = rideType
                
                if rideType == "ShareRide" {
                    Singletons.sharedInstance.passengerType = "BookNow"
                    
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "ReceiveRequestViewController") as! ReceiveRequestViewController
                    next.delegate = self
                    
                    if let grandTotal = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "GrandTotal") as? String {
                        if grandTotal == "" {
                            next.strGrandTotal = "0"
                        }
                        else {
                            next.strGrandTotal = grandTotal
                        }
                    }
                    else {
                        next.strGrandTotal = "0"
                    }
                    if let PickupLocation = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "PickupLocation") as? String {
                        next.strPickupLocation = PickupLocation
                    }
                    
                    if let DropoffLocation = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DropoffLocation") as? String {
                        next.strDropoffLocation = DropoffLocation
                    }
                    
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
                    
                    return
                }
                
            }
            
            if let bookingType = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingType") as? String {
                
                Singletons.sharedInstance.passengerType = bookingType
                Singletons.sharedInstance.strBookingType = bookingType
            }
            
            if Singletons.sharedInstance.firstRequestIsAccepted == true {

                self.strTempBookingId = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingId") as! String

                self.BookingRejected()
                return
            }
            
//            self.isAdvanceBooking = false
//            self.isNowBooking = true
//            self.bookingID = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingId") as! String
            
            Singletons.sharedInstance.isPending = 1
            
            if Singletons.sharedInstance.bookingId == "" {
                Singletons.sharedInstance.bookingId = self.bookingID
                Singletons.sharedInstance.isPending = 0
            }
            else {
                Singletons.sharedInstance.bookingIdTemp = self.bookingID
            }
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ReceiveRequestViewController") as! ReceiveRequestViewController
            next.delegate = self
            
            if let grandTotal = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "GrandTotal") as? String {
                if grandTotal == "" {
                    next.strGrandTotal = "0"
                }
                else {
                    next.strGrandTotal = grandTotal
                }
            }
            else {
                next.strGrandTotal = "0"
            }
            
            if let PickupLocation = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "PickupLocation") as? String {
                next.strPickupLocation = PickupLocation
            }
            
            if let DropoffLocation = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DropoffLocation") as? String {
                next.strDropoffLocation = DropoffLocation
            }
            
            self.playSound(strName: "\(RingToneSound)")
            
            
            self.addLocalNotification()
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: {
                 Singletons.sharedInstance.firstRequestIsAccepted = true
            })
            
        })
    }
    
    func onDriverArrivedAtPickupLocation() {
        self.socket?.on(socketApiKeys.kDriverArrivedAtPickupLocation, callback: { (data, ack) in
            print("onDriverArrivedAtPickupLocation() : \(data)")
            
            self.isArrivedDriver = true
            
            UserDefaults.standard.set(true, forKey: "isArrived")
            
//            self.btnArrived.isHidden = true
//            self.btnStartTrip.isHidden = false
        })
    }
    
    func onAdvanceBookingArrivedAtPickupLocation() {
     
        self.socket?.on(socketApiKeys.kAdvanceBookingDriverArrivedAtPickupLocation , callback: { (data, ack) in
            print("onAdvanceBookingArrivedAtPickupLocation() : \(data)")
            
            self.isArrivedDriver = true
            UserDefaults.standard.set(true, forKey: "isArrived")
            //            self.btnArrived.isHidden = true
            //            self.btnStartTrip.isHidden = false
        })
    }
    
    
    func UpdateDriverLocation()
    {
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        driverID = Singletons.sharedInstance.strDriverID
        let myJSON = [profileKeys.kDriverId : driverID, socketApiKeys.kLat: defaultLocation.coordinate.latitude, socketApiKeys.kLong: defaultLocation.coordinate.longitude, "Token": Singletons.sharedInstance.deviceToken, "Version": version] as [String : Any]
        
        socket?.emit(socketApiKeys.kUpdateDriverLocation, with: [myJSON])
        print ("UpdateDriverLocation : \(myJSON)")
        
        if Singletons.sharedInstance.isPickUPPasenger != nil {
            if !(Singletons.sharedInstance.isPickUPPasenger) {
                getDistanceForPickupPassengerFromLocation()
            }
        }
       
    }
    // ------------------------------------------------------------
    
    func onSessionError() {
        
        self.socket?.on("SessionError", callback: { (data, ack) in
            
            UtilityClass.showAlertWithCompletion("Multiple login", message: "Please Re-Login", vc: self, completionHandler: { ACTION in
                
                self.webserviceOFSignOut()
            })
            
        })
        
    }
    
    func NewBookLaterRequestArrivedNotification() {
        
        self.socket?.on(socketApiKeys.kBookLaterDriverNotify, callback: { (data, ack) in
            
            print ("Book Later Driver Notify : \(data)")
            self.playSound(strName: RingToneSound)
            self.lblTimerForCancelTrip.isHidden = true
            
            let msg = (data as NSArray)
            
            //            UtilityClass.showAlert("Future Booking Request Arrived.", message: (msg.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
            
            let alert = UIAlertController(title: "Future Booking Request Arrived.",
                                          message: (msg.object(at: 0) as! NSDictionary).object(forKey: "message") as? String,
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Open", style: .default, handler: { (action) in
                self.stopSound()
                Singletons.sharedInstance.isFromNotification = true
                //                self.tabBarController?.selectedIndex = 1
                if let vc = UIApplication.topViewController() {
                    if vc is MyJobsViewController {
                        let myJobs = vc as! MyJobsViewController
                        myJobs.btnFutureBookingClicked(myJobs.btnFutureBooking)
                    }else {
                        let vwMyJobs = self.storyboard?.instantiateViewController(withIdentifier: "MyJobsViewController") as! MyJobsViewController
                        vwMyJobs.isFutureBookingArrive = true
                        self.navigationController?.pushViewController(vwMyJobs, animated: true)
                        
                        //                        vwMyJobs.btnFutureBookingClicked(vwMyJobs.btnFutureBooking)
                    }
                }
                
//                if UIApplication.topViewController(vwMyJobs) {
//                    vwMyJobs.btnFutureBookingClicked(vwMyJobs?.btnFutureBooking)
//                }else {
//
//
//                     self.navigationController?.pushViewController(vwMyJobs!, animated: true)
//                }
              
            
                
               
                
               
                //                let myJobs = (self.navigationController?.childViewControllers[0] as! TabbarController).childViewControllers.last as! MyJobsViewController
                
                //                myJobs.btnFutureBookingClicked(myJobs.btnFutureBooking)
            })
            
            
            let cancelAction = UIAlertAction(title: "Dismiss",
                                             style: .destructive, handler:{ (action) in
                                                self.stopSound()
                                                
            })
            
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
//            if(self.presentedViewController != nil)
//            {
//                self.dismiss(animated: true, completion: nil)
//            }
            //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
            
            // Changes in alert due to automtically dismiss
//            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
//            alertWindow.rootViewController = UIViewController()
//            alertWindow.windowLevel = UIWindowLevelAlert + 1
//            alertWindow.makeKeyAndVisible()
//            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
//            self.present(alert, animated: true, completion: nil)
            
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        })
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Check time of booking
    //-------------------------------------------------------------
    
    var isFirstTimeFromPndingJobs = true
    
    //MARK: - Changes Code
    func acceptRequest(_ arrData: NSArray) {
                   print("crashed  \(#function)")
        if arrData.count != 0 {
            //                 self.btnStartTripAction()
            self.advanceBookingID = ((arrData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingId") as! String
            
            
            //                if (self.isFirstTimeFromPndingJobs) {
            //                    self.BottomButtonView.isHidden = false
            //                    self.StartTripView.isHidden = true
            //                }
            //                else {
            //                    self.BottomButtonView.isHidden = true
            //                    self.StartTripView.isHidden = false
            //                }
            //
            //                self.isFirstTimeFromPndingJobs.toggleForBookLaterStartFromPendinfJobs()
            //                self.btnStartTrip.isHidden = true
            
            
            vwMyJobs.isHidden = true
            guard let aryAdvancePassengerData = self.aryPassengerData as? NSArray else {
                
                print("Error")
                return
            }
            
            if aryAdvancePassengerData.count != 0 {
                
                if let indexOfData = aryAdvancePassengerData.object(at: 0) as? NSDictionary, let advenceBookingInfo = indexOfData.object(forKey: "BookingInfo") as? NSDictionary {
                    Singletons.sharedInstance.startedTripLatitude = Double(advenceBookingInfo.object(forKey: "PickupLat") as! String)!
                    Singletons.sharedInstance.startedTripLongitude = Double(advenceBookingInfo.object(forKey: "PickupLng") as! String)!
                }
                else if let indexOfData = aryAdvancePassengerData.object(at: 0) as? NSDictionary, let advenceBookingInfo = indexOfData.object(forKey: "BookingInfo") as? NSArray, let aryDataofPassenger = advenceBookingInfo.object(at: 0) as? NSDictionary {
                    
                    Singletons.sharedInstance.startedTripLatitude = Double(aryDataofPassenger.object(forKey: "PickupLat") as! String)!
                    Singletons.sharedInstance.startedTripLongitude = Double(aryDataofPassenger.object(forKey: "PickupLng") as! String)!
                }
                else {
                    return
                }
            }
            else {
                return
            }
            
            //                ((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary
            
            
            
            self.btnStartTripAction()
            
            self.mapView.clear()
            self.driverMarker = nil
            self.UpdateDriverLocation()
            
            Singletons.sharedInstance.isRequestAccepted = true
            Singletons.sharedInstance.isTripContinue = true
            
            UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
            UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
            
//            self.BottomButtonView.isHidden = false
//            self.StartTripView.isHidden = true
//            self.btnStartTrip.isHidden = true
            
            self.BottomButtonView.isHidden = false
            self.btnStartTrip.isHidden = true
            if self.btnArrived.isHidden == true {
                self.btnStartTrip.isHidden = false
            }
            
            self.vwStartTrip.isHidden = false
            Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterStart
            
            self.pickupPassengerFromLocation()
            
        }
    }
    func getTimeOfStartTrip()
    {
        
        self.socket?.on(socketApiKeys.kStartTripTimeError, callback: { (data, ack) in
                   print("crashed  \(#function)")
            print("getTimeOfStartTrip() : \(data)")
            if((((data as NSArray).object(at: 0) as! NSDictionary)).object(forKey: "status") as! Int == 1)
            {
                /*
                //                 self.btnStartTripAction()
                self.advanceBookingID = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingId") as! String
                
                
//                if (self.isFirstTimeFromPndingJobs) {
//                    self.BottomButtonView.isHidden = false
//                    self.StartTripView.isHidden = true
//                }
//                else {
//                    self.BottomButtonView.isHidden = true
//                    self.StartTripView.isHidden = false
//                }
//
//                self.isFirstTimeFromPndingJobs.toggleForBookLaterStartFromPendinfJobs()
//                self.btnStartTrip.isHidden = true
                
                
                
                guard let aryAdvancePassengerData = self.aryPassengerData as? NSArray else {
                    
                    print("Error")
                    return
                }
                
                if aryAdvancePassengerData.count != 0 {
                    
                    if let indexOfData = aryAdvancePassengerData.object(at: 0) as? NSDictionary, let advenceBookingInfo = indexOfData.object(forKey: "BookingInfo") as? NSDictionary {
                        Singletons.sharedInstance.startedTripLatitude = Double(advenceBookingInfo.object(forKey: "PickupLat") as! String)!
                        Singletons.sharedInstance.startedTripLongitude = Double(advenceBookingInfo.object(forKey: "PickupLng") as! String)!
                    }
                    else if let indexOfData = aryAdvancePassengerData.object(at: 0) as? NSDictionary, let advenceBookingInfo = indexOfData.object(forKey: "BookingInfo") as? NSArray, let aryDataofPassenger = advenceBookingInfo.object(at: 0) as? NSDictionary {
                        
                        Singletons.sharedInstance.startedTripLatitude = Double(aryDataofPassenger.object(forKey: "PickupLat") as! String)!
                        Singletons.sharedInstance.startedTripLongitude = Double(aryDataofPassenger.object(forKey: "PickupLng") as! String)!
                    }
                    else {
                        return
                    }
                }
                else {
                    return
                }
                
//                ((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary
                
                
                
                self.btnStartTripAction()
                
                self.mapView.clear()
                self.driverMarker = nil
                self.UpdateDriverLocation()
                
                Singletons.sharedInstance.isRequestAccepted = true
                Singletons.sharedInstance.isTripContinue = true
                
                UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
                UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
                
                self.BottomButtonView.isHidden = false
                self.StartTripView.isHidden = true
                self.btnStartTrip.isHidden = true
                self.vwStartTrip.isHidden = self.btnStartTrip.isHidden
                Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterStart
                
                self.pickupPassengerFromLocation()
                */
            }
            else
            {
             
//                self.btnCompleteTrip.isHidden = true
                UtilityClass.showAlert(appName.kAPPName, message: (((data as NSArray).object(at: 0) as! NSDictionary)).object(forKey: "message") as! String, vc: self)
            }
        })
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Get Booking Details After Booking Request Accepted
    //-------------------------------------------------------------
    func GetBookingDetailsAfterBookingRequestAccepted() {
        
        self.socket?.on(socketApiKeys.kGetBookingDetailsAfterBookingRequestAccepted, callback: { (data, ack) in
            
            print("GetBookingDetailsAfterBookingRequestAccepted() : \(data)")
        
            print("crashed  \(#function)")
                if let PassengerType = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingType") as? String {
                    
                    Singletons.sharedInstance.passengerType = PassengerType
                }
                
                Singletons.sharedInstance.isRequestAccepted = true
                UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
                
                //            DispatchQueue.main.async {
            
            if !(Singletons.sharedInstance.isBookNowOrBookLater) {
                self.methodAfterDidAcceptBooking(data: data as NSArray)
                
            }
            
            UtilityClass.hideACProgressHUD()
        
            //            }
        })
    }
    
    func zoomoutCamera(PickupLat: CLLocationDegrees, PickupLng: CLLocationDegrees, DropOffLat : String, DropOffLon: String)
    {
        let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: Double(PickupLat), longitude: Double(PickupLng)), coordinate: CLLocationCoordinate2D(latitude: Double(DropOffLat)!, longitude: Double(DropOffLon)!))
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(40))
        
        self.mapView.animate(with: update)
        
        self.mapView.moveCamera(update)
        
        
    }
    func methodAfterDidAcceptBooking(data : NSArray) {
        timerForUpdateCurrentLocation.invalidate() // Bhavesh
        
        let getBookingAndPassengerInfo = self.getBookingAndPassengerInfo(data: data)
        
        DispatchQueue.main.async {
            
            DispatchQueue.main.asyncAfter(deadline: .now()) { // change 2 to desired number of seconds
                self.BottomButtonView.isHidden = false
                
                self.btnStartTrip.isHidden = true // self.btnStartTrip.isHidden = false
                if self.btnArrived.isHidden == true {
                     self.btnStartTrip.isHidden = false
                }
                self.vwStartTrip.isHidden = false // self.btnStartTrip.isHidden
                self.btnStartTrip.layoutIfNeeded()
                self.BottomButtonView.layoutIfNeeded()
            }
            
        }
        
        let BookingInfo = getBookingAndPassengerInfo.0
        let PassengerInfo = getBookingAndPassengerInfo.1
        
        if let paymentType = BookingInfo.object(forKey: "PaymentType") as? String {
            Singletons.sharedInstance.passengerPaymentType = paymentType
        }
        
        if let passengerType = BookingInfo.object(forKey: "PassengerType") as? String {
            Singletons.sharedInstance.passengerType = passengerType
        }
        if let pasengerFlightNumber = BookingInfo.object(forKey: "FlightNumber") as? String {
            Singletons.sharedInstance.pasengerFlightNumber = pasengerFlightNumber
        }
        if let passengerNote = BookingInfo.object(forKey: "Notes") as? String {
            Singletons.sharedInstance.passengerNote = passengerNote
        }
        
        
        let DropOffLat = BookingInfo.object(forKey: "PickupLat") as! String
        let DropOffLon = BookingInfo.object(forKey: "PickupLng") as! String
        
//        self.lblLocationOnMap.text = BookingInfo.object(forKey: "PickupLocation") as? String
        self.strPickupLocation = BookingInfo.object(forKey: "PickupLocation") as! String
        self.strDropoffLocation = BookingInfo.object(forKey: "DropoffLocation") as! String
        self.strPassengerName = PassengerInfo.object(forKey: "Fullname") as! String
        
        var imgURL = String()
        
        self.strPassengerMobileNo = PassengerInfo.object(forKey: "MobileNo") as! String
        imgURL = PassengerInfo.object(forKey: "Image") as! String
        
        let PickupLat = self.defaultLocation.coordinate.latitude
        let PickupLng = self.defaultLocation.coordinate.longitude
        
//        let dummyLatitude = Double(PickupLat) - Double(DropOffLat)!
//        let dummyLongitude = Double(PickupLng) - Double(DropOffLon)!
        
//        let waypointLatitude = self.defaultLocation.coordinate.latitude - dummyLatitude
//        let waypointSetLongitude = self.defaultLocation.coordinate.longitude - dummyLongitude
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        zoomoutCamera(PickupLat: PickupLat, PickupLng: PickupLng, DropOffLat: DropOffLat, DropOffLon: DropOffLon)
        
        
        self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, completionHandler: nil)
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PassengerInfoViewController") as! PassengerInfoViewController
        next.strPickupLocation = self.strPickupLocation
        next.strDropoffLocation = self.strDropoffLocation
        next.imgURL = imgURL
        if((PassengerInfo.object(forKey: "FlightNumber")) != nil)
        {
            next.strFlightNumber = PassengerInfo.object(forKey: "FlightNumber") as! String
        }
        if((PassengerInfo.object(forKey: "Notes")) != nil)
        {
            next.strNotes = PassengerInfo.object(forKey: "Notes") as! String
        }
        next.strPassengerName =  self.strPassengerName
        next.strPassengerMobileNumber =  self.strPassengerMobileNo
        //        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
        
    }
    
    
    func getBookingAndPassengerInfo(data : NSArray) -> (NSMutableDictionary,NSMutableDictionary)
    {
        self.aryBookingData = data as NSArray
        Singletons.sharedInstance.aryPassengerInfo = data as NSArray
        
        /* 6th March 2020
        UserDefaults.standard.set(data, forKey: "BookNowInformation")
        UserDefaults.standard.synchronize()
        */
        
        self.aryPassengerData = NSArray(array: data)
        //
        var BookingInfo = NSMutableDictionary()
        var PassengerInfo = NSMutableDictionary()
        
        if Singletons.sharedInstance.latitude != nil
        {
            oldCoordinate = CLLocationCoordinate2DMake(Singletons.sharedInstance.latitude ,Singletons.sharedInstance.longitude)
            
            
            print("crashed  \(#function)")
            
            if((((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) == nil)
            {
                // print ("Yes its  array ")
                BookingInfo = NSMutableDictionary(dictionary: (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary)
                
                let PassengerType = BookingInfo.object(forKey: "PassengerType") as? String
                
                
                let dictInfo = (self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary
                var strPassengerRating = ""
                if let pRatings = dictInfo["PassengerRate"] as? String {
                    strPassengerRating = pRatings
                }
                if let pRatings = dictInfo["PassengerRate"] as? Double {
                    strPassengerRating = String(format: "%.2f",Double(pRatings))
                }
                
                if PassengerType == "" || PassengerType == nil {
                    Singletons.sharedInstance.passengerType = ""
                }
                else
                {
                    Singletons.sharedInstance.passengerType = PassengerType!
                }
                
                
                if Singletons.sharedInstance.passengerType == "other" || Singletons.sharedInstance.passengerType == "others" {
                    
                    let Fullname = BookingInfo.object(forKey: "PassengerName")
                    
                    let FlightNumber = BookingInfo.object(forKey: "FlightNumber")
                    let PaymentType = BookingInfo.object(forKey: "PaymentType")
                    let Notes = BookingInfo.object(forKey: "Notes")
                    
                    var MobileNo = String()
                    if let mobileNumber = BookingInfo.object(forKey: "MobileNo") as? String {
                        
                        if mobileNumber == "" {
                            
                            if let contacoNo = BookingInfo.object(forKey: "PassengerContact") as? String {
                                MobileNo = contacoNo
                            }
                            else {
                                MobileNo = ""
                            }
                        }
                        else {
                            MobileNo = mobileNumber
                        }
                    }
                    
                    var dictPassengerInfo = [String:AnyObject]()
                    dictPassengerInfo["Fullname"] = Fullname as AnyObject
                    dictPassengerInfo["MobileNo"] = MobileNo as AnyObject
                    dictPassengerInfo["PassengerType"] = PassengerType as AnyObject
                    dictPassengerInfo["FlightNumber"] = FlightNumber as AnyObject
                    dictPassengerInfo["PaymentType"] = PaymentType as AnyObject
                    dictPassengerInfo["Notes"] = Notes as AnyObject
                    dictPassengerInfo["PassengerRating"] = strPassengerRating as AnyObject
                    PassengerInfo = NSMutableDictionary(dictionary: dictPassengerInfo)
                    
                }else {
                    PassengerInfo = NSMutableDictionary(dictionary: (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "PassengerInfo") as! NSArray).object(at: 0) as! NSDictionary)
                    PassengerInfo.setObject(BookingInfo.object(forKey: "Notes") ?? "", forKey: "Notes" as NSCopying)
                    
                    
                    let dictInfo = (self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary
                    var strPassengerRating = ""
                    if let pRatings = dictInfo["PassengerRate"] as? String {
                        strPassengerRating = pRatings
                    }
                    if let pRatings = dictInfo["PassengerRate"] as? Double {
                        strPassengerRating = String(format: "%.2f",Double(pRatings))
                    }
                    
                    PassengerInfo.setObject(strPassengerRating, forKey: "PassengerRating" as NSCopying)
                    
                }
                
                
                // ----------------------------------------------------------------------
            }
            else
            {
                // print ("Yes its dictionary")
                BookingInfo = NSMutableDictionary(dictionary: (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSDictionary))  //.object(at: 0) as! NSDictionary
                
                
                let PassengerType = self.dictCurrentBookingInfoData.object(forKey: "PassengerType") as? String
                
                if PassengerType == "" || PassengerType == nil{
                    Singletons.sharedInstance.passengerType = ""
                }
                else {
                    Singletons.sharedInstance.passengerType = PassengerType!
                }
                
                
                if Singletons.sharedInstance.passengerType == "other" || Singletons.sharedInstance.passengerType == "others" {
                    
                    let Fullname = BookingInfo.object(forKey: "PassengerName")
                    
                    let FlightNumber = BookingInfo.object(forKey: "FlightNumber")
                    let PaymentType = BookingInfo.object(forKey: "PaymentType")
                    let Notes = BookingInfo.object(forKey: "Notes")
                    
                    var MobileNo = String()
                    if let mobileNumber = BookingInfo.object(forKey: "MobileNo") as? String {
                        
                        if mobileNumber == "" {
                            
                            if let contacoNo = BookingInfo.object(forKey: "PassengerContact") as? String {
                                MobileNo = contacoNo
                            }
                            else {
                                MobileNo = ""
                            }
                        }
                        else {
                            MobileNo = mobileNumber
                        }
                    }
                    
                    var dictPassengerInfo = [String:AnyObject]()
                    dictPassengerInfo["Fullname"] = Fullname as AnyObject
                    dictPassengerInfo["MobileNo"] = MobileNo as AnyObject
                    dictPassengerInfo["PassengerType"] = PassengerType as AnyObject
                    dictPassengerInfo["FlightNumber"] = FlightNumber as AnyObject
                    dictPassengerInfo["PaymentType"] = PaymentType as AnyObject
                    dictPassengerInfo["Notes"] = Notes as AnyObject
                    
                    //change 1st January
                    let dictInfo = (self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary
                    var strPassengerRating = ""
                    if let pRatings = dictInfo["PassengerRate"] as? String {
                        strPassengerRating = pRatings
                    }
                    if let pRatings = dictInfo["PassengerRate"] as? Double {
                        strPassengerRating = String(format: "%.2f",Double(pRatings))
                    }
                    
                    PassengerInfo.setObject(strPassengerRating, forKey: "PassengerRating" as NSCopying)
                    
                    PassengerInfo = NSMutableDictionary(dictionary: dictPassengerInfo)
                    
                }
                else {
                    PassengerInfo = NSMutableDictionary(dictionary: ((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "PassengerInfo")  as! NSDictionary)
                    PassengerInfo.setObject(BookingInfo.object(forKey: "Notes") ?? "", forKey: "Notes" as NSCopying)
                    
                    //change 1st January
                    let dictInfo = (self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary
                    var strPassengerRating = ""
                    if let pRatings = dictInfo["PassengerRate"] as? String {
                        strPassengerRating = pRatings
                    }
                    if let pRatings = dictInfo["PassengerRate"] as? Double {
                        strPassengerRating = String(format: "%.2f",Double(pRatings))
                    }
                    
                    PassengerInfo.setObject(strPassengerRating, forKey: "PassengerRating" as NSCopying)
                }
                
            }
            return (BookingInfo,PassengerInfo)
        }
        else
        {
            //            webserviceOfCurrentBooking()
            //            self.getBookingAndPassengerInfo(data: data)
            return (BookingInfo,PassengerInfo)
        }
    }
    
    func PickupPassengerByDriverInBookLaterRequest() {
        
        let myJSON = [socketApiKeys.kBookingId : advanceBookingID,  profileKeys.kDriverId : driverID] as [String : Any]
        socket?.emit(socketApiKeys.kAdvancedBookingPickupPassenger, with: [myJSON])
    }
    
    func StartHoldTrip() {
        
        let myJSON = [socketApiKeys.kBookingId : advanceBookingID] as [String : Any]
        socket?.emit(socketApiKeys.kAdvancedBookingStartHoldTrip, with: [myJSON])
    }
    
    func EndHoldTrip() {
        
        let myJSON = [socketApiKeys.kBookingId : advanceBookingID] as [String : Any]
        socket?.emit(socketApiKeys.kAdvancedBookingEndHoldTrip, with: [myJSON])
    }
    
    func CompletedBookLaterTrip() {
        
                   print("crashed  \(#function)")
        let BookingInfo : NSDictionary!
        if((((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) == nil)
        {
            BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as? NSDictionary
        }
        else
        {
            BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
        }
        
        let strPassengerID = BookingInfo.object(forKey: "PassengerId") as! String
        
        if (Singletons.sharedInstance.advanceBookingIdTemp != "") {
            advanceBookingID = Singletons.sharedInstance.advanceBookingId
        }
        
        let myJSON = ["PassengerId" : strPassengerID, socketApiKeys.kBookingId : advanceBookingID,  profileKeys.kDriverId : driverID] as [String : Any]
        socket?.emit(socketApiKeys.kAdvancedBookingCompleteTrip, with: [myJSON])
    }
    
    func GetAdvanceBookingDetailsAfterBookingRequestAccepted() {
        
        self.socket?.on(socketApiKeys.kAdvancedBookingInfo, callback: { (data, ack) in
            print ("GetAdvanceBookingDetails is :  \(data)")
            
            Singletons.sharedInstance.isRequestAccepted = true
            UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
            self.countDown5Minutes = Singletons.sharedInstance.intArrivalTimeInSeconds
            DispatchQueue.main.async {
                self.BottomButtonView.isHidden = true

                self.btnStartTrip.isHidden = true
                self.btnArrived.isHidden = false
                if self.btnArrived.isHidden == true {
                    self.btnStartTrip.isHidden = false
                }
                
                // print ("GetAdvanceBookingDetailsAfterBookingRequestAccepted()")
                
                if !(Singletons.sharedInstance.isBookNowOrBookLater) {
                    self.methodAfterDidAcceptBookingLaterRequest(data: data as NSArray)
                    
                }
                
                UtilityClass.hideACProgressHUD()
                
            }
            
        })
        
    }
    
    func getNotificationForReceiveMoneyNotify() {
        
        self.socket?.on(socketApiKeys.kReceiveMoneyNotify, callback: { (data, ack) in
            
            print("ReceiveMoneyNotify: \(data)")
                       print("crashed  \(#function)")
            UtilityClass.showAlert(appName.kAPPName, message: ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
            
        })
    }
    
    func onAdvancedBookingPickupPassengerNotification() {
        
        self.socket?.on(socketApiKeys.kAdvancedBookingPickupPassengerNotification, callback: { (data, ack) in
            
            print(#function,": \(data)")
            
            
        })
        
    }
    
    func methodAfterDidAcceptBookingLaterRequest(data: NSArray)
    {
        timerForUpdateCurrentLocation.invalidate() // Bhavesh
        
        // print ("methodAfterDidAcceptBookingLaterRequest")
        self.aryPassengerData = NSArray(array: data)
        self.BottomButtonView.isHidden = false
         self.btnStartTrip.isHidden = true
        if self.btnArrived.isHidden == true {
            self.btnStartTrip.isHidden = false
        }
        vwStartTrip.isHidden = false //btnStartTrip.isHidden
        self.aryBookingData = data as NSArray
        Singletons.sharedInstance.aryPassengerInfo = data as NSArray
        
        self.isAdvanceBooking = true
        
        let getBookingAndPassengerInfo = self.getBookingAndPassengerInfo(data: data)
        
        let BookingInfo = getBookingAndPassengerInfo.0
        let PassengerInfo = getBookingAndPassengerInfo.1
        
        if let paymentType = BookingInfo.object(forKey: "PaymentType") as? String {
            Singletons.sharedInstance.passengerPaymentType = paymentType
        }
        
        if let strBookingAry = data as? NSArray {
            if let strBookingFirstDict = strBookingAry.firstObject as? NSDictionary {
                if let strBookingType = strBookingFirstDict.object(forKey: "BookingType") as? String {
                    Singletons.sharedInstance.strBookingType = strBookingType
                }
                else {
                    Singletons.sharedInstance.strBookingType = "BookLater"
                }
            }
            else {
                Singletons.sharedInstance.strBookingType = "BookLater"
            }
        }
        else {
            Singletons.sharedInstance.strBookingType = "BookLater"
        }
        
//        if let bookingType = BookingInfo.object(forKey: "BookingType") {
//            Singletons.sharedInstance.strBookingType = bookingType as! String
//        }
        
        if let passengerType = BookingInfo.object(forKey: "PassengerType") as? String {
            Singletons.sharedInstance.passengerType = passengerType
        }
        if let pasengerFlightNumber = BookingInfo.object(forKey: "FlightNumber") as? String {
            Singletons.sharedInstance.pasengerFlightNumber = pasengerFlightNumber
        }
        if let passengerNote = BookingInfo.object(forKey: "Notes") as? String {
            Singletons.sharedInstance.passengerNote = passengerNote
        }
        
        
        let DropOffLat = BookingInfo.object(forKey: "PickupLat") as! String
        let DropOffLon = BookingInfo.object(forKey: "PickupLng") as! String
        let strID = BookingInfo.object(forKey: "Id") as AnyObject
        
        self.advanceBookingID = String(describing: strID)
        
//        self.lblLocationOnMap.text = BookingInfo.object(forKey: "PickupLocation") as? String
        self.strPickupLocation = BookingInfo.object(forKey: "PickupLocation") as! String
        self.strDropoffLocation = BookingInfo.object(forKey: "DropoffLocation") as! String
        
        self.mapView.clear()
        
        
        self.strPassengerName = PassengerInfo.object(forKey: "Fullname") as! String
        self.strPassengerMobileNo = PassengerInfo.object(forKey: "MobileNo") as! String
        //         imgURL = PassengerInfo.object(forKey: "Image") as! String
        let PickupLat = self.defaultLocation.coordinate.latitude
        let PickupLng = self.defaultLocation.coordinate.longitude
        
        let dummyLatitude = Double(PickupLat) - Double(DropOffLat)!
        let dummyLongitude = Double(PickupLng) - Double(DropOffLon)!
        
        let waypointLatitude = self.defaultLocation.coordinate.latitude - dummyLatitude
        let waypointSetLongitude = self.defaultLocation.coordinate.longitude - dummyLongitude
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        zoomoutCamera(PickupLat: PickupLat, PickupLng: PickupLng, DropOffLat: DropOffLat, DropOffLon: DropOffLon)
        self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, completionHandler: nil)
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        
        let imgURL = PassengerInfo.object(forKey: "Image") as! String
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PassengerInfoViewController") as! PassengerInfoViewController
        
        next.strPickupLocation = self.strPickupLocation
        next.strDropoffLocation = self.strDropoffLocation
        next.imgURL = imgURL
        
        if((PassengerInfo.object(forKey: "FlightNumber")) != nil)
        {
            next.strFlightNumber = PassengerInfo.object(forKey: "FlightNumber") as! String
        }
        if((PassengerInfo.object(forKey: "Notes")) != nil)
        {
            next.strNotes = PassengerInfo.object(forKey: "Notes") as! String
        }
        next.strPassengerName =  self.strPassengerName
        next.strPassengerMobileNumber =  self.strPassengerMobileNo
        //        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
        
    }
    
    //-------------------------------------------------------------
    // MARK: - My Jobs View
    //-------------------------------------------------------------
    
    @IBAction func myJobsClick(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyJobsViewController") as? MyJobsViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    //-------------------------------------------------------------
    // MARK: - Accept and Reject Request
    //-------------------------------------------------------------
    
    
    func didAcceptedRequest() {
        
       
        timerForUpdateCurrentLocation.invalidate() // Bhavesh
        countDown5Minutes = Singletons.sharedInstance.intArrivalTimeInSeconds
        manager.startUpdatingLocation()
        if self.driverID != "" && self.defaultLocation.coordinate.latitude != 0 && self.defaultLocation.coordinate.longitude != 0 {
//            self.UpdateDriverLocation() //Changess 5th November
        }
        
        Singletons.sharedInstance.isPending = 0
        
        UpdateDriverLocation()
        
        UtilityClass.showACProgressHUD()
        self.stopSound()
        
        
        if Singletons.sharedInstance.strRideTypeFromAcceptRequest == "ShareRide" {
            
        }
        
        Singletons.sharedInstance.isPickUPPasenger = false
        vwMyJobs.isHidden = true
        if isAdvanceBooking {
            
            self.AcceptBookLaterBookingRequest()
        }else {
            BookingAcceped()
        }
        
    }
    
    func didRejectedRequest() {
        
        self.stopSound()
        
        
        if isAdvanceBooking {
            self.RejectBookLaterBookingRequest()
        }
        else {
            BookingRejected()
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Accept Book Later Request
    //-------------------------------------------------------------
    
    func AcceptBookLaterBookingRequest() {
        
//        self.resetMapView() //1
        //        self.mapView.selectedMarker = nil
        
        if Singletons.sharedInstance.advanceBookingIdTemp != "" {
            Singletons.sharedInstance.isPending = 1
        }
        else if Singletons.sharedInstance.bookingId != "" {
            Singletons.sharedInstance.isPending = 1
        }
        else if bookingID != "" {
            Singletons.sharedInstance.isPending = 1
        }
        
        if (Singletons.sharedInstance.oldBookingType.isBookNow) {
            Singletons.sharedInstance.oldBookingType.isBookLater = false
        }
        else {
            Singletons.sharedInstance.oldBookingType.isBookLater = true
        }
        
        UtilityClass.hideACProgressHUD()
        
        let myJSON = [socketApiKeys.kBookingId : advanceBookingID,  profileKeys.kDriverId : driverID, "Lat" : defaultLocation.coordinate.latitude,"Long" : defaultLocation.coordinate.longitude, "Pending": Singletons.sharedInstance.isPending] as [String : Any]
        socket?.emit(socketApiKeys.kAcceptAdvancedBookingRequest, with: [myJSON])
        
        GetAdvanceBookingDetailsAfterBookingRequestAccepted()
        Singletons.sharedInstance.strBookingType = "BookLater"
        
        playSound(strName: RingToneSound)
        
        if !(Singletons.sharedInstance.isBookNowOrBookLater) {
            
            self.resetMapView()
        }
        
    }
    
    
    // ------------------------------------------------------------
    //-------------------------------------------------------------
    // MARK: - Receive Book Later Request
    //-------------------------------------------------------------
    func ReceiveBookLaterBookingRequest() {
        
        self.socket?.on(socketApiKeys.kAriveAdvancedBookingRequest, callback: { (data, ack) in
            print ("ReceiveBookLater is \(data)")
                       print("crashed  \(#function)")
            self.advanceBookingID = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingId") as! String
            self.isAdvanceBooking = true
            self.isNowBooking = false
            
            Singletons.sharedInstance.isPending = 1
            
            if Singletons.sharedInstance.advanceBookingId == "" {
                Singletons.sharedInstance.advanceBookingId = self.advanceBookingID
                
                if Singletons.sharedInstance.bookingId == "" {
                    Singletons.sharedInstance.isPending = 0
                }
                
            }else {
                Singletons.sharedInstance.advanceBookingIdTemp = self.advanceBookingID
            }
            
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ReceiveRequestViewController") as! ReceiveRequestViewController
            next.delegate = self
            
            if let grandTotal = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "GrandTotal") as? String {
                if grandTotal == "" {
                    next.strGrandTotal = "0"
                }
                else {
                    next.strGrandTotal = grandTotal
                }
            }
            else {
                next.strGrandTotal = "0"
            }
            if let PickupLocation = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "PickupLocation") as? String {
                next.strPickupLocation = PickupLocation
            }
            
            if let DropoffLocation = ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DropoffLocation") as? String {
                next.strDropoffLocation = DropoffLocation
            }
            
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
            
            //            self.performSegue(withIdentifier: "segueReceiveRequest", sender: nil)
        })
    }
    
    //
    
    //-------------------------------------------------------------
    // MARK: - Accept Booking Request
    //-------------------------------------------------------------
    func BookingAcceped() {
        
        if Singletons.sharedInstance.bookingIdTemp != "" {
            Singletons.sharedInstance.isPending = 1
        }
        else if Singletons.sharedInstance.advanceBookingId != "" {
            Singletons.sharedInstance.isPending = 1
        }
        else if advanceBookingID != "" {
            Singletons.sharedInstance.isPending = 1
        }
//        else if Singletons.sharedInstance.bookingId != "" {
//            Singletons.sharedInstance.isPending = 1
//        }

        
        if (Singletons.sharedInstance.oldBookingType.isBookLater) {
            Singletons.sharedInstance.oldBookingType.isBookNow = false
        }
        else {
            Singletons.sharedInstance.oldBookingType.isBookNow = true
        }
        
        
        if bookingID == "" || driverID == "" {
            UtilityClass.showAlert("Missing", message: "Booking ID or Driver ID", vc: self)
        }
        else {
            let myJSON = [socketApiKeys.kBookingId : bookingID,  profileKeys.kDriverId : driverID, "Lat" : defaultLocation.coordinate.latitude,"Long": defaultLocation.coordinate.longitude, "Pending": Singletons.sharedInstance.isPending] as [String : Any]
            print("My json is \(myJSON)")
            socket?.emit(socketApiKeys.kAcceptBookingRequest, with: [myJSON])
            
//            UtilityClass.hideACProgressHUD()
//            GetBookingDetailsAfterBookingRequestAccepted() // delete comment
            
            
            if !(Singletons.sharedInstance.isBookNowOrBookLater) {
 
                self.resetMapView()
            }
        }
    }
    
    //
    //-------------------------------------------------------------
    // MARK: - Reject Booking Request
    //-------------------------------------------------------------
    func BookingRejected() {
        if bookingID == "" || driverID == "" {
            UtilityClass.showAlert("Missing", message: "Booking ID or Driver ID", vc: self)
        }
        else {
            
            if (Singletons.sharedInstance.firstRequestIsAccepted && self.strTempBookingId.count != 0) {
                let myJSON = [socketApiKeys.kBookingId : strTempBookingId,  profileKeys.kDriverId : driverID, "CancelledReason": Singletons.sharedInstance.strReasonForCancel] as [String : Any]
                socket?.emit(socketApiKeys.kRejectBookingRequest, with: [myJSON])
                Singletons.sharedInstance.strReasonForCancel = ""
                Singletons.sharedInstance.firstRequestIsAccepted = false
                
            }
            else {
                let myJSON = [socketApiKeys.kBookingId : bookingID,  profileKeys.kDriverId : driverID,"CancelledReason": Singletons.sharedInstance.strReasonForCancel] as [String : Any]
                socket?.emit(socketApiKeys.kRejectBookingRequest, with: [myJSON])
                Singletons.sharedInstance.strReasonForCancel = ""
                Singletons.sharedInstance.firstRequestIsAccepted = false
            }
        }
    }
    
    func RejectBookLaterBookingRequest() {
        
        if (Singletons.sharedInstance.advanceBookingIdTemp != "") {
            advanceBookingID = Singletons.sharedInstance.advanceBookingIdTemp
        }
        
        let myJSON = [socketApiKeys.kBookingId : advanceBookingID,  profileKeys.kDriverId : driverID] as [String : Any]
        socket?.emit(socketApiKeys.kForwardAdvancedBookingRequestToAnother, with: [myJSON])
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Cancel Trip
    //-------------------------------------------------------------
    
    
    func cancelTripByPassenger() {
        
//        if isAdvanceBooking == true {
//
//            self.CancelBookLaterTripByCancelNotification()
//
//        }
//        else {
            self.socket?.on(socketApiKeys.kDriverCancelTripNotification, callback: { (data, ack) in
                print ("Cancel request regular by passenger: \(data)")
                
//                if let bookingData = (((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! [[String:AnyObject]])[0]["Id"] {
//
//                }
                
//                if !(Singletons.sharedInstance.isBookNowOrBookLater) {
                
                UtilityClass.showAlert("Request Cancelled", message: (((data as NSArray).object(at: 0) as! NSDictionary)).object(forKey: "message") as! String, vc: self)
                self.resetMapView()
                
                Singletons.sharedInstance.bookingId = ""
                if self.driverMarker != nil {
                    self.driverMarker.title = ""
                }
                
                self.btnArrived.isEnabled = false
                self.isArrivedDriver = false
                self.btnArrived.isHidden = false
                self.btnStartTrip.isHidden = true
                self.lblTimerForCancelTrip.isHidden = true
                self.timerForCancelTripCountDown?.invalidate()
                self.lblTimerForCancelTrip.isHidden = true
                
                Singletons.sharedInstance.isRequestAccepted = false
                Singletons.sharedInstance.isTripContinue = false
                UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
                UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
                self.setCarAfterTrip()
//                }
               
            })
//        }
        
    }
    
    func CancelBookLaterTripByCancelNotification() {
        
        self.socket?.on(socketApiKeys.kAdvancedBookingDriverCancelTripNotification, callback: { (data, ack) in
            print ("Cancel request Later by passenger:  \(data)")
            
            if !(Singletons.sharedInstance.isBookNowOrBookLater) {
            
                let alert = UIAlertController(title: nil, message: ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "message") as? String, preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                    
                    self.resetMapView()
                    
                    Singletons.sharedInstance.advanceBookingId = ""
                    if self.driverMarker != nil {
                        self.driverMarker.title = ""
                    }
                    
                    //Change 9th january cancel
//                    self.BottomButtonView.isHidden = false

                    self.btnArrived.isEnabled = false
                    self.isArrivedDriver = false
                    self.btnArrived.isHidden = false
                    self.btnStartTrip.isHidden = true
                    self.lblTimerForCancelTrip.isHidden = true
                    self.timerForCancelTripCountDown?.invalidate()
                    self.lblTimerForCancelTrip.isHidden = true
                    self.btnCompleteTrip.isHidden = true
//                    self.btnCancelTrip.isEnabled = false
//                    self.btnCancelTrip.isHidden = true
                    ///////
                    Singletons.sharedInstance.isRequestAccepted = false
                    Singletons.sharedInstance.isTripContinue = false
                    UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
                    UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
                    self.setCarAfterTrip()
                })
                
                alert.addAction(OK)
                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                alertWindow.rootViewController = UIViewController()
                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                alertWindow.makeKeyAndVisible()
                alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
//                self.present(alert, animated: true, completion: nil)
            }
            else {
                print(data)
                
                if let aryCurrentData = data as? NSArray {
                    if let dictFirstObjectIsDict = aryCurrentData.object(at: 0) as? NSDictionary {
                        if let dictBookinInfoIsDictData = dictFirstObjectIsDict.object(forKey: "BookingInfo") as? NSArray {
                            if let passengerDataAdvance = dictBookinInfoIsDictData.object(at: 0) as? NSDictionary {
                                if let nameOfPassenger = passengerDataAdvance.object(forKey: "PassengerName") as? String {
                                    
                                    let alert = UIAlertController(title: nil, message: "\(dictFirstObjectIsDict.object(forKey: "message") as? String ?? "Trip has been canceled by passenger") \(nameOfPassenger)", preferredStyle: .alert)
                                    let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                                        self.resetMapView()
                                        
                                        //Change 9th january cancel
                                        self.btnArrived.isEnabled = false
                                        self.isArrivedDriver = false
                                        self.btnArrived.isHidden = false
                                        self.btnStartTrip.isHidden = true
                                        self.lblTimerForCancelTrip.isHidden = true
                                        self.timerForCancelTripCountDown?.invalidate()
                                        self.lblTimerForCancelTrip.isHidden = true
                                        
                                       
                                        self.btnCancelTrip.isEnabled = false
                                        self.btnCancelTrip.isHidden = true
                                        ///////
                                        
                                        Singletons.sharedInstance.isRequestAccepted = false
                                        Singletons.sharedInstance.isTripContinue = false
                                        UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
                                        UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
                                        self.setCarAfterTrip()
                                    })
                                    alert.addAction(OK)
                                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                    alertWindow.rootViewController = UIViewController()
                                    alertWindow.windowLevel = UIWindowLevelAlert + 1;
                                    alertWindow.makeKeyAndVisible()
                                    alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
//                                    self.presentedViewController?.present(alert, animated: true, completion: nil)
                                    
                                }
                            }
                        }
                    }
                }
                
                
            }
        })
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Set Car icon
    //-------------------------------------------------------------
    
    
    func setCarAfterTrip()
    {
        // print ("setCarAfterTrip")
        
        self.originCoordinate = CLLocationCoordinate2DMake(defaultLocation.coordinate.latitude, defaultLocation.coordinate.longitude)
        App_Delegate.RoadPickupTimer.invalidate()
        arrivedRoutePath = nil

        driverMarker = nil
        Singletons.sharedInstance.isRequestAccepted = false
        
    }
    
    // bhavesh testing
    var index = 0
    
    //-------------------------------------------------------------
    // MARK: - Button Action
    //-------------------------------------------------------------
    
    @IBAction func btnCurrentLocation(_ sender: UIButton) {
        
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude))
        mapView.animate(toZoom: 17.5)
 /*
        // bhavesh testing
       
         var myJSON = [String : Any]()
         
         index += 1
         
         switch index {
         case 1:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.056105, longitude: 72.519245))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 2:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.055942, longitude: 72.519169))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 3:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.055749, longitude: 72.519153))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 4:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.055331, longitude: 72.519015))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 5:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.054966, longitude: 72.518972))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 6:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.054759, longitude: 72.518897))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 7:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.054186, longitude: 72.518768))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 8:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.053726, longitude: 72.518641))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 9:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.053331, longitude: 72.518513))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 10:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.052837, longitude: 72.518362))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 11:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.052423, longitude: 72.518126))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 12:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.051791, longitude: 72.517955))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 13:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.051156, longitude: 72.517816))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 14:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.050721, longitude: 72.517559))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 15:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.050366, longitude: 72.517430))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 16:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.049966, longitude: 72.517331))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 17:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.049300, longitude: 72.517044))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 18:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.050057, longitude: 72.513594))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 19:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.050452, longitude: 72.511362))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 20:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.050373, longitude: 72.509731))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 21:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.050531, longitude: 72.508272))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 22:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.050404, longitude: 72.507388))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 23:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.050167, longitude: 72.506315))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 24:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.049930, longitude: 72.505586))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 25:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.050004, longitude: 72.505079))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         case 26:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.050064, longitude: 72.504564))
         myJSON = ["PassengerId" : passengerIDTimer!,profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": Singletons.sharedInstance.deviceToken]
         index = 0
         //     case 27:mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: 23.050246, longitude: 72.503354))
         //     myJSON = [profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": SingletonClass.sharedInstance.deviceToken]
         //
         //    myJSON = [profileKeys.kDriverId : driverID, socketApiKeys.kLat: aryLat[index], socketApiKeys.kLong: aryLng[index], "Token": SingletonClass.sharedInstance.deviceToken]
         
         default:
         index = 0
         print("")
         }
         
        socket?.emit(socketApiKeys.kSendDriverLocationRequestByPassenger, with: [myJSON])
         //        let myJSON = ["PassengerId" : passengerIDTimer!,  "DriverId" : SingletonClass.sharedInstance.strDriverID, "Lat": "\(lat)","Lng": "\(lng)"] as [String : Any]
         mapView?.animate(toZoom: 17.5)
       */
    }
    
    var timerForCancelTripCountDown: Timer?
    
    @IBAction func btnArrivedActionHandler(_ sender: UIButton) {
        if Singletons.sharedInstance.passengerPaymentType == "cash" || Singletons.sharedInstance.passengerPaymentType == "CASH"  || Singletons.sharedInstance.passengerPaymentType == "CASH" {
            Utilities.showAlertWithCompletion("Cash Job", message: "Please politely check customer has cash before trip starts", vc: self) { (success) in
                self.arriverdAction()
            }
        }else {
            self.arriverdAction()

        }
    }
    func arriverdAction() {
        
        if isNowBooking {
            let myJSON = [socketApiKeys.kBookingId : Singletons.sharedInstance.bookingId,  profileKeys.kDriverId : driverID] as [String : Any]
            socket?.emit(socketApiKeys.kArrivedAtPickupLocation, with: [myJSON])
        }else {
            let myJSON = [socketApiKeys.kBookingId : Singletons.sharedInstance.strPendinfTripData,  profileKeys.kDriverId : driverID] as [String : Any]
            socket?.emit(socketApiKeys.kAdvanceBookingArrivedAtPickupLocation, with: [myJSON])
        }
        print("\(#function)::::\(isNowBooking)")
        
        btnArrived.isHidden = true
        btnStartTrip.isHidden = false
        //        btnCancelTrip.isHidden = false
        
        timerForCancelTripCountDown = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountDown5Minutes), userInfo: nil, repeats: true)
    }
    @objc func updateCountDown5Minutes() {
        
        if(countDown5Minutes > 0) {
            lblTimerForCancelTrip.isHidden = false
            btnCancelTrip.isEnabled = false
            btnCancelTrip.isHidden = true
            let minutes = String(format: "%02i", countDown5Minutes / 60)
            let seconds = String(format:"%02i", countDown5Minutes % 60)
            lblTimerForCancelTrip.text = "You can not cancel trip before: \(minutes + ":" + seconds)"
            countDown5Minutes -= 1
            
        }
        else {
            btnCancelTrip.isEnabled = true
            btnCancelTrip.isHidden = false
            lblTimerForCancelTrip.isHidden = true
            timerForCancelTripCountDown?.invalidate()

        }
        
//        if countDown5Minutes == 1 {
//        }
        
    }
    
    @IBAction func btnStartTrip(_ sender: UIButton) {
        
        timerForCancelTripCountDown?.invalidate()
        
        btnCancelTrip.isEnabled = true
        lblTimerForCancelTrip.isHidden = true
        
        Singletons.sharedInstance.isBookNowOrBookLater = true
        Singletons.sharedInstance.firstRequestIsAccepted = false
        
        Singletons.sharedInstance.isPickUPPasenger = true
        
        Singletons.sharedInstance.isPending = 0
        
        UpdateDriverLocation()
        
        if isAdvanceBooking == true {
            
            if advanceBookingID == "" || driverID == "" {
                
                UtilityClass.showAlert("Missing", message: "Booking ID or Driver ID", vc: self)
                
            }
            else {
                
                self.PickupPassengerByDriverInBookLaterRequest()
                
                self.btnStartTripAction()
            }
        }
        else {
            
            if bookingID == "" || driverID == "" {
                
                UtilityClass.showAlert("Missing", message: "Booking ID or Driver ID", vc: self)
                
            }
            else {
                
                self.startTrip()
                self.btnStartTripAction()
            }
        }
    }
    
    @IBAction func btnCancelTrip(_ sender: Any) {
        self.performSegue(withIdentifier: "segueCancelTrip", sender: nil)
        lblTimerForCancelTrip.isHidden = true
//        cancelTrip()
    }
    
    func cancelTrip()
    {
        var dictParam = [String: AnyObject]()
        dictParam["DriverId"] = driverID as AnyObject
        if(Singletons.sharedInstance.bookingId == "" || self.bookingID.count == 0)
        {
            if (Singletons.sharedInstance.advanceBookingIdTemp != "") {
                self.advanceBookingID = Singletons.sharedInstance.advanceBookingIdTemp
            }
            
            Singletons.sharedInstance.bookingId = self.advanceBookingID
        }
//        if Singletons.sharedInstance.bookingId == "" {
//            Singletons.sharedInstance.bookingId = self.bookingID
//        }
        
        if self.bookingID != "" {
            Singletons.sharedInstance.bookingId = self.bookingID
        }
        
        if Singletons.sharedInstance.strBookingType == "BookLater" {
             dictParam["BookingId"] = advanceBookingID as AnyObject
        } else {
             dictParam["BookingId"] = Singletons.sharedInstance.bookingId as AnyObject
        }
        
       
        dictParam["BookingType"] = Singletons.sharedInstance.strBookingType as AnyObject
        if ( Singletons.sharedInstance.strBookingType == "") {
            dictParam["BookingType"] = "BookNow" as AnyObject//Singletons.sharedInstance.isBookNowOrBookLater = false
        }
        dictParam["CancelledReason"] = Singletons.sharedInstance.strReasonForCancel as AnyObject
        
        webserviceForCancelTrip(dictParam as AnyObject) { (result, status) in
            if (status) {
                Singletons.sharedInstance.strReasonForCancel = ""
                print(result)
                
                Singletons.sharedInstance.bookingId = ""
                Singletons.sharedInstance.bookingIdTemp = ""
                if self.driverMarker != nil {
                    self.driverMarker.title = ""
                }
                Singletons.sharedInstance.isBookNowOrBookLater = false
                
                self.resetMapView()
                
//                self.btnArrived.isEnabled = false
//                self.isArrivedDriver = false
//                self.btnArrived.isHidden = false
//                self.btnStartTrip.isHidden = true
                
                //                ((result as! [String:Any])["details"] as! [String:Any])["GrandTotal"] as! String
                
//                Singletons.sharedInstance.isRequestAccepted = false
//                Singletons.sharedInstance.isTripContinue = false
                Singletons.sharedInstance.bookingIdTemp = ""
                Singletons.sharedInstance.advanceBookingIdTemp = ""
                
                
                
                
                Singletons.sharedInstance.bookingId = ""
                Singletons.sharedInstance.advanceBookingId = ""
                if self.driverMarker != nil {
                    self.driverMarker.title = ""
                }
                
                self.btnArrived.isEnabled = false
                self.isArrivedDriver = false
                self.btnArrived.isHidden = false
                self.btnStartTrip.isHidden = true
                self.lblTimerForCancelTrip.isHidden = true
                self.timerForCancelTripCountDown?.invalidate()
                self.lblTimerForCancelTrip.isHidden = true
                self.btnCancelTrip.isEnabled = false
                self.btnCancelTrip.isHidden = true
                
                Singletons.sharedInstance.isRequestAccepted = false
                Singletons.sharedInstance.isTripContinue = false
                UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
                UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
                self.setCarAfterTrip()
                
                
                if let resDict = result as? NSDictionary {
//                    UtilityClass.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
                }
                
            }
            else {
                
                UtilityClass.showAlertWithCompletion(appName.kAPPName, message: "Please cancel trip again", vc: self, completionHandler: { (status) in
                    self.webserviceOfCurrentBooking()
                })
                
//                if let res = result as? String {
//                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
//                }
//                else if let resDict = result as? NSDictionary {
//                    UtilityClass.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
//                }
//                else if let resAry = result as? NSArray {
//                    UtilityClass.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
//                }
            }
        }
    }
    
    func btnStartTripAction() {
        
        self.mapView.clear()
        self.driverMarker = nil
        UpdateDriverLocation()
        
        Singletons.sharedInstance.isRequestAccepted = true
        Singletons.sharedInstance.isTripContinue = true
        
        UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
        UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
        
        
        if isAdvanceBooking == true {
            
            BottomButtonView.isHidden = true
            StartTripView.isHidden = false
            self.btnStartTrip.isHidden = true
            vwStartTrip.isHidden = btnStartTrip.isHidden
            self.pickupPassengerFromLocation()
            
        }
        else {
            
            BottomButtonView.isHidden = true
            StartTripView.isHidden = false
            self.btnStartTrip.isHidden = true
            vwStartTrip.isHidden = btnStartTrip.isHidden
            self.pickupPassengerFromLocation()
            
        }
        
        Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterStart
    }
    
    func startTrip() {
        
        if Singletons.sharedInstance.bookingId == "" {
            Singletons.sharedInstance.bookingId = bookingID
        }
        
        let myJSON = [socketApiKeys.kBookingId : Singletons.sharedInstance.bookingId,  profileKeys.kDriverId : driverID] as [String : Any]
        socket?.emit(socketApiKeys.kPickupPassengerByDriver, with: [myJSON])
        
    }
    
    @IBAction func btnShowPassengerInfo(_ sender: UIButton) {
       
        let data: NSArray = self.aryBookingData
        /* 6th March 2020
        UserDefaults.standard.set(data, forKey: "BookNowInformation")
        UserDefaults.standard.synchronize()
        */
        self.aryPassengerData = NSArray(array: data)
        self.BottomButtonView.isHidden = false
        
        if self.btnArrived.isHidden == true {
            self.btnStartTrip.isHidden = false
        }
        
        vwStartTrip.isHidden = false // btnStartTrip.isHidden
        
        
        let getPassengerInfo = getBookingAndPassengerInfo(data: self.aryPassengerData)
        
        let BookingInfo = getPassengerInfo.0
        let PassengerInfo = getPassengerInfo.1
        var imgURL = String()
        
//        self.lblLocationOnMap.text = BookingInfo.object(forKey: "PickupLocation") as? String
        self.strPickupLocation = BookingInfo.object(forKey: "PickupLocation") as! String
        self.strDropoffLocation = BookingInfo.object(forKey: "DropoffLocation") as! String
        self.strPassengerName = PassengerInfo.object(forKey: "Fullname") as! String
        self.strPassengerMobileNo = PassengerInfo.object(forKey: "MobileNo") as! String
        
        if let img =  PassengerInfo.object(forKey: "Image") as? String {
            imgURL = img
        }
        else {
            imgURL = ""
        }
        
        if let PassengerType = BookingInfo.object(forKey: "PassengerType") as? String {
            Singletons.sharedInstance.passengerType = PassengerType
        }
        if Singletons.sharedInstance.passengerType == "other" || Singletons.sharedInstance.passengerType == "others" {
            
            if let contactNumber = BookingInfo.object(forKey: "PassengerContact") as? String {
                
                self.strPassengerMobileNo = contactNumber
            }
        }
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PassengerInfoViewController") as! PassengerInfoViewController
        next.strPickupLocation = self.strPickupLocation
        next.strDropoffLocation = self.strDropoffLocation
        next.imgURL = imgURL
        if((PassengerInfo.object(forKey: "FlightNumber")) != nil)
        {
            next.strFlightNumber = PassengerInfo.object(forKey: "FlightNumber") as! String
        }
        if((PassengerInfo.object(forKey: "Notes")) != nil)
        {
            next.strNotes = PassengerInfo.object(forKey: "Notes") as! String
        }
        next.strPassengerName =  self.strPassengerName
        next.strPassengerMobileNumber =  self.strPassengerMobileNo
        let strRate = PassengerInfo["PassengerRating"] as! String
        
        next.nPassengerRate = CGFloat(Double(strRate) ?? 0.0)
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
        
    }
    
    //MARK: Success Cancel Request
    func didCancelRequestSuccess() {
        self.cancelTrip()
    }
    
    func didRejectRequestSuccess() {
        
    }
    
    //MARK: - Local Notification
    
    func addLocalNotification()
    {
        let state: UIApplicationState = UIApplication.shared.applicationState // or use  let state =  UIApplication.sharedApplication().applicationState
        
        if state == .background {
            
            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert,.sound];
            center.requestAuthorization(options: options) {
                (granted, error) in
                if !granted {
                    print("Something went wrong")
                }
            }
            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus != .authorized {
                    // Notifications not allowed
                }
            }
            let content = UNMutableNotificationContent()
            content.title = "Booking Request"
            content.body = "You have a new booking request"
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1,
                                                            repeats: false)
            
            let identifier = "localNotification"
            
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            
            center.add(request) { (error:Error?) in
                
                if error != nil {
                    print(error?.localizedDescription ?? "")
                }
                print("Notification Register Success")
            }
          
        }
    }
    
    
    //MARK: - Play Audio
    var audioPlayer:AVAudioPlayer!
    
    func playSound(strName : String) {
        
        guard let url = Bundle.main.url(forResource: strName, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
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
    
    @objc func enableButton() {
        self.btnCompleteTrip.isEnabled = true
    }
    
    var tollFee = String()
    
    func setPaddingView(txtField: UITextField){
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 18))
        label.text = "\(currency)"
        
        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 45, height: 18))
        txtField.leftViewMode = .always
        txtField.addSubview(label)
        txtField.leftView = paddingView
    }
    
    @IBAction func btnCompleteTrip(_ sender: UIButton)
    {
        btnCompleteTrip.isEnabled = false
       
        var dictOFParam = [String:AnyObject]()
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if error != nil {
                // print ("Pick Place error: \(error.localizedDescription)")
                self.getCurrentLocationForCompleteTrip()
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
                    self.strCompleteTripLocation = place.formattedAddress ?? "\(self.lblLocationOnMap.text ?? "")"
                }
            }
            dictOFParam["BookingType"] = self.isNowBooking ? "BookNow" as AnyObject : "BookLater" as AnyObject //sumOfFinalDistance as AnyObject
            dictOFParam["BookingId"] = self.isNowBooking ? self.bookingID  as AnyObject : self.advanceBookingID as AnyObject
            dictOFParam["DropoffLocation"] = self.strCompleteTripLocation as AnyObject
            webserviceForTripFareInformation(dictOFParam as AnyObject) { (result, status) in
                print(#line,#function,result)
                
                var GrandTotal = String()
                
                if let res = result as? [String:Any] {
                    
                    if let details = res["details"] as? [String:Any] {
                        if let strGrandTotal = details["GrandTotal"] as? String {
                            GrandTotal = strGrandTotal
                        }
                    }
                }
                let next = self.storyboard?.instantiateViewController(withIdentifier: "DamageChargeViewController") as! DamageChargeViewController
                
                
                next.delegate = self
                next.strTotalFare = GrandTotal
//                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
//                alertWindow.rootViewController = UIViewController()
//                alertWindow.windowLevel = UIWindowLevelAlert + 1
//                alertWindow.makeKeyAndVisible()
//                alertWindow.rootViewController?.present(next, animated: true, completion: nil)
                self.present(next, animated: true, completion: nil)
                Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterStop
                
                self.btnCompleteTrip.isEnabled = true
            }
            
            
            Singletons.sharedInstance.isBookNowOrBookLater = false
            
            self.tollFee = "0.00"
            
            
            //            self.completeTripFinalSubmit()
        })
//        let tollfee = self.tollFee.replacingOccurrences(of: "\(currency)", with: "")
      
     
        
        //        if (Singletons.sharedInstance.isTripHolding == false)
        //        {
//        if(Singletons.sharedInstance.strBookingType == "")
//        {
//
//            //1. Create the alert controller.
//            let alert = UIAlertController(title: "Toll Fee", message: "Enter toll fee if any", preferredStyle: .alert)
//
//            //2. Add the text field. You can configure it however you need.
//            alert.addTextField { (textField) in
//                textField.placeholder = "0.00"
//                textField.keyboardType = .decimalPad
//                self.setPaddingView(txtField: textField)
//
//            }
//
//            // 3. Grab the value from the text field, and print it when the user clicks OK.
//            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { [weak alert] (_) in
//                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
//                self.tollFee = (textField?.text)!
//                print("Text field: \(String(describing: textField?.text))")
//
//                if Singletons.sharedInstance.passengerPaymentType == "cash" || Singletons.sharedInstance.passengerPaymentType == "Cash" {
//
//                    self.completeTripButtonAction()
//
//                }
//                else {
//
//                    self.completeTripButtonAction()
//                }
//            }))
//
//
//            // 3. Grab the value from the text field, and print it when the user clicks OK.
//            alert.addAction(UIAlertAction(title: "NO", style: .destructive, handler: { [] (_) in
//                if Singletons.sharedInstance.passengerPaymentType == "cash" || Singletons.sharedInstance.passengerPaymentType == "Cash" {
//
//                    self.completeTripButtonAction()
//
//                }
//                else {
//
//                    self.completeTripButtonAction()
//                }
//            }))
//
//            // 4. Present the alert.
//            self.present(alert, animated: true, completion: nil)
//
//        }
//        else
//        {
//            self.completeTripButtonAction()
//
//        }
        
        
        
        // 9-July-2018
//        self.completeTripButtonAction()
        
        
        
        ///////////////////////////// 1st January Accoring new flow//////////////////////////////
        
        /*
        let next = self.storyboard?.instantiateViewController(withIdentifier: "DamageChargeViewController") as! DamageChargeViewController
        
        
        next.delegate = self
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(next, animated: true, completion: nil)
        
        Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterStop
      
        
        */
        ///////////////////////////////////////////////////////////

      
    }
    
    var strSoilDamageCharge = String()
    
    func didEnterDamageCharge(cost: String) {
        strSoilDamageCharge = cost
        self.completeTripButtonAction()
    }
    
    func completeTripButtonAction() {
        
        
        getCurrentLocationForCompleteTrip()
        
        
        self.btnCompleteTrip.isEnabled = false
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(HomeViewController.enableButton), userInfo: nil, repeats: false)
//        self.completeTripFinalSubmit()
        UtilityClass.hideACProgressHUD()
        App_Delegate.WaitingTimeCount = 0
        NotificationCenter.default.removeObserver("endTrip")
        //        if Singletons.sharedInstance.isTripHolding == true
        //        {
        //            UtilityClass.showAlert("Hold Trip Active", message: "Please stop holding trip", vc: self)
        //
        //        }
        //        else
        //        {
        
//        DispatchQueue.main.async
//            {
//
//                self.webserviceCallToGetDistanceByBackend()
//
//        }
        //        }
    }
    
    func completeTripFinalSubmit() {
       
//        if sumOfFinalDistance != 0 {
        
            var dictOFParam = [String:AnyObject]()
            let tollfee = self.tollFee.replacingOccurrences(of: "\(currency)", with: "")
            dictOFParam["TripDistance"] = App_Delegate.DistanceKiloMeter as AnyObject//sumOfFinalDistance as AnyObject
            dictOFParam["NightFareApplicable"] = 0 as AnyObject
            dictOFParam["PromoCode"] = "" as AnyObject
            dictOFParam["PaymentType"] = Singletons.sharedInstance.passengerPaymentType as AnyObject
            dictOFParam["PaymentStatus"] = "" as AnyObject
            dictOFParam["TransactionId"] = "" as AnyObject
            dictOFParam["TollFee"] = tollfee as AnyObject
            dictOFParam["WaitingTime"] = App_Delegate.WaitingTime as AnyObject
            dictOFParam["Pending"] = Singletons.sharedInstance.isPending as AnyObject
            let pickupCordinate = "\(Singletons.sharedInstance.startedTripLatitude),\(Singletons.sharedInstance.startedTripLongitude)"
            let destinationCordinate = "\(self.defaultLocation.coordinate.latitude),\(self.defaultLocation.coordinate.longitude)"
            if(App_Delegate.DistanceKiloMeter == "")
            {
                dictOFParam["lat"] = "\(self.defaultLocation.coordinate.latitude)" as AnyObject // "\(pickupCordinate)" as AnyObject
                dictOFParam["long"] = "\(self.defaultLocation.coordinate.longitude)" as AnyObject // "\(destinationCordinate)" as AnyObject
            }
            dictOFParam["DropoffLocation"] = self.strCompleteTripLocation as AnyObject
        
//            if strSoilDamageCharge != "" {
//                dictOFParam["SoilDamageCharge"] = strSoilDamageCharge as AnyObject
//            }
        
        if strSoilDamageCharge != "" {
            dictOFParam["SoilDamageChargeNote"] = strSoilDamageCharge as AnyObject
        }
       // dictOFParam["SoilDamageChargeNote"] = strSoilDamageCharge as AnyObject
            if isAdvanceBooking {
                
                if bookingID != "" {
                    
                    if (Singletons.sharedInstance.bookingIdTemp != "") {
                        Singletons.sharedInstance.bookingId = Singletons.sharedInstance.bookingIdTemp
                    }
                    
                    if Singletons.sharedInstance.bookingId == "" && advanceBookingID != "" {
                        
                        dictOFParam["BookingId"] = advanceBookingID as AnyObject
                        webserviceCallForAdvanceCompleteTrip(dictOFParam: dictOFParam as AnyObject)
                        
                    }
                    else {
                        dictOFParam["BookingId"] = Singletons.sharedInstance.bookingId as AnyObject // bookingID as AnyObject
                        webserviceCallForCompleteTrip(dictOFParam: dictOFParam as AnyObject)
                    }
                    
                }
                else {
                    
                    if (Singletons.sharedInstance.advanceBookingIdTemp != "") {
                        advanceBookingID = Singletons.sharedInstance.advanceBookingId
                    }
                    
                    dictOFParam["BookingId"] = advanceBookingID as AnyObject
                    
                    webserviceCallForAdvanceCompleteTrip(dictOFParam: dictOFParam as AnyObject)
                }
                
                
                
                
//
//                if (Singletons.sharedInstance.oldBookingType.isBookNow) {
//                    dictOFParam["BookingId"] = Singletons.sharedInstance.bookingId as AnyObject // bookingID as AnyObject
//
//                    webserviceCallForCompleteTrip(dictOFParam: dictOFParam as AnyObject)
//                }
//                else {
//                    if (Singletons.sharedInstance.advanceBookingIdTemp != "") {
//                        advanceBookingID = Singletons.sharedInstance.advanceBookingId
//                    }
//
//                    dictOFParam["BookingId"] = advanceBookingID as AnyObject
//
//                    webserviceCallForAdvanceCompleteTrip(dictOFParam: dictOFParam as AnyObject)
//                }
                
//                if (Singletons.sharedInstance.advanceBookingIdTemp != "") {
//                    advanceBookingID = Singletons.sharedInstance.advanceBookingId
//                }
//
//                dictOFParam["BookingId"] = advanceBookingID as AnyObject
//
//                webserviceCallForAdvanceCompleteTrip(dictOFParam: dictOFParam as AnyObject)
            }
            else
            {
                
                if advanceBookingID != "" {
                    if (Singletons.sharedInstance.advanceBookingIdTemp != "") {
                        advanceBookingID = Singletons.sharedInstance.advanceBookingId
                    }
                    
                    dictOFParam["BookingId"] = advanceBookingID as AnyObject
                    
                    webserviceCallForAdvanceCompleteTrip(dictOFParam: dictOFParam as AnyObject)
                }
                else {
                    
                    if Singletons.sharedInstance.bookingId == "" {
                        if (Singletons.sharedInstance.bookingIdTemp != "") {
                            Singletons.sharedInstance.bookingId = Singletons.sharedInstance.bookingIdTemp
                        }
                    }
                    
                    dictOFParam["BookingId"] = Singletons.sharedInstance.bookingId as AnyObject // bookingID as AnyObject
                    webserviceCallForCompleteTrip(dictOFParam: dictOFParam as AnyObject)
                }
                
                
//                if (Singletons.sharedInstance.oldBookingType.isBookNow) {
//
//                    dictOFParam["BookingId"] = Singletons.sharedInstance.bookingId as AnyObject // bookingID as AnyObject
//                    webserviceCallForCompleteTrip(dictOFParam: dictOFParam as AnyObject)
//                }
//                else {
//                    if (Singletons.sharedInstance.advanceBookingIdTemp != "") {
//                        advanceBookingID = Singletons.sharedInstance.advanceBookingId
//                    }
//
//                    dictOFParam["BookingId"] = advanceBookingID as AnyObject
//
//                    webserviceCallForAdvanceCompleteTrip(dictOFParam: dictOFParam as AnyObject)
//                }
                
                
//                dictOFParam["BookingId"] = Singletons.sharedInstance.bookingId as AnyObject // bookingID as AnyObject
//                webserviceCallForCompleteTrip(dictOFParam: dictOFParam as AnyObject)
            }
            
//        }
    }
    
    
    //MARK:- ResetMap View
    func resetMapView()
    {
        self.mapView.clear()
        
        self.BottomButtonView.isHidden = true
        
        self.StartTripView.isHidden = true
        
        self.btnStartTrip.isHidden = true
        
        vwStartTrip.isHidden = btnStartTrip.isHidden
        
        self.sumOfFinalDistance = 0
        
        
    }
    
    //MARK:- Holding Button
    
    @IBOutlet weak var btnCompleteTrip: UIButton!
    @IBOutlet weak var btnWaiting: UIButton!
    
    // Holding Button
    @IBAction func btnHoldWaiting(_ sender: UIButton) {
        
        
        if isAdvanceBooking {
            
            if advanceBookingID == "" {
                
                UtilityClass.showAlert("Missing", message: "Booking ID", vc: self)
                
            }
            else {
                
                if Singletons.sharedInstance.MeterStatus == meterStatus.kIsMeterOnHolding
                {
                    
                    btnWaiting.setTitle("Stop (Waiting)",for: .normal)
                    
                    Singletons.sharedInstance.isTripHolding = true
                    UserDefaults.standard.set(Singletons.sharedInstance.isTripHolding, forKey: holdTripStatus.kIsTripisHolding)
                    
                    if (!App_Delegate.RoadPickupTimer.isValid())
                    {
                        App_Delegate.RoadPickupTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:  #selector(HomeViewController.updateTime), userInfo: nil, repeats: true)
                    }
                    
                }
                else
                {
                    
                    btnWaiting.setTitle("Hold (Waiting)",for: .normal)
                    
                    Singletons.sharedInstance.isTripHolding = false
                    UserDefaults.standard.set(Singletons.sharedInstance.isTripHolding, forKey: holdTripStatus.kIsTripisHolding)
                    
                    App_Delegate.RoadPickupTimer.invalidate()
                    
                }
                
//                if btnWaiting.currentTitle == "Hold (Waiting)"
//                {
//
//                    btnWaiting.setTitle("Stop (Waiting)",for: .normal)
//
//                    Singletons.sharedInstance.isTripHolding = true
//                    UserDefaults.standard.set(Singletons.sharedInstance.isTripHolding, forKey: holdTripStatus.kIsTripisHolding)
//                    Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterOnHolding
//                    //                    self.StartHoldTrip()
//
//                }
//                else if btnWaiting.currentTitle == "Stop (Waiting)" {
//
//                    btnWaiting.setTitle("Hold (Waiting)",for: .normal)
//                    Singletons.sharedInstance.MeterStatus = meterStatus.kIsMeterStart
//                    Singletons.sharedInstance.isTripHolding = false
//                    UserDefaults.standard.set(Singletons.sharedInstance.isTripHolding, forKey: holdTripStatus.kIsTripisHolding)
//                    //                    self.EndHoldTrip()
//
//                }
                
            }
            
        }
        else {
            
            if bookingID == "" && Singletons.sharedInstance.isRequestAccepted == true {
                
                UtilityClass.showAlert("Missing", message: "Booking ID", vc: self)
                
            }
            else {
                
                if Singletons.sharedInstance.MeterStatus == meterStatus.kIsMeterOnHolding
                {
                    
                    btnWaiting.setTitle("Stop (Waiting)",for: .normal)
                    
                    Singletons.sharedInstance.isTripHolding = true
                    UserDefaults.standard.set(Singletons.sharedInstance.isTripHolding, forKey: holdTripStatus.kIsTripisHolding)
                    
//                    if (!App_Delegate.RoadPickupTimer.isValid())
//                    {
                        App_Delegate.RoadPickupTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:  #selector(HomeViewController.updateTime), userInfo: nil, repeats: true)
//                    }
                    
                }
                else
                {
                    
                    btnWaiting.setTitle("Hold (Waiting)",for: .normal)
                    
                    Singletons.sharedInstance.isTripHolding = false
                    UserDefaults.standard.set(Singletons.sharedInstance.isTripHolding, forKey: holdTripStatus.kIsTripisHolding)
            
                    App_Delegate.RoadPickupTimer.invalidate()
                    
                }
                
            }
        }
        NotificationCenter.default.removeObserver("HoldCurrentTrip")
    }
    
    @IBOutlet weak var btnRejectRequest: UIButton!
    @IBOutlet weak var btnAcceptRequest: UIButton!
    
    @IBAction func btnAcceptRequest(_ sender: UIButton) {
        
         Singletons.sharedInstance.isPickUPPasenger = false
        
//        self.resetMapView()
        manager.startUpdatingLocation()
        if isAdvanceBooking {
            self.AcceptBookLaterBookingRequest()
        }
        else {
            self.BookingAcceped()
        }
        
    }
    
    @IBAction func btnRejectRequest(_ sender: UIButton) {
        
        if isAdvanceBooking {
            self.RejectBookLaterBookingRequest()
        }
        else {
            self.BookingRejected()
        }
        
    }
    
    @IBAction func btnPassengerInfoOK(_ sender: UIButton) {
        
    }
    
    func pickupPassengerFromLocation() {
        
        Singletons.sharedInstance.isPickUPPasenger = true
        timerForUpdateCurrentLocation.invalidate() // Bhavesh
        
        let BookingInfo : NSDictionary!
                   print("crashed  \(#function)")
        if((((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) == nil)
        {
            // print ("Yes its  array ")
            BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        }
        else
        {
            // print (Yes its dictionary")
            BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
        }
        
        // ------------------------------------------------------------
        
        //        SingletonsForMeter.sharedInstance.vehicleModelID = (Int(BookingInfo.object(forKey: "ModelId") as! NSNumber))
        
        var VehicleID = String()
        
        if let vehId = BookingInfo.object(forKey: "ModelId") as? String {
            VehicleID = vehId
        }
        else if let vehId = BookingInfo.object(forKey: "ModelId") as? Int {
            VehicleID = "\(vehId)"
        }
        
        SingletonsForMeter.sharedInstance.vehicleModelID = Int(VehicleID)!
        
        let DropOffLat = BookingInfo.object(forKey: "DropOffLat") as! String
        let DropOffLon = BookingInfo.object(forKey: "DropOffLon") as! String
        
        Singletons.sharedInstance.startedTripLatitude = Double(BookingInfo.object(forKey: "PickupLat") as! String)!
        Singletons.sharedInstance.startedTripLongitude = Double(BookingInfo.object(forKey: "PickupLng") as! String)!
        
//        self.lblLocationOnMap.text = BookingInfo.object(forKey: "DropoffLocation") as? String
        
        let PickupLat = self.defaultLocation.coordinate.latitude
        let PickupLng = self.defaultLocation.coordinate.longitude
        
        let dummyLatitude = Double(PickupLat) - Double(DropOffLat)!
        let dummyLongitude = Double(PickupLng) - Double(DropOffLon)!
        
        let waypointLatitude = self.defaultLocation.coordinate.latitude - dummyLatitude
        let waypointSetLongitude = self.defaultLocation.coordinate.longitude - dummyLongitude
        
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        zoomoutCamera(PickupLat: PickupLat, PickupLng: PickupLng, DropOffLat: DropOffLat, DropOffLon: DropOffLon)
        
        self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, completionHandler: nil)
        print("crashed  \(#function)")
    }
    
    func getDistanceForPickupPassengerFromLocation() {
        
        var BookingInfo = NSDictionary()
        
        if let aryPsgData = self.aryPassengerData as? NSArray {
            if let psgData = aryPsgData.firstObject as? NSDictionary {
                
                let bInfo = psgData.object(forKey: "BookingInfo") as? NSDictionary
                
                if bInfo == nil {
                    // print ("Yes its  array ")
                    
                    if let aryBInfo = psgData.object(forKey: "BookingInfo") as? NSArray {
                        if let firstObjDict = aryBInfo.firstObject as? NSDictionary {
                            BookingInfo = firstObjDict
                        }
                        else {
                            return
                        }
                    }
                    else {
                        return
                    }
                }
                else {
                    // print (Yes its dictionary")
                    
                    let bInfo = psgData.object(forKey: "BookingInfo") as? NSDictionary
                    
                    if bInfo != nil {
                        BookingInfo = psgData.object(forKey: "BookingInfo") as! NSDictionary
                    }
                    else {
                        return
                    }
                }
                
                // ------------------------------------------------------------
                
                //        SingletonsForMeter.sharedInstance.vehicleModelID = (Int(BookingInfo.object(forKey: "ModelId") as! NSNumber))
                
                var VehicleID = String()
                
                if let vehId = BookingInfo.object(forKey: "ModelId") as? String {
                    VehicleID = vehId
                }
                else if let vehId = BookingInfo.object(forKey: "ModelId") as? Int {
                    VehicleID = "\(vehId)"
                }
                
                SingletonsForMeter.sharedInstance.vehicleModelID = Int(VehicleID)!
                
                let DropOffLat = BookingInfo.object(forKey: "PickupLat") as! String
                let DropOffLon = BookingInfo.object(forKey: "PickupLng") as! String
                
                Singletons.sharedInstance.startedTripLatitude = Double(BookingInfo.object(forKey: "PickupLat") as! String)!
                Singletons.sharedInstance.startedTripLongitude = Double(BookingInfo.object(forKey: "PickupLng") as! String)!
                
//                self.lblLocationOnMap.text = BookingInfo.object(forKey: "DropoffLocation") as? String
                
                let PickupLat = self.defaultLocation.coordinate.latitude
                let PickupLng = self.defaultLocation.coordinate.longitude
                
                let dummyLatitude = Double(PickupLat) - Double(DropOffLat)!
                let dummyLongitude = Double(PickupLng) - Double(DropOffLon)!
                
                let waypointLatitude = self.defaultLocation.coordinate.latitude - dummyLatitude
                let waypointSetLongitude = self.defaultLocation.coordinate.longitude - dummyLongitude
                
                
                let originalLoc: String = "\(PickupLat),\(PickupLng)"
                let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
                
                
                // To Find Distance from Driver to Passenger
                let coordinate0 = CLLocation(latitude: PickupLat, longitude: PickupLng)
                let coordinate1 = CLLocation(latitude: Double(DropOffLat)!, longitude: Double(DropOffLon)!)
                let distanceInMeters = coordinate0.distance(from: coordinate1)
                let perfectDistance = (distanceInMeters/1000).rounded(toPlaces: 2)
                self.driverMarker.title = "Distance: \(perfectDistance) M"
                if distanceInMeters > 999 {
                    self.driverMarker.title = "Distance: \(perfectDistance) KM"
                }
                
                //        self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
                //
               
                //self.getPassengerLocationDistance(origin: originalLoc, destination: destiantionLoc, completionHandler: nil) change 25th January
            }
        }
        
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Prepare For Segue
    //-------------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ReceiveRequestViewController {
            destination.delegate = self
        }
        else if let moveToPassenger = segue.destination as? PassengerInfoViewController {
            
            moveToPassenger.strPickupLocation = self.strPickupLocation
            moveToPassenger.strDropoffLocation = self.strDropoffLocation
            
            moveToPassenger.strPassengerName =  self.strPassengerName
            moveToPassenger.strPassengerMobileNumber =  self.strPassengerMobileNo
        }
        else if let moveToTripInfo = segue.destination as? RatingViewController {
            
            moveToTripInfo.delegate = self
            
            let getBookingAndPassengerInfo = self.getBookingAndPassengerInfo(data: self.aryPassengerData)
            
            let PassengerInfo = getBookingAndPassengerInfo.1
            
//            if isAdvanceBooking {
//                if bookingID == "" {
//                     moveToTripInfo.strBookingType = "BookLater"
//                }
//            }
//            else {
//                if advanceBookingID == "" {
//
//                }
//            }
            
            if (Singletons.sharedInstance.oldBookingType.isBookLater || (isAdvanceBooking == true && bookingID == "") ) {
                moveToTripInfo.strBookingType = "BookLater"
            }
            else {
                 moveToTripInfo.strBookingType = "BookNow"
            }
            
            
//           moveToTripInfo.strBookingType = "BookNow"
//            if(isAdvanceBooking)
//            {
//                moveToTripInfo.strBookingType = "BookLater"
//            }
            //
            moveToTripInfo.dictData = self.dictCompleteTripData
            moveToTripInfo.dictPassengerInfo = PassengerInfo
        }
        else if let moveToMeter = segue.destination as? MeterViewController {
            
            moveToMeter.isFromHome = true
        }else if let vwCancelTrip = segue.destination as? CancelRequestReasonViewController {
            vwCancelTrip.delegate = self
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - ARCar Movement Delegate Method
    //-------------------------------------------------------------
    func ARCarMovementMoved(_ Marker: GMSMarker) {
        
        self.driverMarker = nil
        driverMarker = Marker
        driverMarker.map = mapView
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Route on Map Methods
    //-------------------------------------------------------------
    
    func getDirectionsSeconMethod(origin: String!, destination: String!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?) {
        
        UtilityClass.hideACProgressHUD()
        mapView.clear()
        DispatchQueue.main.async {
            UtilityClass.showACProgressHUD()
            print("Function: \(#function), line: \(#line)")
            
        }
        
        //        UtilityClass.showAlert(appName.kAPPName, message: "Map View Called", vc: self)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" +  getGoogleApiKey(functionName: "\(#function)", URL: "", LineNumber: "\(#line)")

                    print ("directionsURLString: \(directionsURLString)")
                    //                    directionsURLString = directionsURLString.addingPercentEscapes(using: String.Encoding.utf8)!
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    let directionsURL = NSURL(string: directionsURLString)
                    DispatchQueue.main.async( execute: { () -> Void in
                        let directionsData = NSData(contentsOf: directionsURL! as URL)
                        
                        if directionsData == nil {
                            self.pickupPassengerFromLocation()
                        }
                        
                        do{
                            let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                            
                            let status = dictionary["status"] as! String
                            
                            if status == "OK" {
                                self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                                
                                let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                
                                let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                
                                let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                
                                let originAddress = legs[0]["start_address"] as! String
                                let destinationAddress = legs[legs.count - 1]["end_address"] as! String
                                
                                //                                print ("getDirectionsSeconMethod")
                                
                                if(Singletons.sharedInstance.isRequestAccepted)
                                {
                                    
                                    if(self.driverMarker == nil)
                                    {
                                        
                                        self.driverMarker = GMSMarker(position: self.originCoordinate)
                                        //                                    self.driverMarker.position = self.originCoordinate
                                        self.driverMarker.icon = UIImage(named: Singletons.sharedInstance.strSetCar)
                                        self.driverMarker.map = self.mapView
                                        
                                    }
                                    
                                }
                                else
                                {
                                    let originMarker = GMSMarker(position: self.originCoordinate)
                                    originMarker.map = self.mapView
                                    originMarker.icon = UIImage(named: Singletons.sharedInstance.strSetCar)
                                    originMarker.title = originAddress
                                }
                                
                                let destinationMarker = GMSMarker(position: self.destinationCoordinate)
                                destinationMarker.map = self.mapView
                                destinationMarker.icon = UIImage(named: "flag")
//                                destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red) //MY change
                                destinationMarker.title = destinationAddress
                                
                                var aryDistance = [Double]()
                                var finalDistance = Double()
                                
                                for i in 0..<legs.count
                                {
                                    let legsData = legs[i]
                                    let distanceKey = legsData["distance"] as! Dictionary<String, AnyObject>
                                    let distance = distanceKey["text"] as! String
                                    let stringDistance = distance.components(separatedBy: " ")
                                    
                                    //                                    print("stringDistance : \(stringDistance)")
                                    
                                    if stringDistance[1] == "m" {
                                        finalDistance += Double(stringDistance[0])! / 1000
                                    }
                                    else {
                                        finalDistance += Double(stringDistance[0].replacingOccurrences(of: ",", with: ""))!
                                    }
                                    aryDistance.append(finalDistance)
                                }
                                
                                
                                print("aryDistance : \(aryDistance)")
                                
                                if finalDistance == 0 {
                                    //                                    UtilityClass.showAlert(appName.kAPPName, message: "Distance is 0 by not countable distance", vc: self)
                                    
                                }
                                else {
                                    //                                    self.sumOfFinalDistance = finalDistance
                                }
                                
                                let route = self.overviewPolyline["points"] as! String
                                self.arrivedRoutePath = GMSPath(fromEncodedPath: route)!
                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                let routePolyline = GMSPolyline(path: path)
                                routePolyline.map = self.mapView
                                routePolyline.strokeColor = UIColor.init(red: 44, green: 134, blue: 200, alpha: 1.0)
                                routePolyline.strokeWidth = 3.0
                                //                                UtilityClass.hideACProgressHUD()
                                
                            }
                            else {
                                DispatchQueue.main.async {
                                    UtilityClass.hideACProgressHUD()
                                    print("Function: \(#function), line: \(#line)")
                                    
                                }
                                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: {
                                    
                                    //                                    UtilityClass.showAlert(appName.kAPPName, message: "Not able to get location due to free api key please restart app", vc: self)
                                })
                                
                                
//                                self.pickupPassengerFromLocation() // RJ Change 10 Dec
                                // UtilityClass.showAlert(appName.kAPPName, message: "OVER_QUERY_LIMIT", vc: self)
                                print("OVER_QUERY_LIMIT")
                                
                                
                                
                                //completionHandler(status: status, success: false)
                            }
                        }
                        catch {
                            print("Catch Not able to get location due to free api key please restart app")
                            //                            UtilityClass.showAlert(appName.kAPPName, message: "Not able to get location due to free api key please restart app", vc: self)
                            // completionHandler(status: "", success: false)
//                            self.pickupPassengerFromLocation() // RJ Change 10 Dec
                            DispatchQueue.main.async {
                                UtilityClass.hideACProgressHUD()
                                print("Function: \(#function), line: \(#line)")
                                
                            }
                        }
                        
                        DispatchQueue.main.async {
                            UtilityClass.hideACProgressHUD()
                            print("Function: \(#function), line: \(#line)")
                            
                        }
                        
                    })
                }
                else {
                    print  ("Destination is nil.")
                    UtilityClass.showAlert(appName.kAPPName, message: "Destination is nil.", vc: self)
                    DispatchQueue.main.async {
                        UtilityClass.hideACProgressHUD()
                        print("Function: \(#function), line: \(#line)")
                        
                    }
                    //completionHandler(status: "Destination is nil.", success: false)
                }
            }
            else {
                print  ("Origin is nil")
                UtilityClass.showAlert(appName.kAPPName, message: "Origin is nil.", vc: self)
                DispatchQueue.main.async {
                    UtilityClass.hideACProgressHUD()
                    print("Function: \(#function), line: \(#line)")
                    
                }
                //completionHandler(status: "Origin is nil", success: false)
            }
            
        }
        
    }
    
    func getDirectionsCompleteTripInfo(origin: String!, destination: String!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?) {
        
        
        DispatchQueue.main.async {
            UtilityClass.showACProgressHUD()
            print("Function: \(#function), line: \(#line)")
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" +  getGoogleApiKey(functionName: "\(#function)", URL: "", LineNumber: "\(#line)")

                    
                    
                                        print ("directionsURLString: \(directionsURLString)")
                    //                    directionsURLString = directionsURLString.addingPercentEscapes(using: String.Encoding.utf8)!
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    let directionsURL = NSURL(string: directionsURLString)
                    DispatchQueue.main.async( execute: { () -> Void in
                        let directionsData = NSData(contentsOf: directionsURL! as URL)
                        
                        if directionsURL != nil {
                            
                            do{
                                let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                                
                                let status = dictionary["status"] as! String
                                
                                if status == "OK" {
                                    self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                    self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                                    
                                    let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                    
                                    let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                    self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                    
                                    let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                    self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                    
                                    //                                print ("getDirectionsSeconMethod")
                                    
                                    var aryDistance = [String]()
                                    var finalDistance = Double()
                                    
                                    for i in 0..<legs.count
                                    {
                                        let legsData = legs[i]
                                        let distanceKey = legsData["distance"] as! Dictionary<String, AnyObject>
                                        let distance = distanceKey["text"] as! String
                                        let stringDistance = distance.components(separatedBy: " ")
                                        
                                        if stringDistance[1] == "m" {
                                            finalDistance += Double(stringDistance[0])! / 1000
                                        }
                                        else {
                                            finalDistance += Double(stringDistance[0].replacingOccurrences(of: ",", with: ""))!
                                        }
                                        aryDistance.append(distance)
                                    }
                                    
                                    if finalDistance == 0 {
                                        UtilityClass.showAlert(appName.kAPPName, message: "Distance is 0 by not countable distance", vc: self)
                                        
                                    }
                                    else {
                                        self.sumOfFinalDistance = finalDistance
                                        DispatchQueue.main.async {
                                            //                                        UtilityClass.hideACProgressHUD()
                                            self.completeTripFinalSubmit()
                                            
                                            print("Function: \(#function), line: \(#line)")
                                            
                                        }
                                        
                                    }
                                    
                                }
                                else {
                                    
                                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: {
                                        
                                        //                                    UtilityClass.showAlert(appName.kAPPName, message: "Not able to get location due to free api key please restart app", vc: self)
                                        DispatchQueue.main.async {
                                            UtilityClass.hideACProgressHUD()
                                            print("Function: \(#function), line: \(#line)")
                                            
                                        }
                                    })
                                    
                                    //
                                    //                                UtilityClass.showAlert(appName.kAPPName, message: "OVER_QUERY_LIMIT", vc: self)
                                    print("Function: \(#function), line: \(#line) OVER_QUERY_LIMIT")
//                                    self.pickupPassengerFromLocation() // My Change 10 dec
                                    DispatchQueue.main.async {
                                        UtilityClass.hideACProgressHUD()
                                        print("Function: \(#function), line: \(#line)")
                                        
                                    }
                                    
                                }
                            }
                            catch {
                                //                            print("Catch Not able to get location due to free api key please restart app")
                                //                            UtilityClass.showAlert(appName.kAPPName, message: "Not able to get location due to free api key please restart app", vc: self)
                                print("Function: \(#function), line: \(#line) Not able to get location due to free api key please restart app")
//                                self.pickupPassengerFromLocation() // My Change 10 dec
                                
                            }
                        }
                        
                    })
                }
                else {
                    print  ("Destination is nil.")
                    UtilityClass.showAlert(appName.kAPPName, message: "Destination is nil.", vc: self)
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            UtilityClass.hideACProgressHUD()
                            print("Function: \(#function), line: \(#line)")
                            
                        }
                        print("Function: \(#function), line: \(#line)")
                        
                    }
                }
            }
            else {
                print  ("Origin is nil")
                UtilityClass.showAlert(appName.kAPPName, message: "Origin is nil.", vc: self)
                DispatchQueue.main.async {
                    UtilityClass.hideACProgressHUD()
                    print("Function: \(#function), line: \(#line)")
                    
                }
            }
        }
    }
    
    /// Get Passenger Location Distance
    func getPassengerLocationDistance(origin: String!, destination: String!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?) {
      
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" +  getGoogleApiKey(functionName: "\(#function)", URL: "", LineNumber: "\(#line)")

                    print ("directionsURLString: \(directionsURLString)")
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    let directionsURL = NSURL(string: directionsURLString)
                    DispatchQueue.main.async( execute: { () -> Void in
                        let directionsData = NSData(contentsOf: directionsURL! as URL)
                        
                        if directionsData != nil {
                            do{
                                let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                                
                                let status = dictionary["status"] as! String
                                
                                if status == "OK" {
                                    self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                    self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                                    
                                    let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                    
                                    let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                    self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                    
                                    let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                    self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                    
                                    var aryDistance = [Double]()
                                    var finalDistance = Double()
                                    
                                    for i in 0..<legs.count
                                    {
                                        let legsData = legs[i]
                                        let distanceKey = legsData["distance"] as! Dictionary<String, AnyObject>
                                        let distance = distanceKey["text"] as! String
                                        let stringDistance = distance.components(separatedBy: " ")
                                        
                                        if stringDistance[1] == "m" {
                                            finalDistance += Double(stringDistance[0])! / 1000
                                        }
                                        else {
                                            finalDistance += Double(stringDistance[0].replacingOccurrences(of: ",", with: ""))!
                                        }
                                        aryDistance.append(finalDistance)
                                    }
                                    
                                    if aryDistance.count != 0 {
                                        
                                        if self.driverMarker != nil {
                                            if aryDistance.count == 1 {
                                                self.driverMarker.title = "Distance: \(aryDistance.first!) M"
                                            }
                                            else if aryDistance.reduce(0,+) <= 1 {
                                                self.driverMarker.title = "Distance: \(aryDistance.reduce(0,+)) M"
                                            } else {
                                                self.driverMarker.title = "Distance: \(aryDistance.reduce(0,+)) KM"
                                            }
                                        }
                                    }
                                }
                                else {
                                    
//                                    self.getDistanceForPickupPassengerFromLocation()
                                    //                            self.getPassengerLocationDistance(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
                                    
                                }
                            }
                            catch {
//                                self.getDistanceForPickupPassengerFromLocation()
                                //                          self.getPassengerLocationDistance(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
                                
                            }
                        }
                        
                        
                    })
                }
                else {
                    print  ("Destination is nil.")
//                    self.getDistanceForPickupPassengerFromLocation() // Bhavesh
//                self.getPassengerLocationDistance(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
                }
            }
            else {
                print  ("Origin is nil")
//                self.getDistanceForPickupPassengerFromLocation() // Bhavesh
//                self.getPassengerLocationDistance(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
            }
        }
    }
    
    // ----------------------------------------------------------------------
    //-------------------------------------------------------------
    // MARK: - Set Car
    //-------------------------------------------------------------
    
    
    func setCar()
    {
        let profile: NSMutableDictionary = NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as? NSDictionary)!)
        let Vehicle: NSMutableDictionary = NSMutableDictionary(dictionary: profile.object(forKey: "Vehicle") as! NSDictionary)
        let VehicleName = Vehicle.object(forKey: "VehicleClass") as! String
        
        if VehicleName.range(of:"First Class") != nil
        {
            print("First Class")
            //Singletons.sharedInstance.strSetCar = "imgFirstClass"
        }
        else if (VehicleName.range(of:"Business Class") != nil) {
            print("First Class")
            // Singletons.sharedInstance.strSetCar = "imgBusinessClass"
            
        }
        else if (VehicleName.range(of:"Economy") != nil) {
            print("First Class")
            // Singletons.sharedInstance.strSetCar = "imgEconomy"
            
        }
        else if (VehicleName.range(of:"Taxi") != nil) {
            print("First Class")
            // Singletons.sharedInstance.strSetCar = "imgTaxi"
            
        }
        else if (VehicleName.range(of:"LUX-VAN") != nil) {
            print("First Class")
            // Singletons.sharedInstance.strSetCar = "imgLUXVAN"
            
        }
        else if (VehicleName.range(of:"Disability") != nil) {
            print("First Class")
            //Singletons.sharedInstance.strSetCar = "imgDisability"
            
        }
        Singletons.sharedInstance.strSetCar = "iconCar"
        
        print(VehicleName)
    }
    
    func markerCarIconName(modelId: Int) -> String {
        
        var CarModel = String()
        
        switch modelId {
        case 1:
            CarModel = "iconCar"
            return CarModel
        case 2:
            CarModel = "iconCar"
            return CarModel
        case 3:
            CarModel = "iconCar"
            return CarModel
        case 4:
            CarModel = "iconCar"
            return CarModel
        case 5:
            CarModel = "iconCar"
            return CarModel
        case 6:
            CarModel = "iconCar"
            return CarModel
        default:
            CarModel = Singletons.sharedInstance.strSetCar
            return CarModel
        }
        
    }
    
    func didRatingIsSubmitSuccessfully() {
        
        if driverID != "" {
            UpdateDriverLocation()
        }
        
        if (Singletons.sharedInstance.isPending == 1) {
            webserviceOfCurrentBooking()
        }
        
        Singletons.sharedInstance.bookingIdTemp = ""
        Singletons.sharedInstance.advanceBookingIdTemp = ""
        Singletons.sharedInstance.bookingId = ""
        Singletons.sharedInstance.advanceBookingId = ""
        if self.driverMarker != nil {
            self.driverMarker.title = ""
        }
        bookingID = ""
        advanceBookingID = ""
        self.aryPassengerData = NSArray()
        self.aryCurrentBookingData = NSMutableArray()
        
        
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Setup Current Location
    //-------------------------------------------------------------
    
    let baseUrlForGetAddress = "https://maps.googleapis.com/maps/api/geocode/json?"
//    let apikey = googlPlacesApiKey
    
    
    func getAddressForLatLng(latitude: String, longitude: String) {
        
       
        let url = NSURL(string: "\(baseUrlForGetAddress)latlng=\(latitude),\(longitude)&key=\(getGoogleApiKey(functionName: "\(#function)", URL: "", LineNumber: "\(#line)"))")
        do {
            let data = NSData(contentsOf: url! as URL)
            if data != nil {
                if let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                    if let result = json["results"] as? [[String:AnyObject]] {
                        if result.count > 0 {
                            DispatchQueue.main.async(execute: {
                                
                                if let resString = result[0]["formatted_address"] as? String {
                                    
                                    self.lblLocationOnMap.text = resString
//                                    self.strPickupLocation = resString
//                                    btnDoneForLocationSelected.isHidden = false
                                    
                                }
                                else if let address = result[0]["address_components"] as? [[String:AnyObject]] {
                                    
                                    if address.count > 1 {
                                        
                                        var streetNumber = String()
                                        var streetStreet = String()
                                        var streetCity = String()
                                        var streetState = String()
                                        
                                        for i in 0..<address.count {
                                            
                                            if i == 0 {
                                                if let number = address[i]["short_name"] as? String {
                                                    streetNumber = number
                                                }
                                            }
                                            else if i == 1 {
                                                if let street = address[i]["short_name"] as? String {
                                                    streetStreet = street
                                                }
                                            }
                                            else if i == 2 {
                                                if let city = address[i]["short_name"] as? String {
                                                    streetCity = city
                                                }
                                            }
                                            else if i == 3 {
                                                if let state = address[i]["short_name"] as? String {
                                                    streetState = state
                                                }
                                            }
                                            else if i == 4 {
                                                if let city = address[i]["short_name"] as? String {
                                                    streetCity = city
                                                }
                                            }
                                        }
                                        
                                        print("\n\(streetNumber) \(streetStreet), \(streetCity), \(streetState)")
                                        
                                        self.lblLocationOnMap.text = "\(streetNumber) \(streetStreet), \(streetCity), \(streetState)"
                                        
                                    }
                                }
                                
                            })
                            
                        }
                    }
                }

            }
        }
        catch {
            print("Not Geting Address")
        }
    }
    
    
    var dictCurrentBookingInfoData = NSDictionary()
    var dictCurrentPassengerInfoData = NSDictionary()
    var aryCurrentBookingData = NSMutableArray()
    
    var checkBookingType = String()
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Check Current Booking
    //-------------------------------------------------------------
    func webserviceOfCurrentBooking() {
        
        if let Token = UserDefaults.standard.object(forKey: "Token") as? String {
            Singletons.sharedInstance.deviceToken = Token
        }
        
        if self.driverID != "" && self.defaultLocation.coordinate.latitude != 0 && self.defaultLocation.coordinate.longitude != 0 {
            self.UpdateDriverLocation()
        }
        
        let param = Singletons.sharedInstance.strDriverID + "/" + Singletons.sharedInstance.deviceToken
        
        webserviceForCurrentBooking(param as AnyObject) { (result, status) in
            
            
            if let shareRide = result["rating"] as? String {
                Singletons.sharedInstance.driverAverageRatings = CGFloat(Double(shareRide) ?? 0.0)
            }else if let shareRide = result["rating"] as? Int {
                Singletons.sharedInstance.driverAverageRatings = CGFloat(Double(shareRide))
            }
            
            if let isTimeOut = result["Timeout"] as? Int {
                UserDefaults.standard.set(isTimeOut == 0 ? false : true , forKey: "isTimeOutDriver")
            }
            
            if (status) {
                                
                self.resetMapView()
                
                let resultData = (result as! NSDictionary)
                if let paymentMethod = (resultData["BookingInfo"] as? NSDictionary)?.value(forKey: "PaymentType")  as? String {
                    self.isCashBooking = (paymentMethod == "cash") ? true : false
                 }
                
                if let shareRide = resultData["share_ride"] as? String {
                    if shareRide == "1" {
                        Singletons.sharedInstance.isShareRideOn = true
                    } else {
                        Singletons.sharedInstance.isShareRideOn = false
                    }
                } else if let shareRide = resultData["share_ride"] as? Int {
                    if shareRide == 1 {
                        Singletons.sharedInstance.isShareRideOn = true
                    } else {
                        Singletons.sharedInstance.isShareRideOn = false
                    }
                }
                if let BookingType = resultData["BookingType"] as? String {
                   self.isNowBooking =  (BookingType == "BookNow") ? true : false
                    
                }
                
              
                Singletons.sharedInstance.strCurrentBalance = Double(resultData.object(forKey: "balance") as! String)!
                var rating = String()
                if let ratingTemp = resultData.object(forKey: "rating") as? String
                {
                    if (ratingTemp == "")
                    {
                        rating = "0.0"
                    }
                    else
                    {
                        rating = ratingTemp
                    }
                }
                
                Singletons.sharedInstance.strRating = rating
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("rating"), object: nil)
                
                self.aryCurrentBookingData.removeAllObjects()
                
                self.aryCurrentBookingData.add(resultData)
                
                self.aryPassengerData = self.aryCurrentBookingData
                
                if let loginStatus = (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "login") as? Bool {
                    
                    if (loginStatus) {
                        
                    }
                    else {
                        UtilityClass.showAlertWithCompletion("Multiple login", message: "Please Re-Login", vc: self, completionHandler: { ACTION in
                            
                            self.webserviceOFSignOut()
                        })
                    }
                }
                
                var bookingType = String()
                
                if let strBookingTypeFromCurrentBooking = (result as! NSDictionary).object(forKey: "BookingType") as? String {
                    bookingType = strBookingTypeFromCurrentBooking
                }
                else {
                    bookingType = ""
                }
//                let bookingType = (result as! NSDictionary).object(forKey: "BookingType") as! String // (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "BookingType") as! String
                
                Singletons.sharedInstance.strBookingType = bookingType
                //((self.aryCurrentBookingData.object(at: 0) as! [String: AnyObject])["BookingInfo"] as! [String : AnyObject])["BookingType"]! as! String
                
                if(Singletons.sharedInstance.strBookingType == "")
                {
                    Singletons.sharedInstance.strBookingType = bookingType
                }
                
                self.dictCurrentBookingInfoData = ((resultData).object(forKey: "BookingInfo") as! NSDictionary)
//                if let strCompleted = self.dictCurrentBookingInfoData["Completed"] as? String {
//                    if strCompleted == "1" {
//                        self.callCashJobApi()
//                    }
//                }else {
//                    let strCompleted = self.dictCurrentBookingInfoData["Completed"] as! Int
//                    if strCompleted == 1 {
//                        self.callCashJobApi()
//                    }
//                }
                let statusOfRequest = self.dictCurrentBookingInfoData.object(forKey: "Status") as! String
                
                let PassengerType = self.dictCurrentBookingInfoData.object(forKey: "PassengerType") as? String
                
                if PassengerType == "" || PassengerType == nil{
                    Singletons.sharedInstance.passengerType = ""
                }
                else {
                    Singletons.sharedInstance.passengerType = PassengerType!
                }
                if(self.dictCurrentBookingInfoData.object(forKey: "PaymentType") as! String == "cash")
                {
                    Singletons.sharedInstance.passengerPaymentType = self.dictCurrentBookingInfoData.object(forKey: "PaymentType") as! String
                }
                
                // ----------------------------------------------------------
                // For cancel trip action timer
                // ----------------------------------------------------------
               
                
                if let ArrivalTimeDifferenceResult = (resultData).object(forKey: "ArrivalTimeDifference") as? String {
                    
                    let timeInSeconds = Int(ArrivalTimeDifferenceResult)
                    
                    if (timeInSeconds != 0) && (timeInSeconds! < self.countDown5Minutes) {
                       
                        self.countDown5Minutes = self.countDown5Minutes - Int(timeInSeconds!)
                        self.timerForCancelTripCountDown = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountDown5Minutes), userInfo: nil, repeats: true)
                        self.lblTimerForCancelTrip.isHidden = false
                        self.btnArrived.isHidden = true
//                        self.btnCancelTrip.isHidden = false
                    }else if let strArrivedTime = ((resultData["BookingInfo"]as! NSDictionary) ["ArrivedTime"] as? String) {
                        if strArrivedTime == "0" {
                            self.btnArrived.isHidden = false
                            
                            
                            let isArrived = UserDefaults.standard.bool(forKey: "isArrived")
                            self.btnArrived.isEnabled = isArrived
                            
                        }
                    }
                    else {
                        self.btnArrived.isHidden = true
                        self.btnStartTrip.isHidden = false
                        self.btnCancelTrip.isHidden = false
                    }
                    
                }
                else if let ArrivalTimeDifferenceResult = (resultData).object(forKey: "ArrivalTimeDifference") as? Int {
                    //changeeee 
                    let timeInSeconds = ArrivalTimeDifferenceResult
                    
                    if (timeInSeconds != 0) && (timeInSeconds < self.countDown5Minutes) {
                        self.countDown5Minutes = self.countDown5Minutes - timeInSeconds
                        self.timerForCancelTripCountDown = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountDown5Minutes), userInfo: nil, repeats: true)
                        self.lblTimerForCancelTrip.isHidden = false
                        self.btnArrived.isHidden = true
//                        self.btnCancelTrip.isHidden = false
                    } else if let strArrivedTime = ((resultData["BookingInfo"]as! NSDictionary) ["ArrivedTime"] as? String) {
                        if strArrivedTime == "0" {
                            self.btnArrived.isHidden = false
                            
                            
                            let isArrived = UserDefaults.standard.bool(forKey: "isArrived")
                            self.btnArrived.isEnabled = isArrived
//                            self.btnArrived.isEnabled = true
                        }else if timeInSeconds > self.countDown5Minutes {
                            self.btnArrived.isHidden = true
                            self.btnStartTrip.isHidden = false
                            self.btnCancelTrip.isHidden = false
                        }
                    }
                    else {
                        self.btnArrived.isHidden = true
                        self.btnStartTrip.isHidden = false
                        self.btnCancelTrip.isHidden = false
                    }
                }
/*
                let bInfo = (resultData).object(forKey: "BookingInfo") as! NSDictionary
                 
                let ArrivedTime = bInfo.object(forKey: "ArrivedTime") as? String
                
                let currentTimeStemp = Date().timeIntervalSince1970
                let arrivalTimeStemp = self.parseDuration(ArrivedTime ?? "0")
            
                let differenceBetweenTimeStemp = currentTimeStemp - arrivalTimeStemp
                
                print(differenceBetweenTimeStemp)
                
                let converttoTime = Date(timeIntervalSince1970: TimeInterval(differenceBetweenTimeStemp))
                
                let formatter = DateFormatter()
                
                formatter.timeZone = TimeZone.current
                
                formatter.dateFormat = "HH:mm:ss"
                
                let dateString = formatter.string(from: converttoTime)
                
                let secondsOfDefference = String().secondsFromString(string: dateString)
                
                if differenceBetweenTimeStemp != 0 {
                    
                    if Singletons.sharedInstance.intArrivalTimeInSeconds > Int(differenceBetweenTimeStemp) {
                        self.countDown5Minutes = Int(differenceBetweenTimeStemp)
                        self.timerForCancelTripCountDown = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountDown5Minutes), userInfo: nil, repeats: true)
                        self.lblTimerForCancelTrip.isHidden = false
                        self.btnArrived.isHidden = true
                        self.btnCancelTrip.isHidden = false
                    }
                    else {
                        self.btnArrived.isHidden = true
                        self.btnStartTrip.isHidden = false
                        self.btnCancelTrip.isHidden = false
                        
                    }
                    
                }
                
//                self.countDown5Minutes = Int(ArrivedTime ?? "0") ?? 0
                
                // ----------------------------------------------------------

  */
                DispatchQueue.main.async {
                    UtilityClass.showHUD()
                    
                }
                
                
                if bookingType != "" {
                    Singletons.sharedInstance.isBookNowOrBookLater = true
                    
                    if bookingType == "BookNow"
                    {
                        if statusOfRequest == "accepted"
                        {
                            
                            self.bookingID = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.driverID = Singletons.sharedInstance.strDriverID
                            Singletons.sharedInstance.isRequestAccepted = true
                            
                            Singletons.sharedInstance.isPickUPPasenger = false
                            
                            self.bookingTypeIsBookNow()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            self.timerForCancelTripCountDown?.invalidate()
                            self.lblTimerForCancelTrip.isHidden = true
                            self.btnArrived.isHidden = true
                            self.btnCancelTrip.isHidden = false
                            
                            self.bookingID = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.driverID = Singletons.sharedInstance.strDriverID
                            
                            Singletons.sharedInstance.isPickUPPasenger = true
                            
                            self.btnStartTripAction()
                        }
                        
                        Singletons.sharedInstance.bookingId = self.bookingID
                        
                        if (Singletons.sharedInstance.oldBookingType.isBookLater) {
                            Singletons.sharedInstance.oldBookingType.isBookNow = false
                        }
                        else {
                            Singletons.sharedInstance.oldBookingType.isBookNow = true
                        }
                    }
                    else if bookingType == "BookLater" {
                        
                        self.isAdvanceBooking = true
                        
                        if statusOfRequest == "accepted" {
                            
                            self.advanceBookingID = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.driverID = Singletons.sharedInstance.strDriverID
                            Singletons.sharedInstance.isRequestAccepted = true

                            Singletons.sharedInstance.isPickUPPasenger = false
                            
                            self.bookingtypeBookLater()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            
                            self.timerForCancelTripCountDown?.invalidate()
                            self.lblTimerForCancelTrip.isHidden = true
                            
                            self.btnArrived.isHidden = true
                            self.btnCancelTrip.isHidden = false
                            
                            self.advanceBookingID = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.driverID = Singletons.sharedInstance.strDriverID
                            
                            Singletons.sharedInstance.isPickUPPasenger = true
                            
                            self.btnStartTripAction()
                        }
                        
                        if (Singletons.sharedInstance.oldBookingType.isBookNow) {
                            Singletons.sharedInstance.oldBookingType.isBookLater = false
                        }
                        else {
                            Singletons.sharedInstance.oldBookingType.isBookLater = true
                        }
                    }
                }
                self.webserviceOFGetAllCards()
            }
            else
            {
                
                if let res = result as? String
                {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else if result is NSDictionary
                {
                    let resultData = (result as! NSDictionary)
                    Singletons.sharedInstance.dictTripDestinationLocation["location"] = resultData["location"] as AnyObject
                    Singletons.sharedInstance.dictTripDestinationLocation["trip_to_destin"] = resultData["trip_to_destin"] as AnyObject
                    
                    Singletons.sharedInstance.strCurrentBalance = Double(resultData.object(forKey: "balance") as! String)!
                    
                    if let shareRide = resultData["share_ride"] as? String {
                        if shareRide == "1" {
                            Singletons.sharedInstance.isShareRideOn = true
                        } else {
                            Singletons.sharedInstance.isShareRideOn = false
                        }
                    } else if let shareRide = resultData["share_ride"] as? Int {
                        if shareRide == 1 {
                            Singletons.sharedInstance.isShareRideOn = true
                        } else {
                            Singletons.sharedInstance.isShareRideOn = false
                        }
                    }
                    if let isTimeOut = resultData["Timeout"] as? Int {
                        if isTimeOut == 1 {
                            self.SwitchOFFClicked()
                        }
                    }
                    
                    var rating = String()
                    if let ratingTemp = resultData.object(forKey: "rating") as? String
                    {
                        if (ratingTemp == "")
                        {
                            rating = "0.0"
                        }
                        else
                        {
                            rating = ratingTemp
                        }
                    }
                    
                    Singletons.sharedInstance.strRating = rating
                    let nc = NotificationCenter.default
                    nc.post(name: Notification.Name("rating"), object: nil)
                    self.aryCurrentBookingData.add(resultData)
                    
                    self.aryPassengerData = self.aryCurrentBookingData
                    
                    if let loginStatus = (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "login") as? Bool {
                        
                        if (loginStatus) {
                            
                        }
                        else {
                            UtilityClass.showAlertWithCompletion("Multiple login", message: "Please Re-Login", vc: self, completionHandler: { ACTION in
                                
                                self.webserviceOFSignOut()
                            })
                        }
                    }
                    
                    self.webserviceOFGetAllCards()
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
                
            }
            
        }
        
    }
    
    func parseDuration(_ timeString:String) -> TimeInterval {
        guard !timeString.isEmpty else {
            return 0
        }
        
        var interval:Double = 0
        
        let parts = timeString.components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }
        
        return interval
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Completeing Current Booking
    //-------------------------------------------------------------
    
    func webserviceCallForCompleteTrip(dictOFParam : AnyObject)
    {
        webserviceForCompletedTripSuccessfully(dictOFParam as AnyObject) { (result, status) in
            self.vwMyJobs.isHidden = true // false
            if (status) {
                
//                if let isTimeOutDriver = UserDefaults.standard.value(forKey: "isTimeOutDriver") {
//                    self.SwitchOFFClicked()
//                }
                print(result)
                self.dictCompleteTripData = (result as! NSDictionary)
                
                self.resetMapView()
                
              
                self.btnArrived.isEnabled = false
                self.isArrivedDriver = false
                self.btnArrived.isHidden = false
                self.btnStartTrip.isHidden = true
                
                self.btnCancelTrip.isEnabled = false
                self.btnCancelTrip.isHidden = true
//                ((result as! [String:Any])["details"] as! [String:Any])["GrandTotal"] as! String
                
                Singletons.sharedInstance.isRequestAccepted = false
                Singletons.sharedInstance.isTripContinue = false
                Singletons.sharedInstance.bookingIdTemp = ""
                Singletons.sharedInstance.advanceBookingIdTemp = ""
                
                if let paymentType = (self.dictCompleteTripData.object(forKey: "details") as! NSDictionary).object(forKey: "PaymentType") as? String {
                    Singletons.sharedInstance.passengerPaymentType = paymentType
                }
                
                if Singletons.sharedInstance.passengerPaymentType == "cash" || Singletons.sharedInstance.passengerPaymentType == "Cash" {
                    
                    var GrandTotal = String()
                    var fareAmount = ""
                    var strDamageCharge = ""
                    if let res = result as? [String:Any] {
                        
                        if let details = res["details"] as? [String:Any] {
                            if let strGrandTotal = details["GrandTotal"] as? String {
                                GrandTotal =  String(format: "%.2f",Double(strGrandTotal) ?? 0.00)
                            }
                            if let strFareAmount = details["SubTotal"] as? String {
                                fareAmount =  String(format: "%.2f",Double(strFareAmount) ?? 0.00)
                            }
                            if let damageCharge = details["SoilDamageCharge"] as? String {
                                strDamageCharge = String(format: "%.2f",Double(damageCharge) ?? 0.00)
                            }
                        }
                    }
                    
                    self.playSound(strName: "\(RingToneSound)")
                    
                    let damageCharge = (strDamageCharge == "0.00") ? "" : "\n \n DAMAGE CHARGE: \(currency) \(strDamageCharge)"
                    var strAlertMessage = ""
                    if let payment_message = result["payment_message"] as? String {
                        strAlertMessage = "Warning \n \n" + payment_message + "\n \n Fare Amount: \(currency) \(fareAmount)" + damageCharge + "\n \n Total Fare: \(currency) \(GrandTotal)"
                    }else {
                        strAlertMessage = "Alert! This is a cash job \n \n Please Collect Money From Passenger. \n \n Fare Amount: \(currency) \(fareAmount)" + damageCharge + "\n \n Total Fare: \(currency) \(GrandTotal)"

                    }
//                    let strAlertMessage = "Alert! This is a cash job \n \n Please Collect Money From Passenger. \n \n FARE AMOUNT: \(currency) \(fareAmount) \n \n DAMAGE CHARGE: \(currency) \(strDamageCharge) \n \n Total Fare: \(currency) \(GrandTotal)"
                    
                    let alert = UIAlertController.init(title: strAlertMessage , message: nil, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Paid", style: .default, handler: { (action) in
                        self.callCashApi(true)
                        
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Not Paid", style: .default, handler: { (action) in
                        self.callCashApi(false)
                        
                    }))
                    //  Alert View is dismiss automatically so Code change
                    
                    //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
//                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
//                    alertWindow.rootViewController = UIViewController()
//                    alertWindow.windowLevel = UIWindowLevelAlert + 1
//                    alertWindow.makeKeyAndVisible()
//                    alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                    /*
                    //My change
                    UtilityClass.showPaidAlertWithCompletion("Alert! This is a cash job", message: "Please Collect Money From Passenger (\(currency) \(GrandTotal))", vc: self, completionHandler: { ACTION in
                        
                        DispatchQueue.main.async {
                            self.stopSound()
                        }
                        
                        
                        //                        self.completeTripButtonAction()
                        
                        UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
                        UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
                        
                        var dict = [String:AnyObject]()
                        dict["BookingId"] =  self.bookingID as AnyObject
                        dict["BookingType"] = (self.isNowBooking) ? "BookNow" as AnyObject : "BookLater"  as AnyObject
                        
                        //MARK: Paid Cash Payment Service Implement
                        webserviceForPaidCashPayment(dict as AnyObject, completion: { (result, status) in
                            if status {
                                DispatchQueue.main.async {
                                    
                                    self.setCarAfterTrip()
                                    self.completeTripInfo()
                                }
                            }
                        })
                    })
                     
                    */
                    
                    
//                    self.callCashJobApi()
                   
                }
                else
                {
                    
                    let paymentStatus = self.checkDictionaryHaveValue(dictData: self.dictCompleteTripData as! [String : AnyObject], didHaveValue: "payment_status", isNotHave: "")
                    let paymentMessage = self.checkDictionaryHaveValue(dictData: self.dictCompleteTripData as! [String : AnyObject], didHaveValue: "payment_message", isNotHave: "")
                    
                        print("paymentStatus: \(paymentStatus)")
                        print("paymentMessage: \(paymentMessage)")
                    
                    if paymentStatus != "" {
                        
                        if paymentStatus == "1" {
                            
//                            let alert = UIAlertController(title: "Alert", message: paymentMessage, preferredStyle: .alert)
//                            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
//                            let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//                            alert.addAction(OK)
//                            alert.addAction(Cancel)
//                            self.present(alert, animated: true, completion: nil)
                            
                            let alert = UIAlertController(title: "Warning!", message: paymentMessage, preferredStyle: UIAlertControllerStyle.alert)
                            
                            alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
                            
                            alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedMessage")
                            
                            //        alert.setValuesForKeys([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue).rawValue: UIColor.red])
                            
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { ACTION in
                                DispatchQueue.main.async {
                                    self.setCarAfterTrip()
                                    self.completeTripInfo()
                                }
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                            
                            
//                            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
                        } else {
                            DispatchQueue.main.async {
                                self.setCarAfterTrip()
                                self.completeTripInfo()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.setCarAfterTrip()
                            self.completeTripInfo()
                        }
                    }
                    if let isTimeOutDriver = UserDefaults.standard.value(forKey: "isTimeOutDriver") as? Int {
                        if isTimeOutDriver == 1 {
                            self.SwitchOFFClicked()
                        }
                    }
                }
            }
            else {
                UtilityClass.showAlertWithCompletion(appName.kAPPName, message: "Please complete trip again", vc: self, completionHandler: { (status) in
                    self.webserviceOfCurrentBooking()
                })
                
//                if let res: String = result as? String {
//                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
//                }
//                else if let resDict = result as? NSDictionary {
//
//                    if let msgIsArray = resDict.object(forKey: "message") as? NSArray {
//                        UtilityClass.showAlert(appName.kAPPName, message: msgIsArray.firstObject as! String, vc: self)
//                    } else {
//                        UtilityClass.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
//                    }
//
//
//                }
//                else if let resAry = result as? NSArray {
//                    UtilityClass.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
//                }
                
            }
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Cash Job
    //-------------------------------------------------------------
    func callCashApi(_ isPaid: Bool) {
        DispatchQueue.main.async {
            self.stopSound()
        }
        
        
        //                        self.completeTripButtonAction()
        
        UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
        UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
        
        var dict = [String:AnyObject]()
        dict["BookingId"] =  self.bookingID as AnyObject
        dict["BookingType"] = (self.isNowBooking) ? "BookNow" as AnyObject : "BookLater"  as AnyObject
        dict["Paid"] = isPaid ? "1" as AnyObject : "0" as AnyObject
        //MARK: Paid Cash Payment Service Implement
        webserviceForPaidCashPayment(dict as AnyObject, completion: { (result, status) in
            if status {
                print("===cash apissssss response.=== \(result)")
                if !isPaid {
                    self.dictCompleteTripData = (result as! NSDictionary)
                }
                if let isTimeOutDriver = UserDefaults.standard.value(forKey: "isTimeOutDriver") as? Int {
                    if isTimeOutDriver == 1 {
                        self.SwitchOFFClicked()
                    }
                }
                DispatchQueue.main.async {
                    
                    self.setCarAfterTrip()
                    self.completeTripInfo()
                }
            }
        })
    }
    
    func callCashApiForAdvanceBooking(_ isPaid: Bool) {
        DispatchQueue.main.async {
            self.stopSound()
        }
        
        
        //                        self.completeTripButtonAction()
        
        UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
        UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
        
        var dict = [String:AnyObject]()
        dict["BookingId"] =  self.advanceBookingID as AnyObject
        dict["BookingType"] = "BookLater"  as AnyObject
        dict["Paid"] = isPaid ? "1" as AnyObject : "0" as AnyObject
        //MARK: Paid Cash Payment Service Implement
        webserviceForPaidCashPayment(dict as AnyObject, completion: { (result, status) in
            if status {
                print("===cash apissssss response.=== \(result)")
                if !isPaid {
                    self.dictCompleteTripData = (result as! NSDictionary)
                }
                if let isTimeOutDriver = UserDefaults.standard.value(forKey: "isTimeOutDriver") as? Int {
                    if isTimeOutDriver == 1 {
                        self.SwitchOFFClicked()
                    }
                }
                DispatchQueue.main.async {
                    
                    self.setCarAfterTrip()
                    self.completeTripInfo()
                }
            }
        })
    }
    /*
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Cash Job
    //-------------------------------------------------------------
    
    func callCashJobApi() {
        UtilityClass.showPaidAlertWithCompletion("Alert! This is a cash job", message: "Please Collect Money From Passenger (\(currency) \(50))", vc: self, completionHandler: { ACTION in
            
            DispatchQueue.main.async {
                self.stopSound()
            }
            
            
            //                        self.completeTripButtonAction()
            
            UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
            UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
            
            var dict = [String:AnyObject]()
            dict["BookingId"] =  self.bookingID as AnyObject
            dict["BookingType"] = (self.isNowBooking) ? "BookNow" as AnyObject : "BookLater" as AnyObject
            
            //MARK: Paid Cash Payment Service Implement
            webserviceForPaidCashPayment(dict as AnyObject, completion: { (result, status) in
                if status {
                    DispatchQueue.main.async {
                        
                        self.setCarAfterTrip()
                        self.completeTripInfo()
                    }
                }
            })
        })
    }
    */
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Completeing Advance Booking
    //-------------------------------------------------------------
    
    func webserviceCallForAdvanceCompleteTrip(dictOFParam : AnyObject)
    {
        webserviceForCompletedAdvanceTripSuccessfully(dictOFParam as AnyObject) { (result, status) in
            self.vwMyJobs.isHidden = true // false
            if (status) {
                
//                if let isTimeOutDriver = UserDefaults.standard.value(forKey: "isTimeOutDriver") {
//                    self.SwitchOFFClicked()
//                }
                self.dictCompleteTripData = (result as! NSDictionary)
                
                self.resetMapView()
                
                /////
                self.btnArrived.isEnabled = false
                self.isArrivedDriver = false
                self.btnArrived.isHidden = false
                self.btnStartTrip.isHidden = true
                
                self.btnCancelTrip.isEnabled = false
                self.btnCancelTrip.isHidden = true
                ////
                
                Singletons.sharedInstance.oldBookingType.isBookNow = false
                Singletons.sharedInstance.oldBookingType.isBookLater = false
                
                
                Singletons.sharedInstance.isRequestAccepted = false
                Singletons.sharedInstance.isTripContinue = false
                UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
                UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
                if let paymentType = (self.dictCompleteTripData.object(forKey: "details") as! NSDictionary).object(forKey: "PaymentType") as? String {
                    Singletons.sharedInstance.passengerPaymentType = paymentType
                }
                
                if Singletons.sharedInstance.passengerPaymentType == "cash" || Singletons.sharedInstance.passengerPaymentType == "Cash" {
                    
//                    var GrandTotal = String()
//
//                    if let res = result as? [String:Any] {
//
//                        if let details = res["details"] as? [String:Any] {
//                            if let strGrandTotal = details["GrandTotal"] as? String {
//                                GrandTotal = strGrandTotal
//                            }
//                        }
//                    }
                    
                    var GrandTotal = String()
                    var fareAmount = ""
                    var strDamageCharge = ""
                    if let res = result as? [String:Any] {
                        
                        if let details = res["details"] as? [String:Any] {
                            if let strGrandTotal = details["GrandTotal"] as? String {
                                GrandTotal =  String(format: "%.2f",Double(strGrandTotal) ?? 0.0)
                            }
                            if let strFareAmount = details["SubTotal"] as? String {
                                fareAmount =  String(format: "%.2f",Double(strFareAmount) ?? 0.0)
                            }
                            if let damageCharge = details["SoilDamageCharge"] as? String {
                                strDamageCharge = String(format: "%.2f",Double(damageCharge) ?? 0.0)
                            }
                        }
                    }
                    self.playSound(strName: "\(RingToneSound)")
                    
                    
                    //My change
                    
                    /*
                    UtilityClass.showPaidAlertWithCompletion("Alert! This is a cash job", message: "Please Collect Money From Passenger (\(currency) \(GrandTotal))", vc: self, completionHandler: { ACTION in
                        
                        DispatchQueue.main.async {
                            self.stopSound()
                        }
                        
                        
                        //                        self.completeTripButtonAction()
                        
                        UserDefaults.standard.set(Singletons.sharedInstance.isRequestAccepted, forKey: tripStatus.kisRequestAccepted)
                        UserDefaults.standard.set(Singletons.sharedInstance.isTripContinue, forKey: tripStatus.kisTripContinue)
                        
                        var dict = [String:AnyObject]()
                        dict["BookingId"] =  self.advanceBookingID as AnyObject
                        dict["BookingType"] = (self.isNowBooking) ? "BookNow" as AnyObject : "BookLater"  as AnyObject
                        
                        //MARK: Paid Cash Payment Service Implement
                        webserviceForPaidCashPayment(dict as AnyObject, completion: { (result, status) in
                            if status {
                                DispatchQueue.main.async {
                                    
                                    self.setCarAfterTrip()
                                    self.completeTripInfo()
                                }
                            }
                        })
                    })
                     
                    */
                    let damageCharge = (strDamageCharge == "0.00") ? "" : "\n \n DAMAGE CHARGE: \(currency) \(strDamageCharge)"
                    var strAlertMessage = ""
                    if let payment_message = result["payment_message"] as? String {
                        strAlertMessage = "Warning \n \n" + payment_message + "\n \n Fare Amount: \(currency) \(fareAmount)" + damageCharge + "\n \n Total Fare: \(currency) \(GrandTotal)"
                    }else {
                        strAlertMessage = "Alert! This is a cash job \n \n Please Collect Money From Passenger. \n \n Fare Amount: \(currency) \(fareAmount)" + damageCharge + "\n \n Total Fare: \(currency) \(GrandTotal)"
                        
                    }
                    
//                    let strAlertMessage = "Alert! This is a cash job \n \n Please Collect Money From Passenger. \n \n FARE AMOUNT: \(currency) \(fareAmount) \n \n DAMAGE CHARGE: \(currency) \(strDamageCharge) \n \n Total Fare: \(currency) \(GrandTotal)"
                    
                    let alert = UIAlertController.init(title: strAlertMessage , message: nil, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Paid", style: .default, handler: { (action) in
//                        self.callCashApi(true)
                       self.callCashApiForAdvanceBooking(true)
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Not Paid", style: .default, handler: { (action) in
//                        self.callCashApi(false)
                        self.callCashApiForAdvanceBooking(false)
                    }))
                    //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
//                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
//                    alertWindow.rootViewController = UIViewController()
//                    alertWindow.windowLevel = UIWindowLevelAlert + 1
//                    alertWindow.makeKeyAndVisible()
//                    alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
//
                    // Changes for Alert  by Uttam Bhoj
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                    
                    //                    self.callCashJobApi()
                    
                } else {
                    let paymentStatus = self.checkDictionaryHaveValue(dictData: self.dictCompleteTripData as! [String : AnyObject], didHaveValue: "payment_status", isNotHave: "")
                    let paymentMessage = self.checkDictionaryHaveValue(dictData: self.dictCompleteTripData as! [String : AnyObject], didHaveValue: "payment_message", isNotHave: "")
                    
                    print("paymentStatus: \(paymentStatus)")
                    print("paymentMessage: \(paymentMessage)")
                    
                    if paymentStatus != "" {
                        
                        if paymentStatus == "1" {
                            
                            let alert = UIAlertController(title: "Warning!", message: paymentMessage, preferredStyle: UIAlertControllerStyle.alert)
                            
                            alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
                            
                            alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedMessage")
                            
                            //        alert.setValuesForKeys([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue).rawValue: UIColor.red])
                            
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { ACTION in
                                DispatchQueue.main.async {
                                    self.setCarAfterTrip()
                                    self.completeTripInfo()
                                }
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        else {
                            DispatchQueue.main.async {
                                self.setCarAfterTrip()
                                self.completeTripInfo()
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.setCarAfterTrip()
                            self.completeTripInfo()
                        }
                    }
                    if let isTimeOutDriver = UserDefaults.standard.value(forKey: "isTimeOutDriver") as? Int {
                        if isTimeOutDriver == 1 {
                            self.SwitchOFFClicked()
                        }
                    }
                }
                
//                self.setCarAfterTrip()
//                self.completeTripInfo()
                
            }
            else {
                
                if let res: String = result as? String {
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
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Getting List of Sards
    //-------------------------------------------------------------
    
    func webserviceOFGetAllCards() {
        
        webserviceForCardListingInWallet(Singletons.sharedInstance.strDriverID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                Singletons.sharedInstance.CardsVCHaveAryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
               
            }
            else {
                
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
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Sign Out
    //-------------------------------------------------------------
    
    func webserviceOFSignOut()
    {
        let srtDriverID = Singletons.sharedInstance.strDriverID
        
        let param = srtDriverID + "/" + Singletons.sharedInstance.deviceToken
        
        webserviceForSignOut(param as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
//                let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
                
                Utilities.removeUserDefaultsValue()
                self.socket?.off(socketApiKeys.kReceiveBookingRequest)
                self.socket?.off(socketApiKeys.kBookLaterDriverNotify)
                
                self.socket?.off(socketApiKeys.kGetBookingDetailsAfterBookingRequestAccepted)
                self.socket?.off(socketApiKeys.kAdvancedBookingInfo)
                
                self.socket?.off(socketApiKeys.kReceiveMoneyNotify)
                self.socket?.off(socketApiKeys.kAriveAdvancedBookingRequest)
                
                self.socket?.off(socketApiKeys.kDriverCancelTripNotification)
                self.socket?.off(socketApiKeys.kAdvancedBookingDriverCancelTripNotification)
                
                self.socket?.disconnect()
                Singletons.sharedInstance.isDriverLoggedIN = false
                
                let loginVw = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let navigationController = UINavigationController(rootViewController: loginVw)
                
                appDelegate.window?.rootViewController = navigationController
                
                
                self.navigationController?.popToRootViewController(animated: true)
//                self.performSegue(withIdentifier: "SignOutFromHome", sender: (Any).self)
                
            }
            else {
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
    
    func webserviceOFSignOutWhenSessionExpire(_ strAlertMessage: String)
    {
        let srtDriverID = Singletons.sharedInstance.strDriverID
        
        let param = srtDriverID + "/" + Singletons.sharedInstance.deviceToken
        
        webserviceForSignOut(param as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                //                let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
                Utilities.removeUserDefaultsValue()
                self.socket?.off(socketApiKeys.kReceiveBookingRequest)
                self.socket?.off(socketApiKeys.kBookLaterDriverNotify)
                
                self.socket?.off(socketApiKeys.kGetBookingDetailsAfterBookingRequestAccepted)
                self.socket?.off(socketApiKeys.kAdvancedBookingInfo)
                
                self.socket?.off(socketApiKeys.kReceiveMoneyNotify)
                self.socket?.off(socketApiKeys.kAriveAdvancedBookingRequest)
                
                self.socket?.off(socketApiKeys.kDriverCancelTripNotification)
                self.socket?.off(socketApiKeys.kAdvancedBookingDriverCancelTripNotification)
                
                self.socket?.disconnect()
                Singletons.sharedInstance.isDriverLoggedIN = false
                
                let loginVw = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let navigationController = UINavigationController(rootViewController: loginVw)
                
                appDelegate.window?.rootViewController = navigationController
                
                
                self.navigationController?.popToRootViewController(animated: true)
                
                Utilities.showAlert("", message: strAlertMessage, vc: loginVw)
                
                //                self.performSegue(withIdentifier: "SignOutFromHome", sender: (Any).self)
                
            }
            else {
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
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Running Trip Track
    //-------------------------------------------------------------
    
    @objc func webserviceOfRunningTripTrack() {
        
        webserviceForTrackRunningTrip(Singletons.sharedInstance.bookingId as AnyObject) { (result, status) in
            
            if (status) {
                
                self.aryCurrentBookingData.removeAllObjects()
                
                self.resetMapView()
                
                let resultData = (result as! NSDictionary)
                
                if let shareRide = resultData["share_ride"] as? String {
                    if shareRide == "1" {
                        Singletons.sharedInstance.isShareRideOn = true
                    } else {
                        Singletons.sharedInstance.isShareRideOn = false
                    }
                } else if let shareRide = resultData["share_ride"] as? Int {
                    if shareRide == 1 {
                        Singletons.sharedInstance.isShareRideOn = true
                    } else {
                        Singletons.sharedInstance.isShareRideOn = false
                    }
                }
                
                
                self.aryCurrentBookingData.add(resultData)
                
                self.aryPassengerData = self.aryCurrentBookingData
                
                if let loginStatus = (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "login") as? Bool {
                    
                    if (loginStatus) {
                        
                    }
                    else {
                        UtilityClass.showAlertWithCompletion("Multiple login", message: "Please Re-Login", vc: self, completionHandler: { ACTION in
                            
                            self.webserviceOFSignOut()
                        })
                    }
                }
                
                var bookingType = String()
                
                if let strBookingTypeFromCurrentBooking = (result as! NSDictionary).object(forKey: "BookingType") as? String {
                    bookingType = strBookingTypeFromCurrentBooking
                }
                else {
                    bookingType = ""
                }
                //                let bookingType = (result as! NSDictionary).object(forKey: "BookingType") as! String // (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "BookingType") as! String
                
                Singletons.sharedInstance.strBookingType = bookingType
                //((self.aryCurrentBookingData.object(at: 0) as! [String: AnyObject])["BookingInfo"] as! [String : AnyObject])["BookingType"]! as! String
                
                if(Singletons.sharedInstance.strBookingType == "")
                {
                    Singletons.sharedInstance.strBookingType = bookingType
                }
                
                if let aryBooking = (resultData).object(forKey: "BookingInfo") as? NSArray {
                    self.dictCurrentBookingInfoData = aryBooking.object(at: 0) as! NSDictionary
                }
                else if let dictBooking = (resultData).object(forKey: "BookingInfo") as? NSDictionary {
                     self.dictCurrentBookingInfoData = dictBooking
                }
                
               
                let statusOfRequest = self.dictCurrentBookingInfoData.object(forKey: "Status") as! String
                
                let PassengerType = self.dictCurrentBookingInfoData.object(forKey: "PassengerType") as? String
                
                if PassengerType == "" || PassengerType == nil{
                    Singletons.sharedInstance.passengerType = ""
                }
                else {
                    Singletons.sharedInstance.passengerType = PassengerType!
                }
                if(self.dictCurrentBookingInfoData.object(forKey: "PaymentType") as! String == "cash")
                {
                    Singletons.sharedInstance.passengerPaymentType = self.dictCurrentBookingInfoData.object(forKey: "PaymentType") as! String
                }
                
                
                DispatchQueue.main.async {
                    UtilityClass.showHUD()
                    
                }
                
                
                if bookingType != "" {
                    Singletons.sharedInstance.isBookNowOrBookLater = true
                    
                    if bookingType == "BookNow"
                    {
                        if statusOfRequest == "accepted"
                        {
                            
                            self.bookingID = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.driverID = Singletons.sharedInstance.strDriverID
                            Singletons.sharedInstance.isRequestAccepted = true
                            self.bookingTypeIsBookNow()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            
                            self.bookingID = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.driverID = Singletons.sharedInstance.strDriverID
                            
                            self.btnStartTripAction()
                        }
                        
                        Singletons.sharedInstance.bookingId = self.bookingID
                        
                        if (Singletons.sharedInstance.oldBookingType.isBookLater) {
                            Singletons.sharedInstance.oldBookingType.isBookNow = false
                        }
                        else {
                            Singletons.sharedInstance.oldBookingType.isBookNow = true
                        }
                    }
                    else if bookingType == "BookLater" {
                        
                        self.isAdvanceBooking = true
                        
                        if statusOfRequest == "accepted" {
                            
                            self.advanceBookingID = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.driverID = Singletons.sharedInstance.strDriverID
                            Singletons.sharedInstance.isRequestAccepted = true
                            
                            self.bookingtypeBookLater()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            
                            self.advanceBookingID = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.driverID = Singletons.sharedInstance.strDriverID
                            
                            self.btnStartTripAction()
                        }
                        
                        if (Singletons.sharedInstance.oldBookingType.isBookNow) {
                            Singletons.sharedInstance.oldBookingType.isBookLater = false
                        }
                        else {
                            Singletons.sharedInstance.oldBookingType.isBookLater = true
                        }
                    }
                }
                self.webserviceOFGetAllCards()
            }
            else
            {
                
                if let res = result as? String
                {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else if result is NSDictionary
                {
                    let resultData = (result as! NSDictionary)
                    Singletons.sharedInstance.dictTripDestinationLocation["location"] = resultData["location"] as AnyObject
                    Singletons.sharedInstance.dictTripDestinationLocation["trip_to_destin"] = resultData["trip_to_destin"] as AnyObject
                    
                    Singletons.sharedInstance.strCurrentBalance = Double(resultData.object(forKey: "balance") as! String)!
                    
                    if let shareRide = resultData["share_ride"] as? String {
                        if shareRide == "1" {
                            Singletons.sharedInstance.isShareRideOn = true
                        } else {
                            Singletons.sharedInstance.isShareRideOn = false
                        }
                    } else if let shareRide = resultData["share_ride"] as? Int {
                        if shareRide == 1 {
                            Singletons.sharedInstance.isShareRideOn = true
                        } else {
                            Singletons.sharedInstance.isShareRideOn = false
                        }
                    }
                    
                    var rating = String()
                    if let ratingTemp = resultData.object(forKey: "rating") as? String
                    {
                        if (ratingTemp == "")
                        {
                            rating = "0.0"
                        }
                        else
                        {
                            rating = ratingTemp
                        }
                    }
                    
                    Singletons.sharedInstance.strRating = rating
                    let nc = NotificationCenter.default
                    nc.post(name: Notification.Name("rating"), object: nil)
                    self.aryCurrentBookingData.add(resultData)
                    
                    self.aryPassengerData = self.aryCurrentBookingData
                    
                    if let loginStatus = (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "login") as? Bool {
                        
                        if (loginStatus) {
                            
                        }
                        else {
                            UtilityClass.showAlertWithCompletion("Multiple login", message: "Please Re-Login", vc: self, completionHandler: { ACTION in
                                
                                self.webserviceOFSignOut()
                            })
                        }
                    }
                    
                    self.webserviceOFGetAllCards()
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
                
            }
            
        }
        
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - Trip Bookings
    //-------------------------------------------------------------
    
    @IBAction func btnRoadPickUp(_ sender: Any)
    {
        
        //        self.performSegue(withIdentifier: "segueToTRoadPickup", sender: nil)
        
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MeterViewController") as! MeterViewController
        viewController.strVehicleName = strVehicleName
        viewController.baseFare = baseFare
        
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    func bookingTypeIsBookNow() {
        
        methodAfterDidAcceptBooking(data: aryCurrentBookingData)
    }
    
    func bookingtypeBookLater() {
        
        methodAfterDidAcceptBookingLaterRequest(data: aryCurrentBookingData)
    }
    
    func bookingStatusAccepted() {
        
        btnStartTripAction()
    }
    
    func bookingStatusTraveling() {
        
        btnStartTripAction()
    }
    
    @IBAction func getDirections(_ sender: Any) {
        
        let BookingInfo : NSDictionary!
                   print("crashed  \(#function)")
        if((((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) == nil) {
            
            BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        }
        else {
            
            BookingInfo = (((self.aryPassengerData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
        }
        
        
        // ------------------------------------------------------------
        var DropOffLat = BookingInfo.object(forKey: "PickupLat") as! String
        var DropOffLon = BookingInfo.object(forKey: "PickupLng") as! String
        
        if(Singletons.sharedInstance.isTripContinue == true) {
            
            DropOffLat = BookingInfo.object(forKey: "DropOffLat") as! String
            DropOffLon = BookingInfo.object(forKey: "DropOffLon") as! String
        }
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            
            UIApplication.shared.open(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(String(describing: Float(DropOffLat)!)),\(String(describing: Float(DropOffLon)!))&directionsmode=driving")! as URL, options: [:], completionHandler: { (status) in
            })
        }
        else {
            
            NSLog("Can't use com.google.maps://");
            UtilityClass.showAlert(appName.kAPPName, message: "Please install Google Maps", vc: self)
        }
    }
    
    
    func didRatingCompleted() {
            //        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.performSegue(withIdentifier: "seguePresentRatings", sender: nil)
            //        self.window?.rootViewController!.performSegue(withIdentifier: "seguePresentRatings", sender: nil)
            
            resetMapView()
            driverMarker = nil
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
            
            
            next.delegate = self
            
            let getBookingAndPassengerInfo = self.getBookingAndPassengerInfo(data: self.aryPassengerData)
            
            let PassengerInfo = getBookingAndPassengerInfo.1
            
            
            if (Singletons.sharedInstance.oldBookingType.isBookLater || (isAdvanceBooking == true && bookingID == "") ) {
                next.strBookingType = "BookLater"
            }
            else {
                next.strBookingType = "BookNow"
            }
            
            next.dictData = self.dictCompleteTripData
            next.dictPassengerInfo = PassengerInfo
            
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
            
            //        guard ((self.performSegue(withIdentifier: "seguePresentRatings", sender: self)) != nil) else {
            //            print("error")
            //            return
            //        }
            //        self.navigationController?.performSegue(withIdentifier: "seguePresentRatings", sender: nil)
        
        
//        self.navigationController?.performSegue(withIdentifier: "seguePresentRatings", sender: nil)
    }
    
    func completeTripInfo() {
        
        App_Delegate.WaitingTime = "00:00:00"
        App_Delegate.WaitingTimeCount = 0
        let next = self.storyboard?.instantiateViewController(withIdentifier: "TripInfoCompletedTripVC") as! TripInfoCompletedTripVC
        next.dictData = self.dictCompleteTripData
        next.delegate = self
        DispatchQueue.main.async {
              self.stopSound()
            self.btnCurrentLocation(self.btnCurrentlocation)
            
        }
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Meter Setup -
    
   
    var waitingTime = Double()
    var baseFare = Double()
    var minKM = Double()
    var perKMCharge = Double()
    var waitingChargePerMinute = Double()
    var bookingFee = Double()
    var strVehicleName = String()
    var strWaitingTime = String()
    //    var counter = 0.0
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    @objc func updateTime()
    {
        
        
        //        print("Function: \(#function), line: \(#line), Waiting Time Count: \(App_Delegate.WaitingTimeCount)")
        if(SingletonsForMeter.sharedInstance.isMeterOnHold == true)
        {
        App_Delegate.WaitingTimeCount = App_Delegate.WaitingTimeCount + 1.0
        }
      //  print("Function: \(#function), line: \(#line), Waiting Time Count: \(App_Delegate.WaitingTimeCount)")
        
        
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(App_Delegate.WaitingTimeCount))
        
        App_Delegate.WaitingTime = "\(getStringFrom(seconds: h)):\(getStringFrom(seconds: m)):\(getStringFrom(seconds: s))"
        print(App_Delegate.WaitingTime)
        
        let meterVC = self.navigationController?.childViewControllers.last?.presentedViewController as? MeterViewController
        meterVC?.updateTime()
        self.calculateDistanceAndPrice()
    }
    
    func webserviceCallToGetFare()
    {
        webserviceForGetTaxiModelPricing("" as AnyObject) { (result, status) in
            if(status)
            {
                if ((result as AnyObject)["model_cat1"] != nil)
                {
                    SingletonsForMeter.sharedInstance.arrCarModels = (result["model_cat1"] as? AnyObject as! [[String:AnyObject]])
                }
                else
                {
                    UtilityClass.showAlert(appName.kAPPName, message: "Something went wrong", vc: self)
                }
                
                if ((result as AnyObject)["meter_model"] != nil)
                {
                    SingletonsForMeter.sharedInstance.arrMeterCarModels = (result["meter_model"] as? AnyObject as! [[String:AnyObject]])
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
    
    
    
    
    func calculateDistanceAndPrice()
    {
        var vehicleID = Int()
        
        for i in 0..<SingletonsForMeter.sharedInstance.arrCarModels.count
        {
            if ((SingletonsForMeter.sharedInstance.arrCarModels[i]["Id"] as! NSString).integerValue == SingletonsForMeter.sharedInstance.vehicleModelID)
            {
                vehicleID = i
                
            }
        }
        
        
        let dictdata = SingletonsForMeter.sharedInstance.arrCarModels[vehicleID]
        
        SingletonsForMeter.sharedInstance.strVehicleName = dictdata["Name"] as! String
        SingletonsForMeter.sharedInstance.baseFare = (dictdata["BaseFare"]! as! NSString).doubleValue// as! Double!
        SingletonsForMeter.sharedInstance.minKM = (dictdata["MinKm"]! as! NSString).doubleValue//self.arrOfTaxis[0]["MinKm"] as! Double!
        SingletonsForMeter.sharedInstance.perKMCharge = (dictdata["AbovePerKmCharge"]! as! NSString).doubleValue//self.arrOfTaxis[0]["AbovePerKmCharge"] as! Double!
        //        let nightCharge = self.arrOfTaxis[0]["NightCharge"]
        SingletonsForMeter.sharedInstance.waitingChargePerMinute = (dictdata["WaitingTimePerMinuteCharge"]! as! NSString).doubleValue//self.arrOfTaxis[0]["WaitingTimePerMinuteCharge"] as! Double!
        SingletonsForMeter.sharedInstance.bookingFee = (dictdata["BookingFee"]! as! NSString).doubleValue//self.arrOfTaxis[0]["BookingFee"] as! Double!
        
        SingletonsForMeter.sharedInstance.total = 0.0
        
        if(Singletons.sharedInstance.distanceTravelledThroughMeter <= minKM)
        {
            SingletonsForMeter.sharedInstance.total = baseFare + bookingFee
        }
        else
        {
            SingletonsForMeter.sharedInstance.total = ((Singletons.sharedInstance.distanceTravelledThroughMeter - minKM) * SingletonsForMeter.sharedInstance.perKMCharge) + SingletonsForMeter.sharedInstance.baseFare +  SingletonsForMeter.sharedInstance.bookingFee
        }
        
        
        SingletonsForMeter.sharedInstance.waitingMinutes = String()
        SingletonsForMeter.sharedInstance.waitingMinutes  = "0.0"
        
        if App_Delegate.WaitingTime != "" {
        }
        else {
            App_Delegate.WaitingTime = "00:00:00"
        }
        
        if (App_Delegate.WaitingTime.count != 0)
        {
            SingletonsForMeter.sharedInstance.waitingMinutes = (App_Delegate.WaitingTime.components(separatedBy: ":")[1])
            
            if (SingletonsForMeter.sharedInstance.waitingMinutes != "")
            {
                SingletonsForMeter.sharedInstance.total = SingletonsForMeter.sharedInstance.total + (Double(SingletonsForMeter.sharedInstance.waitingMinutes)! * waitingChargePerMinute)
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateDistanceInMeters"), object: nil)
        
//        print("The total is Home View \(SingletonsForMeter.sharedInstance.total)")
//        print("The time is \(SingletonsForMeter.sharedInstance.waitingMinutes)")
        
       
    }
    
}




extension Bool {
    /// To Check is First Time from Pending Jobs
    mutating func toggleForBookLaterStartFromPendinfJobs() {
        self = !self
    }
}


//extension HomeViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let location: CLLocation = locations.last!
//        defaultLocation = location
//        Singletons.sharedInstance.latitude = location.coordinate.latitude
//        Singletons.sharedInstance.longitude = location.coordinate.longitude
//    }
//}
