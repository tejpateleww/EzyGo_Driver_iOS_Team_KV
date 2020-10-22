//
//  WalletTopUpVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 23/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit


@objc protocol SelectCardDelegate {
    
    func didSelectCard(dictData: [String:AnyObject])
}


class WalletTopUpVC: ParentViewController, SelectCardDelegate {

    
    var strCardId = String()
    var strAmt = String()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewMain.layer.cornerRadius = 5
        viewMain.layer.masksToBounds = true
        
        btnAddFunds.layer.cornerRadius = 20
        btnAddFunds.layer.masksToBounds = true
//          Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Wallet Top Up", naviTitleImage: "", leftImage: kBack_Icon, rightImage: "")
//        self.title = "Wallet Top Up"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var lblCardTitle: UILabel!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var btnAddFunds: UIButton!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnCardTitle: UIButton!
    
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnCardTitle(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
        Singletons.sharedInstance.isFromTopUP = true
        next.delegateForTopUp = self
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnAddFunds(_ sender: UIButton) {
        
        if strCardId == "" {
            Utilities.showAlert(appName.kAPPName, message: "Please select card", vc: self)
        }
        else if txtAmount.text == "" {
            Utilities.showAlert(appName.kAPPName, message: "Please Enter Amount", vc: self)
        }
        else {
            webserviceOFTopUp()
            txtAmount.resignFirstResponder()
        }
        
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
            
            strAmt = y
            print("amount : \(strAmt)")
            
            
            
            
        }
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - Select Card Delegate Methods
    //-------------------------------------------------------------
    
    func didSelectCard(dictData: [String : AnyObject]) {
        
        print(dictData)
        
        lblCardTitle.text = "\(dictData["Type"] as! String) \(dictData["CardNum2"] as! String)"
        strCardId = dictData["Id"] as! String
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For TOP UP
    //-------------------------------------------------------------
    
    func webserviceOFTopUp() {
       
        var dictParam = [String:AnyObject]()
        
//        strAmt = strAmt.trimmingCharacters(in: .whitespacesAndNewlines)
        
        dictParam[profileKeys.kDriverId] = Singletons.sharedInstance.strDriverID as AnyObject
        dictParam[walletAddMoney.kCardId] = strCardId as AnyObject
        dictParam[walletAddMoney.kAmount] = txtAmount.text?.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject
        
        webserviceForAddMoneyInWallet(dictParam as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                self.txtAmount.text = ""
                
//                Utilities.showAlert(appName.kAPPName, message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                Singletons.sharedInstance.strCurrentBalance = ((result as! NSDictionary).object(forKey: "walletBalance") as! AnyObject).doubleValue
                Utilities.showAlertWithCompletion(appName.kAPPName, message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self, completionHandler: { (status) in
                    
                    self.navigationController?.popViewController(animated: true)
                })
              
                
            }
            else {
                print(result)
                
                self.txtAmount.text = ""
                
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

}

/*
{
    message = "Add Money successfully";
    status = 1;
    walletBalance = "-4.63";
}
 */


