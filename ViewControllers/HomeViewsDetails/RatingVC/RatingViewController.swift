//
//  RatingViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 22/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import FloatRatingView
import SideMenuController
protocol delegateRatingIsSubmitSuccessfully {
    
    func didRatingIsSubmitSuccessfully()
}

class RatingViewController: UIViewController,FloatRatingViewDelegate {

    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var txtFeedback: UITextField!
    @IBOutlet var viewRating: FloatRatingView!
    @IBOutlet var lblDetail: UILabel!

    @IBOutlet var viewStarsRating: HCSStarRatingView!
    
    
    var delegate: delegateRatingIsSubmitSuccessfully?
    
    var ratingToDriver = Float()
    var commentToDriver = String()
    var strBookingType = String()
    var strBookingID = String()
    var dictData : NSDictionary!
    var dictPassengerInfo : NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewStarsRating.value = 0.0
        
//        viewStarsRating.delegate = self
//        viewStarsRating.type = .halfRatings

        strBookingID = (dictData["details"]! as! [String : AnyObject])["Id"] as! String
        
        lblDetail.text = "Please Rate Your Customer"
//        lblDetail.text = "How was your experience with \((dictPassengerInfo!.object(forKey: "Fullname") as! String))?"// (dictPassengerInfo!.object(forKey: "Fullname") as! String)
        // Do any additional setup after loading the view.
        SideMenuController.preferences.interaction.panningEnabled = false
        SideMenuController.preferences.interaction.swipingEnabled = false
        
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SideMenuController.preferences.interaction.panningEnabled = true
        SideMenuController.preferences.interaction.swipingEnabled = true
    }
    @IBAction func btnGiveRating(_ sender: Any) {
        
        webserviceCallToGiveRating()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        
//        viewStarsRating.rating = Double(rating)
//        ratingToDriver = Float(viewStarsRating.rating)
        
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        self.delegate?.didRatingIsSubmitSuccessfully()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func webserviceCallToGiveRating() {
        
        var param = [String:AnyObject]()
        param["BookingId"] = strBookingID as AnyObject
        
//        ratingToDriver = viewStarsRating.value
        
        param["Rating"] = viewStarsRating.value as AnyObject
        param["Comment"] = txtFeedback.text as AnyObject
        param["BookingType"] = strBookingType as AnyObject
        
        
        webserviceForGiveRating(param as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                self.ratingToDriver = 0
                self.viewStarsRating.value = 0.0
                UtilityClass.showAlertWithCompletion(appName.kAPPName, message: "Rating successfull", vc: self) { (status) in
                }
                
                self.delegate?.didRatingIsSubmitSuccessfully()
                
                self.dismiss(animated: true, completion: nil)
                
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

}
