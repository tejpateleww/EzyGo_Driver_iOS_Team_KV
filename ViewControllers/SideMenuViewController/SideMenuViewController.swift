 //
//  SideMenuViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 10/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
  
  
    var driverFullName = String()
    var driverImage = UIImage()
    var driverMobileNo = String()
    var strImagPath = String()
    
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgProfilePic: UIImageView!
    var arrTitle = [kMyProfile, kBankDetails, kTripHistory, kEzygoInvoices, kWallet, kMyRating,"Log Mate",kLogRecord, kInviteDriver,"Customer Support", kSettings, kSignout]
    var isSelectedIndex = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.getData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.size.width / 2
        self.imgProfilePic.clipsToBounds = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Set Data
    func getData() {
        let profile =  NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary))
        //         {
        
        
        //            NSMutableDictionary(Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as NSDictionary).object(forKey: "profile")
        
        driverFullName = profile.object(forKey: "Fullname") as! String
        driverMobileNo = profile.object(forKey: "Email") as! String
        
        strImagPath = profile.object(forKey: "Image") as! String
        
        lblName.text = driverFullName
        lblEmail.text = driverMobileNo
        
        if let strUrl = profile.object(forKey: "Image") as? String {
            imgProfilePic.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            imgProfilePic.sd_setImage(with: URL(string:  WebserviceURLs.kImageBaseURL + strUrl)) { (image, error, cacheType, url) in
                self.imgProfilePic.sd_removeActivityIndicator()
        }
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
    //MARK: - Custom Function
    @objc func contactClick() {
//        Singletons.sharedInstance.selectedMenuSection = indexPath.section
//        Singletons.sharedInstance.selectedMenuIndex = indexPath.row
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as? ContactUsViewController
        let navController = NavigationRootViewController(rootViewController: viewController ?? UIViewController())
        navController.isNavigationBarHidden = false
//        frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
//        frostedViewController.hideMenuViewController()
    }
    
    @objc func openUrlTermsOfUse() {
        //        Singletons.sharedInstance.selectedMenuSection = indexPath.section
        //        Singletons.sharedInstance.selectedMenuIndex = indexPath.row
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowTripViewController") as? ShowTripViewController
        viewController?.URLString = "https://www.ezygo.co.nz/web/ezygo-terms-of-use-privacy.pdf"
//        "http://ezygo.co.nz/wp-content/uploads/2016/08/ezygo-terms-conditions-without-JavaScript.pdf"
        self.navigationController?.pushViewController(viewController!, animated: true)
        //        frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
        //        frostedViewController.hideMenuViewController()
    }
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
        if indexPath.row == 9 {
             cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuViewCell1") as! SideMenuViewCell
            
            cell.btnContactUs.isHidden = !isSelectedIndex
            cell.btnTermsofUse.isHidden = !isSelectedIndex
            cell.btnPrivacyPolicy.isHidden = !isSelectedIndex
            cell.btnContactUs.addTarget(self, action: #selector(contactClick), for: .touchUpInside)
            cell.btnTermsofUse.addTarget(self, action: #selector(openUrlTermsOfUse), for: .touchUpInside)
//            cell.btnPrivacyPolicy.addTarget(self., action: #selector(<#T##@objc method#>), for: .touchUpInside)
        }else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuViewCell") as! SideMenuViewCell
        }
        
        
        cell.selectionStyle = .none

        let strTitle : String = arrTitle[indexPath.row]
        
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
        } else {
            cell.lblTitle.text = strTitle
            if indexPath.row == 8 {
                 cell.iconMenuItem.image = UIImage.init(named: "iconCustomerSelect")
            }else {
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
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
            let navController = NavigationRootViewController(rootViewController: viewController ?? UIViewController())
            navController.isNavigationBarHidden = true
//            frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
//            frostedViewController.hideMenuViewController()
            return
        }
        if strTitle == kTripHistory
        {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyJobsViewController") as? MyJobsViewController

            let navController = NavigationRootViewController(rootViewController: ViewController ?? UIViewController())
            navController.isNavigationBarHidden = true
//            frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
//            frostedViewController.hideMenuViewController()
            return
        }
        if strTitle == kMyProfile
        {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController") as? UpdateProfileViewController
            let navController = NavigationRootViewController(rootViewController: viewController ?? UIViewController())
            navController.isNavigationBarHidden = true
//            frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
//            frostedViewController.hideMenuViewController()
            return
        }
        if strTitle == kBankDetails
        {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BankAccountDetailsViewController") as? BankAccountDetailsViewController
            let navController = NavigationRootViewController(rootViewController: viewController ?? UIViewController())
            navController.isNavigationBarHidden = true
//            frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
//            frostedViewController.hideMenuViewController()
            return
        }
        if strTitle == kInviteDriver
        {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendsViewController") as? InviteFriendsViewController
            let navController = NavigationRootViewController(rootViewController: viewController ?? UIViewController())
            navController.isNavigationBarHidden = true
//            frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
//            frostedViewController.hideMenuViewController()
            return
        }
        if strTitle == kWallet
        {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as? WalletViewController
            let navController = NavigationRootViewController(rootViewController: viewController ?? UIViewController())
            navController.isNavigationBarHidden = true
//            frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
//            frostedViewController.hideMenuViewController()
            return
        }
        if strTitle == "Customer Support" {
           isSelectedIndex = !isSelectedIndex
            tableView.reloadData()
        }
       /*
        //        if Singletons.sharedInstance.selectedMenuIndex == indexPath.row && Singletons.sharedInstance.selectedMenuSection == indexPath.section
        //        {
        //            //            self.revealViewController() .revealToggle(nil)
        //        }
        Singletons.sharedInstance.selectedMenuSection = indexPath.section
        Singletons.sharedInstance.selectedMenuIndex = indexPath.row
        let strTitle : String = Singletons.sharedInstance.arrCategoryListTitle[indexPath.row]["name"] as! String
        
        if strTitle == kHOME //indexPath.row == 0
        {
            //for HOME
            Singletons.sharedInstance.selectedMenuSection = 0
            Singletons.sharedInstance.selectedMenuIndex = 0
            Singletons.sharedInstance.strNavigationHOMETitle = "Home"
            //            Appdelegate.selectedMenuSection = indexPath.section
            //            Appdelegate.selectedMenuIndex = indexPath.row
            Singletons.sharedInstance.isFromSideMenu = false
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
            let navController = NavigationRootViewController(rootViewController: viewController ?? UIViewController())
            navController.isNavigationBarHidden = true
            frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
            frostedViewController.hideMenuViewController()
            return
        }
        //
        if strTitle == kCopyRight
        {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
            viewController?.isPresented = false
            viewController?.strNaviTitle = kCopyRight
            viewController?.strURL = WebserviceURLs.kCopyRights
            let navController = NavigationRootViewController(rootViewController: viewController ?? UIViewController())
            navController.isNavigationBarHidden = true
            frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
            frostedViewController.hideMenuViewController()
            return
        }
        if strTitle == kTermsOfUse
        {
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
            viewController?.isPresented = false
            viewController?.strNaviTitle = kTermsOfUse
            viewController?.strURL = WebserviceURLs.kTermsCondition
            let navController = NavigationRootViewController(rootViewController: viewController ?? UIViewController())
            navController.isNavigationBarHidden = true
            frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
            frostedViewController.hideMenuViewController()
            return
        }
       
        if strTitle == kSignout || strTitle == kLogIn  //indexPath.row == Singletons.sharedInstance.arrCategoryListTitle.count - 1 //+ 1
        {
            
            //for Logout
            if UserDefaults.standard.bool(forKey: kIsLogin) == false
            {
                Singletons.sharedInstance.selectedMenuSection = 0
                Singletons.sharedInstance.selectedMenuIndex = 0
                Singletons.sharedInstance.isFromSocilaLogin = false
                Singletons.sharedInstance.isFromSideMenu = true
                var navController: NavigationRootViewController?
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                navController = NavigationRootViewController(rootViewController: controller ?? UIViewController())
                
                self.frostedViewController.contentViewController = navController
                self.frostedViewController.hideMenuViewController()
            }
            else
            {
                Singletons.sharedInstance.selectedMenuSection = 0
                Singletons.sharedInstance.selectedMenuIndex = 0
                RMUniversalAlert.show(in: self, withTitle:appName, message: "Are you sure you want to logout?", cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: ["Yes", "No"], tap: {(alert, buttonIndex) in
                    if (buttonIndex == 2)
                    {
                        //                        let results = Utilities.decodeDictionaryfromData(KEY: kLoginData)
                        //                        print(results)
                        //
                        //                        if results.count != 0
                        //                        {
                        //                            let tempID = results["id"] as! Int
                        //                            Singletons.sharedInstance.strUserID = String(tempID)
                        //                            Singletons.sharedInstance.strLoginToken = results["token"] as! String
                        //                        }
                        //
                        //                      self.webserviceLogout(dictParams: Singletons.sharedInstance.strUserID as AnyObject)
                        
                        Singletons.sharedInstance.isFromSocilaLogin = false
                        Singletons.sharedInstance.isFromSideMenu = false
                        UserDefaults.standard.set(false, forKey: kIsLogin)
                        UserDefaults.standard.removeObject(forKey: kLoginData)
                        UserDefaults.standard.synchronize()
                        
                        var navController: NavigationRootViewController?
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
                        navController = NavigationRootViewController(rootViewController: controller ?? UIViewController())
                        navController?.isNavigationBarHidden = true
                        self.frostedViewController.contentViewController = navController
                        self.frostedViewController.hideMenuViewController()
                        //                        Utilities.hideActivityIndicator()
                        
                        
                    }
                })
                return
            }
            
        }
        else
        {
            //for Other category
            Singletons.sharedInstance.selectedMenuSection = indexPath.section
            Singletons.sharedInstance.selectedMenuIndex = indexPath.row
            
            Singletons.sharedInstance.isFromSideMenu = true
            let tempID = (Singletons.sharedInstance.arrCategoryListTitle[indexPath.row]["id"] as! Int)
            let strID = String(tempID)
            Singletons.sharedInstance.strNavigationHOMETitle = Singletons.sharedInstance.arrCategoryListTitle[indexPath.row]["name"] as! String
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
            let navController = NavigationRootViewController(rootViewController: viewController ?? UIViewController())
            navController.isNavigationBarHidden = true
            Singletons.sharedInstance.strSelectedCategoryID = strID
            frostedViewController.contentViewController = navController as? UIViewController ?? UIViewController()
            frostedViewController.hideMenuViewController()
            return
            
        }
 */
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let strTitle : String = arrTitle[indexPath.row]
        if strTitle == kSignout {
            return 100
        }else if indexPath.row == 8 {
            return isSelectedIndex ?  158 : 50
        }else {
            return 50
        }

    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
//    {
//
//        let viewFooter = UIView.init(frame: CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: 100))
//        viewFooter.backgroundColor = UIColor.red
//
//        let iconLogout = UIImageView.init(frame: CGRect(x: ((SCREEN_WIDTH * 0.75) - (70 / 2)), y: 0, width: 70, height: 70))
//        iconLogout.image = UIImage.init(named: "iconLogoutSelect")
//        viewFooter.addSubview(iconLogout)
//
//        let lblLogout = UILabel.init(frame: CGRect(x: ((SCREEN_WIDTH * 0.75) - (100 / 2)), y: (iconLogout.frame.size.height + iconLogout.frame.origin.y), width: 100, height: 25))
//        lblLogout.text = kSignout
//        lblLogout.textColor = ThemeWhiteColor
//        viewFooter.addSubview(lblLogout)
//
//
//        return viewFooter
//    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 100
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
