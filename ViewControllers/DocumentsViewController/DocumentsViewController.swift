//
//  DocumentsViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 11/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SideMenuController
class DocumentsViewController: ParentViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,WWCalendarTimeSelectorProtocol {
    let picker = UIImagePickerController()
    
    @IBOutlet weak var txtDriverLicenceNumber: UITextField!
    
    
    @IBOutlet weak var txtNameOnUniqueId: UITextField!
    @IBOutlet weak var txtUniqIdCardExpiryDate: UITextField!
    @IBOutlet weak var txtCOF: UITextField!
    @IBOutlet weak var txtSPSLHolderName: UITextField!
    @IBOutlet weak var txtSpslNumber: UITextField!
    @IBOutlet weak var txtSpslCertificate: UITextField!
    @IBOutlet weak var txtCameraMake: UITextField!
    @IBOutlet weak var txtCameraSerial: UITextField!
    @IBOutlet weak var txtRegistration: UITextField!
    @IBOutlet weak var txtLatestCameraTest: UITextField!
    @IBOutlet weak var txtInsurancePolicy: UITextField!
    @IBOutlet weak var txtCertificationOfRegistration: UITextField!
    
    
    @IBOutlet weak var txtVisaExpiryDate: UITextField!
    @IBOutlet weak var txtLicenceExpiryDate: UITextField!
    @IBOutlet weak var vwEndorsementDate: UIView!
    @IBOutlet weak var vwImmigrationStatus: UIView!
    
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet var btnImages:[UIButton]!
    
    //IBOutlet Image Pick
    @IBOutlet weak var btnFrontCopy: UIButton!
    @IBOutlet weak var btnBackCopy: UIButton!
    
    @IBOutlet weak var btnUniqIdCardFront: UIButton!
    @IBOutlet weak var btnUniqIdCardBack: UIButton!
    @IBOutlet weak var btnCertificateExpiry: UIButton!
    @IBOutlet weak var btnVehiclRegistration: UIButton!
    @IBOutlet weak var btnAirportTarm: UIButton!
    
    @IBOutlet weak var btnVisaImage: UIButton!
    
    
    @IBOutlet weak var btnSpslCertificate: UIButton!
    @IBOutlet weak var btnCofLabel: UIButton!
    @IBOutlet weak var btnRegistrationLabel: UIButton!
    @IBOutlet weak var btnLatestCameraTestForm: UIButton!
    @IBOutlet weak var btnHoldSpsl: UIButton!
    @IBOutlet weak var btnInsurancePolicy: UIButton!
    @IBOutlet weak var btnSelectImmigration: UIButton!
    @IBOutlet weak var btnEndorcementDate: UIButton!
    
    
    @IBOutlet weak var vwSpslHolderName: UIStackView!
    @IBOutlet weak var vwSpslCertificate: UIStackView!
    
    @IBOutlet weak var vwStackExpiry: UIStackView!
    @IBOutlet weak var vwSpslNumber: UIStackView!
    
    
    
    @IBOutlet weak var imgVwVehicle: UIImageView!
    var selectedIndex = 0
    let arrImmigration = ["NZ Citizen","Permanent Resident","Work Visa"]
    

    var strVehicleImage = ""
    
    var strLicenceFrontUrl = ""
    var strLicenseBackUrl = ""
    var strUniqIdFrontUrl = ""
    var strUniqIdBackUrl = ""
    var strSpslCertifcateUrl = ""
    var strCofUrl = ""
    var strCertificateRegistrationUrl = ""
    var strVehicleRegistrationUrl = ""
    var strCameraTestUrl =  ""
    var strInsurancePolicyUrl = ""
    var strVisaExpiryUrl = ""
        
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Utilities.setCornerRadiusTextField(textField: txtDriverLicenceNumber, borderColor: UIColor.lightGray, bgColor: ThemeClearColor, textColor: UIColor.black)
//
//        Utilities.setCornerRadiusTextField(textField: txtNameOnUniqueId, borderColor: UIColor.lightGray, bgColor: ThemeClearColor, textColor: UIColor.black)
//
//        Utilities.setCornerRadiusTextField(textField: txtCertificationOfRegistration, borderColor: UIColor.lightGray, bgColor: ThemeClearColor, textColor: UIColor.black)
//
//
//        Utilities.setCornerRadiusTextField(textField: txtUniqIdCardExpiryDate, borderColor: UIColor.lightGray, bgColor: ThemeClearColor, textColor: UIColor.black)
//
//        Utilities.setCornerRadiusTextField(textField: txtSPSLHolderName, borderColor: UIColor.lightGray, bgColor: ThemeClearColor, textColor: UIColor.black)
//
//        Utilities.setCornerRadiusTextField(textField: txtSpslNumber, borderColor: UIColor.lightGray, bgColor: ThemeClearColor, textColor: UIColor.black)
//
//        Utilities.setCornerRadiusTextField(textField: txtSpslCertificate, borderColor: UIColor.lightGray, bgColor: ThemeClearColor, textColor: UIColor.black)
//
//        Utilities.setCornerRadiusTextField(textField: txtCOF, borderColor: UIColor.lightGray, bgColor: ThemeClearColor, textColor: UIColor.black)
//
//        Utilities.setCornerRadiusTextField(textField: txtRegistration, borderColor: UIColor.lightGray, bgColor: ThemeClearColor, textColor: UIColor.black)
//
//        Utilities.setCornerRadiusTextField(textField: txtCameraMake, borderColor: UIColor.lightGray, bgColor: ThemeClearColor, textColor: UIColor.black)
//
//        Utilities.setCornerRadiusTextField(textField: txtCameraSerial, borderColor: UIColor.lightGray, bgColor: ThemeClearColor, textColor: UIColor.black)
//
//
//        Utilities.setCornerRadiusTextField(textField: txtVisaExpiryDate, borderColor: UIColor.lightGray, bgColor: ThemeClearColor, textColor: UIColor.black)
//
//        Utilities.setCornerRadiusTextField(textField: txtLatestCameraTest, borderColor: UIColor.lightGray, bgColor: ThemeClearColor, textColor: UIColor.black)
//
//        Utilities.setCornerRadiusTextField(textField: txtInsurancePolicy, borderColor: UIColor.lightGray, bgColor: ThemeClearColor, textColor: UIColor.black)
        
        
        Utilities.setCornerRadiusButton(button: btnSubmit, borderColor: ThemeYellowColor, bgColor: ThemeYellowColor, textColor: UIColor.white)
        
//        Utilities.setCornerRadiusView(view: vwLicenseCopy, borderColor: UIColor.lightGray, bgColor: ThemeClearColor)
        
