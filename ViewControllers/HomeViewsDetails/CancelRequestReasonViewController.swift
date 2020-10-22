//
//  CancelRequestReasonViewController.swift
//  ezygo-Driver
//
//  Created by Apple on 02/11/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class CancelRequestReasonViewController: UIViewController {
    
    @IBOutlet weak var btnSelectCancelOption: UIButton!
    @IBOutlet weak var txtReasonForOther: UITextField!
    
    var selectedIndex = -1
    var delegate : CancelRequestClick!
    var isOtherReason = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtReasonForOther.isHidden = true
    }
    
    
    @IBAction func cancelClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectCancelRequestClick(_ sender: UIButton) {
//        let arr = ["Car1","Car2","Car3","Car4"]
//        var arr = [Singletons.sharedInstance.arrReasonForCancel]
        let arrData = Singletons.sharedInstance.arrReasonForCancel.map{$0.strReason}
       
        
        ActionSheetStringPicker.show(withTitle: "Select Reason", rows: arrData, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
            Singletons.sharedInstance.strReasonForCancel = arrData[index]
            self.selectedIndex = index
            self.btnSelectCancelOption.setTitle(arrData[index], for: .normal)
            self.isOtherReason = false
            self.txtReasonForOther.isHidden = true
            if arrData[index] == "Other Reason" || arrData[index] == "other reason" || arrData[index] == "Other reason" {
                self.txtReasonForOther.isHidden = false
                Singletons.sharedInstance.strReasonForCancel = self.txtReasonForOther.text ?? "Other Reason"
                self.isOtherReason = true
            }
            
            
        }, cancel: { (actionSheet) in
            
        }, origin: self.view)
        
    }
    
    @IBAction func submitReason(_ sender: UIButton) {
        if selectedIndex == -1 {
            Utilities.showAlert("Select Reason", message: "Please select reason", vc: self)
        }
        else if isOtherReason && txtReasonForOther.text!.isEmptyOrWhitespace() {
            Utilities.showAlert(appName.kAPPName, message: "Please enter other reason.", vc: self)
        }
        else {
            if isOtherReason {
                Singletons.sharedInstance.strReasonForCancel = self.txtReasonForOther.text!
            }
            let objSelectedReason = Singletons.sharedInstance.arrReasonForCancel[selectedIndex]
            self.delegate.didCancelRequestSuccess()
            self.dismiss(animated: true, completion: nil)
            print(objSelectedReason)
        }
    }
}
