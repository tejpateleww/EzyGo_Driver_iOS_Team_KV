//
//  DriverSelectVehicleTypesViewController.swift
//  ezygo-Driver
//
//  Created by Apple on 24/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
class DriverSelectVehicleTypesViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var txtOwnerFullName: UITextField!
    @IBOutlet weak var txtVehiclePlateNumber: UITextField!
    @IBOutlet weak var txtVehicleMake: UITextField!
    @IBOutlet weak var txtVehicleModel: UITextField!
    @IBOutlet weak var txtYearOfManufacture: UITextField!
    @IBOutlet weak var txtColor: UITextField!
    
 
    
    
    @IBOutlet weak var vwVehicleType: UIView!
    @IBOutlet weak var vwNumberOfPassanger: UIView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnCarType: UIButton!
    
    @IBOutlet weak var btnSelectCar: UIButton!
    
    @IBOutlet weak var btnNoOfPassanger: UIButton!
    var arrVehicleType = [String]()
    //MARK: View Life cycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.setCornerRadiusTextField(textField: txtOwnerFullName, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtVehiclePlateNumber, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtVehicleMake, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtVehicleModel, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtYearOfManufacture, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtColor, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)

        
       
        
        Utilities.setCornerRadiusButton(button: btnNext, borderColor: ThemeYellowColor, bgColor: ThemeYellowColor, textColor: ThemeWhiteColor)
        
        
        Utilities.setCornerRadiusView(view: vwVehicleType, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor)
        Utilities.setCornerRadiusView(view: vwNumberOfPassanger, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor)
        
        print(#function)
        
        self.getCarList()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        objRegistration = loadRegistrationObject(withKey: RegistrationKeys.registrationUser)
        if objRegistration != nil {
            if !objRegistration.strVehicleImageUrl.isEmptyOrWhitespace() {
                btnSelectCar.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + objRegistration.strVehicleImageUrl), for: .normal) { (img, error, cache, url) in
                }
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
    
    //MARK: Actions
    @IBAction func nextClick(_ sender: UIButton) {
        
        if btnSelectCar.currentImage == nil || btnSelectCar.currentImage == UIImage.init(named: "carPlaceholder") {
            self.showAlert("Please select vehicle image.")
        }else if txtOwnerFullName.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter vehicle owner name.")
        }else if txtVehiclePlateNumber.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter vehicle plate number.")
        }else if txtVehicleMake.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter vehicle make.")
        }else if txtVehicleModel.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter vehicle model.")
        }else if btnCarType.currentTitle == "Vehicle Type" {
            self.showAlert("Please select vehicle type.")
        }else if txtYearOfManufacture.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter year of manufacture.")
        }else if txtColor.text!.isEmptyOrWhitespace() {
            self.showAlert("Please enter car color.")
        }else if btnNoOfPassanger.currentTitle == "No Of Passengers" {
            self.showAlert("Please select number of passengers.")
        }else {
            
            objRegistration.strVehicleOwnerFullName = txtOwnerFullName.text!
            objRegistration.strVehiclePlateNumber = txtVehiclePlateNumber.text!
            objRegistration.strVehicleMake = txtVehicleMake.text!
            objRegistration.strVehicleModel = txtVehicleModel.text!
            objRegistration.strVehicleType = (btnCarType.currentTitle == "Vehicle Type") ? "" : btnCarType.currentTitle!
            objRegistration.strVehicleManufactureYear = txtYearOfManufacture.text!
            objRegistration.strVehicleColor = txtColor.text!
            
            objRegistration.strNoOfPassenger = btnNoOfPassanger.currentTitle!
            
            objRegistration.nFillPageNumber = 4.0
            
            saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
            
            let vwSuper = self.parent as! DriverRegistrationMainViewController
            vwSuper.changeContentOffset(4.0)
            
            
        }
        
        
        
       
    }
    
    @IBAction func carTypeClick(_ sender: UIButton) {
//        let arr = ["Car1","Car2","Car3","Car4"]
     
        ActionSheetStringPicker.show(withTitle: "Car Type", rows: arrVehicleType, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
            self.btnCarType.setTitle(self.arrVehicleType[index], for: .normal)
        }, cancel: { (actionSheet) in
            
        }, origin: self.view)
        
    }
    @IBAction func noOfPassanger(_ sender: UIButton) {
        let arr = ["4","5","6","7","8","9","10"]
        
        ActionSheetStringPicker.show(withTitle: "No Of Passengers", rows: arr, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
            self.btnNoOfPassanger.setTitle(arr[index], for: .normal)
        }, cancel: { (actionSheet) in
            
        }, origin: self.view)
        
  
        
    }
    
    @IBAction func selectCarClick(_ sender: Any) {
        self.openActionSheet()
    }
    //MARK: - Custom Method
    
    func getYearsOfManufacture() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: Date())
        
        let currentYear = Int(year)!
        
        var integerArray = [Int]()
        for i in 1901...currentYear {
            integerArray.append(i)
        }
        
        ActionSheetStringPicker.show(withTitle: "Year of manufacture", rows: integerArray, initialSelection: integerArray.count-1, doneBlock: { (actionSheet, index, obj) in
            
            self.txtYearOfManufacture.text = String("\(integerArray[index])")
        }, cancel: { (actionSheet) in
            
        }, origin: self.view)
    }
    func getCarList(){
        webserviceForGetVehicleTypeList("" as AnyObject) { (result, status) in
            let arrayCars = result["cars_and_taxi"] as? NSArray ?? NSArray()
            
            for i in 0..<arrayCars.count {
                let dict = arrayCars[i] as? NSDictionary ?? NSDictionary()
                self.arrVehicleType.append(dict["Name"] as? String ?? "")
            }
        }
    }
    func showAlert(_ strMessage: String) {
        Utilities.showAlert("", message: strMessage, vc: self)
    }

    func openActionSheet() {
        let imagePickerController : UIImagePickerController = UIImagePickerController.init()
        
        RMUniversalAlert.showActionSheet(in: self, withTitle: "Select Profile Picture", message: nil, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: ["Take a Photo","Choose from Gallery"], popoverPresentationControllerBlock:
            { (popover) in
                
                popover.sourceView = self.view
                popover.sourceRect = self.btnCarType.frame
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
                    pop.sourceRect = self.btnCarType.frame
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
                    pop.sourceRect = self.btnCarType.frame
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
//                       self.btnSelectCar.setImage(ChosenImage, for: .normal)
            webserviceForUploadImage( [:] as AnyObject , image: ChosenImage, imageParamName: "Image") { (result, status) in
                print(result)
                if status {
                    let strUrl = result["url"] as? String ?? ""
                    self.btnSelectCar.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + strUrl), for: .normal, completed: nil)

                    
                    //                    self.imgVwProfile.sd_setImage(with: URL.init(string: WebserviceURLs.kImageBaseURL + strUrl), placeholderImage: UIImage.init(named: "carPlaceholder"))
                    
                    objRegistration.strVehicleImageUrl =  strUrl
                    saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
                }
            }
            
            
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
}


//MARK: Textfield Delegate
extension DriverSelectVehicleTypesViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtYearOfManufacture {
            self.getYearsOfManufacture()
            return false
        }
        return true
    }
}
