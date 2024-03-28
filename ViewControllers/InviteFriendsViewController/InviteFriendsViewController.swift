//
//  InviteFriendsViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 11/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class InviteFriendsViewController: ParentViewController
{

    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var view4: UIView!
    @IBOutlet var viewFB: UIView!
    
    @IBOutlet var btnMoreOption: UIButton!
    @IBOutlet var btnShareFB: UIButton!
    @IBOutlet var lblInviteCode: UILabel!
    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var iconCurve: UIImageView!
    @IBOutlet var iconBanner: UIImageView!
   
    @IBOutlet var viewBottom: UIView!
    
    var driverFullName = ""
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let profileData = Singletons.sharedInstance.dictDriverProfile
//        print(profileData)
        let profileMainDict = profileData?["profile"] as? NSDictionary
        driverFullName = profileMainDict?.object(forKey: "Fullname") as! String
        
        if let strReferalCode = profileMainDict?["ReferralCode"] as? String {
            lblInviteCode.text = strReferalCode
        }
        if let strDriverImageUrl = profileMainDict?["Image"] as? String {
            imgProfilePic.sd_setImage(with: URL(string:  strDriverImageUrl), placeholderImage: UIImage.init(named: "placeHolderProfile"))
        }
        
        self.createViewRound(view1)
        self.createViewRound(view2)
        self.createViewRound(view3)
        self.createViewRound(view4)
        self.createViewRound(viewFB)
        self.imgProfilePic.layer.cornerRadius =  self.imgProfilePic.frame.size.height / 2
        self.imgProfilePic.clipsToBounds = true
        
        viewBottom.layer.cornerRadius = 3
        
        
        
        // border
        /*            
        viewBottom.layer.borderWidth = 1.0
        viewBottom.layer.borderColor = UIColor.black.cgColor
        */
        
        // shadow
//        viewBottom.layer.shadowColor = UIColor.gray.cgColor
//        viewBottom.layer.shadowOffset = CGSize(width: 3, height: 3)
//        viewBottom.layer.shadowOpacity = 0.7
//        viewBottom.layer.shadowRadius = 4.0
    }

    func createViewRound(_ view : UIView)
    {
        view.layer.cornerRadius =  view.frame.size.height / 2
        view.clipsToBounds = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
//        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Invite Friends", naviTitleImage: "", leftImage: kBack_Icon, rightImage: "")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnFBShareClicked(_ sender: Any)
    {
        
    }
    
    @IBAction func btnMoreOptionClicked(_ sender: Any) {
        let strInviteMessage = "\(driverFullName) has invited you to become a EzyGo Driver \n \n"
        //let urlStr = "Click here: \nitms://itunes.apple.com/us/app/apple-store/id375380948?mt=8 \n \n"
        let urlStr = "Click here: \nitems: https://apps.apple.com/us/app/ezygo-drivers/id1445117658 \n \n"
        let strInviteCode = "Your invite code is: \(lblInviteCode.text ?? "")"
        
        let finalShareUrl = strInviteMessage + urlStr + strInviteCode
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
//
//        } else {
//            UIApplication.shared.openURL(URL(string: urlStr)!)
//        }
        Utilities.shareUrl(finalShareUrl)
    }
    
}

