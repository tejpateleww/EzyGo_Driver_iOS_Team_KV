//
//  ForgotPasswordViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 10/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: ParentViewController,UIGestureRecognizerDelegate {

    
    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.setCornerRadiusTextField(textField: txtEmail, borderColor: ThemeWhiteColor, bgColor: ThemeClearColor, textColor: ThemeWhiteColor)
        Utilities.setCornerRadiusButton(button: btnSubmit, borderColor: ThemeYellowColor, bgColor: ThemeYellowColor, textColor: ThemeWhiteColor)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = false
//        self.frostedViewController.panGestureEnabled = false
//        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Forgot Password", naviTitleImage: "", leftImage: kBack_Icon, rightImage: "")
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
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        if txtEmail.text!.isEmptyOrWhitespace() {
            Utilities.showAlert("", message: "Please enter email.", vc: self)
        }else if !Utilities.isEmail(testStr: txtEmail.text!) {
            Utilities.showAlert("", message: "Please enter valid email.", vc: self)
        }else {
            
            var param = [String:AnyObject]()
            param["Email"] = txtEmail.text! as AnyObject
            webserviceForForgotPassword(param as AnyObject) { (result, status) in
                print(result)
                self.view.endEditing(true)
                if status {
                    Utilities.showAlertWithCompletion("", message: result["message"] as? String ?? "", vc: self, completionHandler: { (success) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }else {
                    
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
                    
                    //                    Utilities.showAlertWithCompletion("", message: result["message"] as? String ?? "", vc: self, completionHandler: { (success) in
                    //
                    //                    })
                    //                }
                }
            }
        }
        
    }
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
//    {
//        return true
//    }

}
