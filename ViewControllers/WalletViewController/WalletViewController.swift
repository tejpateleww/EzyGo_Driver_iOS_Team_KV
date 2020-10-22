//
//  WalletViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 12/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class WalletViewController: ParentViewController
{

    
    @IBOutlet var viewBalance: UIView!
    @IBOutlet var viewTransfer: UIView!
    @IBOutlet var viewCards: UIView!
    
    @IBOutlet var lblBalanceTitle: UILabel!
    @IBOutlet var lblTransferTitle: UILabel!
    @IBOutlet var lblCardsTitle: UILabel!
    
    @IBOutlet var lblCurrentBalance: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.setCornerRadiusToView(viewBalance)
        self.setCornerRadiusToView(viewTransfer)
        self.setCornerRadiusToView(viewCards)
        webserviceOfTransactionHistory()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
//        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Wallet", naviTitleImage: "", leftImage: kBack_Icon, rightImage: "")

        self.lblCurrentBalance.text = "\(currency) \(Singletons.sharedInstance.strCurrentBalance)"
        
    }
    
    func setCornerRadiusToView(_ view : UIView)
    {
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
    }

    @IBAction func btnBalanceClicked(_ sender: Any)
    {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletBalanceMainVC") as! WalletBalanceMainVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnTransferClicked(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletTransferViewController") as! WalletTransferViewController
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    @IBAction func btnCardsClicked(_ sender: Any)
    {
        if(Singletons.sharedInstance.CardsVCHaveAryData.count == 0) {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
            //            next.delegateAddCard = self
            self.navigationController?.pushViewController(next, animated: true)
        }  else {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
            self.navigationController?.pushViewController(next, animated: true)
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Transaction History
    //-------------------------------------------------------------
    
    func webserviceOfTransactionHistory() {
        
        webserviceForTransactionHistoryInWallet(Singletons.sharedInstance.strDriverID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                Singletons.sharedInstance.strCurrentBalance = ((result as! NSDictionary).object(forKey: "walletBalance") as AnyObject).doubleValue
                let currentRatio = Double(Singletons.sharedInstance.strCurrentBalance)
                
                self.lblCurrentBalance.text = "\(currency) \(String(format: "%.2f", currentRatio))"
                //                self.lblCurrentBalance.text = "\(currency)\(Singletons.sharedInstance.strCurrentBalance)"
                
                //                self.lblAvailableFundsDesc.text = "\(currency)\(Singletons.sharedInstance.strCurrentBalance)"
                
                //                self.aryData = (result as! NSDictionary).object(forKey: "history") as! [[String:AnyObject]]
                if let history = (result as! NSDictionary).object(forKey: "history") as? [[String:AnyObject]] {
                    Singletons.sharedInstance.walletHistoryData = history
                }
                
                
                self.webserviceOFGetAllCards()
                
                //                self.tableView.reloadData()
                
            }
            else {
                print(result)
                
                if let res = result as? String {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert(appName.kAPPName, message: (resDict).object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert(appName.kAPPName, message: ((resAry).object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
                
            }
        }
        
    }
    
    var aryCards = [[String:AnyObject]]()
    
    func webserviceOFGetAllCards() {
        
        webserviceForCardListingInWallet(Singletons.sharedInstance.strDriverID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                self.aryCards = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                Singletons.sharedInstance.CardsVCHaveAryData = self.aryCards
                
                //                Singletons.sharedInstance.isCardsVCFirstTimeLoad = false
                //                self.tableView.reloadData()
                //                self.refreshControl.endRefreshing()
            }
            else {
                print(result)
                if let res = result as? String {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }
    }
}
