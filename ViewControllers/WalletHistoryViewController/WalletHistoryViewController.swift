//
//  WalletHistoryViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 23/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class WalletHistoryViewController: ParentViewController, UITableViewDataSource, UITableViewDelegate {

    
    var aryData = [[String:AnyObject]]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = ThemeYellowColor

        return refreshControl
    }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {

        webserviceOfTransactionHistory()
        tableView.reloadData()
    }
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Wallet History", naviTitleImage: "", leftImage: kBack_Icon, rightImage: "")
        
        tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)

        if Singletons.sharedInstance.walletHistoryData.count != 0 {
            aryData = Singletons.sharedInstance.walletHistoryData
        }
        else {
            webserviceOfTransactionHistory()
        }
        
    }

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    

    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletHistoryTableViewCell") as! WalletHistoryTableViewCell
        cell.selectionStyle = .none
//        cell.lblTransferTitle.text = ""
//        cell.lblDateOfTransfer.text = ""
 
        let dictData = aryData[indexPath.row]
        
        cell.lblTransferTitle.text = dictData["Description"] as? String
        cell.lblDateOfTransfer.text = dictData["UpdatedDate"] as? String
        
//        if dictData["Status"] as! String == "failed" {
//
//            cell.lblAmount.text = "\(dictData["Type"] as! String) \(dictData["Amount"] as! String)"
//            cell.lblAmount.textColor = UIColor.red
//        }
//        else {
//
//            cell.lblAmount.text = "\(dictData["Type"] as! String) \(dictData["Amount"] as! String)"
//            cell.lblAmount.textColor = UIColor.init(red: 0, green: 144/255, blue: 81/255, alpha: 1.0)
//        }
//
        let amount = "\(dictData["Amount"] ?? "00.00" as AnyObject)"

        if !amount.isEmpty {
            let currentRatio = Double(amount)
            if dictData["Status"] as! String == "failed" || dictData["Status"] as! String == "pending" {
                
                if dictData["Status"] as! String == "failed" {
                    cell.lblAmount.text = "\("Transaction Failed ")\(dictData["Type"] as! String) \(String(format: "%.2f", currentRatio!))"
                }else {
                    cell.lblAmount.text = "\(dictData["Type"] as! String) \(String(format: "%.2f", currentRatio!))"
                }
                
                
                cell.lblAmount.textColor = UIColor.red
            }
            else {
                
                cell.lblAmount.text = "\(dictData["Type"] as! String) \(String(format: "%.2f", currentRatio!))"
                cell.lblAmount.textColor = UIColor.init(red: 0, green: 144/255, blue: 81/255, alpha: 1.0)
            }
            
            if dictData["Status"] as! String == "pending" {
                cell.lblPending.isHidden = false
            }else {
                cell.lblPending.isHidden = true
            }
        }
        return cell
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Transaction History
    //-------------------------------------------------------------
    
    func webserviceOfTransactionHistory()
    {
      
        webserviceForTransactionHistoryInWallet(Singletons.sharedInstance.strDriverID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                if let aryHistory = (result as! NSDictionary).object(forKey: "history") as? [[String:AnyObject]] {
                    self.aryData = aryHistory
                    Singletons.sharedInstance.walletHistoryData = self.aryData
                }
                
                
                Singletons.sharedInstance.strCurrentBalance = ((result as! NSDictionary).object(forKey: "walletBalance") as AnyObject).doubleValue
                
                if self.aryData.count != 0 {
                    self.tableView.isHidden = false
                }else {
                    self.tableView.isHidden = true
                }
                
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                print(result)
                
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
