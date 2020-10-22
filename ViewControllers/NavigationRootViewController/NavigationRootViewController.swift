//
//  NavigationRootViewController.swift
//  TiCKPAY
//
//  Created by MAYUR on 25/01/18.
//  Copyright © 2018 MAYUR. All rights reserved.
//

import UIKit

class NavigationRootViewController: UINavigationController,UIGestureRecognizerDelegate,UINavigationControllerDelegate
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

//        self.interactivePopGestureRecognizer?.delegate = self
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled =  true
//

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        UIView *vw_pan = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, 40, self.view.frame.size.height)];
//        vw_pan.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:vw_pan];
//        [vw_pan addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
        
        
        
//        let vw_Pan : UIView = UIView.init(frame: CGRect(x: 0, y: (self.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.size.height), width: 130, height: (self.view.frame.size.height - kAdMobBannerViewHeight * 3.5)))
//        vw_Pan.backgroundColor = UIColor.red
//        self.view.addSubview(vw_Pan)
        
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognized)))
        
    }
    func showMenu()
    {
        view.endEditing(true)
//        frostedViewController.view.endEditing(true)
        
        dismiss(animated: true) {
            
        }
//        frostedViewController.presentMenuViewController()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
//    
    @objc func panGestureRecognized(_ sender: UIPanGestureRecognizer)
    {
        view.endEditing(true)
//        frostedViewController.view.endEditing(true)
        
        dismiss(animated: true) {
            
        }
//        frostedViewController.panGestureRecognized(sender)
    }

}
