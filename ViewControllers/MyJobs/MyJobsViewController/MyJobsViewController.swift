//
//  MyJobsViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 12/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

protocol RefreshDataDelegate: class
{
    func refreshJobs()
}
class MyJobsViewController: ParentViewController,UIGestureRecognizerDelegate
{

    var crnRadios = CGFloat()
    var shadowOpacity = Float()
    var shadowRadius = CGFloat()
    var shadowOffsetWidth = Int()
    var shadowOffsetHeight = Int()
    var btnHomeNavigation: UIButton!
    
    @IBOutlet var viewSelection: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var btnFutureBooking: UIButton!
    
    @IBOutlet var btnPendingJobs: UIButton!
    
    @IBOutlet var btnPastJobs: UIButton!
    
    @IBOutlet var constrainSelectionX_position: NSLayoutConstraint!
    var pageControl = UIPageControl()
    
    
    var isFutureBookingArrive = false
    
    @IBOutlet var tableView: UITableView!
    
//    @IBOutlet var Conmmstain_btnStackViewY_posistion: NSLayoutConstraint!
//
//    @IBOutlet var constrasin_viewSelection_y_position: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        crnRadios = 20
        shadowOpacity = 0.2
        shadowRadius = 1
        shadowOffsetWidth = 0
        shadowOffsetHeight = 1
        
        if isFutureBookingArrive {
            isFutureBookingArrive = false
            self.btnFutureBookingClicked(btnFutureBooking)
        }
        
        getTimeOfStartTrip()
//        giveCornorRadiosToView()
// Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.socket?.off(socketApiKeys.kStartTripTimeError)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMyJobs(segue:UIStoryboardSegue) {
        
//        self.btnPendingJobs(btnPending)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
        
        if self.navigationController?.childViewControllers.count == 1
        {
//            Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "My Jobs", naviTitleImage: "", leftImage: kMenu_Icon, rightImage: "")
//            self.frostedViewController.panGestureEnabled = true
        }
        else
        {
//            Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "My Jobs", naviTitleImage: "", leftImage: kBack_Icon, rightImage: "")
//            self.frostedViewController.panGestureEnabled = false
//            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        
        
        /*
        btnHomeNavigation = UIButton(type: .custom)

        btnHomeNavigation.setImage(UIImage(named: "iconHome"), for: .normal)

        btnHomeNavigation.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnHomeNavigation.addTarget(self, action: #selector(btnHomeIconClicked(_:)), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btnHomeNavigation)
        
        self.navigationItem.setRightBarButtonItems([item1], animated: true)

        */
        
//        if Singletons.sharedInstance.isPresentVC == true
//        {
//        
//            let PendingJobsList = self.storyboard?.instantiateViewController(withIdentifier: "PendingJobsListVC") as! PendingJobsListVC
//            
//            Singletons.sharedInstance.isPresentVC = false
//
//            self.navigationController?.pushViewController(PendingJobsList, animated: true)
//        }
        
//        if Singletons.sharedInstance.isBackFromPending == true
//        {
//
//            Singletons.sharedInstance.isBackFromPending = false
//
//            self.callSocket()
//
//        }
        
        if Singletons.sharedInstance.isFromNotification == true
        {
            Singletons.sharedInstance.isFromNotification = false
            self.btnFutureBookingClicked(self.btnFutureBooking)
        }
        
    }
    @objc func btnHomeIconClicked(_ sender : UIButton)
    {
//        if Singletons.sharedInstance.driverDuty == "0"
//        {
//            print("on")
//            Singletons.sharedInstance.driverDuty = "1"
//            self.btnHomeNavigation.setImage(UIImage(named: "iconSwitchOFF"), for: .normal)
//            //            self.webserviceForChangeDutyStatus()
//        }
//        else
//        {
//            print("off")
//            Singletons.sharedInstance.driverDuty = "0"
//            self.btnSwitchNavigation.setImage(UIImage(named: "iconSwitchON"), for: .normal)
//            //            self.webserviceForChangeDutyStatus()
//        }
        
    }
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    
//     @IBOutlet var btnPending: UIButton!
//    @IBOutlet var viewDispatchedJobs: UIView!
//    @IBOutlet var viewPastJobs: UIView!
//    @IBOutlet var viewFutureJobs: UIView!
//    @IBOutlet var viewPendingJobs: UIView!
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------