        Utilities.setCornerRadiusView(view: vwEndorsementDate, borderColor: UIColor.lightGray, bgColor: ThemeClearColor)
        
        Utilities.setCornerRadiusView(view: vwImmigrationStatus, borderColor: UIColor.lightGray, bgColor: ThemeClearColor)
        
        
        vwSpslHolderName.isHidden = !btnHoldSpsl.isSelected
        vwSpslNumber.isHidden = !btnHoldSpsl.isSelected
        vwSpslCertificate.isHidden = !btnHoldSpsl.isSelected
        
        vwStackExpiry.isHidden = true
        
        
        
        let mainDict = Singletons.sharedInstance.dictDriverProfile
        
        let profileDict = mainDict?["profile"] as? NSDictionary ?? NSDictionary()
        let vehicleDict = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "Vehicle") as! NSDictionary)
        let driverOtherDetails = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "DriverOtherDetails") as! NSDictionary)
        
        
        if vehicleDict.allKeys.count != 0 {
            if (vehicleDict["VehicleImage"] as? String ?? "" != "http://13.237.0.107/web/images/no-image.png") {
                if let strVehicleUrl = vehicleDict["VehicleImage"] as? String {
                    imgVwVehicle.sd_setImage(with: URL.init(string: strVehicleUrl), placeholderImage: UIImage.init(named: "iconPlaceholderCar"))
                }
            }
            
            if let strLicenceNumber = profileDict["DriverLicenceNumber"] as? String {
                txtDriverLicenceNumber.text = strLicenceNumber
            }
            
            if let strDriverExpiryDate = profileDict["DriverLicenseExpire"] as? String {
                txtLicenceExpiryDate.text = "\(strDriverExpiryDate)"
            }
            
            if let strDriverFrontImage = profileDict["DriverLicense"] as? String {
                btnFrontCopy.sd_setImage(with: URL.init(string: strDriverFrontImage), for: .normal)
            }
            
            if let strDriverBackImage = profileDict["DriverLicenceBack"] as? String {
                btnBackCopy.sd_setImage(with: URL.init(string: strDriverBackImage), for: .normal)
            }
            
            if let strNameOnUniqIDCard = driverOtherDetails["UniqueIDCardName"] as? String {
                txtNameOnUniqueId.text = strNameOnUniqIDCard
            }
            
            if let strUniqueIDDate =  driverOtherDetails["UniqueIDCardExpire"] as? String {
                txtUniqIdCardExpiryDate.text = strUniqueIDDate
            }
            
            if let strUniqIdFrontImage = driverOtherDetails["UniqueIDCard"] as? String {
                if strUniqIdFrontImage != "http://13.237.0.107/web/images/no-image.png"{
                    btnUniqIdCardFront.sd_setImage(with: URL.init(string: strUniqIdFrontImage), for: .normal)
                }
                
                
            }
            if let strBackUniqIDImage = driverOtherDetails["UniqueIDCardBack"] as? String {
                if strBackUniqIDImage != "http://13.237.0.107/web/images/no-image.png" {
                    btnUniqIdCardBack.sd_setImage(with: URL.init(string: strBackUniqIDImage), for: .normal)
                }
            }
            
            if let strHoldSPL = driverOtherDetails["HoldSPSLCertificate"] as? String {
                if strHoldSPL == "0" {
                    btnHoldSpsl.isSelected = false
                }else {
                    btnHoldSpsl.isSelected = true
                }
                vwSpslHolderName.isHidden = !btnHoldSpsl.isSelected
                vwSpslNumber.isHidden = !btnHoldSpsl.isSelected
                vwSpslCertificate.isHidden = !btnHoldSpsl.isSelected
            }else if let strHoldSPL = driverOtherDetails["HoldSPSLCertificate"] as? Int {
                if strHoldSPL == 0 {
                    btnHoldSpsl.isSelected = false
                }else {
                    btnHoldSpsl.isSelected = true
                }
                vwSpslHolderName.isHidden = !btnHoldSpsl.isSelected
                vwSpslNumber.isHidden = !btnHoldSpsl.isSelected
                vwSpslCertificate.isHidden = !btnHoldSpsl.isSelected
            }
            if let strSpslHolderName = driverOtherDetails["SPSLHolderName"] as? String {
                txtSPSLHolderName.text = strSpslHolderName
            }
            
            if let strSpslNumber =  driverOtherDetails["SPSLNumber"] as? String {
                txtSpslNumber.text = strSpslNumber
            }
            
            if let strSPSLCertificateUrl = driverOtherDetails["SPSLCertificate"] as? String {
                
                if strSPSLCertificateUrl != "http://13.237.0.107/web/images/no-image.png"{
                    btnSpslCertificate.sd_setImage(with: URL.init(string: strSPSLCertificateUrl), for: .normal)
                }
            }
            
            if let strCofLabelExpiry = driverOtherDetails["COFExpire"] as? String {
                txtCOF.text = strCofLabelExpiry
            }
            
            if let strCofUrl = driverOtherDetails["COF"] as? String {
                if strCofUrl != "http://13.237.0.107/web/images/no-image.png"{
                    btnCofLabel.sd_setImage(with: URL.init(string: strCofUrl), for: .normal)
                }
            }
            
            
            
            if let strCertificateOfRegistration = vehicleDict["RegistrationCertificate"] as? String {
                if strCertificateOfRegistration != "http://13.237.0.107/web/images/no-image.png"{
                    btnCertificateExpiry.sd_setImage(with: URL.init(string: strCertificateOfRegistration), for: .normal)
                }
            }
            if let strCertificateRegistrationExpire = vehicleDict["RegistrationCertificateExpire"] as? String {
                txtCertificationOfRegistration.text = strCertificateRegistrationExpire
            }
            
//            if let strVehicleRegistration = vehicleDict["VehicleRegistrationNo"] as? String {
//                txtRegistration.text = strVehicleRegistration
//            }
//
            if let strVehicleUrl = vehicleDict["VehicleRegistrationLabelImage"] as? String {
                if strVehicleUrl != "http://13.237.0.107/web/images/no-image.png"{
                    btnVehiclRegistration.sd_setImage(with: URL.init(string: strVehicleUrl), for: .normal)
                }
            }
            
            if let strCameraMakeModel = driverOtherDetails["CameraMake"] as? String {
                txtCameraMake.text = strCameraMakeModel
            }
            
            if let strCameraSerialNo = driverOtherDetails["CameraSerialNumber"] as? String {
//                if strCameraSerialNo != "http://13.237.0.107/web/images/no-image.png" {
//                    btnVehiclRegistration.sd_setImage(with: URL.init(string: strCameraSerialNo), for: .normal)
//                }
                txtCameraSerial.text = strCameraSerialNo
            }
            if let strLatestCameraExpire = driverOtherDetails["LatestCameraTestExpire"] as? String {
                txtLatestCameraTest.text = strLatestCameraExpire
            }
            
            if let strLatestCameraTestUrl = driverOtherDetails["LatestCameraTest"] as? String {
                if strLatestCameraTestUrl != "http://13.237.0.107/web/images/no-image.png" {
                    btnLatestCameraTestForm.sd_setImage(with: URL.init(string: strLatestCameraTestUrl), for: .normal)
                }
            }
            
            
            if let strInsuranceExpiry = vehicleDict["VehicleInsuranceCertificateExpire"] as? String {
                txtInsurancePolicy.text = strInsuranceExpiry
            }
            
            if let strVehicleInsuranceUrl = vehicleDict["VehicleInsuranceCertificate"] as? String {
                if strVehicleInsuranceUrl != "http://13.237.0.107/web/images/no-image.png" {
                    btnInsurancePolicy.sd_setImage(with: URL.init(string: strVehicleInsuranceUrl), for: .normal)
                }
            }
            
            if let strImmigrationStatus = driverOtherDetails["ImmigrationStatus"] as? String {
                
                if strImmigrationStatus == "0" {
                    btnSelectImmigration.setTitle(arrImmigration[0], for: .normal)
                }else if strImmigrationStatus == "1" {
                    btnSelectImmigration.setTitle(arrImmigration[1], for: .normal)
                }else if strImmigrationStatus == "2" {
                    btnSelectImmigration.setTitle(arrImmigration[2], for: .normal)
                }
                
                if strImmigrationStatus == "Work Visa" {
                    self.vwStackExpiry.isHidden = false
                }else {
                    self.vwStackExpiry.isHidden = true
                }
                self.view.layoutIfNeeded()
                
                
            }else if let strImmigrationStatus = driverOtherDetails["ImmigrationStatus"] as? Int {
                
                if strImmigrationStatus == 0 {
                    btnSelectImmigration.setTitle(arrImmigration[0], for: .normal)
                }else if strImmigrationStatus == 1 {
                    btnSelectImmigration.setTitle(arrImmigration[1], for: .normal)
                }else if strImmigrationStatus == 2 {
                    btnSelectImmigration.setTitle(arrImmigration[2], for: .normal)
                }
                
                if btnSelectImmigration.currentTitle == "Work Visa"  {
                    self.vwStackExpiry.isHidden = false
                }else {
                    self.vwStackExpiry.isHidden = true
                }
                self.view.layoutIfNeeded()
                
            }
            
            if let strAirportTarmTag = driverOtherDetails["AirpotTamsTag"] as? String {
                if strAirportTarmTag == "0" {
                    btnAirportTarm.isSelected = false
                }else {
                    btnAirportTarm.isSelected = true
                }
            }else if let strAirportTarmTag = driverOtherDetails["AirpotTamsTag"] as? Int {
                if strAirportTarmTag == 0 {
                    btnAirportTarm.isSelected = false
                }else {
                    btnAirportTarm.isSelected = true
                }
            }
            
            

//            SPSLCertificate = "http://13.237.0.107/web/images/driver/32/The-New-driver-license-5493222.jpg";
//            SPSLCertificateExpire = "0000-00-00";
//            SPSLHolderName = "";
//            SPSLNumber = "";
//            HoldSPSLCertificate = 0;
            
//            if let strUniqIDExpiryDate = driverOtherDetails["UniqueIDCardExpire"] as? String {
//                txtUniqIdCardExpiryDate.text = "Unique ID Card "
//            }
            
        }
            
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        objRegistration = loadRegistrationObject(withKey: RegistrationKeys.registrationUser)
//        if objRegistration != nil {
//
//            btnFrontCopy.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strLicenceFrontImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
//            btnBackCopy.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strLicenceBackImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
//            btnUniqIdCardFront.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strUniqueIdFrontImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
//            btnUniqIdCardBack.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strUniqueIdBackImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
//            btnSpslCertificate.sd_setImage(with: URL.init(string:WebserviceURLs.kImageBaseURL + objRegistration.strSpslCertificateImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
//            btnCofLabel.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strCofExpiryImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
//            btnCertificateExpiry.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strCertificateOfRegistrationExpiryImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
//            btnVehiclRegistration.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strVehicleRegistrationImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
//            btnLatestCameraTestForm.sd_setImage(with: URL.init(string:WebserviceURLs.kImageBaseURL + objRegistration.strLatestCameraTestImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
//            btnInsurancePolicy.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strInsurancePolicyImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
//
//
//            self.txtUniqIdCardExpiryDate.text = objRegistration.strUniquIdExpiryDate
//            self.txtCOF.text =  objRegistration.strCOFExpiryDate
//            self.txtCertificationOfRegistration.text = objRegistration.strCertificateOfRegistrationExpiryDate
//            self.txtRegistration.text = objRegistration.strVehicleRegistrationLabel
//            self.txtLatestCameraTest.text = objRegistration.strLatestCameraTestFrom
//            self.txtInsurancePolicy.text = objRegistration.strInsurancePolicy
//
//            if !objRegistration.strLicenceExpirationDate.isEmptyOrWhitespace() {
//                self.lblDriverExpiryDate.text = objRegistration.strLicenceExpirationDate
//
//            }
//            if  !objRegistration.strSelectImmigrationStatus.isEmptyOrWhitespace() {
//                btnSelectImmigration.setTitle(objRegistration.strSelectImmigrationStatus, for: .normal)
//            }
//            if txtVisaExpiryDate.text! == "Work Visa" {
//
//                vwStackExpiry.isHidden = false
//                btnVisaImage.sd_setImage(with: URL.init(string: objRegistration.strWorkVisaUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
//                txtVisaExpiryDate.text = objRegistration.strVisaExpiryDate
//            }
//
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
    @IBAction func endorcementClick(_ sender: UIButton) {
        let arr = ["Before 1 October 2017","Before 1 October 2017"]
        
        ActionSheetStringPicker.show(withTitle: "Select immigration Status", rows: arr, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
            self.btnEndorcementDate.setTitle(arr[index], for: .normal)
        }, cancel: { (actionSheet) in
            
        }, origin: self.view)
    }
    func changeDateFormat(_ formatedDate: String) -> String {
        let myDateFormatter: DateFormatter = DateFormatter()
        //        myDateFormatter.dateFormat = "yyyy/MM/dd"
        myDateFormatter.dateFormat = "dd-MM-yyyy"
        let date = myDateFormatter.date(from: formatedDate)
        
        myDateFormatter.dateFormat = "yyyy-MM-dd"
        let finalDate = myDateFormatter.string(from: date ?? Date())
        return finalDate
    }
    @IBAction func saveClick(_ sender: UIButton) {
        if txtDriverLicenceNumber.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter driver licence number.")
        }else if txtNameOnUniqueId.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter name on unique id.")
        }else if txtUniqIdCardExpiryDate.text!.isEmptyOrWhitespace() {
            self.showAlert("Please select unique id expiry date.")
        }else if btnHoldSpsl.isSelected && (txtSPSLHolderName.text!.isEmptyOrWhitespace() || txtSpslNumber.text!.isEmptyOrWhitespace() || btnSpslCertificate.currentImage == UIImage.init(named: "uploadPlaceholder")) {
            if txtSPSLHolderName.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter SPSL holder name.")
            }else if txtSpslNumber.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter SPSL number.")
            }else if btnSpslCertificate.currentImage == UIImage.init(named: "uploadPlaceholder") || btnSpslCertificate.currentImage == nil {
                self.showAlert("Please select SPSL Image.")
            }
            //            }else if txtSpslCertificate.text!.isEmptyOrWhitespace(){
            //                self.showAlert("Please select COF expiry date.")
            //            }
        }else if txtCOF.text!.isEmptyOrWhitespace() {
            self.showAlert("Please select COF expiry date.")
        }else if txtLatestCameraTest.text!.isEmptyOrWhitespace() {
            self.showAlert("Please select camera label expiry date.")
        }else if btnSelectImmigration.currentTitle ==  "Select Immigraton Status" {
            self.showAlert("Please select immigration type.")
        }else if btnSelectImmigration.currentTitle ==  "Work Visa" && (txtVisaExpiryDate.text!.isEmptyOrWhitespace() || btnVisaImage.currentImage == UIImage.init(named: "uploadPlaceholder")) {
            
            if txtVisaExpiryDate.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter Work visa expiry date.")
            }else if btnVisaImage.currentImage == UIImage.init(named: "uploadPlaceholder") || btnVisaImage.currentImage == nil {
                self.showAlert("Please select visa Image.")
            }
            //            }else if txtSpslCertificate.text!.isEmptyOrWhitespace(){
            //                self.showAlert("Please select COF expiry date.")
            //            }
        }else if txtCameraMake.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter camera make/model.")
        }else if txtCameraSerial.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter camera serial number.")
        }else {
            
            /*
             DriverId,DriverLicenceNumber,UniqueIDCardName,UniqueIDCardExpire,HoldSPSLCertificate,
             SPSLHolderName,SPSLNumber,
             COFExpire,LatestCameraTestExpire,
             ImmigrationStatus,WorkVisaExpire,CameraMake,
             CameraSerialNumber,AirpotTamsTag,PassengerEndorsement,AcceptHailWork
             
             
             == Optional ==
             DriverLicenceBack,DriverLicense,UniqueIDCard,UniqueIDCardBack,SPSLCertificate,COF,LatestCameraTest,WorkVisaImage,RegistrationCertificate,VehicleRegistrationLabelImage
             
             
             if textField == txtLicenceExpiryDate ||  textField == txtUniqIdCardExpiryDate ||  textField == txtCOF || textField == txtCertificationOfRegistration   || textField == txtLatestCameraTest || textField == txtInsurancePolicy || textField == txtVisaExpiryDate {
             self.selectDate(textField)
             return false
             }
             
             */
            
            let mainDict = Singletons.sharedInstance.dictDriverProfile
            
            let profileDict = mainDict?["profile"] as? NSDictionary ?? NSDictionary()
            let vehicleDict = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "Vehicle") as! NSDictionary)
            let driverOtherDetails = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "DriverOtherDetails") as! NSDictionary)
            
            var param = [String:AnyObject]()
            param["DriverId"] = Singletons.sharedInstance.strDriverID as AnyObject
            param["DriverLicenceNumber"] = txtDriverLicenceNumber.text as AnyObject
            param["DriverLicenseExpire"] = changeDateFormat(txtLicenceExpiryDate.text!) as AnyObject
            param["UniqueIDCardName"] = txtNameOnUniqueId.text as AnyObject
            
            param["UniqueIDCardExpire"] = changeDateFormat(txtUniqIdCardExpiryDate.text!) as AnyObject
            
            param["HoldSPSLCertificate"] = btnHoldSpsl.isSelected ? "1" as AnyObject : "0" as AnyObject
            param["SPSLHolderName"] = txtSPSLHolderName.text as AnyObject
            param["SPSLNumber"] = txtSpslNumber.text as AnyObject
            param["COFExpire"] = changeDateFormat(txtCOF.text!) as AnyObject
            param["LatestCameraTestExpire"] = changeDateFormat(txtLatestCameraTest.text!) as AnyObject
