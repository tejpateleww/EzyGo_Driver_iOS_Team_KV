//
//  Utilities.swift
//  SwiftFirstDemoLoginSignUp
//
//  Created by Elite on 23/06/17.
//  Copyright © 2017 Palak. All rights reserved.
//

import UIKit
import BFKit
import QuartzCore

class DataClass: NSObject
{
    var viewBackFull = UIView()
    
    var str = ""
    
    class func getInstance() -> DataClass?
    {
        var instance: DataClass? = nil
        
      
            let lockQueue = DispatchQueue(label: "self")
            lockQueue.sync {
                if instance == nil {
                    instance = DataClass()
                }
            }
            return instance
    }
}
//typealias CompletionHandler = (_ success:Bool) -> Void


class Utilities: NSObject
{
    class func isInternetConnectionAvailable() -> Bool
    {
        let networkReachability = Reachability.forInternetConnection()
        let networkStatus : NetworkStatus = (networkReachability?.currentReachabilityStatus())!
        
        if networkStatus != .NotReachable
        {
            return true
        }
        else
        {
            return false
        }
    }

    class func showActivityIndicator()
    {
        SVProgressHUD.show()
    }
    class func hideActivityIndicator()
    {
        SVProgressHUD.dismiss()
    }
    class func showAlertWithCompletion(_ title: String, message: String, vc: UIViewController,completionHandler: @escaping CompletionHandler) -> Void
    {
        //        title = "TickToc"
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
        vc.present(alert, animated: true, completion: nil)
        
    }
    
    class func hexStringToUIColor (hex:String) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
    class func checkEmptyString(str: String?) -> String
    {
        var newString : String?
        newString = (str)
        
        if (newString as? NSNull) == NSNull()
        {
            return ""
        }
        if (newString == "(null)")
        {
            return ""
        }
        if (newString == "<null>")
        {
            return ""
        }
        if newString == nil
        {
            return ""
        }
        else if (newString?.count ?? 0) == 0 {
            return ""
        }
        else
        {
            newString = newString?.trimmingCharacters(in: .whitespacesAndNewlines)
            if ((str)!.count ?? 0) == 0 {
                return ""
                
            }
        }
        if ((str)! == "<null>")
        {
            return ""
        }
        return newString!
    }
    
    class func isEmpty(str: String?) -> Bool
    {
        var newString : String?
        newString = (str)
        
        if (newString as? NSNull) == NSNull()
        {
            return true
        }
        if (newString == "(null)")
        {
            return true
        }
        if (newString == "<null>")
        {
            return true
        }
        if (newString == "null")
        {
            return true
        }
        if newString == nil
        {
            return true
        }
        else if (newString?.count ?? 0) == 0 {
            return true
        }
        else
        {
            newString = newString?.trimmingCharacters(in: .whitespacesAndNewlines)
            if ((str)!.count ?? 0) == 0 {
                return true
            
            }
        }
        if ((str)! == "<null>")
        {
            return true
        }
        return false
    }
    class func isEmail(testStr:String) -> Bool
    {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func setLeftPaddingInTextfield(textfield:UITextField , padding:(CGFloat))
    {
        let view:UIView = UIView (frame: CGRect (x: 0, y: 0, width: padding, height: textfield.frame.size.height) )
        textfield.leftView = view
        textfield.leftViewMode = UITextFieldViewMode.always
    }

    class func setRightPaddingInTextfield(textfield:UITextField, padding:(CGFloat))
    {
        
        let view:UIView = UIView (frame: CGRect (x: 0, y: 0, width: padding, height: textfield.frame.size.height) )
        textfield.rightView = view
        textfield.rightViewMode = UITextFieldViewMode.always
    }
    
    class func setCornerRadiusTextField(textField : UITextField, borderColor : UIColor , bgColor : UIColor, textColor : UIColor)
    {
        textField.layer.cornerRadius = textField.frame.size.height / 2
        textField.backgroundColor = bgColor
        textField.layer.borderColor = borderColor.cgColor
        textField.layer.borderWidth = 1.0
        textField.textColor = textColor
        textField.clipsToBounds = true
    }
    
    class func setCornerRadiusButton(button : UIButton , borderColor : UIColor , bgColor : UIColor, textColor : UIColor)
    {
        button.layer.cornerRadius = button.frame.size.height / 2
        button.clipsToBounds = true
        button.backgroundColor = bgColor
        button.setTitleColor(textColor, for: .normal)
        button.layer.borderColor = borderColor.cgColor
        button.layer.borderWidth = 1.0
    }
    
