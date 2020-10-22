//
//  LoginViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 10/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import CoreLocation
class LoginViewController: UIViewController {

    
    @IBOutlet var txtMobileNumber: UITextField!
    
    @IBOutlet var txtPassword: UITextField!
    
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnForgotPass: UIButton!
    
    @IBOutlet var btnSignUp: UIButton!
    
    var strLatitude = Double()
    var strLongitude = Double()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Utilities.setCornerRadiusTextField(textField: txtMobileNumber, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtPassword, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusButton(button: btnLogin, borderColor: ThemeYellowColor, bgColor: ThemeYellowColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusButton(button: btnSignUp, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
//        txtMobileNumber.text = "9632587410"
//        txtPassword.text = "123456"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
//        self.frostedViewController.panGestureEnabled = false
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnForgotPassClicked(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    @IBAction func btnLoginClicked(_ sender: Any)
    {

        if (validateAllFields())
        {
            if Singletons.sharedInstance.latitude == nil {
                
                self.checkAllowLocationPermission()
            }else {
                webserviceForLoginDrivers()

            }
            
            
        }
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! CustomSideMenuViewController
//        self.navigationController?.pushViewController(next, animated: true)
        
    }
    func checkAllowLocationPermission() {
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
                
            case .authorizedAlways, .authorizedWhenInUse:
                
                print("Authorize.")
                
                break
                
            case .notDetermined:
                
                print("Not determined.")
                
                break
                
            case .restricted:
                showAlertIfDenied()
                print("Restricted.")
                
                break
                
            case .denied:
                showAlertIfDenied()
                print("Denied.")
            }
        }
    }
    func showAlertIfDenied() {
        if (CLLocationManager.locationServicesEnabled() == false || CLLocationManager.authorizationStatus() == .denied) {
            let alert = UIAlertController(title: appName.kAPPName, message: "You have denied location permission. Turn it on from the device settings", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
                if !CLLocationManager.locationServicesEnabled() {
                    //This will open ios devices location settings
                    /*
                    var url: String?
                    if #available(iOS 10.0,*)
                    {
                        url =  "prefs:root=LOCATION_SERVICES"
                    }else{
                        url = "App-Prefs:root=Privacy&path=LOCATION"
                    }
                    UIApplication.shared.openURL(URL(string: url!)!)
                    */
                    
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl)  {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            })
                        }
                        else  {
                            UIApplication.shared.openURL(settingsUrl)
                        }
                    }
                }
                else {
                    //This will opne particular app location settings
                    UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                }
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func removeZeros(from anyString: String?) -> String? {
        if anyString?.hasPrefix("0") ?? false && (anyString?.count ?? 0) > 1 {
            return removeZeros(from: (anyString as NSString?)?.substring(from: 1))
        } else {
            return anyString
        }
    }

    @IBAction func textDidChange(_ sender: UITextField) {
        if !sender.text!.isEmpty {
            txtMobileNumber.text = removeZeros(from: sender.text!)
        }
    }
    @IBAction func btnSignUpClicked(_ sender: Any) {
    
        objRegistration = loadRegistrationObject(withKey: RegistrationKeys.registrationUser)
        if objRegistration !=  nil {
            let alert = UIAlertController(title: "Continue Registration",
                                          message: "Your previous registration is pending. Do you want to continue registration?",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Continue", style: .default, handler: { (action) in
                let vwDriverRegistrationMain = StroryBords.registrationStoryBoard.instantiateViewController(withIdentifier: "DriverRegistrationMainViewController") as! DriverRegistrationMainViewController
                self.navigationController?.pushViewController(vwDriverRegistrationMain, animated: true)
                //            DriverRegistrationMainViewController
            })
            let startNewAction = UIAlertAction(title: "Start New", style: .default, handler: { (action) in
                
                
                UserDefaults.standard.removeObject(forKey: RegistrationKeys.registrationUser)
                
//                saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
                
                let vwDriverRegistrationMain = StroryBords.registrationStoryBoard.instantiateViewController(withIdentifier: "DriverRegistrationMainViewController") as! DriverRegistrationMainViewController
                self.navigationController?.pushViewController(vwDriverRegistrationMain, animated: true)
            })
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
            
            alert.addAction(okAction)
            alert.addAction(startNewAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else {
            let vwDriverRegistrationMain = StroryBords.registrationStoryBoard.instantiateViewController(withIdentifier: "DriverRegistrationMainViewController") as! DriverRegistrationMainViewController
            self.navigationController?.pushViewController(vwDriverRegistrationMain, animated: true)
        }
    }
    
    
    // MARK: -
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var dictData = [String:AnyObject]()
    
    func webserviceForLoginDrivers()
    {
        
        dictData["Username"] = self.txtMobileNumber.text as AnyObject
        dictData["Password"] = self.txtPassword.text as AnyObject
        
        if Singletons.sharedInstance.latitude == nil {
           checkAllowLocationPermission()
        } else {
            dictData["Lat"] = Singletons.sharedInstance.latitude as AnyObject
        }
        
        if Singletons.sharedInstance.longitude == nil {
            checkAllowLocationPermission()
            
        } else {
            dictData["Lng"] = Singletons.sharedInstance.longitude as AnyObject
        }
        dictData["Token"] =
            Singletons.sharedInstance.deviceToken as AnyObject
        
//
        dictData["DeviceType"] = "1" as AnyObject
        
        
        webserviceForDriverLogin(dictParams: dictData as AnyObject) { (result, status) in
            
            if (status)
            {
                print(result)
                
                if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
                {
                    Singletons.sharedInstance.dictDriverProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "driver") as! NSDictionary)
                    Singletons.sharedInstance.isDriverLoggedIN = true
                    
                    UserDefaults.standard.set(Singletons.sharedInstance.dictDriverProfile, forKey: driverProfileKeys.kKeyDriverProfile)
                    UserDefaults.standard.set(true, forKey: driverProfileKeys.kKeyIsDriverLoggedIN)
                    
                    Singletons.sharedInstance.strDriverID = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "Vehicle") as! NSDictionary).object(forKey: "DriverId") as! String
                    
                    Singletons.sharedInstance.driverDuty = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "DriverDuty") as! String)
                    //                    Singletons.sharedInstance.showTickPayRegistrationSceeen =
                    
