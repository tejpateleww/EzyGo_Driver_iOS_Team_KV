//
//  PassengerViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 12/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import MarqueeLabel

class PassengerViewController: UIViewController
{

    
    @IBOutlet var viewMain: UIView!
    
    @IBOutlet var imgProfilePic: UIImageView!
    
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var lblPickupLocation: MarqueeLabel!
    @IBOutlet var lblDropoffLocation: MarqueeLabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewMain.layer.cornerRadius = 5
        self.viewMain.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
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
    @IBAction func btnMSGClicked(_ sender: Any) {
        
    }
    @IBAction func btnCallClicked(_ sender: Any) {
        
    }
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