//            param["ImmigrationStatus"] = btnSelectImmigration.currentTitle as AnyObject
            param["VehicleInsuranceCertificateExpire"] = changeDateFormat(txtInsurancePolicy.text!) as AnyObject //change
            
            param["RegistrationCertificateExpire"] = changeDateFormat(txtCertificationOfRegistration.text!) as AnyObject
            if btnSelectImmigration.currentTitle == "NZ Citizen" {
                param["ImmigrationStatus"] = "0" as AnyObject
            }else if btnSelectImmigration.currentTitle == "Permanent Resident" {
                param["ImmigrationStatus"] = "1" as AnyObject
            }else if btnSelectImmigration.currentTitle == "Work Visa" {
                param["ImmigrationStatus"] = "2" as AnyObject
            }
            param["WorkVisaExpire"] = changeDateFormat(txtVisaExpiryDate.text!) as AnyObject
            param["CameraMake"] = txtCameraMake.text as AnyObject
            param["CameraSerialNumber"] = txtCameraSerial.text as AnyObject
            param["AirpotTamsTag"] = btnAirportTarm.isSelected ? "1" as AnyObject : "0" as AnyObject
            param["PassengerEndorsement"] = driverOtherDetails["PassengerEndorsement"] as? String as AnyObject
            
            if let strIsHailWork = driverOtherDetails["AcceptHailWork"] as? String {
                param["AcceptHailWork"] = strIsHailWork as AnyObject
            }else if let strIsHailWork = driverOtherDetails["AcceptHailWork"] as? Int {
                param["AcceptHailWork"] = strIsHailWork as AnyObject
            }
            
            if !strLicenseBackUrl.isEmptyOrWhitespace() {
                param["DriverLicenceBack"] = strLicenseBackUrl as AnyObject
            }
            
            if !strLicenceFrontUrl.isEmptyOrWhitespace() {
                param["DriverLicense"] = strLicenceFrontUrl as AnyObject
            }
            if !strUniqIdFrontUrl.isEmptyOrWhitespace() {
                param["UniqueIDCard"] = strUniqIdFrontUrl as AnyObject
            }
            if !strUniqIdBackUrl.isEmptyOrWhitespace() {
                param["UniqueIDCardBack"] = strUniqIdBackUrl as AnyObject
            }
            if !strSpslCertifcateUrl.isEmptyOrWhitespace() {
                param["SPSLCertificate"] = strSpslCertifcateUrl as AnyObject
            }
            if !strCofUrl.isEmptyOrWhitespace() {
                param["COF"] = strCofUrl as AnyObject
            }
            if !strCameraTestUrl.isEmptyOrWhitespace() {
                param["LatestCameraTest"] = strCameraTestUrl as AnyObject
            }
            if !strVisaExpiryUrl.isEmptyOrWhitespace() {
                param["WorkVisaImage"] = strVisaExpiryUrl as AnyObject
            }
            if !strCertificateRegistrationUrl.isEmptyOrWhitespace() {
                param["RegistrationCertificate"] = strCertificateRegistrationUrl as AnyObject
            }
            if !strVehicleRegistrationUrl.isEmptyOrWhitespace() {
                param["VehicleRegistrationLabelImage"] = strVehicleRegistrationUrl as AnyObject
            }
            
