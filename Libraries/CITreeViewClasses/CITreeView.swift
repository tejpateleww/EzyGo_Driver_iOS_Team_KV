//
//  CITreeViewController.swift
//  CITreeView
//
//  Created by Apple on 24.01.2018.
//  Copyright © 2018 Cenk Işık. All rights reserved.
//

import UIKit

@objc
public protocol CITreeViewDataSource : NSObjectProtocol{
    func treeView(_ treeView:CITreeView, atIndexPath indexPath:IndexPath, withTreeViewNode treeViewNode:CITreeViewNode) -> UITableViewCell
    func treeViewSelectedNodeChildren(for treeViewNodeItem:AnyObject) -> [AnyObject]
    func treeViewDataArray() -> [AnyObject]
//    func didAddDataInHeader(_ treeView: CITreeView,dictionary  userData : NSDictionary)
}

@objc
public protocol CITreeViewDelegate : NSObjectProtocol{
    
    func treeView(_ treeView: CITreeView, heightForRowAt indexPath: IndexPath, withTreeViewNode treeViewNode:CITreeViewNode) -> CGFloat
    func treeView(_ treeView: CITreeView, didSelectRowAt treeViewNode:CITreeViewNode, atIndexPath indexPath:IndexPath)
    func treeView(_ treeView: CITreeView, didDeselectRowAt treeViewNode:CITreeViewNode, atIndexPath indexPath: IndexPath)
    func willExpandTreeViewNode(treeViewNode:CITreeViewNode, atIndexPath: IndexPath)
    func didExpandTreeViewNode(treeViewNode:CITreeViewNode, atIndexPath: IndexPath)
    func willCollapseTreeViewNode(treeViewNode:CITreeViewNode, atIndexPath: IndexPath)
    func didCollapseTreeViewNode(treeViewNode:CITreeViewNode, atIndexPath: IndexPath)
    
}

public class CITreeView: UITableView {
    
    @IBOutlet open weak var treeViewDataSource:CITreeViewDataSource?
    @IBOutlet open weak var treeViewDelegate: CITreeViewDelegate?
    fileprivate var treeViewController = CITreeViewController(treeViewNodes: [])
    fileprivate var selectedTreeViewNode:CITreeViewNode?
    public var collapseNoneSelectedRows = false
    fileprivate var mainDataArray:[CITreeViewNode] = []
    public var dictProfileHeaderData = [String : AnyObject]()
    
