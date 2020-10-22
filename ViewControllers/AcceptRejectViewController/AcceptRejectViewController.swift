//
//  AcceptRejectViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 12/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit


class AcceptRejectViewController: UIViewController {

    
    @IBOutlet var viewCircular: UIView!
    
    @IBOutlet var countdownViewCircluar: BRCircularProgressView!
    
    @IBOutlet var btnReject: UIButton!
    @IBOutlet var btnAccept: UIButton!
    
    @IBOutlet var constrainXPositionViewAniation: NSLayoutConstraint!
    
//    @IBOutlet var viewTempCircle: MBCircularProgressBarView!
    @IBOutlet var viewMain: UIView!
    @IBOutlet var viewButtons: UIView!
    @IBOutlet var viewAnimated: UIView!
    let completeProgress: CGFloat = 30
    var progressCompleted: CGFloat = 1
    var isAccept : Bool!
    var boolTimeEnd = Bool()
    var timerOfRequest : Timer!
    
    @IBOutlet var lblButtontitle: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        boolTimeEnd = false
        isAccept = false
        showTimerProgressViaInstance()
        btnReject.isSelected = true
        btnAccept.isSelected = false
        self.viewButtons.layer.cornerRadius = self.viewButtons.frame.size.height / 2
        self.viewButtons.clipsToBounds = true
        self.viewMain.layer.cornerRadius = 5
        self.viewMain.clipsToBounds = true
        self.lblButtontitle.text = "Reject"
        self.lblButtontitle.textColor = ThemeNaviBlueColor
        self.viewAnimated.layer.cornerRadius = self.viewAnimated.frame.size.height / 2
        self.viewAnimated.clipsToBounds = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func timerDidEnd()
    {
        
        if (isAccept == false)
        {
            if (boolTimeEnd)
            {
//                self.delegateTripAcceptReject?.delegateforRejectTrip()
                timerOfRequest.invalidate()
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
//                self.delegateTripAcceptReject?.delegateforRejectTrip()
                timerOfRequest.invalidate()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    func showTimerProgressViaInstance()
    {
        countdownViewCircluar.setCircleStrokeWidth(1)
        countdownViewCircluar.setCircleStrokeColor(ThemeClearColor, circleFillColor: UIColor.white, progressCircleStrokeColor: ThemeRedColor, progressCircleFillColor: ThemeRedColor)
        
        countdownViewCircluar.clipsToBounds = true
        
        
        if timerOfRequest == nil {
            timerOfRequest = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(AcceptRejectViewController.showTimer), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func showTimer()
    {
        progressCompleted += 1
        self.countdownViewCircluar.progress = progressCompleted / completeProgress
        
        print("counter progress: \(self.countdownViewCircluar.progress)")
        if progressCompleted >= 300
        {
            self.boolTimeEnd = true
            self.timerDidEnd()
            timerOfRequest.invalidate()
            //                timer = nil
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

    @IBAction func btnRejectClicked(_ sender: Any)
    {
        self.constrainXPositionViewAniation.constant = 1
        self.lblButtontitle.text = ""
        self.lblButtontitle.textColor = ThemeNaviBlueColor
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations:
            {
                self.btnReject.setTitle("", for: .normal)
                self.btnAccept.setTitle("Accepet", for: .normal)
                self.btnReject.setTitleColor(ThemeNaviBlueColor, for: .normal)
                self.btnAccept.setTitleColor(ThemeYellowColor, for: .normal)
                self.view.layoutIfNeeded()
        }) { (status) in
            self.lblButtontitle.text = "Reject"
            self.lblButtontitle.textColor = ThemeNaviBlueColor
             DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            Singletons.sharedInstance.firstRequestIsAccepted = false
            self.isAccept = false
            self.boolTimeEnd = true
            self.timerOfRequest.invalidate()
            //        delegateTripAcceptReject?.delegateforRejectTrip()
            self.dismiss(animated: true, completion: nil)
            })
        }
        

    }
    @IBAction func btnAcceptClicked(_ sender: Any)
    {
        self.constrainXPositionViewAniation.constant = self.btnReject.frame.size.width - 2
        self.lblButtontitle.text = ""
        self.lblButtontitle.textColor = ThemeNaviBlueColor
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            
            self.btnReject.setTitle("Reject", for: .normal)
            self.btnAccept.setTitle("", for: .normal)
            self.btnReject.setTitleColor(ThemeYellowColor, for: .normal)
            self.btnAccept.setTitleColor(ThemeNaviBlueColor, for: .normal)
            
            self.view.layoutIfNeeded()
        }) { (status) in
            self.lblButtontitle.text = "Accepet"
            self.lblButtontitle.textColor = ThemeNaviBlueColor
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                Singletons.sharedInstance.firstRequestIsAccepted = false
                self.isAccept = true
                self.boolTimeEnd = true
                self.timerOfRequest.invalidate()
                //        delegateTripAcceptReject?.delegateforAcceptTrip()
                self.dismiss(animated: true, completion: nil)
            })
            
            
        }

    }
}
