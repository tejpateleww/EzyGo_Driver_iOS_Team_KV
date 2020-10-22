//
//  WalletTransferToBankVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 23/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

@objc protocol SelectBankCardDelegate {
    
    func didSelectBankCard(dictData: [String: AnyObject])
}

class WalletTransferToBankVC: ParentViewController, SelectBankCardDelegate {
    
    

    
    @IBOutlet var lblBSB: UILabel!
    @IBOutlet var lblBankAccNumber: UILabel!
    @IBOutlet var lblABN: UILabel!
    @IBOutlet var lblAccountHolderName: UILabel!
    @IBOutlet var lblBankName: UILabel!
    
    @IBOutlet weak var constraintTopOfMoney: NSLayoutConstraint! // 40
    @IBOutlet weak var constraintHeightOfMoney: NSLayoutConstraint! // 40
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var lblCardTitle: UILabel!
    @IBOutlet weak var lblCurrentBalanceTitle: UITextField!

    @IBOutlet weak var txtSendBalanceToBank: UITextField!

    @IBOutlet weak var txtAmount: UITextField!
    
    @IBOutlet weak var btnWithdrawFunds: UIButton!
    
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var btnCardTitle: UIButton!
    
    
    var strAmt = String()
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Wallet Transfer To Bank", naviTitleImage: "", leftImage: kBack_Icon, rightImage: "")
        
        if IS_IPAD || IS_IPHONE_4_OR_LESS {
            constraintTopOfMoney.constant = 20
            constraintHeightOfMoney.constant = 30
        }
        
        viewMain.layer.cornerRadius = 5
        viewMain.layer.masksToBounds = true
        
//        btnWithdrawFunds.layer.cornerRadius = 5
//        btnWithdrawFunds.layer.masksToBounds = true
        
      
//        lblCurrentBalanceTitle.text = "\(Singletons.sharedInstance.strCurrentBalance)"
        let profileData = Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! [String : AnyObject]
//
//
//        let strBSB = profileData["BSB"] as! String
//        let strHolderName = profileData["BankHolderName"] as! String
//        let strABN = profileData["ABN"] as! String
//        let strBankName = profileData["BankName"] as! String
//        let strAccNumber = profileData["BankAcNo"] as! String
//
//
        
//        lblAccountHolderName.text = "\(profileData["BankHolderName"] as! String)"
//        lblBankName.text = "\(profileData["BankName"] as! String)"
//        lblBankAccNumber.text = "\(profileData["BankAcNo"] as! String)"
//        lblBSB.text = "\(profileData["BSB"] as! String)"
        
        if let strBankHolderName = profileData["BankHolderName"] as? String {
            if strBankHolderName.isEmptyOrWhitespace() {
                lblAccountHolderName.text = "Account Holder Name"
            }else {
                lblAccountHolderName.text = strBankHolderName
            }
        }
        
        if let strBankName = profileData["BankName"] as? String {
            if strBankName.isEmptyOrWhitespace() {
                lblBankName.text = "Bank Name"
            }else {
                lblBankName.text = strBankName
            }
        }
        
        if let strBankAcNo = profileData["BankAcNo"] as? String {
            if strBankAcNo.isEmptyOrWhitespace() {
                lblBankAccNumber.text = "Bank Account No"
            }else {
                lblBankAccNumber.text = strBankAcNo
            }
        }
        
        if let strBSB = profileData["BSB"] as? String {
            if strBSB.isEmptyOrWhitespace() {
                lblBSB.text = "BSB"
            }else {
                lblBSB.text = strBSB
            }
        }
        
//        "Account Holder Name","Bank Name","Bank Account No", "BSB"
        
        
        let currentRatio = Double(Singletons.sharedInstance.strCurrentBalance)
        