    override public init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit()
    {
        super.delegate = self
        super.dataSource = self
        treeViewController.treeViewControllerDelegate = self as CITreeViewControllerDelegate
        self.backgroundColor = UIColor.clear
        
      
        NotificationCenter.default.addObserver(self, selector: #selector(setDataInHeaderViewMethod(_:)), name: NSNotification.Name(rawValue: "profiledata"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tableView(_:viewForHeaderInSection:)), name: NSNotification.Name(rawValue: "headerview"), object: nil)

    }
    
    override public func reloadData() {
        
        guard let treeViewDataSource = self.treeViewDataSource else {
            mainDataArray = [CITreeViewNode]()
            return
        }
        
        mainDataArray = [CITreeViewNode]()
        treeViewController.treeViewNodes.removeAll()
        for item in treeViewDataSource.treeViewDataArray() {
            treeViewController.addTreeViewNode(with: item)
        }
        mainDataArray = treeViewController.treeViewNodes
        
        super.reloadData()
    }

    public func reloadDataWithoutChangingRowStates() {
        
        guard let treeViewDataSource = self.treeViewDataSource else {
            mainDataArray = [CITreeViewNode]()
            return
        }
        
        if (treeViewDataSource.treeViewDataArray()).count > treeViewController.treeViewNodes.count {
            mainDataArray = [CITreeViewNode]()
            treeViewController.treeViewNodes.removeAll()
            for item in treeViewDataSource.treeViewDataArray() {
                treeViewController.addTreeViewNode(with: item)
            }
            mainDataArray = treeViewController.treeViewNodes
        }
        super.reloadData()
    }
    
    fileprivate func deleteRows() {
        if treeViewController.indexPathsArray.count > 0 {
            self.beginUpdates()
            self.deleteRows(at: treeViewController.indexPathsArray, with: .automatic)
            self.endUpdates()
        }
    }
    
    public func deleteRow(at indexPath:IndexPath) {
        self.beginUpdates()
        self.deleteRows(at: [indexPath], with: .automatic)
        self.endUpdates()
    }
    
    fileprivate func insertRows() {
        if treeViewController.indexPathsArray.count > 0 {
            self.beginUpdates()
            self.insertRows(at: treeViewController.indexPathsArray, with: .automatic)
            self.endUpdates()
        }
    }
    
    fileprivate func collapseRows(for treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath ,completion: @escaping () -> Void) {
        guard let treeViewDelegate = self.treeViewDelegate else { return }
        if #available(iOS 11.0, *) {
            self.performBatchUpdates({
                deleteRows()
            }, completion: { (complete) in
                treeViewDelegate.didCollapseTreeViewNode(treeViewNode: treeViewNode, atIndexPath:indexPath)
                completion()
            })
        } else {
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                treeViewDelegate.didCollapseTreeViewNode(treeViewNode: treeViewNode, atIndexPath: indexPath)
                completion()
            })
            deleteRows()
            CATransaction.commit()
        }
    }
    
    fileprivate func expandRows(for treeViewNode: CITreeViewNode, withSelected indexPath: IndexPath) {
        guard let treeViewDelegate = self.treeViewDelegate else {return}
        if #available(iOS 11.0, *) {
            self.performBatchUpdates({
                insertRows()
            }, completion: { (complete) in
                treeViewDelegate.didExpandTreeViewNode(treeViewNode: treeViewNode, atIndexPath: indexPath)
            })
        } else {
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                treeViewDelegate.didExpandTreeViewNode(treeViewNode: treeViewNode, atIndexPath: indexPath)
            })
            insertRows()
            CATransaction.commit()
        }
    }
    
    func getAllCells() -> [UITableViewCell] {
        var cells = [UITableViewCell]()
        for section in 0 ..< self.numberOfSections{
            for row in 0 ..< self.numberOfRows(inSection: section){
                cells.append(self.cellForRow(at: IndexPath(row: row, section: section))!)
            }
        }
        return cells
    }
    public func expandAllRows() {
        treeViewController.expandAllRows()
        reloadDataWithoutChangingRowStates()
        
    }
    
    public func collapseAllRows() {
        treeViewController.collapseAllRows()
        reloadDataWithoutChangingRowStates()
    }
}

extension CITreeView : UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let treeViewNode = treeViewController.getTreeViewNode(atIndex: indexPath.row)
        return (self.treeViewDelegate?.treeView(tableView as! CITreeView,heightForRowAt: indexPath,withTreeViewNode :treeViewNode))!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        Singletons.sharedInstance.selectedMenuSection = indexPath.section
        Singletons.sharedInstance.selectedMenuIndex = indexPath.row
        selectedTreeViewNode = treeViewController.getTreeViewNode(atIndex: indexPath.row)
        guard let treeViewDelegate = self.treeViewDelegate else { return }
        
        if let justSelectedTreeViewNode = selectedTreeViewNode {
            treeViewDelegate.treeView(tableView as! CITreeView, didSelectRowAt: justSelectedTreeViewNode, atIndexPath: indexPath)
            var willExpandIndexPath = indexPath
            if justSelectedTreeViewNode.expand {
                treeViewController.collapseRows(for: justSelectedTreeViewNode, atIndexPath: indexPath)
                collapseRows(for: justSelectedTreeViewNode, atIndexPath: indexPath){}
            }
            else
            {
                if collapseNoneSelectedRows,
                    selectedTreeViewNode?.level == 0,
                    let collapsedTreeViewNode = treeViewController.collapseAllRowsExceptOne(),
                    treeViewController.indexPathsArray.count > 0 {
                    
                    collapseRows(for: collapsedTreeViewNode, atIndexPath: indexPath){
                        for (index, treeViewNode) in self.mainDataArray.enumerated() {
                            if treeViewNode == justSelectedTreeViewNode {
                                willExpandIndexPath.row = index
                            }
                        }
                        self.treeViewController.expandRows(atIndexPath: willExpandIndexPath, with: justSelectedTreeViewNode, openWithChildrens: false)
                        self.expandRows(for: justSelectedTreeViewNode, withSelected: indexPath)
                    }
                    
                }else{
                    treeViewController.expandRows(atIndexPath: willExpandIndexPath, with: justSelectedTreeViewNode, openWithChildrens: false)
                    expandRows(for: justSelectedTreeViewNode, withSelected: indexPath)
                }
            }
        }
    }
}

