//
//  AppDelegate.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 10/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import Firebase
import UserNotifications
import FirebaseMessaging
import SocketIO
import SideMenuController
import GooglePlaces
import GoogleMaps

//AIzaSyCrTmm5JjgEWuauH42rGCVmJotYfes2Q-0


let googlApiKey = "AIzaSyD9A_1VItzxiUnARQWpEbqT42KPND4TEwg"//"AIzaSyDZbRqzGvylGV1ejO3GdQXqm0yaPHwxjJg" last

//"AIzaSyD7bq-RXLeSv9PMDB9x62c0d_ZlVy3ndNE" //"AIzaSyBpHWct2Dal71hBjPis6R1CU0OHZNfMgCw"         // AIzaSyB08IH_NbumyQIAUCxbpgPCuZtFzIT5WQo

let googlPlacesApiKey = "AIzaSyD9A_1VItzxiUnARQWpEbqT42KPND4TEwg" //"AIzaSyDZbRqzGvylGV1ejO3GdQXqm0yaPHwxjJg" last


//"AIzaSyD7bq-RXLeSv9PMDB9x62c0d_ZlVy3ndNE" // "AIzaSyCKEP5WGD7n5QWtCopu0QXOzM9Qec4vAfE"
//AIzaSyD7bq-RXLeSv9PMDB9x62c0d_ZlVy3ndNE  EzyGo Driver
//AIzaSyDZbRqzGvylGV1ejO3GdQXqm0yaPHwxjJg Pick Nd Go


  #warning("New warn")
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    var storyboard: UIStoryboard?
//    var frostedViewController: REFrostedViewController?

    var bgTask : UIBackgroundTaskIdentifier!
    
    var WaitingTime  = ""
    var WaitingTimeCount  : Double = 0
    var DistanceKiloMeter  = ""
    var Speed  = ""
    
    var RoadPickupTimer = Timer()
    let locationManager = CLLocationManager()

    
    let manager = SocketManager(socketURL: URL(string: socketApiKeys.kSocketBaseURL)!, config:  [.log(false), .compress])
    var Socket:SocketIOClient? = nil
    
    
//    let socketManager = SocketManager(socketURL: URL(string: socketApiKeys.kSocketBaseURL)!, config: [.log(true), .compress])


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        Socket = manager.defaultSocket
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Fabric.with([Crashlytics.self])
        
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menu")
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = (window?.frame.width)! - 80
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.isIdleTimerDisabled = true
        