    class func setCornerRadiusView(view: UIView, borderColor: UIColor, bgColor: UIColor) {
        view.layer.cornerRadius = view.frame.size.height / 2
        view.clipsToBounds = true
        view.backgroundColor = bgColor       
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = 1.0
    }
    
    class func showToastMSG(MSG: String)
    {
        CSToastManager.setQueueEnabled(false)
        Appdelegate.window?.makeToast(MSG)
    }
    
    class func sizeForText(text : String , font : UIFont, width : CGFloat) -> CGSize
    {
        let constraint : CGSize = CGSize.init(width: width, height: 20000.0)
        var size  = CGSize()
        let boundingBox : CGSize = text.boundingRect(with: constraint,
                                                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                attributes: [NSAttributedStringKey.font: font],
                                                context: nil).size
        size = CGSize.init(width: ceil(boundingBox.width), height: ceil(boundingBox.height))
        return size
        
    }
    class func getAspectSizeOfImage(imageSize : CGSize , widthTofit: CGFloat) -> CGSize
    {
        var imageWidth : CGFloat = imageSize.width
        var imageHeight : CGFloat = imageSize.height
         var imgRatio : CGFloat = imageWidth/imageHeight
        
        
         let width_1 : CGFloat = widthTofit
         let height_1 : CGFloat = CGFloat(MAXFLOAT)
        let maxRatio
            : CGFloat = width_1/height_1;
        
        if(imgRatio != maxRatio)
        {
            if(imgRatio < maxRatio)
            {
                imgRatio = height_1 / imageHeight;
                imageWidth = imgRatio * imageWidth;
                imageHeight = height_1;
            }
            else
            {
                imgRatio = width_1 / imageWidth;
                imageHeight = imgRatio * imageHeight;
                imageWidth = width_1;
            }
        }
        return CGSize.init(width: imageWidth, height: imageHeight)
    }
    class func formatStringForDBUse(strValue : String) -> String
    {
        let strFinalString : String = strValue .replacingOccurrences(of: "'", with: "''")
        
        return strFinalString;
    }
    
    class func imageWithImage(image : UIImage  ,newSize :CGSize  ) -> UIImage
    {
        UIGraphicsBeginImageContext( newSize );
        image .draw(in: CGRect (x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return newImage;
    }
    
    class func setFraction(StrAmount : String) -> String
    {
        let inputNumber : NSNumber = NSNumber.init(value: Double(StrAmount)!)
        let formatterInput : NumberFormatter = NumberFormatter.init()
        formatterInput.numberStyle = NumberFormatter.Style.decimal
        formatterInput.maximumFractionDigits = 2
        var formattedInputString : String = formatterInput .string(from: inputNumber)!
        formattedInputString = formattedInputString .replacingOccurrences(of: ",", with: "")
        
        if formattedInputString == "0"
        {
            formattedInputString = "0.0"
        }
        else
        {
            formattedInputString = formattedInputString .appending(".0")
        }
        return formattedInputString
    }


//    func getFontSize(asPerResolutionIphone font: CGFloat) -> CGFloat
//    {
//        if IS_IPHONE_4_OR_LESS
//        {
//            //        if (font == customFontSize)
//            //        {
//            font = 10
//            //        }
//        }
//        else if IS_IPHONE_X {
//            font = 15
//        }
//        else {
//            var ratio_size: Float = 0.0
//            ratio_size = SCREEN_HEIGHT / 568
//            font = font * ratio_size
//        }
//        
//        return font
//    }

    class func setFraction(_ StrAmount: String) -> String {
        //    StrAmount = @"123456.1000";
        let inputNumber = Double(StrAmount) ?? 0.0
        let formatterInput = NumberFormatter()
        formatterInput.numberStyle = .decimal
        formatterInput.numberStyle = .decimal
        formatterInput.maximumFractionDigits = 2
        var formattedInputString: String? = formatterInput.string(from: (inputNumber as? NSNumber) ?? 0)
        formattedInputString = formattedInputString?.replacingOccurrences(of: ",", with: "")
        //    if ([formattedInputString isEqualToString:@"0"])
        //    {
        //        formattedInputString = @"0.0";
        //    }
        //    if (![formattedInputString containsString:@"." ])
        //    {
        //        formattedInputString =  [formattedInputString stringByAppendingString:@".0"];
        //    }
        return formattedInputString ?? ""
    }

    
    // Alert
    
    class func showAlert(_ title: String, message: String, vc: UIViewController) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        if(vc.presentedViewController != nil)
        {
            vc.dismiss(animated: true, completion: nil)
        }
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
        vc.present(alert, animated: true, completion: nil)
    }
    
//    class func showAlertWithCompletion(_ title: String, message: String, vc: UIViewController,completionHandler: @escaping CompletionHandler) -> Void
//    {
//        //        title = "TickToc"
//        let alert = UIAlertController(title: title,
//                                      message: message,
//                                      preferredStyle: UIAlertControllerStyle.alert)
//        
//        
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//            completionHandler(true)
//        }))
//        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
//        vc.present(alert, animated: true, completion: nil)
//        
//    }
    
    
    class func showAlertAnother(_ title: String, message: String, vc: UIViewController) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        if(vc.presentedViewController != nil)
        {
            vc.dismiss(animated: true, completion: {
                vc.present(alert, animated: true, completion: nil)
                
            })
        }
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
    }
    
