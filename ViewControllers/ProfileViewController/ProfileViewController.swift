//
//  ProfileViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 11/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class ProfileViewController: ParentViewController,UIGestureRecognizerDelegate
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = false
//        self.frostedViewController.panGestureEnabled = true
        
//        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Settings", naviTitleImage: "", leftImage: kBack_Icon, rightImage: kCallHelp_Icon)
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

    
    
    @IBAction func btnEditProfileClicked(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController") as? UpdateProfileViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    @IBAction func btnAccountClicked(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BankAccountDetailsViewController") as? BankAccountDetailsViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    @IBAction func btnVehicleOptionClicked(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VehicleOptionViewController") as? VehicleOptionViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    @IBAction func btnDocumentsClicked(_ sender: Any)
    {
        
    }
}
