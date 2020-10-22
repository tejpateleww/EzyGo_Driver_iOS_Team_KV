//
//  BankAccountDetailsViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 11/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift

class BankAccountDetailsViewController: ParentViewController,UIGestureRecognizerDelegate
{

    @IBOutlet var txtBankName: ACFloatingTextfield!
    @IBOutlet var txtBSB: ACFloatingTextfield!
    @IBOutlet var txtAccountHolderName: ACFloatingTextfield!

    @IBOutlet var txtBankAccountNo: ACFloatingTextfield!
    
    @IBOutlet var btnSave: UIButton!
    
    @IBOutlet weak var btnTransferToAccount: RadioButton!
    @IBOutlet weak var btnCollectFromOffice: RadioButton!
    
    @IBOutlet weak var lblCashORBank: UILabel!

   //Local Variable
    var strDriverID = String()
    
    var dictData = NSMutableDictionary()
    
    var sendData = [String:AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCollectFromOffice.isSelected = true
        Utilities.setLeftPaddingInTextfield(textfield: txtBankName, padding: 10)
        Utilities.setLeftPaddingInTextfield(textfield: txtBankAccountNo, padding: 10)
        Utilities.setLeftPaddingInTextfield(textfield: txtBSB, padding: 10)
        Utilities.setLeftPaddingInTextfield(textfield: txtAccountHolderName, padding: 10)
        
        Utilities.setCornerRadiusButton(button: btnSave, borderColor: ThemeYellowColor, bgColor: ThemeYellowColor, textColor: ThemeWhiteColor)
        
        dictData = NSMutableDictionary(dictionary: Singletons.sharedInstance.dictDriverProfile as NSDictionary)
        
        
        let profile = dictData.object(forKey: "profile") as! NSDictionary
        strDriverID = profile.object(forKey: "Id") as! String
        
        setData()
        txtAccountHolderName.isEnabled = false
        txtBankName.isEnabled = txtAccountHolderName.isEnabled
        txtBSB.isEnabled = txtAccountHolderName.isEnabled
        txtBankAccountNo.isEnabled = txtAccountHolderName.isEnabled
        
         self.bankDetailsOptional(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        self.navigationController?.isNavigationBarHidden = false
        
        if self.navigationController?.childViewControllers.count == 1 {
            Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Payment Method From Ezygo", naviTitleImage: "", leftImage: kMenu_Icon, rightImage: "")
//            self.frostedViewController.panGestureEnabled = true
        }
        else {
            Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Payment Method From Ezygo", naviTitleImage: "", leftImage: kBack_Icon, rightImage: "")
//            self.frostedViewController.panGestureEnabled = false
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        */
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    //MARK: - Click Events
    @IBAction func btnSaveClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func collectFromOfficeClick(_ sender: Any) {
        self.bankDetailsOptional(true)
    }
    @IBAction func transferToAccountClick(_ sender: Any) {
        self.bankDetailsOptional(false)
    }
    func setData()
    {
        
        let profile: NSMutableDictionary = NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile")) as! NSDictionary)
        
        
        
        //        let Vehicle: NSMutableDictionary = profile.object(forKey: "Vehicle") as! NSMutableDictionary
        //
        
//        txtAccountHolderName.text = profile.object(forKey: "BankHolderName") as? String
//        txtBankName.text = profile.object(forKey: "BankName") as? String
//        txtBankAcNo.text = profile.object(forKey: "BankAcNo") as? String
//        txtABN.text = profile.object(forKey: "ABN") as? String
//        txtBSB.text = profile.object(forKey: "BSB") as? String
//        txtServiceDescription.text = profile.object(forKey: "Description") as? String
        if let strPayementType =  profile["PaymentCollectionType"] as? String {
           lblCashORBank.text =  (strPayementType == "1") ? "Cash Cheque" : "Direct Credit"
         }
        
        txtBankName.text = profile.object(forKey: "BankName") as? String
        txtBankAccountNo.text = profile.object(forKey: "BankAcNo") as? String
        txtAccountHolderName.text =  profile.object(forKey: "BankHolderName") as? String
        txtBSB.text = profile.object(forKey: "BSB") as? String //Branch name
    }
    
}
//MARK: - Custom Methods
extension BankAccountDetailsViewController {
    func bankDetailsOptional(_ isOptional: Bool) {
        

        txtBankName.placeholder = isOptional ? "Bank Name (optional)" : "Bank Name"
        txtBSB.placeholder = isOptional ? "Bank Branch (optional)" : "Bank Branch"
        txtAccountHolderName.placeholder = isOptional ? "Account Holder Name (optional)" : "Account Holder Name"
        txtBankAccountNo.placeholder = isOptional ? "Account Number (optional)" : "Account Number"
    }
}