extension CITreeView : UITableViewDataSource
{
    
   
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return treeViewController.treeViewNodes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let treeViewNode = treeViewController.getTreeViewNode(atIndex: indexPath.row)
        
        return (self.treeViewDataSource?.treeView(tableView as! CITreeView, atIndexPath: indexPath, withTreeViewNode: treeViewNode))!
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profiledata"), object: nil, userInfo: dictUserData)
//         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profiledata"), object: nil)
        var strImage = String()
        var strFullName = String()
        var strEmail = String()
        print(dictProfileHeaderData)
        if UserDefaults.standard.bool(forKey: kIsLogin) == true
        {
            let decodeResults = Utilities.decodeDictionaryfromData(KEY: kLoginData)
            print(decodeResults)
            
           
            
            if decodeResults.count != 0
            {
                
                strFullName = decodeResults["Fullname"] as! String
                strEmail = decodeResults["Email"] as! String
                
                strImage = decodeResults["Image"] as! String
            }
        }
        else
        {
            strFullName = ""
            strEmail = ""
            
            strImage = ""
        }
        
        let demoView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100))
        demoView.backgroundColor = ThemeNaviBlackLikeClearColor
        let viewProfile : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100))
        
        let commonWidth : CGFloat = 95
        let commonHeight : CGFloat = commonWidth
        let xPosi : CGFloat = ((viewProfile.frame.size.width / 2) - (commonWidth / 2))
        let yPosi : CGFloat = 20
        
        let iconProfile : UIImageView = UIImageView.init(frame: CGRect(x: xPosi, y: yPosi, width: commonWidth, height: commonHeight))
        iconProfile.layer.cornerRadius = iconProfile.frame.size.width / 2
        iconProfile.clipsToBounds = true
        