    class func encodeDatafromDictionary(KEY:String , Param:Any) -> Void
    {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: Param)
        UserDefaults.standard.set(encodedData, forKey: KEY)
        UserDefaults.standard.synchronize()
    }
    class func decodeDictionaryfromData(KEY:String) -> NSDictionary
    {
        
        let decoded  = UserDefaults.standard.object(forKey: kLoginData) as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSDictionary
        return decodedTeams
    }
    
    class func showLoaderLeafIndicator(viewController : UIViewController)
    {
        let activeVc = UIApplication.shared.keyWindow?.rootViewController
        activeVc?.present(viewController, animated: true, completion: nil)
    }
    class func dismissLoaderLeafIndicator(viewController : UIViewController)
    {
        
        print("dismiss Loader")
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    

//    class func spinAnimation(withDuration duration: CGFloat, clockwise: Bool, repeat repeats: Bool, withImage imageView: UIImageView) -> CABasicAnimation {
//
////        CABasicAnimation* animation = [CABasicAnimation
////            animation WithKeyPath:@"transform.rotation.y"];
////        animation.fromValue = @(0);
////        animation.toValue = @(2 * M_PI);
////        animation.repeatCount = INFINITY;
////        animation.duration = 5.0;
////
////        [self.rotatingView.layer addAnimation:animation forKey:@"rotation"];
////
////        CATransform3D transform = CATransform3DIdentity;
////        transform.m34 = 1.0 / 500.0;
////        self.rotatingView.layer.transform = transform;
//
//
//        var rotation: CABasicAnimation?
//        rotation = CABasicAnimation(keyPath: "transform.rotation")
//        rotation?.fromValue = 0
//        rotation?.toValue = 2 * Double.pi
//        rotation?.duration = CFTimeInterval(duration)
//
//        rotation?.repeatCount = Float.infinity
//        rotation?.isRemovedOnCompletion = false
//        imageView.layer.removeAllAnimations()
//        imageView.layer.add(rotation!, forKey: "Spin")
//
////        var transform : CATransform3D?
////        transform = CATransform3DIdentity
////        transform?.m34 = 1.0 / 500.0
////        imageView.layer.transform = transform!
//
//        return CABasicAnimation()
//    }
//    class func hideHUD()
//    {
//        let obj = DataClass.getInstance()
//        obj?.viewBackFull.removeFromSuperview()
//    }
    
    class func delay(_ delay:Double, closure:@escaping ()->())
    {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    class func sizeForText(_ text: String, _ font: UIFont,_ width:CGFloat) -> CGSize
    {
        let constraint = CGSize(width: width, height: 200000.0)
        var size = CGSize()
        
        let boundingBox: CGSize? = text.boundingRect(with: constraint, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font : font], context: nil).size
        size = CGSize(width: ceil((boundingBox?.width)!), height: ceil((boundingBox?.height)!))
        return size;
    }
    
