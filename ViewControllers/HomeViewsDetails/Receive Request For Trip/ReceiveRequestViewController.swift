//
//  ReceiveRequestViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 06/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SRCountdownTimer
import NVActivityIndicatorView
import ActionSheetPicker_3_0
class ReceiveRequestViewController: UIViewController, SRCountdownTimerDelegate {

    
    
    @IBOutlet weak var txtReasonForrejectTrip: UITextField!
    
    
    
    @IBOutlet weak var viewCountdownTimer: SRCountdownTimer!
    var isAccept : Bool!
    var delegate: ReceiveRequestDelegate!
    
//    @IBOutlet var constratintHorizontalSpaceBetweenButtonAndTimer: NSLayoutConstraint!
    
    var strPickupLocation = String()
    var strDropoffLocation = String()
    var strGrandTotal = String()
    
    var strFlightNumber = String()
    var strNotes = String()
    
    var newTimeForReject = 0
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIApplication.shared.beginBackgroundTask(expirationHandler: nil)

        txtReasonForrejectTrip.isHidden = true

        CountDownView()
        vwRejectReason.fadeOutVw()
//        btnReject.layer.cornerRadius = 5
//        btnReject.layer.masksToBounds = true
//        
//        btnAccepted.layer.cornerRadius = 5
//        btnAccepted.layer.masksToBounds = true
        
        boolTimeEnd = false
        isAccept = false
        
//        self.playSound()
        
        fillAllFields()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CountDownView() {
        
        viewCountdownTimer.labelFont = UIFont(name: "HelveticaNeue-Light", size: 50.0)
        //                    self.timerView.timerFinishingText = "End"
        viewCountdownTimer.lineWidth = 4
        viewCountdownTimer.lineColor = UIColor.gray
        viewCountdownTimer.trailLineColor = UIColor.red
        viewCountdownTimer.labelTextColor = UIColor.darkText
        viewCountdownTimer.delegate = self
        viewCountdownTimer.start(beginingValue: 30, interval: 1)
        
        lblMessage.text = "New booking request arrived from Ezygo"
        
    }
    func timerDidUpdateCounterValue(newValue: Int) {
        newTimeForReject = newValue
        
    }
    func fillAllFields() {
        
        if Singletons.sharedInstance.passengerType == "" {
            
            viewDetails.isHidden = true
            
            lblGrandTotal.isHidden = true
//            constratintHorizontalSpaceBetweenButtonAndTimer.priority = 1000
//            stackViewFlightNumber.isHidden = true
//            stackViewNotes.isHidden = true
        }
        else {
            viewDetails.isHidden = false
            print(strGrandTotal)
            print(strPickupLocation)
            print(strDropoffLocation)
            print(strFlightNumber)
            print(strNotes)
            lblGrandTotal.text = "Grand Total is \(currency) \(strGrandTotal)"
            lblPickupLocation.text = strPickupLocation
            lblDropoffLocation.text = strDropoffLocation
            
//            if strFlightNumber.count == 0 {
//                stackViewFlightNumber.isHidden = true
//            }
//            else {
//                stackViewFlightNumber.isHidden = false
//                lblFlightNumber.text = strFlightNumber
//            }
//
//            if strNotes.count == 0 {
//                stackViewNotes.isHidden = true
//            }
//            else {
//                stackViewNotes.isHidden = false
//                lblNotes.text = strNotes
//            }
        }
        
    }
    
