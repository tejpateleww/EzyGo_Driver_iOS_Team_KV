//
//  WalletBalanceMainVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 23/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class WalletBalanceMainVC: ParentViewController, UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate
{
    
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

    
     var aryData = [[String:AnyObject]]()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
//        self.tableView.addSubview(self.refreshControl)
        
        if Singletons.sharedInstance.walletHistoryData.count == 0 {
             webserviceOfTransactionHistory()
        }else {
            aryData = Singletons.sharedInstance.walletHistoryData
            let currentRatio = Double(Singletons.sharedInstance.strCurrentBalance)
            
            self.lblAvailableFundsDesc.text = "\(currency)\(String(format: "%.2f", currentRatio))"
            
        }
//       imgLKR.image = UIImage.init(named: "roundDollar")?.withRenderingMode(.alwaysTemplate)
//        imgLKR.tintColor = UIColor.gray
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        viewAvailableFunds.layer.cornerRadius = 5
        viewAvailableFunds.layer.masksToBounds = true
        
        viewCenter.layer.cornerRadius = 5
        viewCenter.layer.masksToBounds = true
        
        viewBottom.layer.cornerRadius = 5
        viewBottom.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentRatio = Double(Singletons.sharedInstance.strCurrentBalance)
        
        self.lblAvailableFundsDesc.text = "\(currency)\(String(format: "%.2f", currentRatio))"
        //        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Balance", naviTitleImage: "", leftImage: kBack_Icon, rightImage: "")
//        self.frostedViewController.panGestureEnabled = false
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var viewAvailableFunds: UIView!
    @IBOutlet weak var lblAvailableFunds: UILabel!
    @IBOutlet weak var lblAvailableFundsDesc: UILabel!
    
    @IBOutlet var imgLKR: UIImageView!
    
    @IBOutlet weak var viewCenter: UIView!
    
    @IBOutlet weak var imgTopUp: UIImageView!
    @IBOutlet weak var lblTopUp: UILabel!
    
    @IBOutlet weak var imgTansferToBank: UIImageView!
    @IBOutlet weak var lblTransferToBank: UILabel!
    
    @IBOutlet weak var imgHistory: UIImageView!
    @IBOutlet weak var lblHistory: UILabel!
    
    
    @IBOutlet weak var viewBottom: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
  
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if aryData.count != 0 {
            return 5
        }
        return 0
//        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletBalanceMainTableViewCell") as! WalletBalanceMainTableViewCell
        cell.selectionStyle = .none
        if aryData.count != 0 {
            let dictData = aryData[indexPath.row]
            
            cell.lblTransferTitle.text = dictData["Description"] as? String
            cell.lblTransferDateAndTime.text = dictData["UpdatedDate"] as? String
            
            let amount = "\(dictData["Amount"] ?? "00.00" as AnyObject)"
            //        let currentRatio = Double(dictData["Amount"] as! String)!
            if !amount.isEmpty {
                let currentRatio = Double(amount)
                if dictData["Status"] as! String == "failed" || dictData["Status"] as! String == "pending" {
                    
                    if dictData["Status"] as! String == "failed" {
                        cell.lblPrice.text = "\("Transaction Failed ")\(dictData["Type"] as! String) \(String(format: "%.2f", currentRatio!))"
                    }else {
                        cell.lblPrice.text = "\(dictData["Type"] as! String) \(String(format: "%.2f", currentRatio!))"
                    }
                    
                    
                    cell.lblPrice.textColor = UIColor.red
                }
                else {
                    
                    cell.lblPrice.text = "\(dictData["Type"] as! String) \(String(format: "%.2f", currentRatio!))"
                    cell.lblPrice.textColor = UIColor.init(red: 0, green: 144/255, blue: 81/255, alpha: 1.0)
                }
                
                if dictData["Status"] as! String == "pending" {
                    cell.lblPending.isHidden = false
                }else {
                    cell.lblPending.isHidden = true
                }
            }
        }
      
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnTopUP(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletTopUpVC") as! WalletTopUpVC
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    @IBAction func btnTransferToBank(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletTransferToBankVC") as! WalletTransferToBankVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnHistory(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletHistoryViewController") as! WalletHistoryViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Transaction History
    //-------------------------------------------------------------
    
    func webserviceOfTransactionHistory()
    {
        
        webserviceForTransactionHistoryInWallet(Singletons.sharedInstance.strDriverID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                Singletons.sharedInstance.strCurrentBalance = ((result as! NSDictionary).object(forKey: "walletBalance") as AnyObject).doubleValue
                
                
                let currentRatio = Double(Singletons.sharedInstance.strCurrentBalance)
                
                self.lblAvailableFundsDesc.text = "\(currency)\(String(format: "%.2f", currentRatio))"
                
                
                    if let historyData = (result as! NSDictionary).object(forKey: "history") as? [[String:AnyObject]] {
                        self.aryData = historyData
                        Singletons.sharedInstance.walletHistoryData = self.aryData
                        
                    }
                
                
                
                if self.aryData.count != 0 {
                    
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }

}
