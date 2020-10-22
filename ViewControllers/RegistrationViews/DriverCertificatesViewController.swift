//
//  DriverCertificatesViewController.swift
//  ezygo-Driver
//
//  Created by Apple on 24/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
class DriverCertificatesViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,WWCalendarTimeSelectorProtocol {
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
    @IBOutlet weak var vwLicenseCopy: UIView!
    @IBOutlet weak var vwEndorsementDate: UIView!
    @IBOutlet weak var vwImmigrationStatus: UIView!
    
    @IBOutlet weak var lblDriverExpiryDate: UILabel!
    
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
    
    var selectedIndex = 0
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.setCornerRadiusTextField(textField: txtDriverLicenceNumber, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtNameOnUniqueId, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtCertificationOfRegistration, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        
        Utilities.setCornerRadiusTextField(textField: txtUniqIdCardExpiryDate, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtSPSLHolderName, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtSpslNumber, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtSpslCertificate, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtCOF, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtRegistration, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtCameraMake, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtCameraSerial, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        
          Utilities.setCornerRadiusTextField(textField: txtVisaExpiryDate, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtLatestCameraTest, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtInsurancePolicy, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusButton(button: btnSubmit, borderColor: ThemeYellowColor, bgColor: ThemeYellowColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusView(view: vwLicenseCopy, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor)
        
        Utilities.setCornerRadiusView(view: vwEndorsementDate, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor)
        
        Utilities.setCornerRadiusView(view: vwImmigrationStatus, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor)
        
        
        vwSpslHolderName.isHidden = !btnHoldSpsl.isSelected
        vwSpslNumber.isHidden = !btnHoldSpsl.isSelected
        vwSpslCertificate.isHidden = !btnHoldSpsl.isSelected
        
        vwStackExpiry.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        objRegistration = loadRegistrationObject(withKey: RegistrationKeys.registrationUser)
        if objRegistration != nil {
            
            btnFrontCopy.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strLicenceFrontImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
            btnBackCopy.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strLicenceBackImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
            btnUniqIdCardFront.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strUniqueIdFrontImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
            btnUniqIdCardBack.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strUniqueIdBackImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
            btnSpslCertificate.sd_setImage(with: URL.init(string:WebserviceURLs.kImageBaseURL + objRegistration.strSpslCertificateImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
            btnCofLabel.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strCofExpiryImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
            btnCertificateExpiry.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strCertificateOfRegistrationExpiryImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
            btnVehiclRegistration.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strVehicleRegistrationImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
            btnLatestCameraTestForm.sd_setImage(with: URL.init(string:WebserviceURLs.kImageBaseURL + objRegistration.strLatestCameraTestImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
            btnInsurancePolicy.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strInsurancePolicyImageUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
            
            
            self.txtUniqIdCardExpiryDate.text = objRegistration.strUniquIdExpiryDate
            self.txtCOF.text =  objRegistration.strCOFExpiryDate
            self.txtCertificationOfRegistration.text = objRegistration.strCertificateOfRegistrationExpiryDate
            self.txtRegistration.text = objRegistration.strVehicleRegistrationLabel
            self.txtLatestCameraTest.text = objRegistration.strLatestCameraTestFrom
            self.txtInsurancePolicy.text = objRegistration.strInsurancePolicy
            
            if !objRegistration.strLicenceExpirationDate.isEmptyOrWhitespace() {
                self.lblDriverExpiryDate.text = objRegistration.strLicenceExpirationDate
            
            }
            if  !objRegistration.strSelectImmigrationStatus.isEmptyOrWhitespace() {
                btnSelectImmigration.setTitle(objRegistration.strSelectImmigrationStatus, for: .normal)
            }
            if txtVisaExpiryDate.text! == "Work Visa" {
                
                vwStackExpiry.isHidden = false
                btnVisaImage.sd_setImage(with: URL.init(string: objRegistration.strWorkVisaUrl), for: .normal, placeholderImage: UIImage.init(named: "uploadPlaceholder") , completed: nil)
                txtVisaExpiryDate.text = objRegistration.strVisaExpiryDate
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
    @IBAction func endorcementClick(_ sender: UIButton) {
        let arr = ["Before 1 October 2017","After 1 October 2017"]
        
        ActionSheetStringPicker.show(withTitle: "Select immigration Status", rows: arr, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
            self.btnEndorcementDate.setTitle(arr[index], for: .normal)
        }, cancel: { (actionSheet) in
            
        }, origin: self.view)
    }
    @IBAction func nextClick(_ sender: UIButton) {
        
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
//            objRegistration.isHoldSPSL = btnAirportTarm.isSelected

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
            objRegistration.strSelectImmigrationStatus = arr[index]
            saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
            
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
        webserviceForUploadImage( [:] as AnyObject , image: chosenImage, imageParamName: "Image") { (result, status) in
            print(result)
            
            if status {
                
                let strUrl = result["url"] as? String ?? ""
                self.btnImages[self.selectedIndex-1].sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + strUrl), for: .normal, completed: nil)
                

                if self.selectedIndex == 1 {
                    objRegistration.strLicenceFrontImageUrl =  strUrl
                }else if self.selectedIndex == 2 {
                     objRegistration.strLicenceBackImageUrl =  strUrl
                }else if self.selectedIndex == 3 {
                     objRegistration.strUniqueIdFrontImageUrl =  strUrl
                }else if self.selectedIndex == 4 {
                     objRegistration.strUniqueIdBackImageUrl =  strUrl
                }else if self.selectedIndex == 5 {
                     objRegistration.strSpslCertificateImageUrl =  strUrl
                }else if self.selectedIndex == 6 {
                     objRegistration.strCofExpiryImageUrl =  strUrl
                }else if self.selectedIndex == 7 {
                     objRegistration.strCertificateOfRegistrationExpiryImageUrl =  strUrl
                }else if self.selectedIndex == 8 {
                     objRegistration.strVehicleRegistrationImageUrl =  strUrl
                }else if self.selectedIndex == 9 {
                     objRegistration.strLatestCameraTestImageUrl =  strUrl
                }else if self.selectedIndex == 10 {
                     objRegistration.strInsurancePolicyImageUrl =  strUrl
                }else if self.selectedIndex == 11 {
                    objRegistration.strWorkVisaUrl =  strUrl
                }
                saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
            }
        }
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
       
        if let ChosenImage  = info[UIImagePickerControllerEditedImage] as? UIImage
        {
//            self.btnImages[selectedIndex-1].setImage(ChosenImage, for: .normal)
            
            self.uploadDocumentImage(ChosenImage)
            
            
//            self.btnFrontCopy.setImage(ChosenImage, for: .normal)
//            DispatchQueue.main.async {
//                self.btnFrontCopy.setImage(ChosenImage, for: .normal)
//
////               self.btnFrontCopy.layer.borderColor = UIColor.white.cgColor
////
////                self.imgUpdatedProfilePic = ChosenImage
//            }
            
            
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - IBOutlets
    
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
        self.view.endEditing(true)
        let sheet =  ActionSheetDatePicker.init(title: "Select Date", datePickerMode: .date, selectedDate: Date(), doneBlock: { (actionSheet, date, obj) in
            let myDateFormatter: DateFormatter = DateFormatter()
            //        myDateFormatter.dateFormat = "yyyy/MM/dd"
            myDateFormatter.dateFormat = "dd-MM-yyyy"
            let finalDate = myDateFormatter.string(from: date as! Date)
            self.lblDriverExpiryDate.text = finalDate
            
            objRegistration.strLicenceExpirationDate = finalDate
            saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
        }, cancel: nil, origin: self.view)
        sheet?.minimumDate = Date()
        
        sheet?.show()
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
            
            if textfield == self.txtUniqIdCardExpiryDate {
                objRegistration.strUniquIdExpiryDate = textfield.text!
            }else if textfield == self.txtCOF {
                objRegistration.strCOFExpiryDate = textfield.text!
            }else if textfield == self.txtCertificationOfRegistration {
                objRegistration.strCertificateOfRegistrationExpiryDate = textfield.text!
            }else if textfield == self.txtRegistration {
                objRegistration.strVehicleRegistrationLabel = textfield.text!
            }else if textfield == self.txtLatestCameraTest {
                objRegistration.strLatestCameraTestFrom = textfield.text!
            }else if textfield == self.txtInsurancePolicy {
                objRegistration.strInsurancePolicy = textfield.text!
            }else if textfield == self.txtVisaExpiryDate {
                objRegistration.strVisaExpiryDate = textfield.text!
            }
            saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
            
        }, cancel: nil, origin: self.view)
        sheet?.minimumDate = Date()
        
        sheet?.show()
    }
    
}


extension DriverCertificatesViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtUniqIdCardExpiryDate ||  textField == txtCOF || textField == txtCertificationOfRegistration   || textField == txtLatestCameraTest || textField == txtInsurancePolicy || textField == txtVisaExpiryDate {
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
