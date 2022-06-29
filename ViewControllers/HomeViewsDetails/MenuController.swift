//
//  MenuController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 11/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
//import SideMenuController
import SDWebImage



class MenuController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgProfilePic: UIImageView!
//    var arrTitle = [kMyProfile, kBankDetails, kTripHistory, kEzygoInvoices, kWallet, kMyRating,"Log Mate", kLogRecord,kInviteDriver, "Customer Support" ,kVehicleOption,kDocuments,kSettings]
    var arrTitle = [String]()
    var isSelectedIndex = false
    

//    var aryItemNames = [String]()
//    var aryItemIcons = [String]()
//
    var driverFullName = String()
    var driverImage = UIImage()
    var driverMobileNo = String()
    var strImagPath = String()
    
    private var previousIndex: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.navigationItem.title = "Log Record"
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "updateProfile"), object: nil)
        self.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.size.width / 2
        self.imgProfilePic.clipsToBounds = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func giveGradientColor() {
        
        let colorTop =  UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        let colorMiddle =  UIColor(red: 36/255, green: 24/255, blue: 3/255, alpha: 0.5).cgColor
        let colorBottom = UIColor(red: 64/255, green: 43/255, blue: 6/255, alpha: 0.8).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorMiddle, colorBottom]
        gradientLayer.locations = [ 0.0, 0.5, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    //MARK: - Set Data
    @objc func getData() {
        let profile =  NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary))
        
        
        
        var isLogMate = false
        /*
        if let strLogMate = profile.object(forKey: "Logmate") as? String {
            isLogMate  = (strLogMate == "0") ? false : true
        }else if let strLogMate = profile.object(forKey: "Logmate") as? Int {
            isLogMate = strLogMate == 0 ? false : true
        } */
        
        if let strLogMate = profile.object(forKey: "EzygoTaxiMeter") as? String {
            isLogMate  = (strLogMate == "0") ? false : true
        }else if let strLogMate = profile.object(forKey: "EzygoTaxiMeter") as? Int {
            isLogMate = strLogMate == 0 ? false : true
        }
        
      /*  if isLogMate { 20th feb 2020
            arrTitle = [kMyProfile, kBankDetails, kTripHistory, kEzygoInvoices, kWallet, kMyRating,"Taxi Meter", kLogRecord,kInviteDriver, "Customer Support" ,kVehicleOption,kDocuments,kDriverPortal]
        }else {
            arrTitle = [kMyProfile, kBankDetails, kTripHistory, kEzygoInvoices, kWallet, kMyRating,kLogRecord,kInviteDriver, "Customer Support" ,kVehicleOption,kDocuments,kDriverPortal]
        } */
        
        if isLogMate {
            arrTitle = [kMyProfile, kBankDetails, kTripHistory, kEzygoInvoices, kMyRating,"Taxi Meter", kLogRecord,kInviteDriver, "Customer Support" ,kVehicleOption,kDocuments,kDriverPortal]
        }else {
            arrTitle = [kMyProfile, kBankDetails, kTripHistory, kEzygoInvoices, kMyRating,kLogRecord,kInviteDriver, "Customer Support" ,kVehicleOption,kDocuments,kDriverPortal]
        }
        tblView.reloadData()
        //         {
        
        
        //            NSMutableDictionary(Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as NSDictionary).object(forKey: "profile")
        
        driverFullName = profile.object(forKey: "Fullname") as! String
        driverMobileNo = profile.object(forKey: "Email") as! String
        
        strImagPath = profile.object(forKey: "Image") as! String
        
        lblName.text = driverFullName
        lblEmail.text = driverMobileNo
        
        if let strUrl = profile.object(forKey: "Image") as? String {
//            imgProfilePic.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            imgProfilePic.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage.init(named: "placeHolderProfile"))
            
        }
        
        //        }
        //        if let profile =  NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as NSDictionary).object(forKey: "profile") as) {
        //
        //
        //            //            NSMutableDictionary(Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as NSDictionary).object(forKey: "profile")
        //
        //            driverFullName = profile.object(forKey: "Fullname") as! String
        //            driverMobileNo = profile.object(forKey: "MobileNo") as! String
        //
        //            strImagPath = profile.object(forKey: "Image") as! String
        //        }
        
        
        
        
        
        
    }
    @objc func setRating() {
        self.tableView.reloadData()
    }

   
    //MARK: - Custom Function
    @objc func openUrlTermsOfUse() {
       
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowTripViewController") as? ShowTripViewController
        viewController?.URLString = "https://ezygo.co.nz/web/ezygo-terms-conditions-without-JavaScript.pdf"
        viewController?.strNavTitle = "Terms Of Use"
        self.navigationController?.pushViewController(viewController!, animated: true)
       
    }
    @objc func openUrlPrivacyPolicy() {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowTripViewController") as? ShowTripViewController
        viewController?.URLString = "https://ezygo.co.nz/web/ezygo-terms-conditions-without-JavaScript.pdf"
        viewController?.strNavTitle = "Privacy Policy"
        self.navigationController?.pushViewController(viewController!, animated: true)
        
    }
    @objc func contactClick() {
        //        Singletons.sharedInstance.selectedMenuSection = indexPath.section
        //        Singletons.sharedInstance.selectedMenuIndex = indexPath.row
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as? ContactUsViewController
        let navController = NavigationRootViewController(rootViewController: viewController ?? UIViewController())
        navController.isNavigationBarHidden = false
//        frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
//        frostedViewController.hideMenuViewController()
    }
    @IBAction func contactUsClick(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    @IBOutlet var tableView: UITableView!
    
    //MARK: - UITableView Datasource and Delegate Method
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrTitle.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: SideMenuViewCell
         let strTitle : String = arrTitle[indexPath.row]
        if strTitle == "Customer Support" {
            cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuViewCell1") as! SideMenuViewCell
            
            cell.btnContactUs.isHidden = !isSelectedIndex
            cell.btnTermsofUse.isHidden = !isSelectedIndex
            cell.btnPrivacyPolicy.isHidden = !isSelectedIndex
            cell.btnContactUs.addTarget(self, action: #selector(contactUsClick(_:)), for: .touchUpInside)
            cell.btnTermsofUse.addTarget(self, action: #selector(openUrlTermsOfUse), for: .touchUpInside)
            cell.btnPrivacyPolicy.addTarget(self, action: #selector(openUrlPrivacyPolicy), for: .touchUpInside)
            
        }else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuViewCell") as! SideMenuViewCell
        }
        
        
        cell.selectionStyle = .none
        
       
        
        cell.lblTitle.textColor = ThemeWhiteColor
        cell.lblTitle.isHidden = false
        cell.iconMenuItem.isHidden = false
        
        if strTitle == "Trip Receipts/Invoices" {
            cell.iconMenuItem.image = UIImage.init(named: "iconEzygoInvoicesUnselect")
            cell.lblTitle.text = strTitle
        } else if strTitle == kSignout {
            cell.lblTitle.isHidden = true
            cell.iconMenuItem.isHidden = true
            let viewFooter = UIView.init(frame: CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: 100))
            
            let iconLogout = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
            iconLogout.image = UIImage.init(named: "iconLogoutUnselect")
            iconLogout.contentMode = .scaleAspectFit
            viewFooter.addSubview(iconLogout)
            
            let lblLogout = UILabel.init(frame: CGRect(x: 0, y: (iconLogout.frame.size.height + iconLogout.frame.origin.y), width: self.view.frame.size.width, height: 25))
            lblLogout.text = kSignout
            lblLogout.textAlignment = .center
            lblLogout.textColor = ThemeWhiteColor
            viewFooter.addSubview(lblLogout)
            
            cell.viewCell.addSubview(viewFooter)
        }else if strTitle == kVehicleOption{
            cell.iconMenuItem.image = UIImage.init(named: "vehicleOption")
            cell.lblTitle.text = strTitle
        }else if strTitle == kDocuments {
            cell.iconMenuItem.image = UIImage.init(named: "documentsOption")
            cell.lblTitle.text = strTitle
        }
        else if strTitle == kDriverPortal {
            cell.iconMenuItem.image = UIImage.init(named: "iconDriverPortalUnSelect")
            cell.lblTitle.text = strTitle
        }
        else if strTitle == "Customer Support" {
            cell.iconMenuItem.image = UIImage.init(named: "iconCustomerSelect")
            cell.lblTitle.text = strTitle
        }else {
            cell.lblTitle.text = strTitle
//            if indexPath.row == 9 {
//                cell.iconMenuItem.image = UIImage.init(named: "iconCustomerSelect")
//            }else
                if indexPath.row == 1 {
                cell.iconMenuItem.image = UIImage.init(named: "iconBankDetailsUnselect")
            } else {
                let strImage = "icon\(strTitle.replacingOccurrences(of: " ", with: ""))Unselect"
                cell.iconMenuItem.image = UIImage.init(named: strImage)
            }
            
        }
       
        return cell
    }
    internal  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tblView.deselectRow(at: indexPath, animated: false)
        let strTitle : String = arrTitle[indexPath.row]
        if strTitle == kSettings
        {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            /*
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
            let navController = NavigationRootViewController(rootViewController: viewController ?? UIViewController())
            navController.isNavigationBarHidden = true
            frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
            frostedViewController.hideMenuViewController()
            */
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(next, animated: true)
            return
        }
        if strTitle == kTripHistory
        {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            /*
            let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyJobsViewController") as? MyJobsViewController
            
            let navController = NavigationRootViewController(rootViewController: ViewController ?? UIViewController())
            navController.isNavigationBarHidden = true
            frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
            frostedViewController.hideMenuViewController() */
            let next = self.storyboard?.instantiateViewController(withIdentifier: "MyJobsViewController") as! MyJobsViewController
            self.navigationController?.pushViewController(next, animated: true)
            return
        }
        if strTitle == kMyProfile
        {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
//            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController") as? UpdateProfileViewController
//            let navController = NavigationRootViewController(rootViewController: viewController ?? UIViewController())
//            navController.isNavigationBarHidden = true
//            frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
//            frostedViewController.hideMenuViewController()
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController") as! UpdateProfileViewController
            self.navigationController?.pushViewController(next, animated: true)
            return
            
        }
        if strTitle == kBankDetails
        {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
//            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BankAccountDetailsViewController") as? BankAccountDetailsViewController
//            let navController = NavigationRootViewController(rootViewController: viewController ?? UIViewController())
//            navController.isNavigationBarHidden = true
//            frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
//            frostedViewController.hideMenuViewController()
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "BankAccountDetailsViewController") as! BankAccountDetailsViewController
            self.navigationController?.pushViewController(next, animated: true)
            return
        }
        if strTitle == kInviteDriver
        {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
//            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendsViewController") as? InviteFriendsViewController
//            let navController = NavigationRootViewController(rootViewController: viewController ?? UIViewController())
//            navController.isNavigationBarHidden = true
//            frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
//            frostedViewController.hideMenuViewController()
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendsViewController") as! InviteFriendsViewController
            self.navigationController?.pushViewController(next, animated: true)
            return
        }
        if strTitle == kWallet
        {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
//            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as? WalletViewController
           
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
            self.navigationController?.pushViewController(next, animated: true)
            return
        }
        if strTitle == "Customer Support" {
            isSelectedIndex = !isSelectedIndex
            tableView.reloadData()
            return
        }
        if strTitle == kMyRating {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            let next = self.storyboard?.instantiateViewController(withIdentifier: "MyRatingViewController") as! MyRatingViewController
            self.navigationController?.pushViewController(next, animated: true)
            return
        }
        if strTitle == kEzygoInvoices {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            let next = self.storyboard?.instantiateViewController(withIdentifier: "TripInvoiceViewController") as! TripInvoiceViewController
            self.navigationController?.pushViewController(next, animated: true)
            return
        }
        if strTitle ==  kLogRecord {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            let next = self.storyboard?.instantiateViewController(withIdentifier: "LogRecordViewController") as! LogRecordViewController
            self.navigationController?.pushViewController(next, animated: true)
            return
        }
        
        if strTitle ==  "Taxi Meter" {
            sideMenuController?.toggle()
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            let next = self.storyboard?.instantiateViewController(withIdentifier: "MeterViewController") as! MeterViewController
            self.navigationController?.present(next, animated: true, completion: nil)
            
            return
        }
        if strTitle == kVehicleOption {
            sideMenuController?.toggle()
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "VehicleOptionViewController") as! VehicleOptionViewController
            self.navigationController?.pushViewController(next, animated: true)
            return
        }
        if strTitle == kDocuments {
            sideMenuController?.toggle()
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "DocumentsViewController") as! DocumentsViewController
            self.navigationController?.pushViewController(next, animated: true)
            return
        }
        if strTitle == kDriverPortal {
            sideMenuController?.toggle()
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row

            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowTripViewController") as? ShowTripViewController
            viewController?.URLString = "https://ezygo.co.nz/web/DriverPanel/loginFromApp/43/e5-f1J5F13s:APA91bEglX-jutCMRh90pDkRQ0kNPfYkQ0iM_kqVrCemXuLw7EsU576tD9Pszk8HWCzedb549i94sfvXdoBwHCnJuoflh55-ChUYCqFObpAYFGT_I9jrBsrcUGy_NJ4CJEtsDOfMQU4R"
            viewController?.strNavTitle = kDriverPortal
            self.navigationController?.pushViewController(viewController!, animated: true)
            return
        }
        
        if strTitle == kLogout {
            webserviceOFSignOut()
        }
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        //MY CHange
        /*
        if indexPath.section == 1
        {
            
            let strCellItemTitle = aryItemNames[indexPath.row]
            
            if strCellItemTitle == kPaymentOption
            {
                if(Singletons.sharedInstance.CardsVCHaveAryData.count == 0)
                {
                      let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                    self.navigationController?.pushViewController(viewController, animated: true)

                }
                else
                {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
                    self.navigationController?.pushViewController(viewController, animated: true)


                }
            }
            else if strCellItemTitle == kWallet
            {
                
                //                self.moveToComingSoon()
                //                   UserDefaults.standard.set(Singletons.sharedInstance.isPasscodeON, forKey: "isPasscodeON")
                
                if (Singletons.sharedInstance.isPasscodeON) {
                    //                    if Singletons.sharedInstance.setPasscode == "" {
                    //                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
                    //                        self.navigationController?.pushViewController(viewController, animated: true)
                    //                    }
                    //                    else {
                    //                        if (Singletons.sharedInstance.passwordFirstTime) {
                    //
                    //                            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                    //                            self.navigationController?.pushViewController(next, animated: true)
                    //                        }
                    //                        else {
                    
                    //My Changesss
                    
//                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
//                    viewController.strStatusToNavigate = "wallet"
//                    self.navigationController?.pushViewController(viewController, animated: true)
                    
                    
                    
                    //                        }
                }
                    
                else
                {
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                    self.navigationController?.pushViewController(next, animated: true)
                }
                
                
                
                
                //                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
                //                self.navigationController?.pushViewController(viewController, animated: true)
                //
                
                //                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                //                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
//            else if indexPath.row == 2 {
//
//                if (Singletons.sharedInstance.isPasscodeON) {
//                    let tabbar =  ((((((self.navigationController?.childViewControllers)?.last as! CustomSideMenuViewController).childViewControllers[0]) as! UINavigationController).childViewControllers[0]) as! TabbarController)
//                    tabbar.selectedIndex = 4
//                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
//                    self.present(viewController, animated: false, completion: nil)
//                    sideMenuController?.toggle()
//
//                }
//                else {
//                    let tabbar =  ((((((self.navigationController?.childViewControllers)?.last as! CustomSideMenuViewController).childViewControllers[0]) as! UINavigationController).childViewControllers[0]) as! TabbarController)
//                    tabbar.selectedIndex = 4
//
//                    sideMenuController?.toggle()
//                }
//
//            }
//            else if indexPath.row == 2 {
////                 self.moveToComingSoon()
//
//                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WeeklyEarningViewController") as! WeeklyEarningViewController
//                self.navigationController?.pushViewController(viewController, animated: true)
//            }
            else if strCellItemTitle == kDriverNews {
//                self.moveToComingSoon()

                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DriverNewsViewController") as! DriverNewsViewController
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
           else if strCellItemTitle == kInviteDrivers {
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "InviteDriverViewController") as! InviteDriverViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if strCellItemTitle == kChangePassword {
                
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
            else if strCellItemTitle == kSettings {

                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingPasscodeVC") as! SettingPasscodeVC
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
            else if strCellItemTitle == kMeter
            {

                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MeterViewController") as! MeterViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if strCellItemTitle == kTripToDstination
            {
                let storyboard = UIStoryboard(name: "TripToDestination", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "TripToDestinationViewController") as! TripToDestinationViewController

//                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TripToDestinationViewController") as! TripToDestinationViewController
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
            else if strCellItemTitle == kShareRide {
                let viewController = storyboard?.instantiateViewController(withIdentifier: "ShareRideViewController") as! ShareRideViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }
                
            else if strCellItemTitle == kLogout
            {
               self.webserviceOFSignOut()
            }
        }
      */
    }
    */
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        let strTitle : String = arrTitle[indexPath.row]
        if strTitle == kSignout {
            return 100
        }else if strTitle == "Customer Support" {
            return isSelectedIndex ?  158 : 50
        }else {
            return 50
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    @objc func updateProfile() {
        /*
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EditDriverProfileVC") as! EditDriverProfileVC
        self.navigationController?.pushViewController(viewController, animated: true)
*/
//        self.sideMenuController?.embed(centerViewController: viewController)
    }
    func getDataFromSingleton() {
        if Singletons.sharedInstance.dictDriverProfile != nil {
            if let profile =  Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as? NSDictionary {
                driverFullName = profile.object(forKey: "Fullname") as! String
                driverMobileNo = profile.object(forKey: "Email") as! String
                
                strImagPath = profile.object(forKey: "Image") as! String
            }
        }
        
//         {
        
            
//            NSMutableDictionary(Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as NSDictionary).object(forKey: "profile")
        
        
        
        
//        }
//        if let profile =  NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as NSDictionary).object(forKey: "profile") as) {
//
//
//            //            NSMutableDictionary(Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as NSDictionary).object(forKey: "profile")
//
//            driverFullName = profile.object(forKey: "Fullname") as! String
//            driverMobileNo = profile.object(forKey: "MobileNo") as! String
//
//            strImagPath = profile.object(forKey: "Image") as! String
//        }
        
        
        
        
        tableView.reloadData()
        
    }
    
    // ------------------------------------------------------------
    
    func moveToComingSoon() {
        /*
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ComingSoonVC") as! ComingSoonVC
        self.navigationController?.pushViewController(viewController, animated: true)
         */
    }
    
    @IBAction func logoutClick(_ sender: UIButton) {
        self.webserviceOFSignOut()
    }
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOFSignOut()
    {
        let srtDriverID = Singletons.sharedInstance.strDriverID
        
        let param = srtDriverID + "/" + Singletons.sharedInstance.deviceToken
        
        webserviceForSignOut(param as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                let socket = (UIApplication.shared.delegate as! AppDelegate).Socket
   
                socket?.off(socketApiKeys.kReceiveBookingRequest)
                socket?.off(socketApiKeys.kBookLaterDriverNotify)
                
                socket?.off(socketApiKeys.kGetBookingDetailsAfterBookingRequestAccepted)
                socket?.off(socketApiKeys.kAdvancedBookingInfo)
                
                socket?.off(socketApiKeys.kReceiveMoneyNotify)
                socket?.off(socketApiKeys.kAriveAdvancedBookingRequest)
                
                socket?.off(socketApiKeys.kDriverCancelTripNotification)
                socket?.off(socketApiKeys.kAdvancedBookingDriverCancelTripNotification)
                Singletons.sharedInstance.setPasscode = ""
                Singletons.sharedInstance.isPasscodeON = false
                socket?.disconnect()
                
                for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
                    print("\(key) = \(value) \n")
                    
                    if key == "Token" {
                        
                    }
                    else {
                        UserDefaults.standard.removeObject(forKey: key)
                    }
                }
                UserDefaults.standard.set(false, forKey: "isTripDestinationShow")
              //  UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                Singletons.sharedInstance.isDriverLoggedIN = false                                                                                                                                                                                                                                                        
//                self.performSegue(withIdentifier: "SignOutFromSideMenu", sender: (Any).self)
//                self.navigationController?.popToRootViewController(animated: true)
                
                
                let loginVw = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let navigationController = UINavigationController(rootViewController: loginVw)

                appDelegate.window?.rootViewController = navigationController
                
                
                self.navigationController?.popToRootViewController(animated: true)
//                let arrView = self.navigationController!.viewControllers
//
//                for vw in arrView {
//                    if vw is LoginViewController {
//                         self.navigationController?.popToViewController(vw, animated: true)
//                        break
//                    }
//                }
               
                
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
