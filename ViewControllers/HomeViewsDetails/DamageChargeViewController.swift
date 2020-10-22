//
//  DamageChargeViewController.swift
//  ezygo-Driver
//
//  Created by Apple on 22/11/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class DamageChargeViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------

    @IBOutlet weak var txtDamageCharges: UITextField!
    
    @IBOutlet weak var lblTotalFare: UILabel!
    
    @IBOutlet weak var btnAddDamages: UIButton!
    
    @IBOutlet weak var vwStackDamage: UIStackView!
    var strTotalFare = ""
    // ----------------------------------------------------
    // MARK: - Globle Declaration
    // ----------------------------------------------------
    
    weak var delegate: delegateForDamageCharge?
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwStackDamage.isHidden = true
        lblTotalFare.text = "TotalFare : " + currency + String(format: "%.2f",Double(strTotalFare) ?? 0.0)
    }

    // ----------------------------------------------------
    // MARK: - Action Handler
    // ----------------------------------------------------
    
    @IBAction func btnSubmitActionHandler(_ sender: UIButton) {
        
        if btnAddDamages.isSelected && txtDamageCharges.text!.isEmptyOrWhitespace() {
            Utilities.showAlert("", message: "Please enter damage charge", vc: self)
        }else {
            delegate?.didEnterDamageCharge!(cost: txtDamageCharges.text ?? "")
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnCloseActionHandler(_ sender: UIButton) {
        
//        delegate?.didEnterDamageCharge!(cost: "")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func damageChargeClick(_ sender: UIButton) {
        
        btnAddDamages.isSelected = !btnAddDamages.isSelected
        
        vwStackDamage.isHidden =  btnAddDamages.isSelected ? false : true
        
    }
}
