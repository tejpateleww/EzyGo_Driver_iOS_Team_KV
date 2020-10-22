//
//  WalletCardsVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 23/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

@objc protocol AddCadsDelegate {
    
    func didAddCard(cards: NSArray)
}

class WalletCardsVC: ParentViewController, UITableViewDataSource, UITableViewDelegate, AddCadsDelegate , UIGestureRecognizerDelegate
{

    
    weak var delegateForTopUp: SelectCardDelegate!
    weak var delegateForTransferToBank: SelectBankCardDelegate!
    
    var aryData = [[String:AnyObject]]()
     var creditCardValidator: CreditCardValidator!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = ThemeYellowColor
        
        return refreshControl
    }()
    
   
    @IBAction func btnCall(_ sender: Any) {
        CallButtonClicked()
    }
    
    
//    func CallButtonClicked()     //  Call Button
//    {
//        let contactNumber = helpLineNumber
//
//        if contactNumber == "" {
//
//            //            Utilities.showAlertWithCompletion(title: "\(appName)", message: "Contact number is not available") { (index, title) in
//            //            }
//
//            Utilities.showAlertWithCompletion(appName.kAPPName, message: "Contact number is not available", vc: self, completionHandler: {_ in
//            })
//        }
//        else
//        {
//            callNumber(phoneNumber: contactNumber)
//        }
//    }
//    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func loadView() {
        super.loadView()
        
        if Singletons.sharedInstance.isCardsVCFirstTimeLoad {
//            webserviceOFGetAllCards()
            
            if Singletons.sharedInstance.CardsVCHaveAryData.count != 0 {
                aryData = Singletons.sharedInstance.CardsVCHaveAryData
            }
            else {
                
                webserviceOFGetAllCards()
                
                
                
            }
        }
        else {
            if Singletons.sharedInstance.CardsVCHaveAryData.count != 0 {
                aryData = Singletons.sharedInstance.CardsVCHaveAryData
            }
            else {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                next.delegateAddCard = self
                self.navigationController?.pushViewController(next, animated: true)
            }
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
         creditCardValidator = CreditCardValidator()
        self.tableView.addSubview(self.refreshControl)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Cards", naviTitleImage: "", leftImage: kBack_Icon, rightImage: "")
//        self.frostedViewController.panGestureEnabled = false
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addNewCardClick(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
        next.delegateAddCard = self
        self.navigationController?.pushViewController(next, animated: true)
    }
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddCards: UIButton!
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
//        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
//            return  5
            return aryData.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCardsTableViewCell") as! WalletCardsTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "AddCard") as! WalletCardsTableViewCell
        
        cell.selectionStyle = .none
        cell2.selectionStyle = .none
        
        if indexPath.section == 0 {
             let dictData = aryData[indexPath.row] as [String:AnyObject]
            cell.lblCardNumber.text = dictData["CardNum2"] as? String ?? ""
            cell.lblYear.text = dictData["Expiry"] as? String ?? ""
            
            let strCardType = dictData["Type"] as? String ?? ""
            cell.btnDeleteCard.tag = indexPath.row
            cell.btnDeleteCard.addTarget(self, action: #selector(deleteCard(sender:)), for: .touchUpInside)
           
            switch strCardType {
            case "visa":
                cell.imgCardIcon.image = #imageLiteral(resourceName: "c_visa")
                break
            case "mastercard":
                cell.imgCardIcon.image = #imageLiteral(resourceName: "c_master")
                break
            case "discover":
                cell.imgCardIcon.image = #imageLiteral(resourceName: "c_discover")
                break
            default:
                cell.imgCardIcon.image = UIImage(named: "card_dummy")!
                break
            }
            
        
            /*
            let dictData = aryData[indexPath.row] as [String:AnyObject]
            
            cell.lblCardType.text = "Credit Card"
            
            cell.viewCards.layer.cornerRadius = 10
            cell.viewCards.layer.masksToBounds = true
            let number = dictData["CardNum"] as! String
             cell.imgCardIcon.image = detectCardNumberType(number: number)
            
//            let type = dictData["Type"] as! String
            
           
            
            if (indexPath.row % 2) == 0
            {
                cell.viewCards.backgroundColor = UIColor.orange
                cell.lblBankName.text = dictData["Alias"] as? String
                cell.lblCardNumber.text = dictData["CardNum2"] as? String
//                cell.imgCardIcon.image = UIImage(named: "MasterCard")
            }
            else {
                cell.viewCards.backgroundColor = UIColor.init(red: 0, green: 145/255, blue: 147/255, alpha: 1.0)
                cell.lblBankName.text = dictData["Alias"] as? String
                cell.lblCardNumber.text = dictData["CardNum2"] as? String
//                cell.imgCardIcon.image = UIImage(named: "Visa")
                
            }
            
            
            cell.lblMonth.text = dictData["Expiry"]?.components(separatedBy: "/").first
            cell.lblYear.text = dictData["Expiry"]?.components(separatedBy: "/").last

            
         /*
          //   visa , mastercard , amex , diners , discover , jcb , other
             
            if (indexPath.row % 2) == 0 {
                cell.viewCards.backgroundColor = UIColor.orange
                cell.lblCardNumber.text = "**** **** **** 1081"
                cell.imgCardIcon.image = UIImage(named: "MasterCard")
            }
            else {
                cell.viewCards.backgroundColor = UIColor.init(red: 0, green: 145/255, blue: 147/255, alpha: 1.0)
                cell.lblCardNumber.text = "**** **** **** 9964"
                cell.imgCardIcon.image = UIImage(named: "Visa")
                
            }
          */
            */
            return cell
        }
        else
        {
            cell2.imgArrow.image = UIImage.init(named: "iconArrowGrey")?.withRenderingMode(.alwaysTemplate)
            cell2.imgArrow.tintColor = UIColor.white
            
            return cell2
        }
    }
    func detectCardNumberType(number: String) -> UIImage
    {
        if let type = creditCardValidator.type(from: number)
        {
            return UIImage(named: type.name)!
        }
        else
        {
            return UIImage(named: "card_dummy")!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 0 {
         
            let selectedData = aryData[indexPath.row] as [String:AnyObject]
            
            print("selectedData : \(selectedData)")
            
            if Singletons.sharedInstance.isFromTopUP {
                delegateForTopUp.didSelectCard(dictData: selectedData)
                Singletons.sharedInstance.isFromTopUP = false
                self.navigationController?.popViewController(animated: true)
            }
            else if Singletons.sharedInstance.isFromTransferToBank {
                delegateForTransferToBank.didSelectBankCard(dictData: selectedData)
                Singletons.sharedInstance.isFromTransferToBank = false
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        else if indexPath.section == 1 {
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
            next.delegateAddCard = self
            self.navigationController?.pushViewController(next, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 160
        }
        else {
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let selectedData = aryData[indexPath.row] as [String:AnyObject]

        if editingStyle == .delete {

            let selectedID = selectedData["Id"] as? String

            tableView.beginUpdates()
            aryData.remove(at: indexPath.row)
            webserviceForRemoveCard(cardId : selectedID!)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        
    }
   
    @IBAction func deleteCard(sender: UIButton) {
        
        let alertDeleteCard = UIAlertController.init(title: "", message: "Are you sure you want to delete this card?", preferredStyle: .alert)
        let alertYes = UIAlertAction.init(title: "Yes", style: .default) { (alert) in
            let selectedData = self.aryData[sender.tag] as [String:AnyObject]
            
            //        if editingStyle == .delete {
            
            let selectedID = selectedData["Id"] as? String
            
            self.tableView.beginUpdates()
            self.aryData.remove(at: sender.tag)
            self.webserviceForRemoveCard(cardId : selectedID!)
            let indexPath = IndexPath.init(row: sender.tag, section: 0)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        }
        let alertNO = UIAlertAction.init(title: "No", style: .cancel, handler: nil)
        alertDeleteCard.addAction(alertNO)
        alertDeleteCard.addAction(alertYes)
        self.present(alertDeleteCard, animated: true, completion: nil)
        //        }
    }
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func btnAddCards(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
        
        next.delegateAddCard = self
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        webserviceOFGetAllCards()
        
        tableView.reloadData()
    }
    
    func setCreditCardImage(str: String) -> String
    {
        
        //   visa , mastercard , amex , diners , discover , jcb , other
        
        var strType = String()
        
        if str == "visa" {
            strType = "Visa"
        }
        else if str == "mastercard" {
            strType = "MasterCard"
        }
        else if str == "amex" {
            strType = "Amex"
        }
        else if str == "diners" {
            strType = "Diners Club"
        }
        else if str == "discover" {
            strType = "Discover"
        }
        else if str == "jcb" {
            strType = "JCB"
        }
        else {
            strType = "card_dummy"
        }
        
        return strType
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Add Cads Delegate Methods
    //-------------------------------------------------------------
    
    func didAddCard(cards: NSArray) {
        
        aryData = cards as! [[String:AnyObject]]
        
        tableView.reloadData()
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For All Cards
    //-------------------------------------------------------------
    
    func webserviceOFGetAllCards() {
        
        webserviceForCardListingInWallet(Singletons.sharedInstance.strDriverID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                self.aryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                Singletons.sharedInstance.CardsVCHaveAryData = self.aryData
                
                Singletons.sharedInstance.isCardsVCFirstTimeLoad = false
                
                self.tableView.reloadData()
                
                if Singletons.sharedInstance.CardsVCHaveAryData.count == 0 {
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                    next.delegateAddCard = self
                    self.navigationController?.pushViewController(next, animated: true)
                }
                
                self.refreshControl.endRefreshing()
            }
            else {
                
                print(result)
                if let res = result as? String {
                    Utilities.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    Utilities.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    Utilities.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Remove Cards
    //-------------------------------------------------------------
    
    
    
    func webserviceForRemoveCard(cardId : String)
    {
      
       
        var params = String()
        params = "\(Singletons.sharedInstance.strDriverID)/\(cardId)"

        webserviceForRemoveCardFromWallet(params as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                self.aryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                Singletons.sharedInstance.CardsVCHaveAryData = self.aryData
                
                Singletons.sharedInstance.isCardsVCFirstTimeLoad = false
                
                self.tableView.reloadData()
                
                Utilities.showAlert(appName.kAPPName, message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
            }else {
                print(result)
                
                if let res = result as? String {
                    Utilities.showAlert(appName.kAPPName, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    Utilities.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    Utilities.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }
 
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
    
    
}



