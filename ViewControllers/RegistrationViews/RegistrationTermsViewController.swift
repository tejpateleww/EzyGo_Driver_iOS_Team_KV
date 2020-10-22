//
//  RegistrationTermsViewController.swift
//  ezygo-Driver
//
//  Created by Apple on 19/12/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class RegistrationTermsViewController: UIViewController {
    
    @IBOutlet weak var txtNameOfCompanyTransportService: UITextField!
    @IBOutlet weak var txtDaysWorkedPerWeekTransportService: UITextField!
    @IBOutlet weak var txtHoursWorkedPerWeekTransportService: UITextField!
    
    
    @IBOutlet weak var vwNameOfCompanyTransportService: UIStackView!
    @IBOutlet weak var vwDaysWorkedPerWeekTransportService: UIStackView!
    
    @IBOutlet weak var vwHoursWorkedPerWeekTransportService: UIStackView!
    
    
    
    
    @IBOutlet weak var txtEmployeDetailsOtherPaid: UITextField!
    @IBOutlet weak var txtEmployeWorkedWeekOtherPaid: UITextField!
    @IBOutlet weak var txtHoursWorkedPerWeekOtherPaid: UITextField!
    
    
    @IBOutlet weak var vwEmployeDetailsOtherPaid: UIStackView!
    @IBOutlet weak var vwEmployeWorkedWeekOtherPaid: UIStackView!
    @IBOutlet weak var vwHoursWorkedPerWeekOtherPaid: UIStackView!
    
    
    
    
    @IBOutlet weak var txtOhterWorkDetailsSelfEmployed: UITextField!
    @IBOutlet weak var txtDaysPerWeekSelfEmployed: UITextField!
    @IBOutlet weak var txtHoursWorkedPerWeekSelfEmployed: UITextField!
    
    
    @IBOutlet weak var vwOhterWorkDetailsSelfEmployed: UIStackView!
    @IBOutlet weak var vwDaysPerWeekSelfEmployed: UIStackView!
    @IBOutlet weak var vwHoursWorkedPerWeekSelfEmployed: UIStackView!
    
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var btnOtherTransportService: UIButton!
    
    @IBOutlet weak var btnOtherPaidEmployment: UIButton!
    
    @IBOutlet weak var btnSelfEmployment: UIButton!
    
    @IBOutlet weak var btnHailWork: UIButton!
    @IBOutlet weak var btnLogmate: UIButton!
    
    @IBOutlet weak var btnYourMeter: UIButton!
    @IBOutlet weak var btnEzyGoMeter: UIButton!
    
    @IBOutlet weak var vwTaxiMeter: UIStackView!
    @IBOutlet weak var lblTermsAndCondition: UILabel!
    
    @IBOutlet weak var txtVwTermsCondition: UITextView!
    
    @IBOutlet weak var btnTermsCondition: UIButton!