    @IBAction func btnDispatchedJobs(_ sender: UIButton) {
        

//        let dispatchJobs = self.storyboard?.instantiateViewController(withIdentifier: "DispatchedJobsForMyJobsVC") as! DispatchedJobsForMyJobsVC
//
//        self.navigationController?.pushViewController(dispatchJobs, animated: true)
//        self.navigationController?.present(dispatchJobs, animated: true, completion: nil)
//         (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(dispatchJobs, animated: true, completion: nil)

    }
//    @IBAction func btnPastJobs(_ sender: UIButton) {
//        
//        let PastJobsList = self.storyboard?.instantiateViewController(withIdentifier: "PastJobsListVC") as! PastJobsListVC
//
//        self.navigationController?.pushViewController(PastJobsList, animated: true)
//        
////        self.navigationController?.present(PastJobsList, animated: true, completion: nil)
//        
//     
//    }
//    @IBAction func btnFutureBookings(_ sender: UIButton) {
//        
//        let FutureBooking = self.storyboard?.instantiateViewController(withIdentifier: "FutureBookingVC") as! FutureBookingVC
//        
//        self.navigationController?.pushViewController(FutureBooking, animated: true)
//    
////        self.navigationController?.present(FutureBooking, animated: true, completion: nil)
//        
//    }
//    
//    @IBAction func btnPendingJobs(_ sender: UIButton) {
//
//        let PendingJobsList = self.storyboard?.instantiateViewController(withIdentifier: "PendingJobsListVC") as! PendingJobsListVC
//        PendingJobsList.webserviceofPendingJobs()
//        self.navigationController?.pushViewController(PendingJobsList, animated: true)
//        
////        self.navigationController?.present(PendingJobsList, animated: true, completion: nil)
//       
//        
//    }
    @IBAction func btnFutureBookingClicked(_ sender: Any)
    {
      
        btnFutureBooking.isSelected = true
        btnPendingJobs.isSelected = false
        btnPastJobs.isSelected = false
        self.constrainSelectionX_position.constant = 0
        
        let vwFuture = self.childViewControllers[0] as? FutureBookingViewController
        
//        ViewController?.webserviceOFFurureBooking(showHud: true)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations:
            {
                
                self.btnFutureBooking.setTitleColor(ThemeYellowColor, for: .normal)
                self.btnPendingJobs.setTitleColor(UIColor.lightGray, for: .normal)
                self.btnPastJobs.setTitleColor(UIColor.lightGray, for: .normal)
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                
                self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func btnPendingJobsClicked(_ sender: Any)
    {
        btnFutureBooking.isSelected = false
        btnPendingJobs.isSelected = true
        btnPastJobs.isSelected = false
        self.constrainSelectionX_position.constant = self.btnPendingJobs.frame.size.width

        let vwPendingJobs = self.childViewControllers[1] as? PendingJobsViewController
        vwPendingJobs?.webserviceofPendingJobs()
//        ViewController?.webserviceofPendingJobs()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {

            self.btnFutureBooking.setTitleColor(UIColor.lightGray, for: .normal)
            self.btnPendingJobs.setTitleColor(ThemeYellowColor, for: .normal)
            self.btnPastJobs.setTitleColor(UIColor.lightGray, for: .normal)
            self.scrollView.contentOffset = CGPoint(x: self.view.frame.size.width, y: 0)
            self.view.layoutIfNeeded()


//            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyJobsViewController") as? MyJobsViewController
//
//            _ = (viewController?.childViewControllers[1])as! PendingJobsViewController



            let deadlineTime = DispatchTime.now() + .seconds(3)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
//                PendingJobsList.webserviceofPendingJobs()
            })

        }, completion: nil)
    }
    
    @IBAction func btnPastJobsClicked(_ sender: Any)
    {
        btnFutureBooking.isSelected = false
        btnPendingJobs.isSelected = false
        btnPastJobs.isSelected = true
        
        self.constrainSelectionX_position.constant = self.btnPastJobs.frame.size.width*2
        let vwPastJobs = self.childViewControllers[2] as? PastJobsViewController
        
//        ViewController?.webserviceofPendingJobs()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations:
            {
            
            self.btnFutureBooking.setTitleColor(UIColor.lightGray, for: .normal)
            self.btnPendingJobs.setTitleColor(UIColor.lightGray, for: .normal)
            self.btnPastJobs.setTitleColor(ThemeYellowColor, for: .normal)
            self.scrollView.contentOffset = CGPoint(x: self.view.frame.size.width*2, y: 0)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    let socket = (UIApplication.shared.delegate as! AppDelegate).Socket

    
    func callSocket()
    {
        
//        let socket = (((self.navigationController?.childViewControllers[0] as! TabbarController).childViewControllers)[0] as! ContentViewController).socket
        
        
        if Singletons.sharedInstance.driverDuty == "1"  {
           Utilities.showActivityIndicator()
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as? HomeViewController
            var isAdvance = viewController?.isAdvanceBooking
            
            isAdvance = true
            
            
            let myJSON = ["DriverId" : Singletons.sharedInstance.strDriverID, "BookingId" : Singletons.sharedInstance.strPendinfTripData] as [String : Any]
            socket?.emit("NotifyPassengerForAdvancedTrip", with: [myJSON])
            Singletons.sharedInstance.strBookingType = "BookLater"
            print("Start Trip : \(myJSON)")
            Utilities.hideActivityIndicator()
//            self.navigationController?.popViewController(animated: true) // 1st jan 
        }else {
            
            UtilityClass.showAlert(appName.kAPPName, message: "Please get online first", vc: self)
        }
      
    }
    
    
    func getTimeOfStartTrip()
    {
        self.socket?.on(socketApiKeys.kStartTripTimeError, callback: { (data, ack) in
            print("getTimeOfStartTrip() : \(data)")
            if((((data as NSArray).object(at: 0) as! NSDictionary)).object(forKey: "status") as! Int == 1) {
                if let vwHome  = self.navigationController?.viewControllers[0] as? HomeViewController {
                    
                    vwHome.acceptRequest(data as NSArray)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                //                self.btnCompleteTrip.isHidden = true
                UtilityClass.showAlert(appName.kAPPName, message: (((data as NSArray).object(at: 0) as! NSDictionary)).object(forKey: "message") as! String, vc: self)
            }
//
        })
    }
    
    func refreshJobs()
    {
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
    
}