//            if !strInsurancePolicyUrl.isEmptyOrWhitespace() {
//            
//                param["VehicleInsuranceCertificate"] = strInsurancePolicyUrl as AnyObject
//            }
            
            
            webserviceUpdateAllDocuments(param as AnyObject) { (result, status) in
                if status {
                    print(result)
                    if let strMessage = result["message"] as? String{
                        Utilities.showAlertWithCompletion("", message: strMessage, vc: self, completionHandler: { (success) in
                            Singletons.sharedInstance.dictDriverProfile = NSMutableDictionary(dictionary: (result as! NSDictionary))
                            UserDefaults.standard.set(Singletons.sharedInstance.dictDriverProfile, forKey: driverProfileKeys.kKeyDriverProfile)
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                   
                }
            }
            
        }
        
        
        /*
        if txtDriverLicenceNumber.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter driver licence number.")
        }else if lblDriverExpiryDate.text!.isEmptyOrWhitespace() || lblDriverExpiryDate.text! == "Driver License (copy of front and back of licence)" {
            self.showAlert("Please select licence expiry date.")
        }else if btnFrontCopy.currentImage == UIImage.init(named: "uploadPlaceholder") || btnFrontCopy.currentImage == nil {
            self.showAlert("Please select driver licence front image.")
        }else if btnBackCopy.currentImage == UIImage.init(named: "uploadPlaceholder") || btnBackCopy.currentImage == nil {
            self.showAlert("Please select driver licence back image.")
        }else if txtNameOnUniqueId.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter name on unique id.")
        }else if txtUniqIdCardExpiryDate.text!.isEmptyOrWhitespace() {
            self.showAlert("Please select unique id expiry date.")
        }else if btnUniqIdCardFront.currentImage == UIImage.init(named: "uploadPlaceholder") || btnUniqIdCardFront.currentImage == nil {
            self.showAlert("Please select unique id front image.")
        }else if btnUniqIdCardBack.currentImage == UIImage.init(named: "uploadPlaceholder") || btnUniqIdCardBack.currentImage == nil {
            self.showAlert("Please select unique id back image.")
        }else if btnHoldSpsl.isSelected && (txtSPSLHolderName.text!.isEmptyOrWhitespace() || txtSpslNumber.text!.isEmptyOrWhitespace() || btnSpslCertificate.currentImage == UIImage.init(named: "uploadPlaceholder")) {
            if txtSPSLHolderName.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter SPSL holder name.")
            }else if txtSpslNumber.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter SPSL number.")
            }else if btnSpslCertificate.currentImage == UIImage.init(named: "uploadPlaceholder") || btnSpslCertificate.currentImage == nil {
                self.showAlert("Please select SPSL Image.")
            }
            //            }else if txtSpslCertificate.text!.isEmptyOrWhitespace(){
            //                self.showAlert("Please select COF expiry date.")
            //            }
        }else if txtCOF.text!.isEmptyOrWhitespace() {
            self.showAlert("Please select COF expiry date.")
        }else if btnCofLabel.currentImage == UIImage.init(named: "uploadPlaceholder") || btnCofLabel.currentImage == nil {
            self.showAlert("Please select COF label image.")
        }else if txtCertificationOfRegistration.text!.isEmptyOrWhitespace() {
            self.showAlert("Please select certificate of registration expiry date.")
        }else if btnVehiclRegistration.currentImage == UIImage.init(named: "uploadPlaceholder") || btnVehiclRegistration.currentImage == nil {
            self.showAlert("Please select vehicle registration label image.")
        }
            //        else if txtRegistration.text!.isEmptyOrWhitespace() {
            //            self.showAlert("Please select vehicle registration expiry date.")
            //        }
        else if txtCameraMake.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter camera make/model.")
        }else if txtCameraSerial.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter camera serial number.")
        }else if txtCameraSerial.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter camera serial number.")
        }else if txtLatestCameraTest.text!.isEmptyOrWhitespace() {
            self.showAlert("Please select camera label expiry date.")
        }else if btnLatestCameraTestForm.currentImage == UIImage.init(named: "uploadPlaceholder") || btnLatestCameraTestForm.currentImage == nil {
            self.showAlert("Please select camera label image.")
        }else if txtInsurancePolicy.text!.isEmptyOrWhitespace() {
            self.showAlert("Please select Insurance policy expiry date.")
        }else if btnInsurancePolicy.currentImage == UIImage.init(named: "uploadPlaceholder") || btnInsurancePolicy.currentImage == nil {
            self.showAlert("Please select insurance image.")
        }else if btnSelectImmigration.currentTitle ==  "Select Immigraton Status" {
            self.showAlert("Please select immigration type.")
        }else if btnSelectImmigration.currentTitle ==  "Work Visa" && (txtVisaExpiryDate.text!.isEmptyOrWhitespace() || btnVisaImage.currentImage == UIImage.init(named: "uploadPlaceholder")) {
            
            if txtVisaExpiryDate.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter Work visa expiry date.")
            }else if btnVisaImage.currentImage == UIImage.init(named: "uploadPlaceholder") || btnVisaImage.currentImage == nil {
                self.showAlert("Please select visa Image.")
            }
            //            }else if txtSpslCertificate.text!.isEmptyOrWhitespace(){
            //                self.showAlert("Please select COF expiry date.")
            //            }
        }else {
            
            objRegistration = loadRegistrationObject(withKey: RegistrationKeys.registrationUser)
            objRegistration.strLicenceNumber = txtDriverLicenceNumber.text!
            objRegistration.strLicenceExpirationDate = lblDriverExpiryDate.text!
            objRegistration.strUniqueIDCard = txtNameOnUniqueId.text!
            objRegistration.strUniquIdExpiryDate = txtUniqIdCardExpiryDate.text!
            objRegistration.isHoldSPSL = btnHoldSpsl.isSelected
            objRegistration.strSpslHolderName = txtSPSLHolderName.text!
            objRegistration.strSpslHolderNumber = txtSpslNumber.text!
            objRegistration.strEndorsementPassenger = btnEndorcementDate.currentTitle!
            objRegistration.strCOFExpiryDate = txtCOF.text!
            objRegistration.strCertificateOfRegistrationExpiryDate = txtCertificationOfRegistration.text!
            objRegistration.strVehicleRegistrationLabel = txtRegistration.text!
            objRegistration.strCameraMakeModel = txtCameraMake.text!
            objRegistration.strCameraSerialNumber = txtCameraSerial.text!
            objRegistration.strLatestCameraTestFrom = txtLatestCameraTest.text!
            objRegistration.strInsurancePolicy = txtInsurancePolicy.text!
            objRegistration.strSelectImmigrationStatus = btnSelectImmigration.currentTitle!
            objRegistration.isHoldSPSL = btnAirportTarm.isSelected
            
            objRegistration.isAirportTamTag = btnAirportTarm.isSelected
            objRegistration.strVisaExpiryDate = txtVisaExpiryDate.text!
            
            if txtVisaExpiryDate.text! == "Work Visa" {
                objRegistration.IsWorkVisa = true
            }else {
                objRegistration.IsWorkVisa = false
            }
            
            objRegistration.nFillPageNumber = 5.0
            
            saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
            
            let vwSuper = self.parent as! DriverRegistrationMainViewController
            vwSuper.changeContentOffset(5.0)
        }
        */
    }
    
    @IBAction func immigrationClick(_ sender: UIButton) {
        let arr = ["NZ Citizen","Permanent Resident","Work Visa"]
        
        ActionSheetStringPicker.show(withTitle: "Select Immigration Status", rows: arr, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
            self.btnSelectImmigration.setTitle(arr[index], for: .normal)
            let strTitle = arr[index]
            
            if strTitle == "Work Visa" {
                self.vwStackExpiry.isHidden = false
            }else {
                self.vwStackExpiry.isHidden = true
            }
            self.view.layoutIfNeeded()
//            objRegistration.strSelectImmigrationStatus = arr[index]
//            saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
            
            //            UIView.animate(withDuration: 0.3, animations: {
            //
            //            })
        }, cancel: { (actionSheet) in
            
        }, origin: self.view)
    }
    //MARK: - Custom Method
    func showAlert(_ strMessage: String) {
        Utilities.showAlert("", message: strMessage, vc: self)
    }
    
    
    
    var certiFicateDate = String()
    var selectedTextField = -1
    
    
    func openActionSheet() {
        self.view.endEditing(true)
        let imagePickerController : UIImagePickerController = UIImagePickerController.init()
        
        RMUniversalAlert.showActionSheet(in: self, withTitle: "Select Profile Picture", message: nil, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: ["Take a Photo","Choose from Gallery"], popoverPresentationControllerBlock:
            { (popover) in
                
                popover.sourceView = self.view
                popover.sourceRect = self.btnFrontCopy.frame
        })
        { (alert, buttonIndex) in
            if (buttonIndex == alert.cancelButtonIndex) {
                NSLog("Cancel Tapped");
            } else if (buttonIndex == 2) {
                print("UIImagePickerControllerSourceTypeCamera")
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                
                if(UIDevice .current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
                {
                    self.presentationController?.dismissalTransitionDidEnd(true)
                    self.picker .modalPresentationStyle = UIModalPresentationStyle.popover
                    let pop : UIPopoverPresentationController = self.picker.popoverPresentationController!
                    pop.sourceView = self.view
                    pop.sourceRect = self.btnFrontCopy.frame
                    pop.permittedArrowDirections = UIPopoverArrowDirection.any
                    self.present(self.picker, animated:true, completion: nil)
                }
                else
                {
                    imagePickerController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    
                }
                imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = true;
                imagePickerController.navigationBar.isTranslucent = false;
                imagePickerController.navigationBar.barTintColor = ThemeNaviBlueColor
                imagePickerController.navigationBar.tintColor = UIColor.white
                imagePickerController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
                self.present(imagePickerController, animated: true, completion: nil)
                
            }else {
                print("UIImagePickerControllerSourceTypePhotoLibrary")
                self.picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                if(UIDevice .current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
                {
                    self.presentationController?.dismissalTransitionDidEnd(true)
                    self.picker .modalPresentationStyle = UIModalPresentationStyle.popover
                    
                    let pop : UIPopoverPresentationController = self.picker.popoverPresentationController!
                    pop.sourceView = self.view
                    pop.sourceRect = self.btnFrontCopy.frame
                    pop.permittedArrowDirections = UIPopoverArrowDirection.any
                    self.present(self.picker, animated:true, completion: nil)
                } else {
                    imagePickerController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    
                }
                imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = true;
                imagePickerController.navigationBar.isTranslucent = false;
                imagePickerController.navigationBar.barTintColor = ThemeNaviBlueColor
                imagePickerController.navigationBar.tintColor = UIColor.white
                
                imagePickerController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
    }
    //MARK: - WWWCalendar Method
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date)
    {
        let myDateFormatter: DateFormatter = DateFormatter()
        //        myDateFormatter.dateFormat = "yyyy/MM/dd"
        myDateFormatter.dateFormat = "dd/MM/yyyy"
        let finalDate = myDateFormatter.string(from: date)
        
        // get the date string applied date format
        let mySelectedDate = String(describing: finalDate)
        certiFicateDate = mySelectedDate
        
        
        //        if imagePicked == 1 {
        //            lblDriverLicence.text = mySelectedDate as String
        //
        //        } else if imagePicked == 2 {
        //            lblAccreditation.text = mySelectedDate as String
        //
        //        } else if imagePicked == 3 {
        //            lblCarRegistraion.text = mySelectedDate as String
        //
        //        } else if imagePicked == 4 {
        //            lblVehicleInsurance.text = mySelectedDate as String
        //        }
        
        
    }
    //MARK: - Image Picker Delegates
    func uploadDocumentImage(_ chosenImage: UIImage) {
        
        var param = [String:AnyObject]()
        param["DriverId"] = Singletons.sharedInstance.strDriverID as AnyObject
        
        webserviceForEditDocumentImage( param as AnyObject , image: chosenImage, imageParamName: "Image") { (result, status) in
            print(result)
            if status {
                let strUrl = result["url"] as? String ?? ""
                if self.selectedIndex == 101 {
                    self.imgVwVehicle.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + strUrl))
                    self.strVehicleImage = strUrl
                }else {
                    self.btnImages[self.selectedIndex-1].sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + strUrl), for: .normal, completed: nil)
                    
                    if self.selectedIndex == 1 {
                        self.strLicenceFrontUrl =  strUrl
                    }else if self.selectedIndex == 2 {
                        self.strLicenseBackUrl =  strUrl
                    }else if self.selectedIndex == 3 {
                        self.strUniqIdFrontUrl =  strUrl
                    }else if self.selectedIndex == 4 {
                        self.strUniqIdBackUrl =  strUrl
                    }else if self.selectedIndex == 5 {
                        self.strSpslCertifcateUrl =  strUrl
                    }else if self.selectedIndex == 6 {
                        self.strCofUrl =  strUrl
                    }else if self.selectedIndex == 7 {
                        self.strCertificateRegistrationUrl =  strUrl
                    }else if self.selectedIndex == 8 {
                        self.strVehicleRegistrationUrl =  strUrl
                    }else if self.selectedIndex == 9 {
                        self.strCameraTestUrl =  strUrl
                    }else if self.selectedIndex == 10 {
                        self.strInsurancePolicyUrl =  strUrl
                    }else if self.selectedIndex == 11 {
                        self.strVisaExpiryUrl =  strUrl
                    }
                }
            }
        }
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let ChosenImage  = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            //            self.btnImages[selectedIndex-1].setImage(ChosenImage, for: .normal)
            
            self.uploadDocumentImage(ChosenImage)
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - IBOutlets
    @IBAction func uploadVehicleImageClick(_ sender: UIButton) {
        selectedIndex = 101
        self.openActionSheet()        
    }
    @IBAction func tamsClick(_ sender: UIButton) {
        btnAirportTarm.isSelected = !btnAirportTarm.isSelected
    }
    @IBAction func holdSPSLClick(_ sender: UIButton) {
        btnHoldSpsl.isSelected = !btnHoldSpsl.isSelected
        
        
        vwSpslHolderName.isHidden = !btnHoldSpsl.isSelected
        vwSpslNumber.isHidden = !btnHoldSpsl.isSelected
        vwSpslCertificate.isHidden = !btnHoldSpsl.isSelected
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func selectImageClick(_ sender: UIButton) {
        selectedIndex = sender.tag
        self.openActionSheet()
    }
    
    @IBAction func selectLicenceExpiryDate(_ sender: UIButton) {
//        self.view.endEditing(true)
//        let sheet =  ActionSheetDatePicker.init(title: "Select Date", datePickerMode: .date, selectedDate: Date(), doneBlock: { (actionSheet, date, obj) in
//            let myDateFormatter: DateFormatter = DateFormatter()
//            //        myDateFormatter.dateFormat = "yyyy/MM/dd"
//            myDateFormatter.dateFormat = "dd-MM-yyyy"
//            let finalDate = myDateFormatter.string(from: date as! Date)
//            self.lblDriverExpiryDate.text = finalDate
//
//            objRegistration.strLicenceExpirationDate = finalDate
//            saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
//        }, cancel: nil, origin: self.view)
//        sheet?.minimumDate = Date()
//
//        sheet?.show()
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        
        //        let viewHomeController =
        //            StroryBords.mainStoryBoard.instantiateViewController(withIdentifier: "HomeViewController")as? HomeViewController
        //
        //        let navController = NavigationRootViewController.init(rootViewController: viewHomeController!)
        //        navController.isNavigationBarHidden = true
        //        self.frostedViewController.contentViewController = navController
        
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! CustomSideMenuViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    @IBAction func frontImageClick(_ sender: Any) {
        
        
    }
    
    @IBAction func backImageClick(_ sender: Any) {
    }
    
    @IBAction func uniqeIDClick(_ sender: Any) {
        
    }
    @IBAction func spslCertificateClick(_ sender: Any) {
        
    }
    @IBAction func cofLabelClick(_ sender: Any) {
        
    }
    @IBAction func registrationLabelClick(_ sender: Any) {
        
    }
    @IBAction func latestCameraTestFormClick(_ sender: Any) {
        
    }
    @IBAction func insurancePolicyClick(_ sender: Any) {
        
    }
    
    func selectDate(_ textfield: UITextField) {
        self.view.endEditing(true)
        let sheet =  ActionSheetDatePicker.init(title: "Select Date", datePickerMode: .date, selectedDate: Date(), doneBlock: { (actionSheet, date, obj) in
            //            print(obj)
            let myDateFormatter: DateFormatter = DateFormatter()
            //        myDateFormatter.dateFormat = "yyyy/MM/dd"
            myDateFormatter.dateFormat = "dd-MM-yyyy"
            let finalDate = myDateFormatter.string(from: date as! Date)
            textfield.text! = finalDate
            
//            if textfield == self.txtUniqIdCardExpiryDate {
//                objRegistration.strUniquIdExpiryDate = textfield.text!
//            }else if textfield == self.txtCOF {
//                objRegistration.strCOFExpiryDate = textfield.text!
//            }else if textfield == self.txtCertificationOfRegistration {
//                objRegistration.strCertificateOfRegistrationExpiryDate = textfield.text!
//            }else if textfield == self.txtRegistration {
//                objRegistration.strVehicleRegistrationLabel = textfield.text!
//            }else if textfield == self.txtLatestCameraTest {
//                objRegistration.strLatestCameraTestFrom = textfield.text!
//            }else if textfield == self.txtInsurancePolicy {
//                objRegistration.strInsurancePolicy = textfield.text!
//            }else if textfield == self.txtVisaExpiryDate {
//                objRegistration.strVisaExpiryDate = textfield.text!
//            }
//            saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
            
        }, cancel: nil, origin: self.view)
        sheet?.minimumDate = Date()
        
        sheet?.show()
    }
    
}


extension DocumentsViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtLicenceExpiryDate ||  textField == txtUniqIdCardExpiryDate ||  textField == txtCOF || textField == txtCertificationOfRegistration   || textField == txtLatestCameraTest || textField == txtInsurancePolicy || textField == txtVisaExpiryDate {
            self.selectDate(textField)
            return false
        }else if textField ==  txtSpslCertificate || textField == txtRegistration {
            return false
        }
        
        //        let selector = WWCalendarTimeSelector.instantiate()
        //
        //        // 2. You can then set delegate, and any customization options
        //        //        selector.delegate = self
        //        selector.optionTopPanelTitle = "Please choose date"
        //             selector.delegate = self
        //        // 3. Then you simply present it from your view controller when necessary!
        //        self.present(selector, animated: true, completion: nil)
        
        return true
    }
}
