//
//  UpdateProfileViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 11/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import IQDropDownTextField
import ActionSheetPicker_3_0
import Sheeeeeeeeet
class UpdateProfileViewController: ParentViewController,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
   
   
    @IBOutlet var imgProfilePic: UIImageView!
    let picker = UIImagePickerController()
    var  imgUpdatedProfilePic = UIImage()
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var txtFirstName: ACFloatingTextfield!
    
    @IBOutlet weak var txtUserLandLineNumber: ACFloatingTextfield!
    
    @IBOutlet weak var txtSuburb: ACFloatingTextfield!
    @IBOutlet weak var txtPostCode: ACFloatingTextfield!
    @IBOutlet weak var txtUserCountry: ACFloatingTextfield!
    
    @IBOutlet weak var txtCity: ACFloatingTextfield!
    
    @IBOutlet weak var txtRelativeMobile: ACFloatingTextfield!
    @IBOutlet weak var txtCountryCode: ACFloatingTextfield!
    @IBOutlet weak var txtGSTRegName: ACFloatingTextfield!
    @IBOutlet weak var txtGSTNumber: ACFloatingTextfield!
    
    @IBOutlet weak var txtRelationship: IQDropDownTextField!
    
    @IBOutlet weak var txtRelativeName: ACFloatingTextfield!
    
    @IBOutlet var txtKinMobileNumber: UITextField!
    @IBOutlet var txtKinLandlineNumber: UITextField!
    
    var strGender = String()
    @IBOutlet var txtAddress: ACFloatingTextfield!
    @IBOutlet var txtBirthDate: IQDropDownTextField!
    @IBOutlet var btnMale: RadioButton!
    @IBOutlet var btnFemale: RadioButton!
    
    @IBOutlet var btnChangePassword: UIButton!
    @IBOutlet var btnRegisterForGst: UIButton!
    
    @IBOutlet weak var vwGstNumber: UIView!
    @IBOutlet weak var vwGstRegistration: UIView!
    //Kin Details
    @IBOutlet var vwRealationshipWithKin: UIView!
    
    @IBOutlet var btnRelationshipWithKin: UIButton!

    @IBOutlet var lblCountryCode: UILabel!
    
    @IBOutlet var imgVwFlag: UIImageView!
    var strDriverImageUrl = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.btnMale.isSelected = true
        txtBirthDate.dropDownMode = .datePicker
        txtBirthDate.dateFormatter?.dateFormat = "yyyy-MM-dd"
        txtBirthDate.datePicker.maximumDate = Date()
        Utilities.setCornerRadiusView(view: vwRealationshipWithKin, borderColor: UIColor.lightGray, bgColor: ThemeClearColor)
        
//        let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
//     
//        txtCountryCode.leftView = cpv
//        txtCountryCode.leftViewMode = .always
        
//        cpv.delegate = self
//        cpv.dataSource = self
        
