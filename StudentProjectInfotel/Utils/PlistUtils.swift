//
//  PlistUtils.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 07/03/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

class PlistUtils {
    
    struct SingletonPlistMenu {
        static var menuPlist: NSDictionary = {
            let menuPlistPath = NSBundle.mainBundle().pathForResource("Menu", ofType: "plist")
            let menuPlistData = NSFileManager.defaultManager().contentsAtPath(menuPlistPath!)
            let listOfMenus = NSPropertyListSerialization.propertyListWithData(menuPlistData!, options:0, format:nil,error: nil) as? NSDictionary
            return listOfMenus!
        }()
    }
    
    class func memberMenu() -> [NSDictionary] {
        return SingletonPlistMenu.menuPlist.objectForKey("MemberMenu") as [NSDictionary]
    }
    
    class func homeMenu() -> [NSDictionary] {
        return SingletonPlistMenu.menuPlist.objectForKey("HomeMenu") as [NSDictionary]
    }

}