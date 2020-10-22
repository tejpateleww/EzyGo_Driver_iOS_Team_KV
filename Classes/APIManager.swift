//
//  APIManager.swift
//  SwiftFirstDemoLoginSignUp
//
//  Created by Elite on 27/06/17.
//  Copyright © 2017 Palak. All rights reserved.
//

import UIKit
import Foundation


//typedef void(^ManagerCompletionBlock)(id result, BOOL success);
typealias ManagerCompletionBlock = (_ result : Any? , _ success : Bool?)-> Void



class APIManager: NSObject
{


    func GETAPI(View : UIView, strGetMethod : String, Parameters:NSDictionary, showActivityIndicator:Bool, CompletionBlock: @escaping ManagerCompletionBlock )
    {
        let networkReachability = Reachability.forInternetConnection()
        let networkStatus :NetworkStatus = (networkReachability?.currentReachabilityStatus())!
        if (networkStatus != NetworkStatus.NotReachable)
        {
            if(showActivityIndicator)
            {
//                utility.showActivitiyIndicator()
            }
            
            let  BASE_URL : String = ""
            
            let strRequestUrl : String = BASE_URL .appending(strGetMethod)
            
            let manager : AFHTTPSessionManager = AFHTTPSessionManager()
            
            manager.responseSerializer =    AFJSONResponseSerializer()
            manager.responseSerializer.acceptableContentTypes = Set(["application/json", "text/json", "text/javascript", "text/html"])
            
            [manager.requestSerializer.setValue("RemotePOSRestAPIKey", forHTTPHeaderField: "key")]
            manager.get(strRequestUrl, parameters: Parameters, progress: { (downloadProgress) in
                
            }, success: { (task, responseObject) in
                if(showActivityIndicator)
                {
//                    utility.hideActivitiyIndicator()
                }
                if ((responseObject) != nil) {
                    
//                    NSLog(responseObject as! [String])
                    
                    //                    let jsonString : String = String.init(data: responseObject as! Data, encoding: String.Encoding.utf8)!
                    //                    let data : Data = jsonString .data(using: String.Encoding.utf8)!
                    //                    let json : Any = JSONSerialization .jsonObject(with: data, options:0)
                    
                    //                    if (CompletionBlock)
                    //                    if ManagerCompletionBlock
                    //                    {
                    CompletionBlock(responseObject,true);
                    //                    }
                    
                }
                else
                {
                    CompletionBlock(nil,false);
                }
                
            }, failure: { (task, error) in
                if(showActivityIndicator)
                {
//                    utility.hideActivitiyIndicator()
                }
                CompletionBlock(nil,false);
            })
        }
        else
        {
//            utility.hideActivitiyIndicator()
            Utilities.showToastMSG(MSG: "You do not seem to have a strong Internet connection. Kindly move to a WiFi or stronger cellular signal.")
            CompletionBlock(nil,false);
        }
    }
    
    func POSTAPI(View : UIView, strGetMethod : String, Parameters:NSDictionary, showActivityIndicator:Bool, CompletionBlock: @escaping ManagerCompletionBlock )
    {
        let networkReachability = Reachability.forInternetConnection()
        let networkStatus :NetworkStatus = (networkReachability?.currentReachabilityStatus())!
        if (networkStatus != NetworkStatus.NotReachable)
        {
            if(showActivityIndicator)
            {
//                utility.showActivitiyIndicator()
            }
            
            let  BASE_URL : String = ""
            
            let strRequestUrl : String = BASE_URL .appending(strGetMethod)
            
            let manager : AFHTTPSessionManager = AFHTTPSessionManager()
            
            manager.responseSerializer =    AFJSONResponseSerializer()
            manager.responseSerializer.acceptableContentTypes = Set(["application/json", "text/json", "text/javascript", "text/html"])
            
            //            let img :UIImage = Parameters.object(forKey: "photo") as! UIImage
            
            if (Parameters.value(forKey: "photo") != nil)    //(Parameters.value(forKey: "photo") != nil)
            {
                manager .post(strRequestUrl, parameters: Parameters, constructingBodyWith: { (formData) in
                    var image :UIImage? = nil
                    
                    
                    if (Parameters .object(forKey: "photo") is UIImage)
                    {
                        image = Parameters .object(forKey: "photo") as? UIImage
                        let imageData : Data = UIImageJPEGRepresentation(image!, 0.5)!
                        
                        formData .appendPart(withFileData: imageData, name: "photo", fileName: "image.jpg", mimeType: "image/jpeg")
                    }
                    
                }, progress: { (uploadProgress) in
                    
                }, success: { (task, responseObject) in
                    if(showActivityIndicator)
                    {
//                        utility.hideActivitiyIndicator()
                    }
                    if ((responseObject) != nil) {
                        
                        NSLog(responseObject as! String)
                        
                        let jsonString : String = String.init(data: responseObject as! Data, encoding: String.Encoding.utf8)!
                        let data : Data = jsonString .data(using: String.Encoding.utf8)!
                        var json = "" as Any
                        do {
                            json =  try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue: 0))
                        }
                        catch _ {
                            // Error handling
                        }
                        
                        
                        CompletionBlock(json,true);
                    }
                    else
                    {
                        CompletionBlock(nil,false);
                    }
                    
                }, failure: { (task, responseObject) in
                    if(showActivityIndicator)
                    {
//                        utility.hideActivitiyIndicator()
                    }
                    CompletionBlock(nil,false);
                    
                })
                
            }
            else
            {
                manager .post(strRequestUrl, parameters: Parameters, progress: { (uploadProgress) in
                    
                }, success: { (task, responseObject) in
                    if(showActivityIndicator) {
                        
//                        utility.hideActivitiyIndicator()
                    }
                    if ((responseObject) != nil) {
                        
                        NSLog(responseObject as! String)
                        
                        let jsonString : String = String.init(data: responseObject as! Data, encoding: String.Encoding.utf8)!
                        let data : Data = jsonString .data(using: String.Encoding.utf8)!
                        var json = "" as Any
                        do {
                            json =  try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue: 0))
                        }
                        catch _ {
                            // Error handling
                        }
                        
                        
                        CompletionBlock(json,true);
                    }
                    else
                    {
                        CompletionBlock(nil,false);
                    }
                    
                }, failure: { (task, error) in
                    if(showActivityIndicator)
                    {
//                        utility.hideActivitiyIndicator()
                    }
                    CompletionBlock(nil,false);
                    
                })
            }
        }
        else
        {
//            utility.hideActivitiyIndicator()
            Utilities.showToastMSG(MSG: "You do not seem to have a strong Internet connection. Kindly move to a WiFi or stronger cellular signal.")
            CompletionBlock(nil,false);
        }
        
    }
 
}