//        [cpv].forEach {
//            $0?.dataSource = self
//        }
//        arr.append(Country.ini)
//        cpv.showCountriesList(from: self)
        setData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = false
        /*
        if self.navigationController?.childViewControllers.count == 1
        {
            Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Update Profile", naviTitleImage: "", leftImage: kBack_Icon, rightImage: "")
//            self.frostedViewController.panGestureEnabled = true
        }
        else
        {
            Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Update Profile", naviTitleImage: "", leftImage: kBack_Icon, rightImage: "")
//            self.frostedViewController.panGestureEnabled = false
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        */

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.size.width / 2
        self.imgProfilePic.clipsToBounds = true
        Utilities.setCornerRadiusButton(button: btnChangePassword, borderColor: UIColor.groupTableViewBackground, bgColor: UIColor.groupTableViewBackground, textColor: UIColor.black)
        Utilities.setCornerRadiusButton(button: btnSave, borderColor: ThemeYellowColor, bgColor: ThemeYellowColor, textColor: ThemeWhiteColor)
    }

  
    func setData() {
        
        let profileData = Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as? NSDictionary
        let vehicleDict = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "Vehicle") as! NSDictionary)
        let driverOtherDetails = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "DriverOtherDetails") as! NSDictionary)
        
        
        lblName.text = profileData?.object(forKey: "Fullname") as? String
        lblEmail.text = profileData?.object(forKey: "Email") as? String
        txtUserLandLineNumber.text = driverOtherDetails.object(forKey: "HomeNumber") as? String
        
        txtFirstName.text = profileData?.object(forKey: "Fullname") as? String
        txtAddress.text = profileData?.object(forKey: "Address") as? String
        txtSuburb.text = profileData?.object(forKey: "SubUrb") as? String
        txtPostCode.text = profileData?.object(forKey: "ZipCode") as? String
        txtUserCountry.text = profileData?.object(forKey: "Country") as? String
        txtCity.text = profileData?.object(forKey: "City") as? String
        
        
        
        if  !(driverOtherDetails.object(forKey: "RelativeMobileNo") as! String).isEmptyOrWhitespace() {
            let txtRelativeMobile = driverOtherDetails.object(forKey: "RelativeMobileNo") as! String
            let strCountryCode = txtRelativeMobile.prefix(2)
            
            if strCountryCode == "64" {
                self.lblCountryCode.text = CountryCode.NZ.rawValue
                self.imgVwFlag.image = UIImage.init(named: "NZ")
            }else {
                self.lblCountryCode.text = CountryCode.Au.rawValue
                self.imgVwFlag.image = UIImage.init(named: "AU")
            }
            
            if txtRelativeMobile.count > 2 {
                let strFinalRelativeNumber = txtRelativeMobile.substring(from: 2)
                txtKinMobileNumber.text = strFinalRelativeNumber
            }
       
        }
      
        txtKinLandlineNumber.text = driverOtherDetails.object(forKey: "RelativeLandlineNumber") as? String
        
        var isGstRegistered = false
        if let strGstRegistered = profileData?.object(forKey: "GSTNumberRegistered") as? String {
            isGstRegistered  = (strGstRegistered == "0") ? false : true
        }else if let strGstRegistered = profileData?.object(forKey: "GSTNumberRegistered") as? Int {
            isGstRegistered = strGstRegistered == 0 ? false : true
        }
        
        if isGstRegistered == false {
            btnRegisterForGst.isSelected = false
            vwGstRegistration.isHidden = true
            vwGstNumber.isHidden = true
        }else {
            btnRegisterForGst.isSelected = true
            vwGstRegistration.isHidden = false
            vwGstNumber.isHidden = false
            txtGSTNumber.text = profileData?.object(forKey: "GSTNumber") as? String
            txtGSTRegName.text = profileData?.object(forKey: "GSTRegistrationName") as? String
            
        }
        
        
        let gender = profileData?.object(forKey: "Gender") as? String
        if let imgUrl = profileData?.object(forKey: "Image") {
            imgProfilePic.sd_setImage(with: URL(string: imgUrl as! String), placeholderImage: UIImage.init(named: "placeHolderProfile"))
        }
        
        strGender = gender ?? "Male"
        if strGender == "Female" {
            btnFemale.isSelected = true
            btnMale.isSelected = false
        }
        else {
            btnMale.isSelected = true
            btnFemale.isSelected = false
        }
        
