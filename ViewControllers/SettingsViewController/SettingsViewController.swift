//
//  SettingsViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 11/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class SettingsViewController: ParentViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet var tblView: UITableView!
    
    var arrTitle = ["Profile"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviBlueColor, naviTitle: "Settings", naviTitleImage: "", leftImage: kBack_Icon, rightImage: kCallHelp_Icon)

    }
    
  
    //MARK: - UITableView Datasource and Delegate Method
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrTitle.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: SettingsListViewCell! = tableView.dequeueReusableCell(withIdentifier: "SettingsListViewCell") as? SettingsListViewCell
        
        cell.selectionStyle = .default
        
        cell.viewCell.layer.cornerRadius = 5
        
        let strTitle : String = arrTitle[indexPath.row]
        cell.lblTitle.text = strTitle
        return cell
    }
    
    
    
    internal  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tblView.deselectRow(at: indexPath, animated: false)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
