//
//  RegistrationEmailViewController.swift
//  ezygo-Driver
//
//  Created by Apple on 22/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import Sheeeeeeeeet
import CoreLocation

enum CountryCode: String {
    case NZ = "NZ +64"
    case Au = "AU +61"
}
var objRegistration: RegistrationObject!
class RegistrationEmailViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet var txtMobileNumber: UITextField!
    @IBOutlet var txtCountryCode: UITextField!
    @IBOutlet var txtEmailAddress: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet weak var txtOtp: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!
    @IBOutlet var txtLandlineNumber: UITextField!
    
    @IBOutlet var btnNext: UIButton!
    
    @IBOutlet var lblCountryCode: UILabel!
    
    @IBOutlet var imgVwFlag: UIImageView!
    
    @IBOutlet weak var conVwEmailLeading: NSLayoutConstraint!
    
    @IBOutlet weak var vwScroll: UIScrollView!
    var userDefault = UserDefaults.standard
    var nOtpNumber = 0
    var isOtpSend = false
    
    var selectedCountry = CountryCode.NZ
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if (objRegistration != nil) {
// 
//            if objRegistration!.nFillPageNumber != 0 {
//                if let vwSuper = self.parent as? DriverRegistrationMainViewController {
//                        self.view.layoutIfNeeded()
//                        vwSuper.changeContentOffset(objRegistration!.nFillPageNumber)
//                }
//            }
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: - Actions
    @IBAction func nextClick(_ sender: Any) {
        if isOtpSend == true {
            if txtOtp.text!.isEmptyOrWhitespace() {
                  Utilities.showAlert("", message: "Please enter OTP.", vc: self)
            }else if Int(txtOtp.text ?? "0") != nOtpNumber {
                Utilities.showAlert("", message: "OTP is not same or expired.", vc: self)
            }else {
                
                objRegistration.nFillPageNumber = 1.0
                saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
                
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                    let vwSuper = self.parent as! DriverRegistrationMainViewController
                    vwSuper.changeContentOffset(1.0)
                }
            }
        }
        else
        {
            if txtMobileNumber.text!.isEmptyOrWhitespace() {
                Utilities.showAlert("", message: "Please enter mobile number.", vc: self)
            }else if txtMobileNumber.text!.count < 8 || txtMobileNumber.text!.count > 14 {
                Utilities.showAlert("", message: "Please enter valid phone number.", vc: self)
            }else if txtEmailAddress.text!.isEmptyOrWhitespace() {
                Utilities.showAlert("", message: "Please enter email.", vc: self)
            }else if !Utilities.isEmail(testStr: txtEmailAddress.text!) {
                Utilities.showAlert("", message: "Please enter valid email.", vc: self)
            }else if txtPassword.text!.isEmpty {
                Utilities.showAlert("", message: "Please enter your password.", vc: self)
            }else if txtPassword.text!.count < 6 {
                Utilities.showAlert("", message: "Password must contain at least 6 characters.", vc: self)
                
            }else if txtConfirmPassword.text!.isEmpty {
                Utilities.showAlert("", message: "Please enter confirm password.", vc: self)
                
            }else if txtPassword.text! != txtConfirmPassword.text! {
                Utilities.showAlert("", message: "Password and confirm password must be same.", vc: self)
                
            }else {
                if Singletons.sharedInstance.latitude == nil {
                    checkAllowLocationPermission()
                }else {
                    self.view.endEditing(true)
                    self.callOtpService()
                }
            }
        }
    }
    func checkAllowLocationPermission() {
        if CLLocationManager.locationServicesEnabled() {
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
                    if UIApplication.shared.canOpenURL(settingsUrl) {
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
    @IBAction func resendOtpClick(_ sender: UIButton) {
          self.callOtpService()
    }
    @IBAction func countryClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let item1 = ActionSheetItem(title: "New Zealand (NZ)     +64", value: 2, image: UIImage.init(named: "NZ"))
        let item2 = ActionSheetItem(title: "Australia (AU)     +61", value: 1, image: UIImage.init(named: "AU"))
        
       
        let cancel = ActionSheetDangerButton.init(title: "Cancel")
        
        let actionSheet = ActionSheet.init(items: [item1,item2,cancel]) { (sheet, selectedItem) in
//            print(selectedItem.value)
            
            if let selectedRow = selectedItem.value as? Int {
                if selectedRow == 2 {
                    self.lblCountryCode.text = CountryCode.NZ.rawValue
                    self.imgVwFlag.image = UIImage.init(named: "NZ")
                    self.selectedCountry = .NZ
                }else if selectedRow == 1 {
                    self.lblCountryCode.text = CountryCode.Au.rawValue
                    self.imgVwFlag.image = UIImage.init(named: "AU")
                    self.selectedCountry = .Au
                }
            }

        }

        actionSheet.present(in: self, from: view)

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
    //MARK: - Custom Method
    func loadData() {
        objRegistration = loadRegistrationObject(withKey: RegistrationKeys.registrationUser)
        if (objRegistration != nil) {
            
//            if objRegistration!.nFillPageNumber != 0 {
//                if let vwSuper = self.parent as? DriverRegistrationMainViewController {
//                    vwSuper.changeContentOffset(objRegistration!.nFillPageNumber)
//                }
//            }
            
            
            self.txtEmailAddress.text! = objRegistration.strEmail
            self.txtMobileNumber.text! = objRegistration.strMobileNo
            self.txtLandlineNumber.text! = objRegistration.strLandLineNumber
            self.txtPassword.text! =  objRegistration.strPassword
            self.txtConfirmPassword.text! = objRegistration.strConfirmPassword
            
            if objRegistration.strCountryCode == "2" {
                self.lblCountryCode.text = CountryCode.NZ.rawValue
                self.imgVwFlag.image = UIImage.init(named: "NZ")
            }else {
                self.lblCountryCode.text = CountryCode.Au.rawValue
                self.imgVwFlag.image = UIImage.init(named: "AU")
            }
            
            
        } else {
            lblCountryCode.text = CountryCode.NZ.rawValue
            imgVwFlag.image = UIImage.init(named: "NZ")
        }
        Utilities.setCornerRadiusTextField(textField: txtMobileNumber, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtCountryCode, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtLandlineNumber, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtEmailAddress, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtPassword, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtConfirmPassword, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtOtp, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusButton(button: btnNext, borderColor: ThemeYellowColor, bgColor: ThemeYellowColor, textColor: ThemeWhiteColor)

    }
     //MARK: - Custom WebService Method
    func callOtpService() {
        
        var param = [String:AnyObject]()
        
        param["MobileNo"] = ((self.selectedCountry == .NZ) ? "64": "61") + txtMobileNumber.text! as AnyObject
        param["Email"] = txtEmailAddress.text as AnyObject
        
        webserviceForOTPDriverRegister(param as AnyObject) { (result, status) in
            
            if status {
                Utilities.showAlert(result["message"] as? String ?? "", message: "", vc: self)
                print(result)
                
                self.nOtpNumber = result["otp"] as? Int ?? 0
                
                if objRegistration == nil {
                    
                    objRegistration = RegistrationObject()
                }
                objRegistration.strEmail = self.txtEmailAddress.text!
                objRegistration.strMobileNo = self.txtMobileNumber.text!
                objRegistration.strLandLineNumber = self.txtLandlineNumber.text!
                objRegistration.strPassword = self.txtPassword.text!
                objRegistration.strConfirmPassword = self.txtConfirmPassword.text!
                
                if self.lblCountryCode.text == CountryCode.NZ.rawValue {
                    objRegistration.strCountryCode = "2"
                }else {
                    objRegistration.strCountryCode = "1"
                }
                
                self.userDefault.set(self.nOtpNumber, forKey: RegistrationKeys.OtpNumber)
                saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
                self.isOtpSend = true
                self.conVwEmailLeading.constant = -self.view.frame.width
                self.vwScroll.setContentOffset(.zero, animated: true)
              
              
            }else {
                
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

//MARK: - Textfield Delegate

extension RegistrationEmailViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtMobileNumber || textField == txtMobileNumber {
            
            if textField == txtMobileNumber && range.location == 0 {
                if string == "0" {
                    return false
                }
            }
            
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}

struct RegistrationKeys {
    static let pageNumber = "RegistrationFillPage"
    static let OtpNumber = "OtpNumber"
    static let registrationUser = "RegistrationObject"
}
