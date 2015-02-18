//
//  UIViewExtensions.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 07/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//


extension UIView {
    
    /**
    UIView shake animation
    
    From http://stackoverflow.com/questions/10294451/animating-uitextfield-to-indicate-a-wrong-password
    
    :param: direction Shake orientation
    :param: shakes    The numbers of shakes
    */
    func shake(var direction : Int = 1, var shakes : Int = 0)
    {
        UIView.animateWithDuration(0.05,
            animations: { self.transform =  CGAffineTransformMakeTranslation(CGFloat(8*direction),0) },
            completion: { (value: Bool) in
                
                if shakes >= 10 {
                    self.transform = CGAffineTransformIdentity;
                    return;
                }
                
                shakes++; direction*=(-1);
                
                self.shake(direction: direction, shakes: shakes)
            }
        )
    }
}