//
//  VehicleOptionViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 11/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
class VehicleOptionViewController:  ParentViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var txtVehiclePlateNumber: UITextField!
    @IBOutlet weak var txtNoOfPassanger: UITextField!
    
    @IBOutlet weak var txtCarType: UITextField!
    @IBOutlet weak var vwVehicleType: UIView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnCarType: UIButton!
    
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var btnSelectCar: UIButton!
    
    @IBOutlet weak var imgVwCar: UIImageView!
    //MARK: View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        
//        self.title = "Vehicle Option"
//         Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Vehicle Option", naviTitleImage: "", leftImage: kMenu_Icon, rightImage: "")
//        Utilities.setCornerRadiusTextField(textField: txtVehiclePlateNumber, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
//
//        Utilities.setCornerRadiusTextField(textField: txtVehicleModel, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
//
//        Utilities.setCornerRadiusTextField(textField: txtVehicleMake, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
//
//        Utilities.setCornerRadiusTextField(textField: txtNoOfPassanger, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
//
//        Utilities.setCornerRadiusView(view: vwVehicleType, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor)
//
        Utilities.setCornerRadiusButton(button: btnNext, borderColor: ThemeYellowColor, bgColor: ThemeYellowColor, textColor: ThemeWhiteColor)
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func getData()
    {
        let profile: NSMutableDictionary = NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary))
        let Vehicle: NSMutableDictionary = NSMutableDictionary(dictionary: profile.object(forKey: "Vehicle") as! NSDictionary )
        
        if let strPlateNo =  Vehicle.object(forKey: "VehicleRegistrationNo") as? String {
            txtVehiclePlateNumber.text = "Plate No: " + strPlateNo
        }
//        txtVehiclePlateNumber.text = "Plate No:"  Vehicle.object(forKey: "VehicleRegistrationNo") as? String ?? ""
        if let strCompany = Vehicle.object(forKey: "Company") as? String {
             txtCompanyName.text = "Make: " + strCompany
        }
//        txtCompanyName.text = Vehicle.object(forKey: "Company") as? String
       
        
        if let carType = Vehicle.object(forKey: "VehicleClass") as? String {
            txtCarType.text = "Model: " + carType
        }
        
//        btnCarType.sd
//          btnCarType.sd_setImage(with: URL.init(string: Vehicle.object(forKey: "VehicleImage") as! String), placeholderImage: UIImage.init(named: ""))
        imgVwCar.sd_setImage(with: URL.init(string: Vehicle.object(forKey: "VehicleImage") as! String), completed: nil)
        
    }
    @IBAction func nextClick(_ sender: UIButton) {
        let vwSuper = self.parent as! DriverRegistrationMainViewController
        vwSuper.changeContentOffset(4.0)
    }
    
    @IBAction func carTypeClick(_ sender: UIButton) {
        let arr = ["Car1","Car2","Car3","Car4"]
        
        ActionSheetStringPicker.show(withTitle: "Car Type", rows: arr, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
            self.btnCarType.setTitle(arr[index], for: .normal)
        }, cancel: { (actionSheet) in
            
        }, origin: self.view)
        
    }
    
    @IBAction func selectCarClick(_ sender: Any) {
        self.openActionSheet()
    }
    //MARK: -
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
            self.btnSelectCar.setImage(ChosenImage, for: .normal)
            
            
            
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
}