                    let profileData = Singletons.sharedInstance.dictDriverProfile
                    
                    if let currentBalance = (profileData?.object(forKey: "profile") as! NSDictionary).object(forKey: "Balance") as? Double {
                        Singletons.sharedInstance.strCurrentBalance = currentBalance
                    }
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! CustomSideMenuViewController
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    self.navigationController?.pushViewController(next, animated: true)
                }
                
            }
            else
            {
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
}
//MARK: Custom method
extension LoginViewController {
    //-------------------------------------------------------------
    // MARK: - Validation Methods
    //-------------------------------------------------------------
    
    func validateAllFields() -> Bool
    {
        //        let isEmailAddressValid = isValidEmailAddress(emailID: txtEmailAddress.text!)
        //        let providePassword = txtPassword.text
        
        //        let isPasswordValid = isPwdLenth(password: providePassword!)
        
        
        if self.txtMobileNumber.text!.count == 0
        {
            UtilityClass.showAlert(appName.kAPPName, message: "Please enter mobile number", vc: self)
            return false
        }
        else if self.txtMobileNumber.text!.count < 8 {
            UtilityClass.showAlert(appName.kAPPName, message: "Please enter valid mobile number.", vc: self)
            return false
        }
        else if txtPassword.text!.count == 0
        {
            
            UtilityClass.showAlert(appName.kAPPName, message: "Please enter password", vc: self)
            
            return false
        }
        else if txtPassword.text!.count <= 5 {
            UtilityClass.showAlert(appName.kAPPName, message: "Password should be more than 5 characters", vc: self)
            return false
        }
        
        
        return true
    }
    @IBAction func unwindToVC1(segue:UIStoryboardSegue)
    {
        
    }
    @IBAction func unwindFromHomeView(segue:UIStoryboardSegue)
    {
        
    }
    func isValidEmailAddress(emailID: String) -> Bool
    {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z)-9.-]+\\.[A-Za-z]{2,3}"
        
        do{
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailID as NSString
            let results = regex.matches(in: emailID, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
        }
        catch _ as NSError
        {
            returnValue = false
        }
        
        return returnValue
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtMobileNumber && range.location == 0 {
            if string == "0" {
                return false
            }
        }
        return true
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//    }
}

