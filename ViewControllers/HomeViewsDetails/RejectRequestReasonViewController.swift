//
//  RejectRequestReasonViewController.swift
//  ezygo-Driver
//
//  Created by Apple on 02/11/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
class RejectRequestReasonViewController: UIViewController {
    
    @IBOutlet weak var btnSelectRejectOption: UIButton!
    @IBOutlet weak var txtReasonForReject: UITextField!
    
    var selectedIndex = -1
    var delegate : CancelRequestClick!
    var isOtherReason = false

    override func viewDidLoad() {
        super.viewDidLoad()
        txtReasonForReject.isHidden = true
    }
    
    
    @IBAction func selectRejectRequestClick(_ sender: UIButton) {
        //        let arr = ["Car1","Car2","Car3","Car4"]
        //        var arr = [Singletons.sharedInstance.arrReasonForCancel]
        let arrData = Singletons.sharedInstance.arrReasonForReject.map{$0.strReason}
        
        
        ActionSheetStringPicker.show(withTitle: "Select Reason", rows: arrData, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
            
            self.btnSelectRejectOption.setTitle(arrData[index], for: .normal)
            Singletons.sharedInstance.strReasonForCancel = arrData[index]
            self.selectedIndex = index
            self.txtReasonForReject.isHidden = true
            self.isOtherReason = false
            self.txtReasonForReject.text = ""
            
            if arrData[index] == "Other Reason" || arrData[index] == "other reason" {
                self.txtReasonForReject.isHidden = false
                Singletons.sharedInstance.strReasonForCancel = self.txtReasonForReject.text ?? "Other Reason"
                self.isOtherReason = true
            }
            
        }, cancel: { (actionSheet) in
            
        }, origin: self.view)
        
    }
    @IBAction func submitReason(_ sender: UIButton) {
        if selectedIndex == -1 {
            Utilities.showAlert("Select Reason", message: "Please select reason", vc: self)
        }
        if isOtherReason && txtReasonForReject.text == "" {
            Utilities.showAlert(appName.kAPPName, message: "Please enter right for cancel trip", vc: self)
        }
        else {
            let objSelectedReason = Singletons.sharedInstance.arrReasonForReject[selectedIndex]
            self.delegate.didRejectRequestSuccess()
            
            print(objSelectedReason)
        }
        
    }
}
