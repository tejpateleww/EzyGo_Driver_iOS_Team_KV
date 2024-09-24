//
//  DriverRegistrationMainViewController.swift
//  ezygo-Driver
//
//  Created by Apple on 22/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class DriverRegistrationMainViewController: UIViewController {
    
    @IBOutlet weak var vwScroll: UIScrollView!
    
    @IBOutlet weak var vwProgress1: UIView!
    @IBOutlet weak var vwProgress2: UIView!
    @IBOutlet weak var vwProgress3: UIView!
    @IBOutlet weak var vwProgress4: UIView!
    @IBOutlet weak var vwProgress5: UIView!
    @IBOutlet weak var vwProgress6: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        vwProgress1.backgroundColor = ThemeWalletBlueColor
        
        objRegistration = loadRegistrationObject(withKey: RegistrationKeys.registrationUser)
        if objRegistration !=  nil {
            self.view.layoutIfNeeded()
            changeContentOffset(objRegistration.nFillPageNumber)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backClick(_ sender: UIButton) {
        guard let page = objRegistration?.nFillPageNumber else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        if page == 0 {
            self.navigationController?.popViewController(animated: true)
        } else {
            objRegistration.nFillPageNumber -= 1
            changeContentOffset(objRegistration.nFillPageNumber)
        }
       
    }
    func changeContentOffset(_ page: CGFloat) {
        let offSet =  self.view.frame.width * page
        
        self.vwProgress1.backgroundColor = ThemeNaviBlackLikeClearColor
        self.vwProgress2.backgroundColor = ThemeNaviBlackLikeClearColor
        self.vwProgress3.backgroundColor = ThemeNaviBlackLikeClearColor
        self.vwProgress4.backgroundColor = ThemeNaviBlackLikeClearColor
        self.vwProgress5.backgroundColor = ThemeNaviBlackLikeClearColor
         self.vwProgress6.backgroundColor = ThemeNaviBlackLikeClearColor
        
        switch page {
        case 1.0:
              self.vwProgress2.backgroundColor = ThemeWalletBlueColor
            break
        case 2.0:
              self.vwProgress3.backgroundColor = ThemeWalletBlueColor
            break
        case 3.0:
              self.vwProgress4.backgroundColor = ThemeWalletBlueColor
            break
        case 4.0:
              self.vwProgress5.backgroundColor = ThemeWalletBlueColor
            break
        case 5.0:
            self.vwProgress6.backgroundColor = ThemeWalletBlueColor
            break
        default:
             self.vwProgress1.backgroundColor = ThemeWalletBlueColor
            break
        }
      
        self.vwScroll.setContentOffset(CGPoint.init(x: offSet, y: 0), animated: true)
    }
}
