//
//  AppDelegate.swift
//  AymenRebouh
//
//  Created by Rebouh Aymen on 17/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  // Not running to inactive state
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    // Init the location manager ( also ask location permission )
    Facade.sharedInstance
    UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-Medium", size: 18)! ]
    return true
  }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
      ||  GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
  }
}

//  #############################################  To use everywhere #############################################

public func doInMainQueueAfter(#seconds: Float, completionHandler: () -> Void) {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((seconds * Float(NSEC_PER_SEC)))), dispatch_get_main_queue()) {
    completionHandler()
  }
}