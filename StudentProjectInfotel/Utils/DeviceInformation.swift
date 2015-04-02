//
//  DeviceInformation.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 25/03/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

public class DeviceInformation {
    
    public class func isIphone5() -> Bool {
        return UIScreen.mainScreen().bounds.size.height == 568.0
    }
}