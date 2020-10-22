//
//  SelectionViewController.swift
//  ezygo-Driver
//
//  Created by Mayur iMac on 15/02/19.
//  Copyright © 2019 Excellent WebWorld. All rights reserved.
//

import UIKit

protocol didSelectAllOptions {
    func selectOptions(dictData : [String:String])
}

class SelectionViewController: UIViewController,UITextFieldDelegate {

//    @IBOutlet weak var txtAirportIn: UITextField!
//    @IBOutlet weak var txtAirportOut: UITextField!
//    @IBOutlet weak var txtPaymentType: UITextField!
    var delegate: didSelectAllOptions?

    @IBOutlet weak var btnAirportIn: UIButton!
    @IBOutlet weak var btnAirportOut: UIButton!
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var FPOS: UIButton!

    var strAirportPickUpCharge : String!
    var strAirportDropOffCharge : String!
    var vehicleDetails : [String:AnyObject]!
    override func viewDidLoad() {
        super.viewDidLoad()
        FPOS.isSelected = true

        strAirportPickUpCharge = vehicleDetails["AirportPickUpCharge"] as? String
        btnAirportIn.setTitle("Airport Pick Up: \("$" + strAirportPickUpCharge )", for: .normal)
        btnAirportIn.setTitle("Airport Pick Up: \("$" + strAirportPickUpCharge )", for: .highlighted)
        btnAirportIn.setTitle("Airport Pick Up: \("$" + strAirportPickUpCharge )", for: .selected)


        strAirportDropOffCharge = vehicleDetails["AirportDropOffCharge"] as? String
        btnAirportOut.setTitle("Airport Drop Off: \("$" + strAirportDropOffCharge )", for: .normal)
        btnAirportOut.setTitle("Airport Drop Off: \("$" + strAirportDropOffCharge )", for: .highlighted)
        btnAirportOut.setTitle("Airport Drop Off: \("$" + strAirportDropOffCharge )", for: .selected)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAirport(_ sender: UIButton) {
        if(sender.tag == 0)
        {
            if(btnAirportOut.isSelected == true)
            {
                btnAirportOut.isSelected = false
            }
            btnAirportIn.isSelected = !btnAirportIn.isSelected
        }
        else
        {
            if(btnAirportIn.isSelected == true)
            {
                btnAirportIn.isSelected = false
            }
            btnAirportOut.isSelected = !btnAirportOut.isSelected
        }


    }
    @IBAction func btnFPOS(_ sender: UIButton) {
        if(sender.tag == 0)
        {
            if(btnCash.isSelected == true)
            {
                btnCash.isSelected = false
            }
           // FPOS.isSelected = !FPOS.isSelected
        }
        else
        {
            if(FPOS.isSelected == true)
            {
                FPOS.isSelected = false
            }
          //  btnCash.isSelected = !btnCash.isSelected
        }
        sender.isSelected = true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    @IBAction func btnDone(_ sender: Any) {
        var dictData = [String:String]()

        if(btnAirportIn.isSelected)
        {
            dictData["AirportIn"] = "1"//strAirportPickUpCharge//txtAirportIn.text

        }
        else
        {
             dictData["AirportIn"] = "0"
        }
        if(btnAirportOut.isSelected)
        {
            dictData["AirportOut"] = "1" //strAirportDropOffCharge//txtAirportOut.text

        }
        else
        {
            dictData["AirportOut"] = "0"

        }

//        if(FPOS.isSelected)
//        {
//            dictData["PaymentType"] = "1"
//
//        }
//        else
//        {
//            dictData["PaymentType"] = "0"
//
//        }
        
        dictData["PaymentType"] = "0"

        self.dismiss(animated: true, completion: nil)
        delegate?.selectOptions(dictData: dictData)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
