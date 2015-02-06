//
//  AuthenticationViewController.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 05/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import Foundation

private let kClientId = "630039187091-4unm8bftk7etj24a4budbhb6d8okr2ad.apps.googleusercontent.com"

class AuthenticationViewController: UIViewController {
    
    @IBOutlet private var facebookLoginView: FBLoginView!
    @IBOutlet private var googlePlusLoginButton: GPPSignInButton!
    var signIn: GPPSignIn = GPPSignIn.sharedInstance()

    override func viewDidLoad() {
      
        super.viewDidLoad()
        self.navigationController!.navigationBarHidden = false
        signIn.clientID = kClientId
        signIn.scopes = [kGTLAuthScopePlusLogin]
        signIn.delegate = self
        signIn.shouldFetchGoogleUserEmail = true
        signIn.shouldFetchGoogleUserID = true
        
        FBLoginView.self
        self.facebookLoginView.readPermissions = ["public_profile", "email"]
    }

    
    // MARK: - User Interaction
    
    @IBAction func signIn(sender: AnyObject) {
        SwiftSpinner.show("Connection..", animated: true)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((4 * NSEC_PER_SEC))), dispatch_get_main_queue()) {
            SwiftSpinner.show("Success", animated: false)
        };
    }
}

// MARK: - Facebook Login Delegate

extension AuthenticationViewController: FBLoginViewDelegate {
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        
        let email = user.objectForKey("email") as String
        println("nom = \(user.last_name), prenom = \(user.first_name), email = \(email)")
    
    }
    
}

// MARK: - Google Plus Login Delegate

extension AuthenticationViewController: GPPSignInDelegate {
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        
        println("signIn = \(signIn.authentication.userData) et mail = \(signIn.authentication.userEmail) et user id = \(signIn.authentication.userID)")
        AuthenticationManager.getGooglePlusUserName()
    }
    
}
