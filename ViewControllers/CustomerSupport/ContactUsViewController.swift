//
//  ContactUsViewController.swift
//  ezygo-Driver
//
//  Created by Apple on 08/10/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
class ContactUsViewController: ParentViewController {

    @IBOutlet weak var btnSelectSubject: UIButton!
    
    @IBOutlet weak var txtVwDescription: UITextView!
    
    var arrData = ["Feedback","General Enquiry","Account Enquiry"]
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        txtVwDescription.text = "Description"
        txtVwDescription.textColor = UIColor.lightGray

//        txtVwDescription.selectedTextRange = txtVwDescription.textRange(from: txtVwDescription.beginningOfDocument, to: txtVwDescription.beginningOfDocument)

        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Button Click Event
    
    @IBAction func selectSubjectClick(_ sender: UIButton) {
//        let arrData = Singletons.sharedInstance.arrReasonForReject.map{$0.strReason}
        
        
        ActionSheetStringPicker.show(withTitle: "Select Subject", rows: arrData, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
            self.selectedIndex = index
//            Singletons.sharedInstance.strReasonForCancel = arrData[index]
            self.btnSelectSubject.setTitle(self.arrData[index], for: .normal)
        }, cancel: { (actionSheet) in
            
        }, origin: self.view)
        
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        if btnSelectSubject.currentTitle == "Select Subject" {
            Utilities.showAlert("Please select reason", message: "", vc:    self)
        }else if txtVwDescription.text.isEmpty {
            Utilities.showAlert("Please enter description", message: "", vc:    self)
        }else {
            var param = [String:AnyObject]()
            
            param["DriverId"] = Singletons.sharedInstance.strDriverID as AnyObject
            param["Subject"] = btnSelectSubject.currentTitle as AnyObject
            param["Description"] = txtVwDescription.text as AnyObject
            
            webserviceForContactUs(param as AnyObject) { (result, status) in
//                if status {
//
//                }else {
//
//                }
                if self.selectedIndex == 0 {
                    Utilities.showAlertWithCompletion("Feedback Confirmation", message: result["message"] as? String ?? "", vc: self, completionHandler: { (status) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }else if self.selectedIndex == 1 {
                    Utilities.showAlertWithCompletion("Enquiry Confirmation", message: result["message"] as? String ?? "", vc: self, completionHandler: { (status) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }else if self.selectedIndex == 2 {
                    Utilities.showAlertWithCompletion("Account Enquiry Confirmation", message: result["message"] as? String ?? "", vc: self, completionHandler: { (status) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }
              
                
            }
            

        }
    }
}
extension ContactUsViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Description" {
           textView.text = ""
            textView.textColor = UIColor.black
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
   
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//        // Combine the textView text and the replacement text to
//        // create the updated text string
//        let currentText:String = textView.text
//        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
//
//        // If updated text view will be empty, add the placeholder
//        // and set the cursor to the beginning of the text view
//        if updatedText.isEmpty {
//
//            textView.text = "Description"
//            textView.textColor = UIColor.lightGray
//
//            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
//        }
//
//            // Else if the text view's placeholder is showing and the
//            // length of the replacement string is greater than 0, set
//            // the text color to black then set its text to the
//            // replacement string
//        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
//            textView.textColor = UIColor.black
//            textView.text = text
//        }
//
//            // For every other case, the text should change with the usual
//            // behavior...
//        else {
//            return true
//        }
//
//        // ...otherwise return false since the updates have already
//        // been made
//        return false
//    }
}
