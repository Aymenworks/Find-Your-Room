//
//  AppDelegate.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 17/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Init the location manager ( also ask location permission )
        Facade.sharedInstance
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-Medium", size: 18)! ]
        println("did finish launching with options = \(launchOptions)")
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
            return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
                ||  GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        println("resign active")

    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        println("did enter background")

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        println("did enter foreground")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        println("become active")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
}

//  #############################################  To use everywhere #############################################

func doInMainQueueAfter(#seconds: Float, completionHandler: () -> Void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((seconds * Float(NSEC_PER_SEC)))), dispatch_get_main_queue()) {
        completionHandler()
    }
}