    func timerDidEnd() {
        
        if (isAccept == false)
        {
            if (boolTimeEnd) {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print(#function)
                self.delegate.didRejectedRequest()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Sound Implement Methods
    //-------------------------------------------------------------
    
    var audioPlayer: AVAudioPlayer!
    
    func playSound() {
        
        guard let url = Bundle.main.url(forResource: "\(RingToneSound)", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            //            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.numberOfLoops = 4
            audioPlayer.play()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        
        guard let url = Bundle.main.url(forResource: "\(RingToneSound)", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.stop()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
   
    @IBOutlet weak var viewRequestReceive: UIView!
    
    @IBOutlet weak var lblReceiveRequest: UILabel!
    
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropoffLocation: UILabel!
    
//    @IBOutlet weak var lblFlightNumber: UILabel!
//    @IBOutlet weak var lblNotes: UILabel!
    
//    @IBOutlet weak var stackViewFlightNumber: UIStackView!
    
//    @IBOutlet weak var stackViewNotes: UIStackView!
    
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccepted: UIButton!
    
    @IBOutlet weak var viewDetails: UIView!
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    var boolTimeEnd = Bool()
    
    @IBAction func btnRejected(_ sender: UIButton) {
        
       
//        viewCountdownTimer.end()
        viewCountdownTimer.start(beginingValue: newTimeForReject+15, interval: 1)
        vwRejectReason.fadeInVw()
       
//         Singletons.sharedInstance.firstRequestIsAccepted = false
//        isAccept = false
//        boolTimeEnd = true
//        delegate.didRejectedRequest()
//        self.viewCountdownTimer.end()
////        self.stopSound()
//        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnAcceped(_ sender: UIButton) {
        
         Singletons.sharedInstance.firstRequestIsAccepted = false
        
        isAccept = true
        boolTimeEnd = true
        delegate.didAcceptedRequest()
        self.viewCountdownTimer.end()
        self.stopSound()
        self.dismiss(animated: true, completion: nil)
    }
    // ------------------------------------------------------------
    

    //TODO: Change For Reject Reason
    
    //MARK: Reject Reason Submit
    @IBOutlet weak var btnSelectRejectOption: UIButton!
    @IBOutlet weak var vwRejectReason: UIView!
    var selectedIndex = -1
    var isOtherReason = false
    
    @IBAction func selectRejectRequestClick(_ sender: UIButton) {
        //        let arr = ["Car1","Car2","Car3","Car4"]
        //        var arr = [Singletons.sharedInstance.arrReasonForCancel]
        let arrData = Singletons.sharedInstance.arrReasonForReject.map{$0.strReason}
        
        
        ActionSheetStringPicker.show(withTitle: "Select Reason", rows: arrData, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
            self.selectedIndex = index
            Singletons.sharedInstance.strReasonForCancel = arrData[index]
            self.btnSelectRejectOption.setTitle(arrData[index], for: .normal)
            self.txtReasonForrejectTrip.isHidden = true
            self.isOtherReason = false
            
            if arrData[index] == "Other Reason" || arrData[index] == "other reason" {
                self.txtReasonForrejectTrip.isHidden = false
                Singletons.sharedInstance.strReasonForCancel = self.txtReasonForrejectTrip.text ?? "Other Reason"
                self.isOtherReason = true
            }
            
        }, cancel: { (actionSheet) in
            
        }, origin: self.view)
        
    }
    @IBAction func submitReason(_ sender: UIButton) {
        if selectedIndex == -1 {
            Utilities.showAlert("", message: "Please select reason", vc: self)
        }
        else if isOtherReason && txtReasonForrejectTrip.text == "" {
            Utilities.showAlert(appName.kAPPName, message: "Please enter right for cancel trip", vc: self)
        }
        else {
            let objSelectedReason = Singletons.sharedInstance.arrReasonForReject[selectedIndex]
//            self.delegate.didRejectRequestSuccess()
            vwRejectReason.fadeOutVw()
            Singletons.sharedInstance.firstRequestIsAccepted = false
            isAccept = false
            boolTimeEnd = true
            delegate.didRejectedRequest()
            self.viewCountdownTimer.end()
            //        self.stopSound()
            self.dismiss(animated: true, completion: nil)
            print(objSelectedReason)
        }
    }
    
    @IBAction func btnCloseActionHandler(_ sender: UIButton) {
        Singletons.sharedInstance.firstRequestIsAccepted = false
        isAccept = false
        boolTimeEnd = true
        delegate.didRejectedRequest()
        self.viewCountdownTimer.end()
        //        self.stopSound()
        self.dismiss(animated: true, completion: nil)
    }
    

}
extension UIView {
    func fadeInVw() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }
    func fadeOutVw() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}
