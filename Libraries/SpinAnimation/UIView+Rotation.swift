//
//  UIView+Rotation.swift
//  SpinningImageView-Example
//
//  Created by Ben Bahrenburg on 7/25/15.
//  Copyright © 2015 Bencoding. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    //Start Rotating view
    func startRotating(duration: Double = 1)
    {
//        let kAnimationKey = "rotation"
//
//        if self.layer.animation(forKey: kAnimationKey) == nil {
//            let animate = CABasicAnimation(keyPath: "transform.rotation")
//            animate.duration = duration
//            animate.repeatCount = Float.infinity
//
//            animate.fromValue = 0.0
//            animate.toValue = Float(Double.pi * 2.0)
//            self.layer.add(animate, forKey: kAnimationKey)
//        }
        
        let animation: CABasicAnimation? = self.spinAnimation(withDuration: 1.2, clockwise: true, repeat: true)
        if let anAnimation = animation
        {
            self.layer.add(anAnimation, forKey: "rotationAnimation")
        }
    }
    func spinAnimation(withDuration duration: CGFloat, clockwise: Bool, repeat repeats: Bool) -> CABasicAnimation
    {
    
        
        var rotation: CABasicAnimation?
        rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation?.fromValue = 0
        rotation?.toValue = 2 * Double.pi
        rotation?.duration = CFTimeInterval(duration)
        
        rotation?.repeatCount = Float.infinity
        rotation?.isRemovedOnCompletion = false
        self.layer.removeAllAnimations()
        self.layer.add(rotation!, forKey: "Spin")
        
        //        var transform : CATransform3D?
        //        transform = CATransform3DIdentity
        //        transform?.m34 = 1.0 / 500.0
        //        imageView.layer.transform = transform!
        
        return CABasicAnimation()
    }
    //Stop rotating view
    func stopRotating()
    {
        let kAnimationKey = "rotationAnimation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil
        {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
    
}