        self.lblCurrentBalanceTitle.text = "\(String(format: "%.2f", currentRatio))"
//        lblCurrentBalanceTitle.text = Singletons.sharedInstance.strCurrentBalance
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnCardTitle(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
        Singletons.sharedInstance.isFromTransferToBank = true
        next.delegateForTransferToBank = self
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    
    
   
    
    @IBAction func txtAmount(_ sender: UITextField) {
        
        if let amountString = txtAmount.text?.currencyInputFormatting() {
            
            
            //            txtAmount.text = amountString
            
            
            let unfiltered1 = amountString   //  "!   !! yuahl! !"
            
            
            var y = amountString.replacingOccurrences(of: "$", with: "", options: .regularExpression, range: nil)
            y = y.replacingOccurrences(of: " ", with: "")
            // Array of Characters to remove
            let removal1: [Character] = ["$"," "]    // ["!"," "]
            
            // turn the string into an Array
            let unfilteredCharacters1 = unfiltered1
            
            // return an Array without the removal Characters
            let filteredCharacters1 = unfilteredCharacters1.filter { !removal1.contains($0) }
            
            // build a String with the filtered Array
            let filtered1 = String(filteredCharacters1)
            
            print(filtered1) // => "yeah"
            
            // combined to a single line
            print(String(unfiltered1.filter { !removal1.contains($0) })) // => "yuahl"
            
            txtAmount.text = String(unfiltered1.filter { !removal1.contains($0) })
            
            
            
            // ----------------------------------------------------------------------
            // ----------------------------------------------------------------------
            let unfiltered = amountString   //  "!   !! yuahl! !"
            
            // Array of Characters to remove
            let removal: [Character] = ["$",","," "]    // ["!"," "]
            
            // turn the string into an Array
            let unfilteredCharacters = unfiltered
            
            // return an Array without the removal Characters
            let filteredCharacters = unfilteredCharacters.filter { !removal.contains($0) }
            
            // build a String with the filtered Array
            let filtered = String(filteredCharacters)
            
            print(filtered) // => "yeah"
            
            // combined to a single line
            print(String(unfiltered.filter { !removal.contains($0) })) // => "yuahl"
            
            strAmt = filtered
            print("amount : \(strAmt)")
            
            
            
            
        }
    }
    
    @IBAction func btnWithdrawFunds(_ sender: UIButton) {
        
//        Utilities.showAlert(appName, message: "This feature is not available right now.", vc: self)
        if txtSendBalanceToBank.text!.isEmptyOrWhitespace() {
            Utilities.showAlert("", message: "Please enter amount", vc: self)
        }else if lblBankAccNumber.text!.isEmptyOrWhitespace() || lblBankAccNumber.text == "Bank Account No" {
            Utilities.showAlert("Sorry! You can't transfer money to bank.", message: "Please contact Ezygo via Customer support/Account Enquiry in menu.", vc: self)
        }else {
            webserviceCallToTransferToBank()
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Select Card Delegate Methods
    //-------------------------------------------------------------
    
    func didSelectBankCard(dictData: [String : AnyObject]) {
        
        print(dictData)
        
        lblCardTitle.text = "\(dictData["Type"] as! String) \(dictData["CardNum2"] as! String)"
        
//        lblCurrentBalanceTitle = dictData["Type"] as? AnyObject
        
        //        dictData1["PassengerId"] = "1" as AnyObject
        //        dictData1["CardNo"] = "**** **** **** 1081" as AnyObject
        //        dictData1["Cvv"] = "123" as AnyObject
        //        dictData1["Expiry"] = "08/22" as AnyObject
        //        dictData1["CardType"] = "MasterCard" as AnyObject
        
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Call To transfer money to bank
    //-------------------------------------------------------------
    
    //DriverId,Amount,HolderName,ABN,BankName,BSB,AccountNo
    func  webserviceCallToTransferToBank()
    {
      
        let profileData = Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! [String : AnyObject]
        let strDriverID = profileData["Id"] as! String
        let strAmount = self.strAmt
        
        
        if txtSendBalanceToBank.text?.last == "." {
            
        }
        
        
        var dictData = [String : String]()
        dictData["DriverId"] = strDriverID
        dictData["Amount"] = txtSendBalanceToBank.text
        dictData["HolderName"] = lblAccountHolderName.text //as! String
//        dictData["ABN"] = lblABN.text //as! String
        dictData["BankName"] = lblBankName.text //as! String
        dictData["BSB"] = lblBSB.text //as! String
        dictData["AccountNo"] = lblBankAccNumber.text //as! String
        
        webserviceForTransferMoneyToBank(dictData as AnyObject) { (result, status) in
            if(status)
            {
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
            else
            {
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
//
    

}
extension WalletTransferToBankVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count == 0 && string == "." {
            return false
        } else if (textField.text!.components(separatedBy: ".").count > 1 && string == ".") {
            return false
        }
        return string == "" || (string == "." || Float(string) != nil)
    }
}
