//
//  ShowTripViewController.swift
//  ezygo-Driver
//
//  Created by Apple on 07/12/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class ShowTripViewController: ParentViewController {
    @IBOutlet weak var webView: UIWebView!
    var URLString:String = ""
    var strNavTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.webView.scalesPageToFit = true
        self.webView.contentMode = .scaleAspectFit
        self.webView.loadRequest(URLRequest(url: URL(string: URLString)!))
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         self.headerView?.lblTitle.text = strNavTitle
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
extension ShowTripViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
     Utilities.showActivityIndicator()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        Utilities.hideActivityIndicator()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        Utilities.hideActivityIndicator()
    }
   
}