    class func stringHtmltoPlainText(_ str : String) -> String
    {
        let strTemp = str.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return strTemp
    }
    class func setNavigationBarInViewController (controller : UIViewController,naviColor : UIColor, naviTitle : String, naviTitleImage : String, leftImage : String , rightImage : String)
    {
       /*
        UIApplication.shared.statusBarStyle = .lightContent
        controller.navigationController?.isNavigationBarHidden = false
        controller.navigationController?.navigationBar.isOpaque = false;
        controller.navigationController?.navigationBar.isTranslucent = false
        
        controller.navigationController?.navigationBar.barTintColor = naviColor;
        controller.navigationController?.navigationBar.tintColor = UIColor.white;

        
        
        if naviTitleImage == ""
        {
            controller.navigationItem.title = naviTitle
        }
        else
        {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 38))
            imageView.contentMode = .scaleToFill
            let logo = UIImage(named: naviTitleImage)
            imageView.image = logo
            controller.navigationItem.titleView = imageView
        }
        
        controller.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        controller.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        controller.navigationController?.navigationBar.shadowImage = UIImage()
        
        let btnLeft = UIButton.init()
        btnLeft.setImage(UIImage.init(named: leftImage), for: .normal)
        btnLeft.layer.setValue(controller, forKey: "controller")
        
        if leftImage == kMenu_Icon
        {
            btnLeft.addTarget(self, action: #selector(OpenMenuViewController(_:)), for: .touchUpInside)
        }
        else
        {
            btnLeft.addTarget(self, action: #selector(poptoViewController(_:)), for: .touchUpInside)
        }
        let btnLeftBar : UIBarButtonItem = UIBarButtonItem.init(customView: btnLeft)
        btnLeftBar.style = .plain
        controller.navigationItem.leftBarButtonItem = btnLeftBar
        
        if rightImage == kCallHelp_Icon
        {
            let btnRight = UIButton.init()
            btnRight.setImage(UIImage.init(named: rightImage), for: .normal)
            btnRight.layer.setValue(controller, forKey: "controller")
            
            btnRight.addTarget(self, action: #selector(btnCallClicked(_:)), for: .touchUpInside)

            let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: btnRight)
            btnRightBar.style = .plain
            controller.navigationItem.rightBarButtonItem = btnRightBar
        }
        else
        {
        }
        */
    }

    
    @objc class func poptoViewController (_ sender: UIButton?)
    {
        let controller = sender?.layer.value(forKey: "controller") as? UIViewController
        controller?.navigationController?.popViewController(animated: true)
    }
    @objc class func OpenMenuViewController (_ sender: UIButton?)
    {
        let controller = sender?.layer.value(forKey: "controller") as? UIViewController
//        controller?.frostedViewController.view.endEditing(true)
//        controller?.frostedViewController.presentMenuViewController()
    }
    @objc class func btnCallClicked(_ sender : UIButton?)
    {
        let controller = sender?.layer.value(forKey: "controller") as? UIViewController
        let contactNumber = helpLineNumber
        
        if contactNumber == "" {

            
            Utilities.showAlertWithCompletion(appName.kAPPName, message: "Contact number is not available", vc: controller!) { (status) in
            
            }

        }
        else
        {
            if let phoneCallURL = URL(string: "tel://\(contactNumber)") {
                
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    class func removeUserDefaultsValue()
    {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if (key != "Token")
            {
                UserDefaults.standard.removeObject(forKey: key.description)
            }
        }
    }
    
    class func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
//        2018-08-01 17:34:32
        if let date = inputFormatter.date(from: dateString)
        {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            let str = outputFormatter.string(from: date)
            return str
        }
        
        return nil
    }
    class func formattedDateFromStringPost(dateString: String, withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
          inputFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        //        2018-08-01 17:34:32
        if let date = inputFormatter.date(from: dateString)
        {
            
            let outputFormatter = DateFormatter()
//            outputFormatter.dateFormat = "dd/mm/yyyy"
            outputFormatter.dateFormat = format
            let str = outputFormatter.string(from: date)
            return str
        }
        
        return nil
    }
    
    class  func ConvertSecondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    class func presentPopupOverScreen(_ alertController : UIViewController)
    {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    class func shareUrl(_ strUrl: String) {
        let activityViewController = UIActivityViewController(activityItems: [strUrl], applicationActivities: nil)
        //                activityViewController.popoverPresentationController?.sourceView = .view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
}


extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        //        if let slide = viewController as? SlideMenuController {
        //            return topViewController(slide.mainViewController)
        //        }
        return viewController
    }
}
