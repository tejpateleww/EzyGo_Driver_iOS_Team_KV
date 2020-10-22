//
//  ChangePasswordViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 10/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class ChangePasswordViewController: ParentViewController,UIGestureRecognizerDelegate
{

    
    @IBOutlet var txtNewPassword: UITextField!
    
    @IBOutlet var txtConPassword: UITextField!
    
    @IBOutlet var btnSubmit: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Utilities.setCornerRadiusTextField(textField: txtNewPassword, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusTextField(textField: txtConPassword, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusButton(button: btnSubmit, borderColor: ThemeYellowColor, bgColor: ThemeYellowColor, textColor: ThemeWhiteColor)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = false
//        self.frostedViewController.panGestureEnabled = false
//        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Change Password", naviTitleImage: "", leftImage: kBack_Icon, rightImage: "")
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnSubmitClicked(_ sender: Any)
    {
        if txtNewPassword.text!.isEmpty {
            Utilities.showAlert("", message: "Please enter your new password.", vc: self)
        }else if txtConPassword.text!.isEmpty {
            Utilities.showAlert("", message: "Please re-enter your new password.", vc: self)
        }else if txtNewPassword.text!.count < 6 {
             Utilities.showAlert("", message: "Password must contain at least 6 characters.", vc: self)
        }else if txtConPassword.text !=  txtNewPassword.text {
            Utilities.showAlert("", message: "Password and confirm password must be same.", vc: self)
        }else {
            var dictData = [String:AnyObject]()
            let driverID = Singletons.sharedInstance.strDriverID as AnyObject
            dictData["DriverId"] = driverID
            
            dictData["Password"] = txtNewPassword.text as AnyObject
            
            webserviceForChangePassword(dictData as AnyObject) { (result, status) in
                 self.navigationController?.popViewController(animated: true)
            }
           
        }
       
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }

}
