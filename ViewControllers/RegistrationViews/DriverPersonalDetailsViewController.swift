//
//  DriverPersonalDetailsViewController.swift
//  ezygo-Driver
//
//  Created by Apple on 22/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Sheeeeeeeeet

class DriverPersonalDetailsViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    //MARK: IBOutlets
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    
    
    @IBOutlet var txtStreetAddress: UITextField!
    @IBOutlet var txtSuburb: UITextField!
    @IBOutlet var txtPostCode: UITextField!
 
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtCountry: UITextField!
    
    @IBOutlet var txtInviteCode: UITextField!
    
    //Kin Details
    @IBOutlet var vwRealationshipWithKin: UIView!
    @IBOutlet var txtKinFirstName: UITextField!
    @IBOutlet var txtKinLastName: UITextField!
    @IBOutlet var btnRelationshipWithKin: UIButton!
    @IBOutlet var txtKinMobileNumber: UITextField!
    @IBOutlet var txtKinCountryCode: UITextField!
    @IBOutlet var txtKinLandlineNumber: UITextField!
    
    
    @IBOutlet var txtGstNumber: UITextField!
    @IBOutlet var txtRegistrationName: UITextField!
    @IBOutlet weak var imgVwProfile: UIImageView!
    
    @IBOutlet weak var vwGender: UIView!
    @IBOutlet var btnNext: UIButton!
    
    
    @IBOutlet weak var btnMale: RadioButton!
    @IBOutlet weak var btnFeMale: RadioButton!
    @IBOutlet weak var btnRegisteredForGST: UIButton!
    
    
    @IBOutlet var lblCountryCode: UILabel!
    
    @IBOutlet var imgVwFlag: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnMale.isSelected = true
        
        
        Utilities.setCornerRadiusTextField(textField: txtFirstName, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtLastName, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        
        
        Utilities.setCornerRadiusTextField(textField: txtStreetAddress, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtSuburb, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        
        
        Utilities.setCornerRadiusTextField(textField: txtPostCode, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtCity, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtCountry, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        

        Utilities.setCornerRadiusTextField(textField: txtInviteCode, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtGstNumber, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
         Utilities.setCornerRadiusTextField(textField: txtRegistrationName, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        //KIN Details
        Utilities.setCornerRadiusTextField(textField: txtKinFirstName, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtKinLastName, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusView(view: vwRealationshipWithKin, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor)
        
        Utilities.setCornerRadiusTextField(textField: txtKinMobileNumber, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtKinLandlineNumber, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        
        Utilities.setCornerRadiusTextField(textField: txtRegistrationName, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtRegistrationName, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusButton(button: btnNext, borderColor: ThemeYellowColor, bgColor: ThemeYellowColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusView(view: vwGender, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor)
        
        Utilities.setCornerRadiusView(view: txtKinCountryCode, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor)
        
        
        imgVwProfile.layer.cornerRadius = imgVwProfile.frame.height/2
        imgVwProfile.layer.masksToBounds = true
        
        self.showGstOrNot(btnRegisteredForGST.isSelected)
        
        
        
        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        objRegistration = loadRegistrationObject(withKey: RegistrationKeys.registrationUser)
        if objRegistration != nil {
            if !objRegistration.strProfileImageUrl.isEmptyOrWhitespace() {
                imgVwProfile.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strProfileImageUrl) , placeholderImage: UIImage.init(named: "placeHolderProfile"))
            }
        }
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
    @IBAction func relationShipWithKinClick(_ sender: UIButton) {
        let arr = ["Father","Mother","Brother","Sister","Wife","Husband","Friend","Other"]
        
        ActionSheetStringPicker.show(withTitle: "Relationship with kin", rows: arr, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
            self.btnRelationshipWithKin.setTitle(arr[index], for: .normal)
        }, cancel: { (actionSheet) in
            
        }, origin: self.view)
        
    }
    @IBAction func genderClick(_ sender: Any) {
        
        
    }
    @IBAction func nextClick(_ sender: UIButton) {
        
        if imgVwProfile.image == nil || imgVwProfile.image == UIImage.init(named: "placeHolderProfile") {
            self.showAlert("Please select Profile Picture")
        }else if txtFirstName.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter first name.")
        }else if txtLastName.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter last name.")
        }else if txtLastName.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter last name.")
        }else if txtStreetAddress.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter street address.")
        }else if txtSuburb.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter suburb.")
        }else if txtPostCode.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter post code.")
        }else if txtCity.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter city name.")
        }else if txtCountry.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter country name.")
        }else if btnRegisteredForGST.isSelected && (txtGstNumber.text!.isEmptyOrWhitespace() || txtRegistrationName.text!.isEmptyOrWhitespace()){
            if txtGstNumber.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter GST number.")
            }else if txtRegistrationName.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter GST Registration name.")
            }
            
        }else if txtKinFirstName.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter Kin's first name.")
        }else if txtKinLastName.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter Kin's last name.")
        }else if btnRelationshipWithKin.currentTitle == "Relationship with Kin" {
            self.showAlert("Please enter Relationship with kin.")
        }else if txtKinMobileNumber.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter Kin's mobile number.")
        }else if txtKinMobileNumber.text!.count < 8 || txtKinMobileNumber.text!.count > 14 {
            Utilities.showAlert("", message: "Please enter valid  Kin's mobile number.", vc: self)
        }else {
            
            objRegistration.strFirstName = txtFirstName.text!
            objRegistration.strLastName = txtLastName.text!
            objRegistration.strGender = (btnMale.isSelected) ? "male" : "female"
            objRegistration.strStreetAddress = txtStreetAddress.text!
            objRegistration.strSuburb = txtSuburb.text!
            objRegistration.strPostCode = txtPostCode.text!
            objRegistration.strCity = txtCity.text!
            objRegistration.strCountry = txtCountry.text!
            objRegistration.strInviteCode = txtInviteCode.text!
            objRegistration.isRegisteredForGst = btnRegisteredForGST.isSelected
            objRegistration.strGstnumber = txtGstNumber.text!
            objRegistration.strGstRegistrationName = txtRegistrationName.text!
            
            objRegistration.strKinFirstName = txtKinFirstName.text!
            objRegistration.strKinLastName = txtKinLastName.text!
            objRegistration.strRelationshipWithKin = (btnRelationshipWithKin.currentTitle == "Relationship with kin") ? "" : btnRelationshipWithKin.currentTitle ?? ""
            
            if self.lblCountryCode.text == CountryCode.NZ.rawValue {
                objRegistration.strKinCountryCode = "2"
            }else {
                objRegistration.strKinCountryCode = "1"
            }
            
            objRegistration.strKinMobileNumber = txtKinMobileNumber.text!
            objRegistration.strKinLandlineNumber = txtKinLandlineNumber.text!
            
            
            let vwSuper = self.parent as! DriverRegistrationMainViewController
            vwSuper.changeContentOffset(2.0)
            
          
            
            objRegistration.nFillPageNumber = 2.0
            
            saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
            
            
            if let vwBannkDetails = vwSuper.childViewControllers[2] as? DriverBankDetailsViewController {
                vwBannkDetails.viewDidAppear(true)
            }
            
        }
        

        
    }
    @IBAction func addProfileClick(_ sender: UIButton) {
         self.openActionSheet()
    }
    @IBAction func registeredGSTClick(_ sender: UIButton) {
        btnRegisteredForGST.isSelected = !btnRegisteredForGST.isSelected
        
        self.showGstOrNot(btnRegisteredForGST.isSelected)
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
            txtKinMobileNumber.text = removeZeros(from: sender.text!)
        }
    }
    //MARK: - Custom Method
    func showAlert(_ strMessage: String) {
        Utilities.showAlert("", message: strMessage, vc: self)
    }
    func showGstOrNot(_ isEnable: Bool) {
        
        self.txtGstNumber.isHidden = !isEnable
        self.txtRegistrationName.isHidden = !isEnable
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
    }
    func openActionSheet() {
        let imagePickerController : UIImagePickerController = UIImagePickerController.init()
        
        RMUniversalAlert.showActionSheet(in: self, withTitle: "Select Profile Picture", message: nil, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: ["Take a Photo","Choose from Gallery"], popoverPresentationControllerBlock:
            { (popover) in
                
                popover.sourceView = self.view
                popover.sourceRect = self.imgVwProfile.frame
        })
        { (alert, buttonIndex) in
            if (buttonIndex == alert.cancelButtonIndex) {
                NSLog("Cancel Tapped");
            } else if (buttonIndex == 2) {
                print("UIImagePickerControllerSourceTypeCamera")
                imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
                
                if(UIDevice .current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
                {
                    self.presentationController?.dismissalTransitionDidEnd(true)
                    imagePickerController .modalPresentationStyle = UIModalPresentationStyle.popover
                    let pop : UIPopoverPresentationController = imagePickerController.popoverPresentationController!
                    pop.sourceView = self.view
                    pop.sourceRect = self.imgVwProfile.frame
                    pop.permittedArrowDirections = UIPopoverArrowDirection.any
                    self.present(imagePickerController, animated:true, completion: nil)
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
                imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                if(UIDevice .current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
                {
                    self.presentationController?.dismissalTransitionDidEnd(true)
                    imagePickerController .modalPresentationStyle = UIModalPresentationStyle.popover
                    
                    let pop : UIPopoverPresentationController = imagePickerController.popoverPresentationController!
                    pop.sourceView = self.view
                    pop.sourceRect = self.imgVwProfile.frame
                    pop.permittedArrowDirections = UIPopoverArrowDirection.any
                    self.present(imagePickerController, animated:true, completion: nil)
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
    //MARK: - Image Picker Delegates
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let ChosenImage  = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            //            self.btnImages[selectedIndex-1].setImage(ChosenImage, for: .normal)
//            self.imgVwProfile.image = ChosenImage
            
            
            webserviceForUploadImage( [:] as AnyObject , image: ChosenImage, imageParamName: "Image") { (result, status) in
                print(result)
                if status {
                    let strUrl = result["url"] as? String ?? ""
                    self.imgVwProfile.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + strUrl), placeholderImage: UIImage.init(named: "placeHolderProfile"))
                    objRegistration.strProfileImageUrl = strUrl
                    saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
                }
            }
            
//            self.btnSelectCar.setImage(ChosenImage, for: .normal)
            
            
            
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
}

extension DriverPersonalDetailsViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
       
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtKinMobileNumber && range.location == 0 {
            if string == "0" {
                return false
            }
        }
        return true
    }
    
}