//    private let kURLTermsAndConditions = "http://ezygo.co.nz/wp-content/uploads/2016/08/ezygo-terms-conditions-without-JavaScript.pdf"
//    private let kURLPrivacyPolicy = "http://ezygo.co.nz/wp-content/uploads/2016/08/ezygo-terms-conditions-without-JavaScript.pdf"
    private let kURLTermsAndConditions = "https://www.ezygo.co.nz/web/ezygo-terms-of-use-privacy.pdf"
    private let kURLPrivacyPolicy = "https://www.ezygo.co.nz/web/ezygo-terms-of-use-privacy.pdf"
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.allHides()
        Utilities.setCornerRadiusTextField(textField: txtNameOfCompanyTransportService, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtDaysWorkedPerWeekTransportService, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtHoursWorkedPerWeekTransportService, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        
        Utilities.setCornerRadiusTextField(textField: txtEmployeDetailsOtherPaid, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtEmployeWorkedWeekOtherPaid, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtHoursWorkedPerWeekOtherPaid, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        
        Utilities.setCornerRadiusTextField(textField: txtOhterWorkDetailsSelfEmployed, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtDaysPerWeekSelfEmployed, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtHoursWorkedPerWeekSelfEmployed, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        
        Utilities.setCornerRadiusButton(button: btnSubmit, borderColor: ThemeYellowColor, bgColor: ThemeYellowColor, textColor: ThemeWhiteColor)
        
        
        
        let str = "By signing up you agree to Ezygo Terms of Use and acknowledge that you have read the Privacy Policy."
        
        
        let attributedString = NSMutableAttributedString(string: str)
        let foundRange = attributedString.mutableString.range(of: "Terms of Use")
        attributedString.addAttribute(.link, value: self.kURLTermsAndConditions, range: foundRange)
        let foundRangePrivacyPolicy = attributedString.mutableString.range(of: "Privacy Policy")
        attributedString.addAttribute(.link, value: self.kURLPrivacyPolicy, range: foundRangePrivacyPolicy)
        
        let range = NSMakeRange(0,str.count)
        
        attributedString.addAttributes([
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.systemFont(ofSize: 12),
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white], range: range)
        
        self.txtVwTermsCondition.linkTextAttributes = [
            NSAttributedStringKey.font.rawValue : UIFont.systemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.underlineColor.rawValue: UIColor.lightGray,
            NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleSingle.rawValue]
        
        self.txtVwTermsCondition.attributedText = attributedString
        
        self.txtVwTermsCondition.delegate = self
        self.txtVwTermsCondition.dataDetectorTypes = .link
        self.txtVwTermsCondition.isEditable = false
        
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Button Event
    
    @IBAction func submitClick(_ sender: UIButton) {
      
        if btnOtherTransportService.isSelected && (txtNameOfCompanyTransportService.text!.isEmptyOrWhitespace() || txtDaysWorkedPerWeekTransportService.text!.isEmptyOrWhitespace() || txtHoursWorkedPerWeekTransportService.text!.isEmptyOrWhitespace()) {
            if txtNameOfCompanyTransportService.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter company name.")
            }else if txtDaysWorkedPerWeekTransportService.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter company working days per week.")
            }else if txtHoursWorkedPerWeekTransportService.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter company working hours per week.")
            }
        }else if btnOtherPaidEmployment.isSelected && (txtEmployeDetailsOtherPaid.text!.isEmptyOrWhitespace() || txtEmployeWorkedWeekOtherPaid.text!.isEmptyOrWhitespace() || txtHoursWorkedPerWeekOtherPaid.text!.isEmptyOrWhitespace()) {
            
            if txtEmployeDetailsOtherPaid.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter other company details.")
            }else if txtEmployeWorkedWeekOtherPaid.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter other company working days per week.")
            }else if txtHoursWorkedPerWeekOtherPaid.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter other company working hours per week.")
            }
            
        }else if btnSelfEmployment.isSelected && (txtOhterWorkDetailsSelfEmployed.text!.isEmptyOrWhitespace() || txtDaysPerWeekSelfEmployed.text!.isEmptyOrWhitespace() || txtHoursWorkedPerWeekSelfEmployed.text!.isEmptyOrWhitespace()) {
            if txtOhterWorkDetailsSelfEmployed.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter self company name.")
            }else if txtDaysPerWeekSelfEmployed.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter self company working days per week.")
            }else if txtHoursWorkedPerWeekSelfEmployed.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter self company working hours per week.")
            }
        }else if !btnTermsCondition.isSelected {
            self.showAlert("Please accept terms and condition.")
        }else if !btnEzyGoMeter.isSelected && !btnYourMeter.isSelected{
            self.showAlert("Please select one meter option.")
        }else {
            registrationApi()
        }
        
        
    }
    @IBAction func otherTransportServiceClick(_ sender: UIButton) {
        btnOtherTransportService.isSelected = !btnOtherTransportService.isSelected
        
        //        txtNameOfCompanyTransportService.isHidden = !btnOtherTransportService.isSelected
        //
        //        txtDaysWorkedPerWeekTransportService.isHidden = !btnOtherTransportService.isSelected
        //
        //        txtHoursWorkedPerWeekTransportService.isHidden = !btnOtherTransportService.isSelected
        
        
        vwNameOfCompanyTransportService.isHidden = !btnOtherTransportService.isSelected
        vwDaysWorkedPerWeekTransportService.isHidden = !btnOtherTransportService.isSelected
        
        vwHoursWorkedPerWeekTransportService.isHidden = !btnOtherTransportService.isSelected
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
    }
    @IBAction func otherPaidEmploymentClick(_ sender: UIButton) {
        btnOtherPaidEmployment.isSelected = !btnOtherPaidEmployment.isSelected
        
        //        txtEmployeDetailsOtherPaid.isHidden = !btnOtherPaidEmployment.isSelected
        //
        //        txtEmployeWorkedWeekOtherPaid.isHidden = !btnOtherPaidEmployment.isSelected
        //
        //        txtHoursWorkedPerWeekOtherPaid.isHidden = !btnOtherPaidEmployment.isSelected
        
        
        vwEmployeDetailsOtherPaid.isHidden = !btnOtherPaidEmployment.isSelected
        vwEmployeWorkedWeekOtherPaid.isHidden = !btnOtherPaidEmployment.isSelected
        vwHoursWorkedPerWeekOtherPaid.isHidden = !btnOtherPaidEmployment.isSelected
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func hailWorkClick(_ sender: UIButton) {
        btnHailWork.isSelected = !btnHailWork.isSelected
        
    }
    @IBAction func otherSelfEmploymentClick(_ sender: UIButton) {
        
        btnSelfEmployment.isSelected = !btnSelfEmployment.isSelected
        
        //        txtOhterWorkDetailsSelfEmployed.isHidden = !btnSelfEmployment.isSelected
        //
        //        txtDaysPerWeekSelfEmployed.isHidden = !btnSelfEmployment.isSelected
        //
        //        txtHoursWorkedPerWeekSelfEmployed.isHidden = !btnSelfEmployment.isSelected
        vwOhterWorkDetailsSelfEmployed.isHidden = !btnSelfEmployment.isSelected
        
        vwDaysPerWeekSelfEmployed.isHidden = !btnSelfEmployment.isSelected
        vwHoursWorkedPerWeekSelfEmployed.isHidden = !btnSelfEmployment.isSelected
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func meterInYourVehicleClick(_ sender: UIButton) {
        btnYourMeter.isSelected = !btnYourMeter.isSelected
        vwTaxiMeter.isHidden = btnYourMeter.isSelected
        btnEzyGoMeter.isSelected = false
    }
    
    @IBAction func ezygoTaxiMeterClick(_ sender: UIButton) {
        btnEzyGoMeter.isSelected = !btnEzyGoMeter.isSelected
    }
    @IBAction func btnTermsClick(_ sender: Any) {
        btnTermsCondition.isSelected = !btnTermsCondition.isSelected
    }
    @IBAction func btnLogmateClick(_ sender: Any) {
        btnLogmate.isSelected = !btnLogmate.isSelected
    }
    
    // MARK: - Custom method
    
    func showAlert(_ strMessage: String) {
        Utilities.showAlert("", message: strMessage, vc: self)
    }
    func allHides() {
        vwNameOfCompanyTransportService.isHidden = !btnOtherTransportService.isSelected
        vwDaysWorkedPerWeekTransportService.isHidden = !btnOtherTransportService.isSelected
        
        vwHoursWorkedPerWeekTransportService.isHidden = !btnOtherTransportService.isSelected
        
        
        vwEmployeDetailsOtherPaid.isHidden = !btnOtherPaidEmployment.isSelected
        vwEmployeWorkedWeekOtherPaid.isHidden = !btnOtherPaidEmployment.isSelected
        vwHoursWorkedPerWeekOtherPaid.isHidden = !btnOtherPaidEmployment.isSelected
        
        
        vwOhterWorkDetailsSelfEmployed.isHidden = !btnSelfEmployment.isSelected
        
        vwDaysPerWeekSelfEmployed.isHidden = !btnSelfEmployment.isSelected
        vwHoursWorkedPerWeekSelfEmployed.isHidden = !btnSelfEmployment.isSelected
        
    }
    func openUrlTermsOfUse() {
        //        Singletons.sharedInstance.selectedMenuSection = indexPath.section
        //        Singletons.sharedInstance.selectedMenuIndex = indexPath.row
        let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowTripViewController") as? ShowTripViewController
        viewController?.URLString = "https://www.ezygo.co.nz/web/ezygo-terms-of-use-privacy.pdf"
//        "http://ezygo.co.nz/wp-content/uploads/2016/08/ezygo-terms-conditions-without-JavaScript.pdf"
        self.navigationController?.pushViewController(viewController!, animated: true)
        //        frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
        //        frostedViewController.hideMenuViewController()
    }
    //MARK: - Show Picker
    func showWeekDays(_ textfield: UITextField) {
        self.view.endEditing(true)
        let arr = ["1","2","3","4","5","6","7"]
        
        ActionSheetStringPicker.show(withTitle: "Select days worked per week", rows: arr, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
            //            self.btnNoOfPassanger.setTitle(arr[index], for: .normal)
            
            textfield.text = arr[index]
        }, cancel: { (actionSheet) in
            
        }, origin: self.view)
        
    }
    func showWeekHours(_ textfield: UITextField) {
        self.view.endEditing(true)
        
        var integerArray = [Int]()
        for i in 1...168 {
            integerArray.append(i)
        }
        
        ActionSheetStringPicker.show(withTitle: "Select hours worked per week", rows: integerArray, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
            
            textfield.text = String("\(integerArray[index])")
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
    //MARK: - Call API
    func registrationApi() {
        var param = [String:AnyObject]()
        
        /*
         Email,Fullname,MobileNo,Gender,Password,Address,Suburb,City,Country,Zipcode,Lat,Lng,DeviceType,Token,DriverLicense,DriverLicenceBack,DriverLicenseExpire,GSTNumberRegistered( Yes=1,No=0),GSTNumber,GSTRegistrationName
         PaymentCollectionType(1 = Collect from office or 2= transfer to account ) ,
         AccountHolderName,BankName,BankAcNo,
         VehicleClass,VehicleColor,CompanyModel,VehicleRegistrationNo,
         VehicleOwnerName,YearOfManufacture,
         CarRegistrationCertificate
         ,VehicleRegistrationLabelImage,
         VehicleInsuranceCertificate,
         RegistrationCertificateExpire,VehicleInsuranceCertificateExpire,
         
         
         
         
         VehicleImage,VehicleModelName,
         
         NoOfPassenger,
         DriverLicenceNumber,
         
         HomeNumber,RelativeFullName,Relationship,
         
         
         RelativeMobileNo,
         
         UniqueIDCardName,
         UniqueIDCard,UniqueIDCardBack,
         
         UniqueIDCardExpire,
         
         
         
         HoldSPSLCertificate( Yes=1,No=0),SPSLCertificate,SPSLHolderName, SPSLNumber,COF,COFExpire,
         PassengerEndorsement(before or after)LatestCameraTest,LatestCameraTestExpire,CameraMake,CameraSerialNumber,AirpotTamsTag( Yes=1,No=0),TransportServices( Yes=1,No=0),TransportServicesCompanyName,DaysWorkedPerWeek,HoursWorkedPerWeek,OtherEmployement( Yes=1,No=0), OtherEmployementCompanyName, OtherEmployementDaysWorkedPerWeek,OtherEmployementHoursWorkedPerWeek,SelfEmployement( Yes=1,No=0) ,SelfEmployementWorkDetails , SelfEmployementDaysWorkedPerWeek,SelfEmployementHoursWorkedPerWeek,
         ImmigrationStatus(0=NZ Citizen 1=Permanent Resident 2=WorkVisa),WorkVisaImage,WorkVisaExpire,AcceptHailWork(Yes- 1 or No-2),Logmate(Yes- 1 or No-0)
         
         ReferralCode,Image,BSB
         
         */
        
        
        
        param["Email"] = objRegistration.strEmail as AnyObject
        param["Fullname"] = objRegistration.strFirstName + " " + objRegistration.strLastName  as AnyObject
        
        if objRegistration.strCountryCode == "2" {
            param["MobileNo"] = "64" + objRegistration.strMobileNo as AnyObject
        }else {
            param["MobileNo"] = "61" + objRegistration.strMobileNo as AnyObject
        }
        
        param["Gender"] = objRegistration.strGender as AnyObject
        param["Password"] = objRegistration.strPassword as AnyObject
        param["Address"] = objRegistration.strStreetAddress as AnyObject
        param["Suburb"] = objRegistration.strSuburb as AnyObject
        param["City"] = objRegistration.strCity as AnyObject
        param["Country"] = objRegistration.strCountry as AnyObject
        param["Zipcode"] = objRegistration.strPostCode as AnyObject
        
        param["Lat"] = Singletons.sharedInstance.latitude as AnyObject
        param["Lng"] = Singletons.sharedInstance.longitude as AnyObject
        
        param["DeviceType"] = "1" as AnyObject
        param["Token"] = Singletons.sharedInstance.deviceToken as AnyObject
        
        
        //licence details
        param["DriverLicense"] = objRegistration.strLicenceFrontImageUrl as AnyObject
        param["DriverLicenceBack"] = objRegistration.strLicenceBackImageUrl as AnyObject
        param["DriverLicenseExpire"] = changeDateFormat(objRegistration.strLicenceExpirationDate)  as AnyObject
        param["GSTNumberRegistered"] = (objRegistration.isRegisteredForGst) ? "1" as AnyObject : "0" as AnyObject
        
        if objRegistration.isRegisteredForGst {
            param["GSTNumber"] = objRegistration.strGstnumber as AnyObject
            param["GSTRegistrationName"] = objRegistration.strGstRegistrationName as AnyObject
            
        }
        param["PaymentCollectionType"] = objRegistration.isColllectFromOffice ? "1" as AnyObject : "2" as AnyObject
        
        param["AccountHolderName"] = objRegistration.strAccountHolder as AnyObject
        param["BankName"] = objRegistration.strBankName as AnyObject
        
        param["BankAcNo"] = objRegistration.strAccountNumber as AnyObject
        param["BSB"] = objRegistration.strBankBranch as AnyObject
        
        if objRegistration.strVehicleType == "Standard" {
               param["VehicleClass"] = "1" as AnyObject
        }else if objRegistration.strVehicleType == "Premium" {
               param["VehicleClass"] = "2" as AnyObject
        }else {
               param["VehicleClass"] = "3" as AnyObject
        }
     
        param["VehicleColor"] = objRegistration.strVehicleColor as AnyObject
        param["CompanyModel"] = objRegistration.strVehicleModel as AnyObject
        param["VehicleRegistrationNo"] = objRegistration.strVehiclePlateNumber as AnyObject
        param["VehicleOwnerName"] = objRegistration.strVehicleOwnerFullName as AnyObject
        
        
        param["YearOfManufacture"] = objRegistration.strVehicleManufactureYear as AnyObject
        
        param["CarRegistrationCertificate"] = objRegistration.strCertificateOfRegistrationExpiryImageUrl as AnyObject //Doubt
        
        param["VehicleRegistrationLabelImage"] = objRegistration.strVehicleRegistrationImageUrl as AnyObject
        
        param["VehicleInsuranceCertificate"] = objRegistration.strInsurancePolicyImageUrl as AnyObject //Doubt
        param["RegistrationCertificateExpire"] = changeDateFormat(objRegistration.strCertificateOfRegistrationExpiryDate)  as AnyObject
        
        param["VehicleInsuranceCertificateExpire"] = changeDateFormat(objRegistration.strInsurancePolicy) as AnyObject
        
        param["VehicleImage"] = objRegistration.strVehicleImageUrl as AnyObject
        param["VehicleModelName"] = objRegistration.strVehicleModel as AnyObject
        
        param["NoOfPassenger"] = objRegistration.strNoOfPassenger as AnyObject
        
        param["DriverLicenceNumber"] = objRegistration.strLicenceNumber as AnyObject
        
        param["HomeNumber"] = objRegistration.strLandLineNumber as AnyObject
        
        param["RelativeLandlineNumber"] = objRegistration.strKinLandlineNumber as AnyObject
        
        param["RelativeFullName"] = objRegistration.strKinFirstName + objRegistration.strKinFirstName as AnyObject
        
        param["Relationship"] = objRegistration.strRelationshipWithKin as AnyObject
        
        if objRegistration.strKinCountryCode == "2" {
            param["RelativeMobileNo"] = "64" + objRegistration.strKinMobileNumber as AnyObject
        }else {
            param["RelativeMobileNo"] = "61" + objRegistration.strKinMobileNumber as AnyObject
        }
//        param["RelativeMobileNo"] = objRegistration.strKinMobileNumber as AnyObject
        
        param["UniqueIDCardName"] = objRegistration.strUniqueIDCard as AnyObject
        
        param["UniqueIDCard"] = objRegistration.strUniqueIdFrontImageUrl as AnyObject
        param["UniqueIDCardBack"] = objRegistration.strUniqueIdBackImageUrl as AnyObject
        param["UniqueIDCardExpire"] = changeDateFormat(objRegistration.strUniquIdExpiryDate)  as AnyObject
        
        param["HoldSPSLCertificate"] = objRegistration.isHoldSPSL ? "1" as AnyObject : "0" as AnyObject
        
        param["SPSLCertificate"] = objRegistration.strSpslCertificateImageUrl as AnyObject
        
        param["SPSLHolderName"] = objRegistration.strSpslHolderName as AnyObject
        param["SPSLNumber"] = objRegistration.strSpslHolderNumber as AnyObject
        
        
        param["COF"] = objRegistration.strCofExpiryImageUrl as AnyObject
        param["COFExpire"] = changeDateFormat(objRegistration.strCOFExpiryDate)  as AnyObject
        
        param["PassengerEndorsement"] = (objRegistration.strEndorsementPassenger ==  "Before 1 October 2017") ? "before" as AnyObject : "after" as AnyObject
        
        param["LatestCameraTest"] = objRegistration.strLatestCameraTestImageUrl as AnyObject
        param["LatestCameraTestExpire"] = changeDateFormat(objRegistration.strLatestCameraTestFrom)  as AnyObject
        
        param["CameraMake"] = objRegistration.strCameraMakeModel as AnyObject
        param["CameraSerialNumber"] = objRegistration.strCameraSerialNumber as AnyObject
        
        param["AirpotTamsTag"] = objRegistration.isAirportTamTag ? "1" as AnyObject : "0" as AnyObject
        
        
        param["TransportServices"] = btnOtherTransportService.isSelected ? "1" as AnyObject : "0" as AnyObject
        param["TransportServicesCompanyName"] = txtNameOfCompanyTransportService.text! as AnyObject
        param["DaysWorkedPerWeek"] = txtDaysWorkedPerWeekTransportService.text! as AnyObject
        param["HoursWorkedPerWeek"] = txtHoursWorkedPerWeekTransportService.text! as AnyObject
        
        param["OtherEmployement"] = btnOtherPaidEmployment.isSelected ? "1" as AnyObject : "0" as AnyObject
        param["OtherEmployementCompanyName"] = txtEmployeDetailsOtherPaid.text! as AnyObject
        param["OtherEmployementDaysWorkedPerWeek"] = txtEmployeWorkedWeekOtherPaid.text! as AnyObject
        param["OtherEmployementHoursWorkedPerWeek"] = txtHoursWorkedPerWeekOtherPaid.text! as AnyObject
        
        
        param["SelfEmployement"] = btnSelfEmployment.isSelected ? "1" as AnyObject : "0" as AnyObject
        
        param["SelfEmployementWorkDetails"] = txtOhterWorkDetailsSelfEmployed.text! as AnyObject
        param["SelfEmployementDaysWorkedPerWeek"] = txtDaysPerWeekSelfEmployed.text! as AnyObject
        param["SelfEmployementHoursWorkedPerWeek"] = txtHoursWorkedPerWeekSelfEmployed.text as AnyObject
        
       param["TaxiMeter"] = btnYourMeter.isSelected ? "1" as AnyObject : "0" as AnyObject
       param["EzygoTaxiMeter"]   = btnYourMeter.isSelected ? "0" as AnyObject : btnEzyGoMeter.isSelected ? "1" as AnyObject : "0" as AnyObject
        
        if objRegistration.strSelectImmigrationStatus == "NZ Citizen" {
            param["ImmigrationStatus"] = "0" as AnyObject
        }else if objRegistration.strSelectImmigrationStatus == "Permanent Resident" {
            param["ImmigrationStatus"] = "1" as AnyObject
        }else if objRegistration.strSelectImmigrationStatus == "Work Visa" {
            param["ImmigrationStatus"] = "2" as AnyObject
        }
        
        
        //       param["WorkVisaImage"] = "ass"  as AnyObject //doubt
        //
        //        param["WorkVisaExpire"] = "ass"  as AnyObject //doubt
        
        param["AcceptHailWork"] = btnHailWork.isSelected ? "1" as AnyObject : "0"  as AnyObject
        param["Logmate"] = btnLogmate.isSelected ? "1" as AnyObject : "0" as AnyObject
        
        param["ReferralCode"] = objRegistration.strInviteCode as AnyObject
        
        param["Image"] = objRegistration.strProfileImageUrl as AnyObject
        
        param["WorkVisaImage"] = objRegistration.strWorkVisaUrl as AnyObject
        
        param["WorkVisaExpire"] = changeDateFormat(objRegistration.strVisaExpiryDate) as AnyObject
        
        //        HoldSPSLCertificate( Yes=1,No=0),SPSLCertificate,SPSLHolderName, SPSLNumber,
        
        //COF,COFExpire,
        //        PassengerEndorsement(before or after)LatestCameraTest,LatestCameraTestExpire,
        
        //        CameraMake,CameraSerialNumber,AirpotTamsTag( Yes=1,No=0),TransportServices( Yes=1,No=0),TransportServicesCompanyName,DaysWorkedPerWeek,HoursWorkedPerWeek,OtherEmployement( Yes=1,No=0), OtherEmployementCompanyName, OtherEmployementDaysWorkedPerWeek,OtherEmployementHoursWorkedPerWeek,
        
        //            SelfEmployement( Yes=1,No=0) ,SelfEmployementWorkDetails , SelfEmployementDaysWorkedPerWeek,SelfEmployementHoursWorkedPerWeek,
        
        
        //        ImmigrationStatus(0=NZ Citizen 1=Permanent Resident 2=WorkVisa),WorkVisaImage,WorkVisaExpire,AcceptHailWork(Yes- 1 or No-2),Logmate(Yes- 1 or No-0)
        //
        //        ReferralCode,Image,BSB
        
        //
        
        webserviceForRegistrationForDriver(param as AnyObject) { (result, status) in
            print(result)
            if status {
                
                UserDefaults.standard.removeObject(forKey: RegistrationKeys.registrationUser)

                Utilities.showAlertWithCompletion("", message: result["message"] as? String ?? "Registraion successfully", vc: self, completionHandler: { (success) in
                    self.navigationController?.popViewController(animated: true)
                })
                
 
                
//                if ((result as! NSDictionary).object(forKey: "status") as! Int == 1) {
//                    Singletons.sharedInstance.dictDriverProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
//                    Singletons.sharedInstance.isDriverLoggedIN = true
//
//                    UserDefaults.standard.set(Singletons.sharedInstance.dictDriverProfile, forKey: driverProfileKeys.kKeyDriverProfile)
//                    UserDefaults.standard.set(true, forKey: driverProfileKeys.kKeyIsDriverLoggedIN)
//
//                    Singletons.sharedInstance.strDriverID = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "Vehicle") as! NSDictionary).object(forKey: "DriverId")) as! String
//
//                    Singletons.sharedInstance.driverDuty = (Singletons.sharedInstance.dictDriverProfile.object(forKey: "DriverDuty") as! String)
//                    //                    Singletons.sharedInstance.showTickPayRegistrationSceeen =
//
//                    let profileData = Singletons.sharedInstance.dictDriverProfile
//
//                    if let currentBalance = (profileData?.object(forKey: "profile") as! NSDictionary).object(forKey: "Balance") as? Double
//                    {
//                        Singletons.sharedInstance.strCurrentBalance = currentBalance
//                    }
//                    let next = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! CustomSideMenuViewController
//                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//                    self.navigationController?.pushViewController(next, animated: true)
//                }
            }else {
                let arrMessage = result["message"] as? NSArray ?? NSArray()
                if arrMessage.count != 0 {
                    self.showAlert(arrMessage[0] as? String ?? "Something wrong")
                }
            }
        }
        
    }
}

extension RegistrationTermsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if (URL.absoluteString == kURLTermsAndConditions) {
            
//            openUrlTermsOfUse()
//            strURL = URL.absoluteString
//            self.performSegue(withIdentifier: "segueTermsAndConditions", sender: nil)
        }
        else if (URL.absoluteString == kURLPrivacyPolicy) {
//            strURL = URL.absoluteString
//            self.performSegue(withIdentifier: "seguePrivacyPolicy", sender: nil)
//            openUrlTermsOfUse()
        }
        return true
    }
}
extension RegistrationTermsViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtDaysWorkedPerWeekTransportService || textField == txtEmployeWorkedWeekOtherPaid  || textField == txtDaysPerWeekSelfEmployed {
            self.showWeekDays(textField)
            return false
        }else if  textField == txtHoursWorkedPerWeekTransportService || textField == txtHoursWorkedPerWeekOtherPaid  || textField == txtHoursWorkedPerWeekSelfEmployed {
            self.showWeekHours(textField)
            return false
        }
        return true
    }
   
}