//        let dob = profileData?.object(forKey: "DOB") as? String
        
        txtRelativeName.text = driverOtherDetails.object(forKey: "RelativeFullName") as? String
        let strRelationShipWithKin = driverOtherDetails.object(forKey: "Relationship") as? String
        
        if !strRelationShipWithKin!.isEmptyOrWhitespace() {
            btnRelationshipWithKin.setTitle(strRelationShipWithKin, for: .normal)
        }
    }
 
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
    //MARK: - Custom Method
    func showAlert(_ strMessage: String) {
        Utilities.showAlert("", message: strMessage, vc: self)
    }
    //MARK: - Image Picker Delegates
    func uploadDocumentImage(_ chosenImage: UIImage) {
        
        var param = [String:AnyObject]()
        param["DriverId"] = Singletons.sharedInstance.strDriverID as AnyObject
        
        webserviceForEditDocumentImage( param as AnyObject , image: chosenImage, imageParamName: "Image") { (result, status) in
            print(result)
            if status {
                let strUrl = result["url"] as? String ?? ""
                self.strDriverImageUrl = strUrl
//                self.imgProfilePic.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + strUrl))
                self.imgProfilePic.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + strUrl), placeholderImage: UIImage.init(named: "placeHolderProfile"))
            }
        }
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let ChosenImage  = info[UIImagePickerControllerEditedImage] as? UIImage
        {
             self.uploadDocumentImage(ChosenImage)
            
//            DispatchQueue.main.async {
//                self.imgProfilePic.image = ChosenImage
//
//                self.imgProfilePic.layer.borderColor = UIColor.white.cgColor
//
//                self.imgUpdatedProfilePic = ChosenImage
//            }
            
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnMaleFemaleClicked(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Female"
        {
            strGender = "Female"
        }
        else
        {
            strGender = "Male"
        }
    }
    @IBAction func btnChangePasswordClicked(_ sender: UIButton) {
        
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController
        self.navigationController?.pushViewController(viewcontroller!, animated: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        if txtFirstName.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter first name.")
        }else if txtUserLandLineNumber.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter home number.")
        }else if txtAddress.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter street address.")
        }else if txtSuburb.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter suburb.")
        }else if txtPostCode.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter post code.")
        }else if txtCity.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter city name.")
        }else if txtUserCountry.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter country name.")
        }else if btnRegisterForGst.isSelected && (txtGSTNumber.text!.isEmptyOrWhitespace() || txtGSTRegName.text!.isEmptyOrWhitespace()){
            if txtGSTNumber.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter GST number.")
            }else if txtGSTRegName.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter GST Registration name.")
            }
            
        }else if txtRelativeName.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter Kin's name.")
        }else if btnRelationshipWithKin.currentTitle == "Relationship with Kin" {
            self.showAlert("Please enter Relationship with kin.")
        }else if txtKinMobileNumber.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter Kin's mobile number.")
        }else if txtKinMobileNumber.text!.count < 8 || txtKinMobileNumber.text!.count > 14 {
            Utilities.showAlert("", message: "Please enter valid  Kin's mobile number.", vc: self)
        }else if txtKinLandlineNumber.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter Kin's home number.")
        }else {
            self.webserviceOfUpdateProfile()
        }
    }
    @IBAction func registerForGstClick(_ sender: UIButton) {
        btnRegisterForGst.isSelected = !btnRegisterForGst.isSelected
        
        if btnRegisterForGst.isSelected {
            
            txtGSTNumber.isHidden = false
            txtGSTRegName.isHidden = false
            
            vwGstNumber.isHidden = false
            vwGstRegistration.isHidden = false
            
        }else {
            
            txtGSTNumber.isHidden = true
            txtGSTRegName.isHidden = true
            
            vwGstNumber.isHidden = true
            vwGstRegistration.isHidden = true
            
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func relationShipWithKinClick(_ sender: UIButton) {
        let arr = ["Father","Mother","Brother","Sister","Wife","Husband","Friend","Relationship"]
        
        ActionSheetStringPicker.show(withTitle: "Relationship with kin", rows: arr, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
            self.btnRelationshipWithKin.setTitle(arr[index], for: .normal)
        }, cancel: { (actionSheet) in
            
        }, origin: self.view)
        
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
                    
                }else if selectedRow == 1 {
                    self.lblCountryCode.text = CountryCode.Au.rawValue
                    self.imgVwFlag.image = UIImage.init(named: "AU")
                }
            }
            
        }
        
        actionSheet.present(in: self, from: view)
        
    }
    @IBAction func btnCameraClicked(_ sender: Any) {
        
        let imagePickerController : UIImagePickerController = UIImagePickerController.init()
        
        RMUniversalAlert.showActionSheet(in: self, withTitle: "Select Profile Picture", message: nil, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: ["Take a Photo","Choose from Gallery"], popoverPresentationControllerBlock:
            { (popover) in
                
                popover.sourceView = self.view
                popover.sourceRect = self.imgProfilePic.frame
        })
        { (alert, buttonIndex) in
            if (buttonIndex == alert.cancelButtonIndex)
            {
                NSLog("Cancel Tapped");
            }
            else if (buttonIndex == 2)
            {
                print("UIImagePickerControllerSourceTypeCamera")
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                
                if(UIDevice .current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
                {
                    self.presentationController?.dismissalTransitionDidEnd(true)
                    self.picker .modalPresentationStyle = UIModalPresentationStyle.popover
                    let pop : UIPopoverPresentationController = self.picker.popoverPresentationController!
                    pop.sourceView = self.view
                    pop.sourceRect = self.imgProfilePic.frame
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
                
            }
            else
            {
                print("UIImagePickerControllerSourceTypePhotoLibrary")
                self.picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                if(UIDevice .current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
                {
                    self.presentationController?.dismissalTransitionDidEnd(true)
                    self.picker .modalPresentationStyle = UIModalPresentationStyle.popover
                    
                    let pop : UIPopoverPresentationController = self.picker.popoverPresentationController!
                    pop.sourceView = self.view
                    pop.sourceRect = self.imgProfilePic.frame
                    pop.permittedArrowDirections = UIPopoverArrowDirection.any
                    self.present(self.picker, animated:true, completion: nil)
                }
                else
                {
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
    
    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------

    func webserviceOfUpdateProfile() {
        
        //        DriverId,Fullname,Gender,Address,Suburb,Zipcode,City,Country,GSTNumberRegistered,GSTNumber,GSTRegistrationName,RelativeFullName,Relationship,RelativeLandlineNumber,RelativeMobileNo,HomeNumber
        
        let profileData = Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as? NSDictionary
        
        var param = [String:AnyObject]()
        
        param["DriverId"] = profileData?.object(forKey: "Id") as AnyObject
        param["Fullname"] = txtFirstName.text as AnyObject
        param["Gender"] = strGender as AnyObject
        param["Address"] = txtAddress.text as AnyObject
        
        param["Suburb"] = txtSuburb.text as AnyObject
        param["Zipcode"] = txtPostCode.text as AnyObject
        param["City"] = txtCity.text as AnyObject
        param["Country"] = txtUserCountry.text as AnyObject
        param["GSTNumberRegistered"] = btnRegisterForGst.isSelected ? "1" as AnyObject : "0" as AnyObject
        if  btnRegisterForGst.isSelected {
            param["GSTNumber"] = txtGSTNumber.text as AnyObject
            param["GSTRegistrationName"] = txtGSTRegName.text as AnyObject
        }
        
        param["RelativeFullName"] = txtRelativeName.text as AnyObject
        param["Relationship"] = btnRelationshipWithKin.currentTitle as AnyObject

        param["RelativeLandlineNumber"] = txtKinLandlineNumber.text as AnyObject
        
        if self.lblCountryCode.text == CountryCode.NZ.rawValue {
            param["RelativeMobileNo"] = "64" + txtKinMobileNumber.text! as AnyObject
        }else {
            param["RelativeMobileNo"] = "61" + txtKinMobileNumber.text! as AnyObject
        }
        
        
        param["HomeNumber"] = txtUserLandLineNumber.text as AnyObject
        
        if !strDriverImageUrl.isEmptyOrWhitespace() {
            param["DriverImage"] = strDriverImageUrl as AnyObject
        }
        
        
        webserviceForUpdateDriverProfile(param as AnyObject) { (result, status) in
            if (status) {
                
                let strMessage =  result["message"] as? String ?? ""
                Singletons.sharedInstance.dictDriverProfile = NSMutableDictionary(dictionary: (result as! NSDictionary))
                UserDefaults.standard.set(Singletons.sharedInstance.dictDriverProfile, forKey: driverProfileKeys.kKeyDriverProfile)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateProfile"), object: nil)
                
                Utilities.showAlertWithCompletion("", message: strMessage, vc: self, completionHandler: { (success) in
                     self.navigationController?.popViewController(animated: true)
                })
             

               
            }else {
                
            }
        }
    }
    
}

extension UpdateProfileViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
        return false
    }
}
