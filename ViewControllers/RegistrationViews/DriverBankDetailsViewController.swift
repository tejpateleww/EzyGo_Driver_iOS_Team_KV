//
//  DriverBankDetailsViewController.swift
//  ezygo-Driver
//
//  Created by Apple on 24/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class DriverBankDetailsViewController: UIViewController {

    @IBOutlet weak var imgVwProfile: UIImageView!
    
    
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtBankBranch: UITextField!
    @IBOutlet weak var txtAccountHolderName: UITextField!
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var btnTransferToAccount: RadioButton!
    @IBOutlet weak var btnCollectFromOffice: RadioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewSetup()
        
        imgVwProfile.layer.cornerRadius = imgVwProfile.frame.height/2
        imgVwProfile.layer.masksToBounds = true 
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        objRegistration = loadRegistrationObject(withKey: RegistrationKeys.registrationUser)
        if objRegistration != nil {
            imgVwProfile.sd_setImage(with: URL.init(string:WebserviceURLs.kImageBaseURL + objRegistration.strProfileImageUrl), placeholderImage: UIImage.init(named: "placeHolderProfile"))
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
    @IBAction func collectFromOfficeClick(_ sender: Any) {
        self.bankDetailsOptional(true)
    }
    @IBAction func transferToAccountClick(_ sender: Any) {
        self.bankDetailsOptional(false)
    }
    @IBAction func nextClick(_ sender: UIButton) {
        if btnTransferToAccount.isSelected {
            if txtBankName.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter bank name.")
            }else if txtAccountHolderName.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter account holder name.")
            }else if txtAccountNumber.text!.isEmptyOrWhitespace() {
                self.showAlert("Please enter bank account no.")
            }else {
                
                self.saveData()
             
            }
        }else {
            
            self.saveData()
        }

       
    }
    //MARK: - Custom Method
    func showAlert(_ strMessage: String) {
        Utilities.showAlert("", message: strMessage, vc: self)
    }
    func saveData() {
        objRegistration.strBankName = txtBankName.text!
        objRegistration.strBankBranch = txtBankBranch.text!
        objRegistration.strAccountHolder = txtAccountHolderName.text!
        objRegistration.strAccountNumber = txtAccountNumber.text!
        objRegistration.isColllectFromOffice = btnCollectFromOffice.isSelected
       
        objRegistration.nFillPageNumber = 3.0
        saveRegistrationObject(objRegistration, key: RegistrationKeys.registrationUser)
        let vwSuper = self.parent as! DriverRegistrationMainViewController
        vwSuper.changeContentOffset(3.0)
    }
}

//MARK: Custom Methods
extension DriverBankDetailsViewController {
    func viewSetup() {
        btnCollectFromOffice.isSelected = true
        Utilities.setCornerRadiusTextField(textField: txtBankName, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtBankBranch, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtAccountHolderName, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        Utilities.setCornerRadiusTextField(textField: txtAccountNumber, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        
        
        Utilities.setCornerRadiusButton(button: btnNext, borderColor: ThemeYellowColor, bgColor: ThemeYellowColor, textColor: ThemeWhiteColor)
    }
    func bankDetailsOptional(_ isOptional: Bool) {
        
        txtBankName.placeholder = isOptional ? "Bank Name (Optional)" : "Bank Name"
        txtBankBranch.placeholder = isOptional ? "Bank Branch (Optional)" : "Bank Branch (Optional)"
        txtAccountHolderName.placeholder = isOptional ? "Account Holder Name (Optional)" : "Account Holder Name"
        txtAccountNumber.placeholder = isOptional ? "Account Number (Optional)" : "Account Number"
    }
}
