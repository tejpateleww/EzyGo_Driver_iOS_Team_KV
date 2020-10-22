//
//  MyRatingViewController.swift
//  ezygo-Driver
//
//  Created by Apple on 08/10/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class MyRatingViewController: ParentViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var tblview: UITableView!
    @IBOutlet weak var vwRating: HCSStarRatingView!
    
    @IBOutlet weak var vwHeader: UIView!
    var aryData = NSArray()
    var labelNoData = UILabel()
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        self.tblview.dataSource = self
//        self.tblview.delegate = self
        
        self.tblview.tableFooterView = UIView()
        
        
        labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.labelNoData.text = "Loading..."
        self.labelNoData.isHidden = true
        labelNoData.textAlignment = .center
        self.view.addSubview(labelNoData)
        
        vwRating.value = Singletons.sharedInstance.driverAverageRatings
//        self.tblview.isHidden = true
        
        self.tblview.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
//        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "My Rating", naviTitleImage: "", leftImage: kBackButton, rightImage: "")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.webserviceForMyFeedbackList()
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Feedbackcell = tableView.dequeueReusableCell(withIdentifier: "MyRatingTableViewCell") as! MyRatingTableViewCell
        
        Feedbackcell.selectionStyle = .none
        let dictData = self.aryData[indexPath.row] as! [String:Any]
        
        if let DriverName:String = dictData["PassengerName"] as? String {
            Feedbackcell.lblDriverName.text = DriverName
        }
        
        if let DriverRate:String = dictData["Rating"] as? String {
            Feedbackcell.RatingView.rating = Double(DriverRate)!
        }
        
        if let FromLocation = dictData["PickupLocation"] as? String {
            Feedbackcell.lblFromLocation.text = FromLocation
        }
        
        if let ToLocation = dictData["DropoffLocation"] as? String {
            Feedbackcell.lblToLocation.text = ToLocation
        }
        if let strBookingId = dictData["BookingId"] as? String {
            Feedbackcell.lblBookingID.text = "Booking Id : " + strBookingId
        }
        if let Dates = dictData["Date"] as? String {
            if !Dates.isEmpty {
              Feedbackcell.lblRideDate.text =  Utilities.formattedDateFromStringPost(dateString: Dates, withFormat: "dd-MM-yyyy")
                
            }
//            let fulldate = Dates.components(separatedBy: " ")
//            Feedbackcell.lblRideDate.text = fulldate[0]
        }
        
        if let imgDriver = dictData["PassengerImage"] as? String {
            Feedbackcell.imgProfile.sd_setShowActivityIndicatorView(true)
            Feedbackcell.imgProfile.sd_setIndicatorStyle(.gray)
            Feedbackcell.imgProfile.sd_setImage(with: URL(string:"\(WebserviceURLs.kImageBaseURL)/\(imgDriver)"), completed: nil)
            Feedbackcell.imgProfile.sd_setImage(with: URL(string:"\(WebserviceURLs.kImageBaseURL)/\(imgDriver)")) { (img, error, SDImageCacheTypeNone, url) in
                if img == nil {
                    Feedbackcell.imgProfile.image = UIImage.init(named: "placeHolderProfile") 
                }
            }
        }
        if let strComment = dictData["Comment"] as? String {
            if strComment.isEmpty {
                Feedbackcell.lblCommentTitle.isHidden = true
                Feedbackcell.lblCommentDesc.isHidden = true
                
            }else {
                Feedbackcell.lblCommentTitle.isHidden = false
                Feedbackcell.lblCommentDesc.isHidden = false
                Feedbackcell.lblCommentDesc.text = strComment
            }
        }
        
//            DispatchQueue.main.async {
//                Feedbackcell.imgProfile.layoutIfNeeded()
//                Feedbackcell.imgProfile.layer.cornerRadius = Feedbackcell.imgProfile.frame.height/2
//                Feedbackcell.imgProfile.layer.masksToBounds = true
//        //            let activityData = ActivityData()
//        //        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
//            }
       
        
        return Feedbackcell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    //MARK: MY Change
    func webserviceForMyFeedbackList() {
//        var dictData = [String:AnyObject]()
//        dictData["DeviceType"] = "1" as AnyObject
        
        webserviceForGetMyFeedbackList(Singletons.sharedInstance.strDriverID as AnyObject) { (result, status) in
            if status
            {
                print(result)
                self.aryData = ((result as! NSDictionary).object(forKey: "feedback") as! NSArray)
                print(result)
              
                
                if(self.aryData.count == 0)
                {
                    self.labelNoData.text = "Please check back later"
                    self.tblview.isHidden = true
                    self.vwHeader.isHidden = true
                }
                else
                {
                    self.labelNoData.removeFromSuperview()
                    self.tblview.isHidden = false
                    self.vwHeader.isHidden = false
                }
                self.tblview.reloadData()
            }
            else
            {
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