//        iconProfile.image = UIImage.init(named: strImage)
        
        iconProfile.sd_setImage(with: URL.init(string: strImage), placeholderImage: UIImage.init(named: "iconPlaceHolderUser"))
        viewProfile.addSubview(iconProfile)
        
        
        let btnProfile : UIButton = UIButton.init(frame: CGRect(x: iconProfile.frame.origin.x - 20 , y: 0, width: iconProfile.frame.size.width + 40, height: iconProfile.frame.size.height + 20))
        btnProfile.addTarget(self, action: #selector(btnProfileClickedMethod), for: .touchUpInside)
        viewProfile.addSubview(btnProfile)
        
        
        demoView.addSubview(viewProfile)
        
        let lblName : UILabel = UILabel.init(frame: CGRect(x: 0, y: viewProfile.frame.size.height + 20, width: tableView.frame.size.width, height: 25))
//        let strName = dictProfileHeaderData["name"] as? String
        

        lblName.text = strFullName//"Johna Smith"
        lblName.textColor = UIColor.white
        lblName.textAlignment = .center
        lblName.font = UIFont.init(name: CustomeFontOpenSansREgular, size: 15)
        
        demoView.addSubview(lblName)
        
        let lblEmail : UILabel = UILabel.init(frame: CGRect(x: 0, y: (lblName.frame.origin.y + lblName.frame.size.height) + 8, width: tableView.frame.size.width, height: 25))


        lblEmail.text = strEmail
        lblEmail.textColor = UIColor.white
        lblEmail.textAlignment = .center
        lblEmail.font = UIFont.init(name: CustomeFontOpenSansREgular, size: 13)
        
        demoView.addSubview(lblEmail)
        
        return demoView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 190
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let demoView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 150))
        
        let viewLogout : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 75))
        
        let commonWidth : CGFloat = 45
        let commonHeight : CGFloat = commonWidth
        let xPosi : CGFloat = ((viewLogout.frame.size.width / 2) - (commonWidth / 2))
        let yPosi : CGFloat = 3
        
        let iconLogout : UIImageView = UIImageView.init(frame: CGRect(x: xPosi, y: yPosi, width: commonWidth, height: commonHeight))
        iconLogout.image = UIImage.init(named: "iconLogout")
        iconLogout.contentMode = .center
        viewLogout.addSubview(iconLogout)
        
        let lblLogout : UILabel = UILabel.init(frame: CGRect(x: 0, y: (iconLogout.frame.origin.y + iconLogout.frame.size.height) + yPosi, width: tableView.frame.size.width, height: 18))
        lblLogout.text = "Logout"
        lblLogout.textColor = UIColor.white
        lblLogout.textAlignment = .center
        lblLogout.font = UIFont.init(name: CustomeFontOpenSansREgular, size: 12.5)
        
        viewLogout.addSubview(lblLogout)
        
         let btnLogout : UIButton = UIButton.init(frame: CGRect(x: iconLogout.frame.origin.x - 20 , y: 0, width: iconLogout.frame.size.width + 40, height: viewLogout.frame.size.height))
        btnLogout.addTarget(self, action: #selector(btnLogoutClickedMethod), for: .touchUpInside)
        viewLogout.addSubview(btnLogout)
        
        
        demoView.addSubview(viewLogout)
        
        let lblNumber1 : UILabel = UILabel.init(frame: CGRect(x: 0, y: viewLogout.frame.size.height + 30, width: tableView.frame.size.width, height: 20))
        lblNumber1.text = "(833) 837-5893"
        lblNumber1.textColor = ThemeRedColor
        lblNumber1.textAlignment = .center
        lblNumber1.font = UIFont.init(name: CustomeFontOpenSansREgular, size: 14)
        
        demoView.addSubview(lblNumber1)
        
        let lblNumber2 : UILabel = UILabel.init(frame: CGRect(x: 0, y: (lblNumber1.frame.origin.y + lblNumber1.frame.size.height) + 5, width: tableView.frame.size.width, height: 20))
        lblNumber2.text = "PUC LL-03447"
        lblNumber2.textColor = UIColor.white
        lblNumber2.textAlignment = .center
        lblNumber2.font = UIFont.init(name: CustomeFontOpenSansREgular, size: 12)
        
        demoView.addSubview(lblNumber2)
        
        let btnCall : UIButton = UIButton.init(frame: CGRect(x: 0 , y: viewLogout.frame.size.height + 30, width: tableView.frame.size.width, height: (lblNumber2.frame.origin.y + lblNumber2.frame.size.height)))
        btnCall.addTarget(self, action: #selector(btnCALLClickedMethod), for: .touchUpInside)
        demoView.addSubview(btnCall)
        
        return demoView
    }
    @objc func btnLogoutClickedMethod()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
    }
    @objc func btnCALLClickedMethod()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "callnumber"), object: nil)
    }
    @objc func btnProfileClickedMethod()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editprofile"), object: nil)
    }
    @objc func setDataInHeaderViewMethod(_ notification: NSNotification)
    {
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as! [String : AnyObject]?
        {
            dictProfileHeaderData = dict
            self.reloadData()
        }
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 200
    }
}

extension CITreeView : CITreeViewControllerDelegate
{
    public func getChildren(forTreeViewNodeItem item: AnyObject, with indexPath: IndexPath) -> [AnyObject]
    {
        return (self.treeViewDataSource?.treeViewSelectedNodeChildren(for: item))!
    }
    
    public func willCollapseTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath)
    {
        self.treeViewDelegate?.willCollapseTreeViewNode(treeViewNode: treeViewNode, atIndexPath: atIndexPath)
    }
    
    public func willExpandTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath)
    {
        self.treeViewDelegate?.willExpandTreeViewNode(treeViewNode: treeViewNode, atIndexPath: atIndexPath)
    }
}
