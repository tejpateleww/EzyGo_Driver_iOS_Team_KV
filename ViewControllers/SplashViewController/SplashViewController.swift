//
//  SplashViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 10/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    
    
    @IBOutlet var iconLogo: UIImageView!
    
    @IBOutlet var lblFooter: UILabel!
    @IBOutlet var viewLine: UIView!
    
    
    
    override func loadView() {
        super.loadView()
        webserviceOfAppSetting()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.iconLogo.alpha = 0
        self.viewLine.alpha = 0
        self.lblFooter.alpha = 0
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        UIView.animate(withDuration: 0.6, animations:
            {
                self.iconLogo.alpha = 0.5
        })
        { (status) in
            
            UIView.animate(withDuration: 1, animations:
                {
                    self.viewLine.alpha = 0.5
                    self.lblFooter.alpha = 0.5
            })
            { (status) in
                self.iconLogo.alpha = 1
                self.viewLine.alpha = 1
                self.lblFooter.alpha = 1
            }
        }
        
        self.perform(#selector(moveToLogin), with: nil, afterDelay: 6.0)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func moveToLogin()
    {
        if(Singletons.sharedInstance.isDriverLoggedIN == false)
        
        {
        let viewLoginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        let viewHomeController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as? HomeViewController

//        if (UserDefaults.standard.object(forKey:  driverProfileKeys.kKeyDriverProfile) != nil)
//        {
//            Singletons.sharedInstance.isDriverLoggedIN = true
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.navigationController?.pushViewController(viewLoginController!, animated: false)
//        }
//        else
//        {
//            Singletons.sharedInstance.isDriverLoggedIN = false
//            self.navigationController?.pushViewController(viewLoginController!, animated: false)
//        }
        
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // ----------------------------------------------------------------------
    
    func webserviceOfAppSetting() {
        //        version : 1.0.0 , (app_type : AndroidPassenger , AndroidDriver , IOSPassenger , IOSDriver)
        
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        
        var param = String()
        
        param = version + "/" + "IOSDriver"
        
        webserviceForAppSetting(param as AnyObject) { (result, status) in
            
            if(status) {
                print(result)
                /*
                 {
                 "status": true,
                 "update": false,
                 "message": "Ticktoc app new version available"
                 }
                 */
                
                
                if let res = result as? [String:Any] {
                    if res.count != 0 {
                        if let cancelTime = res["cancel_time"] as? [String:Any] {
                            if cancelTime.count != 0 {
                                if let timeValue = cancelTime["SettingValue"] as? String {
                                    let exampleString = Int(Int(timeValue)! * 60)
                                    Singletons.sharedInstance.intArrivalTimeInSeconds = exampleString
                                }
                                else if let timeValue = cancelTime["SettingValue"] as? Int {
                                    let exampleString = Int(timeValue * 60)
                                    Singletons.sharedInstance.intArrivalTimeInSeconds = exampleString
                                }
                            }
                        }
                    }
                }
                
                
                let arrData = result["cancel_list"] as! NSArray
                
                for dict in arrData {
                    let dictResult = dict as! NSDictionary
                    var obj = ReasonForCancel.init()
                    obj.strId = dictResult.getStringForID(key: "Id") ?? "0"
                    obj.strReason = dictResult["Reason"] as? String ?? ""
                    
                    Singletons.sharedInstance.arrReasonForCancel.append(obj)
                }
                
                let arrDataRejectList = result["reject_list"] as! NSArray
                
                for dict in arrDataRejectList {
                    let dictResult = dict as! NSDictionary
                    var obj = ReasonForCancel.init()
                    obj.strId = dictResult.getStringForID(key: "Id") ?? "0"
                    obj.strReason = dictResult["Reason"] as? String ?? ""
                    
                    Singletons.sharedInstance.arrReasonForReject.append(obj)
                }
                
                if ((result as! NSDictionary).object(forKey: "update") as? Bool) != nil {
                    
                    let alert = UIAlertController(title: nil, message: (result as! NSDictionary).object(forKey: "message") as? String, preferredStyle: .alert)
                    let UPDATE = UIAlertAction(title: "UPDATE", style: .default, handler: { ACTION in
                        
                        UIApplication.shared.openURL(NSURL(string: appName.kAPPUrl)! as URL)
                    })
                    let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: { ACTION in
                        
                        if(Singletons.sharedInstance.isDriverLoggedIN)
                        {
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! CustomSideMenuViewController
                            self.navigationController?.pushViewController(next, animated: true)
                        }
                    })
                    alert.addAction(UPDATE)
                    alert.addAction(Cancel)
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    
                    if(Singletons.sharedInstance.isDriverLoggedIN)
                    {
                        let next = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! CustomSideMenuViewController
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                        self.navigationController?.pushViewController(next, animated: true)
                    }
                    
                }
                
                //                if(SingletonClass.sharedInstance.isUserLoggedIN)
                //                {
                //                    self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                //                }
                
                
            }
            else {
                print(result)
                /*
                 {
                 "status": false,
                 "update": false,
                 "maintenance": true,
                 "message": "Server under maintenance, please try again after some time"
                 }
                 */
                
                if let res = result as? String {
                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else if let update = (result as! NSDictionary).object(forKey: "update") as? Bool {
                    
                    if (update) {
                        //                        UtilityClass.showAlert(appName.kAPPName, message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                        
                        UtilityClass.showAlertWithCompletion(appName.kAPPName, message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self, completionHandler: { ACTION in
                            
                            UIApplication.shared.open((NSURL(string: appName.kAPPUrl)! as URL), options: [:], completionHandler: { (status) in
                                
                            })//openURL(NSURL(string: appName.kAPPUrl)! as URL)
                        })
                    }
                    else {
                        UtilityClass.showAlert(appName.kAPPName, message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                    }
                    
                }
                /*
                 {
                 "status": false,
                 "update": true,
                 "message": "Ticktoc app new version available, please upgrade your application"
                 }
                 */
                //                if let res = result as? String {
                //                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                //                }
                //                else if let resDict = result as? NSDictionary {
                //                    UtilityClass.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
                //                }
                //                else if let resAry = result as? NSArray {
                //                    UtilityClass.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                //                }
            }
        }
        
    }
}


extension NSDictionary {
    func getStringForID(key: String) -> String? {
        
        var strKeyValue : String = ""
        if (self[key] as? Int) != nil {
            strKeyValue = String(self[key] as? Int ?? 0)
        } else if (self[key] as? String) != nil {
            strKeyValue = self[key] as? String ?? ""
        }
        return strKeyValue
    }
}
