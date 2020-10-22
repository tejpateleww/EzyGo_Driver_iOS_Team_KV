//
//  LogRecordViewController.swift
//  ezygo-Driver
//
//  Created by Apple on 04/12/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class LogRecordViewController: ParentViewController, UITableViewDataSource, UITableViewDelegate {
    
    var strNotAvailable: String = "N/A"
    var aryData = NSArray()
  
    
    var selectedCellIndexPath: IndexPath?
    let selectedCellHeight: CGFloat = 350.5
    let unselectedCellHeight: CGFloat = 86.5
    var thereIsCellTapped = false
    var selectedRowIndex = -1
    
    @IBOutlet var tblView: UITableView!
    
    
    var expandedCellPaths = Set<IndexPath>()
    var labelNoData = UILabel()
    
    override func loadView() {
        super.loadView()
        
        //        let activityData = ActivityData()
        //        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Global Declaration
    //-------------------------------------------------------------
    
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = ThemeYellowColor
        
        return refreshControl
    }()
    
    
    func dismissSelf() {
        
        self.navigationController?.popViewController(animated: true)
        
        
        //        self.dismiss(animated: true, completion: nil)
    }
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate = self
        
        self.labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.labelNoData.text = "Loading..."
        self.labelNoData.textAlignment = .center
        self.view.addSubview(self.labelNoData)
        self.tblView.isHidden = true
        
        self.tblView.tableFooterView = UIView()
        
        
        self.tblView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        self.tblView.addSubview(self.refreshControl)
        self.webserviceofLogRecord()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        //        aryPastJobs.removeAllObjects()
        
        webserviceofLogRecord()
        
        tblView.reloadData()
        
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    
    
    
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  self.aryData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogRecordCell") as! LogRecordCell
        //        let cell2 = tableView.dequeueReusableCell(withIdentifier: "NoDataFound") as! PastJobsListTableViewCell
        
        cell.selectionStyle = .none
        cell.vwCell.layer.cornerRadius = 10
        cell.vwCell.clipsToBounds = true
        cell.vwCell.layer.shadowRadius = 3.0
        cell.vwCell.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        cell.vwCell.layer.shadowOffset = CGSize (width: 1.0, height: 1.0)
        cell.vwCell.layer.shadowOpacity = 1.0
        //
//        cell.viewAllDetails.isHidden = !expandedCellPaths.contains(indexPath)
        
        //        cell2.selectionStyle = .none
        
        let data = aryData.object(at: indexPath.row) as! NSDictionary
        
        //        cell.viewAllDetails.isHidden = true
        //                cell.selectionStyle = .none
        
        cell.lblShiftStart.text = data.object(forKey: "StartDate") as? String
        cell.lblShiftStop.text = data.object(forKey: "StopDate") as? String
        cell.lblTotalShiftTime.text = data.object(forKey: "Online") as? String
        let strBookingDate  =  data.object(forKey: "StartDate") as! String
        cell.lblCurrentDate.text = "Date: " + Utilities.formattedDateFromStringPost(dateString: strBookingDate , withFormat: "dd-MM-yyyy")!
        
        return cell
        
        
    }
    
    //MARK: shareReceipt
    @IBAction func shareRecieptClick(_ sender: UIButton) {
        let data = aryData[sender.tag] as! NSDictionary
        let strShareUrl = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "ShareUrl", isNotHave: strNotAvailable)
        if strShareUrl != strNotAvailable {
            Utilities.shareUrl(strShareUrl)
        }
    }
    
    func setTimeStampToDate(timeStamp: String) -> String {
        
        //        let unixTimestamp = Double(timeStamp)
        //        //        let date = Date(timeIntervalSince1970: unixTimestamp)
        //
        //        let date = Date(timeIntervalSince1970: unixTimestamp!)
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone = NSTimeZone.system //TimeZone(abbreviation: "GMT") //Set timezone that you want
        //        dateFormatter.locale = NSLocale.current
        //        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss" //Specify your format that you want
        //        let strDate: String = dateFormatter.string(from: date)
        
        return timeStamp
    }
    func setTimeStampToDateDropTime(timeStamp: String) -> String {
        
        let unixTimestamp = Double(timeStamp)
        //        let date = Date(timeIntervalSince1970: unixTimestamp)
        
        let date = Date(timeIntervalSince1970: unixTimestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system //TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss" //Specify your format that you want
        let strDate: String = dateFormatter.string(from: date)
        
        return strDate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        if indexPath.section == 0 {
        //
        //            if aryPastJobs.count != 0 {
        //
        
        /*
        if let cell = tableView.cellForRow(at: indexPath) as? PastJobsListViewCell {
            cell.viewAllDetails.isHidden = !cell.viewAllDetails.isHidden
            if cell.viewAllDetails.isHidden {
                expandedCellPaths.remove(indexPath)
            } else {
                expandedCellPaths.insert(indexPath)
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            //            tableView.deselectRow(at: indexPath, animated: true)
        }
        */
        
        //            }
        //        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    
    func webserviceofLogRecord() {
        
        Utilities.showActivityIndicator()
        let driverID = Singletons.sharedInstance.strDriverID
        //        UtilityClass.showHUD()
//        driverID = "46"
        webserviceForLogRecordHistory(driverID as AnyObject) { (result, status) in
            
            if (status) {
                //                print(result)
                
                
                self.aryData = ((result as! NSDictionary).object(forKey: "driverlog") as! NSArray)
                
                
                if(self.aryData.count == 0)
                {
                    self.labelNoData.text = "There are no data"
                    self.tblView.isHidden = true
                }
                else
                {
                    self.labelNoData.removeFromSuperview()
                    self.tblView.isHidden = false
                }
                
                //                self.getPostJobs()
                self.tblView.reloadData()
                self.refreshControl.endRefreshing()
                Utilities.hideActivityIndicator()
                //               UtilityClass.hideHUD()
                //                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            else {
                print(result)
                
                Utilities.hideActivityIndicator()
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
        
        
   
    
//    func getPostJobs() {
//
//        aryPastJobs.removeAllObjects()
//
//        refreshControl.endRefreshing()
//        for i in 0..<aryData.count {
//
//            let dataOfAry = (aryData.object(at: i) as! NSDictionary)
//
//            //            let strHistoryType = dataOfAry.object(forKey: "HistoryType") as? String
//            let strHistoryType = dataOfAry.object(forKey: "Status") as? String
//
//            if strHistoryType == "completed" {
//                self.aryPastJobs.add(dataOfAry)
//            }
//
//        }
//    }

    
}

class LogRecordCell: UITableViewCell {
    @IBOutlet weak var vwCell: UIView!
    @IBOutlet weak var lblCurrentDate: UILabel!
    @IBOutlet weak var lblShiftStart: UILabel!

    @IBOutlet weak var lblShiftStop: UILabel!

    @IBOutlet weak var lblTotalShiftTime: UILabel!

}