//                var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
//                bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {() -> Void in
//                })
        if (UserDefaults.standard.object(forKey:  driverProfileKeys.kKeyDriverProfile) != nil)
        {
            self.setDataInSingletonClass()
        }
        else
        {
            Singletons.sharedInstance.isDriverLoggedIN = false
        }
        
        // Google Map
        self.window?.rootViewController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        

        GMSPlacesClient.provideAPIKey(googlApiKey)
        GMSServices.provideAPIKey(googlPlacesApiKey)
        self.registerForPushNotification()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("App is in Background mode")
        Socket?.connect()
        Socket?.on(clientEvent: .connect) {data, ack in
            print ("socket connected")
        }
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation = locations.last!
        
        //        defaultLocation = location
        
        Singletons.sharedInstance.latitude = location.coordinate.latitude
        Singletons.sharedInstance.longitude = location.coordinate.longitude
        
        if locations.first != nil {
            //            print("location:: (location)")
        }
    }

    
    // MARK: - Check Login
    func setDataInSingletonClass()
    {
        Singletons.sharedInstance.dictDriverProfile = NSMutableDictionary(dictionary:UserDefaults.standard.object(forKey:  driverProfileKeys.kKeyDriverProfile) as! NSDictionary)
        Singletons.sharedInstance.strDriverID = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "Vehicle") as! NSDictionary).object(forKey: "DriverId") as! String
        Singletons.sharedInstance.isDriverLoggedIN = UserDefaults.standard.object(forKey: driverProfileKeys.kKeyIsDriverLoggedIN) as! Bool
        
        if UserDefaults.standard.object(forKey: "DriverDuty") as? String == nil {
            
            Singletons.sharedInstance.driverDuty = "0"
        }
        else {
            Singletons.sharedInstance.driverDuty = UserDefaults.standard.object(forKey: "DriverDuty") as! String
        }
        
        
        if let passOn = UserDefaults.standard.object(forKey: "isPasscodeON") as? Bool {
            
            if passOn == false {
                
                Singletons.sharedInstance.isPasscodeON = false
            }
            else {
                Singletons.sharedInstance.isPasscodeON = true
            }
        }else {
            Singletons.sharedInstance.isPasscodeON = false
            UserDefaults.standard.set(Singletons.sharedInstance.isPasscodeON, forKey: "isPasscodeON")
        }
    }
    //-------------------------------------------------------------
    // MARK: - Push Notification Methods
    //-------------------------------------------------------------
    
    func registerForPushNotification() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
            
            print("Permissin granted: \(granted)")
            
            self.getNotificationSettings()
            
        })
        
    }
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {(settings) in
            
            print("Notification Settings: \(settings)")
            
            
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                
            }
            
        })
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        
        let deviceTemp = deviceToken.map({ (data)-> String in
            return String(format: "%0.2.2hhx", data)
        })
        Messaging.messaging().apnsToken = deviceToken as Data
        if let fcmToken = Messaging.messaging().fcmToken
        {
            Singletons.sharedInstance.deviceToken = fcmToken
        }
        UserDefaults.standard.set(Singletons.sharedInstance.deviceToken, forKey: "Token")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")!
        
        if(application.applicationState == .background)
        {
//            self.pushAfterReceiveNotification(typeKey: key as! String)
        }
        else
        {
            let data = ((userInfo["aps"]! as! [String : AnyObject])["alert"]!) as! [String : AnyObject]
            
            
            let alert = UIAlertController(title: appName.kAPPName,
                                          message: data["title"] as? String,
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
            if((userInfo as! [String:AnyObject])["gcm.notification.type"]! as! String == "AcceptBookingRequestNotification")
            {
                /*
                alert.addAction(UIAlertAction(title: "Get Details", style: .default, handler: { (action) in
                    self.pushAfterReceiveNotification(typeKey: key as! String)
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { (action) in
                    
                }))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                */
            }
            else if ((userInfo as! [String:AnyObject])["gcm.notification.type"]! as! String == "Logout")
            {
                let navigationController = application.windows[0].rootViewController as! UINavigationController
                
                let viewControllers: [UIViewController] = navigationController.viewControllers
                for aViewController in viewControllers {
                    if aViewController is CustomSideMenuViewController {
                        
                        if let homeVC = (((aViewController.childViewControllers.first as! UINavigationController).childViewControllers).first as? HomeViewController) {
                            homeVC.webserviceOFSignOutWhenSessionExpire(data["title"] as? String ?? "Session Expire")
                        }
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//change
//                            if let homeVC = (((aViewController.childViewControllers.first as! UINavigationController).childViewControllers).first as? HomeViewController) {
//                                homeVC.webserviceOFSignOut()
//                            }
                            
                        }))
                        
//                        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                        
                        
                    }
                }
                
            }else if ((userInfo as! [String:AnyObject])["gcm.notification.type"]! as! String == "Timeout") {
                
                let alert1 = UIAlertController(title: appName.kAPPName,
                                              message: data["body"] as? String,
                                              preferredStyle: UIAlertControllerStyle.alert)
                
                UserDefaults.standard.set(true, forKey: "isTimeOutDriver")
                let navigationController = application.windows[0].rootViewController as! UINavigationController
                
                let viewControllers: [UIViewController] = navigationController.viewControllers
                for aViewController in viewControllers {
                    if aViewController is CustomSideMenuViewController {
                        
                        if let homeVC = (((aViewController.childViewControllers.first as! UINavigationController).childViewControllers).first as? HomeViewController) {
                         
                            if homeVC.isNowBooking || homeVC.isAdvanceBooking {
                                
                            }else {
                                homeVC.SwitchOFFClicked()
                            }
                            
                        }
                        
                        alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            //change
                            //                            if let homeVC = (((aViewController.childViewControllers.first as! UINavigationController).childViewControllers).first as? HomeViewController) {
                            //                                homeVC.webserviceOFSignOut()
                            //                            }
                            
                        }))
                        
                        self.window?.rootViewController?.present(alert1, animated: true, completion: nil)
                        
                        
                    }
                }
                
            }
        }
        //        let data = ((userInfo["aps"]! as! [String : AnyObject])["alert"]!) as! [String : AnyObject]
        //  UtilityClass.showAlert(data["title"] as! String, message: data["body"] as! String, vc: (self.window?.rootViewController)!)
        print(userInfo)
    }
    
    func handleRemoteNotification(key : String, userInfo : NSDictionary, application: UIApplication)
    {
//        var newsID = String()
//
//        if key == "news"
//        {
//            newsID = (userInfo as NSDictionary).object(forKey: "gcm.notification.news_id")! as! String
//        }
//        else
//        {
//            newsID = ""
//        }
//        print(application.applicationState.rawValue)
//        if(application.applicationState == .background || application.applicationState == .inactive)
//        {
////            self.pushAfterReceiveNotification(typeKey: key, newsID: newsID)
//        }
//        else if (application.applicationState == .active)
//        {
//            print(userInfo)
//            let data = ((userInfo["aps"]! as! [String : AnyObject])["alert"]!) as! [String : AnyObject]
//
//
//            let alert = UIAlertController(title: appName,
//                                          message: data["body"] as? String,
//                                          preferredStyle: UIAlertControllerStyle.alert)
//
//            if key == "news"
//            {
//                alert.addAction(UIAlertAction(title: "Get Media Details", style: .default, handler: { (action) in
//                    self.pushAfterReceiveNotification(typeKey: key, newsID: newsID)
//
//                }))
//            }
//            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { (action) in
//
//            }))
//
//            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
//        }
//
//        print(userInfo)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        
        //        print(response.notification.request.content.userInfo)
        //
//        dictNoti = response.notification.request.content.userInfo as! [String : AnyObject]
//        //
//        let key = (dictNoti)["gcm.notification.type"] as! String
//        //        let state : UIApplicationState = application.applicationState
//
//        self.handleRemoteNotification(key: key, userInfo: dictNoti as NSDictionary, application: UIApplication.shared)
//
//        completionHandler()
        
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        
        let token = Messaging.messaging().fcmToken
        Singletons.sharedInstance.deviceToken = token!
        UserDefaults.standard.set(Singletons.sharedInstance.deviceToken, forKey: "Token")
        print("FCM token: \(token ?? "")")
        
    }
    
    //MARK: - FrostraedViewController
    /*
    func frostedViewController(_ frostedViewController: REFrostedViewController, didRecognizePanGesture recognizer: UIPanGestureRecognizer) {
    }
    
    func frostedViewController(_ frostedViewController: REFrostedViewController, willShowMenuViewController menuViewController: UIViewController) {
        //        print("willShowMenuViewController")
    }
    
    func frostedViewController(_ frostedViewController: REFrostedViewController, didShowMenuViewController menuViewController: UIViewController) {
        //        print("didShowMenuViewController")
    }
    
    func frostedViewController(_ frostedViewController: REFrostedViewController, willHideMenuViewController menuViewController: UIViewController) {
        //        print("willHideMenuViewController")
    }
    
    func frostedViewController(_ frostedViewController: REFrostedViewController, didHideMenuViewController menuViewController: UIViewController) {
        //        print("didHideMenuViewController")
    }
    */

    
}

//MARK: Registration Object
//User Object
func saveRegistrationObject(_ object: RegistrationObject, key: String) {
    let encodedObject = NSKeyedArchiver.archivedData(withRootObject: object)
    let defaults = UserDefaults.standard
    defaults.set(encodedObject, forKey: key)
    defaults.synchronize()
}

func loadRegistrationObject(withKey key: String) -> RegistrationObject? {
    let defaults = UserDefaults.standard
    let encodedObject: Data? = defaults.object(forKey: key) as! Data?
    if encodedObject != nil {
        let object: RegistrationObject? = NSKeyedUnarchiver.unarchiveObject(with: encodedObject!) as! RegistrationObject?
        return object!
    }
    return nil
}
