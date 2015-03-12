//
//  SplashViewController.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 21/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import UIKit

/**
*  <#Description#>
*/
class SplashViewController: UIViewController {

    @IBOutlet private var estimoteImage: UIImageView!
    @IBOutlet private var estimoteReverseImage: UIImageView!
    @IBOutlet private var universityImage: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var beaconImage: UIImageView!
    @IBOutlet private var userName: UILabel!
    @IBOutlet private var userProfilPicture: UIImageView!
    
    // MARK: - Lifeycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.estimoteImage.shake(direction: 2.3, shakes: -20, duration: 2.8)
        self.estimoteReverseImage.shake(direction: 2.3, shakes: -20, duration: 2.8)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        println("bounds splash = \(self.view.bounds)")
        doInMainQueueAfter(seconds: 0.6) {
            self.beaconImage.shake()
        }
    
        doInMainQueueAfter(seconds: 1.5) {
            
            if Facade.sharedInstance().isUserLoggedIn() {
                self.showUserLoggedInView()
                
            } else {
                self.performSegueWithIdentifier("goToWalkthroughViewFromSplashView", sender: self)
            }
        }
    }
    
    // MARK: - User Interface -
    
    func toggleView() {
        self.beaconImage.hidden = !self.beaconImage.hidden
        self.universityImage.hidden = !self.universityImage.hidden
        self.activityIndicator.hidden = !self.activityIndicator.hidden
        self.activityIndicator.isAnimating() ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
        
        self.userProfilPicture.image = Member.sharedInstance().profilPicture
        self.userProfilPicture.hidden = !self.userProfilPicture.hidden
        self.userName.text = Member.sharedInstance().fullName()
        self.userName.hidden = !self.userName.hidden
    }
    func showUserLoggedInView() {

        self.toggleView()
            
        // TODO: - MANAGE ERRORS

        Facade.sharedInstance().fetchUserProfile(Member.sharedInstance().email!.encodeBase64(), completionHandler: { (jsonProfil, error) -> Void in
            
            if error == nil {
                
                let userProfil = jsonProfil!["response"]["profil"]
                Member.sharedInstance().fillMemberProfilWithJSON(userProfil)

                Facade.sharedInstance().roomsBySchoolId(Member.sharedInstance().schoolId!.encodeBase64(),
                    completionHandler: { (jsonSchoolRooms, error) -> Void in
                        
                        println("json response = \(jsonSchoolRooms)")
                        
                        if error == nil {
                            let schoolRooms = jsonSchoolRooms!["response"]["rooms"]
                            Facade.sharedInstance().addRoomsFromJSON(schoolRooms)
                            Facade.sharedInstance().fetchStudentsInsideRoom()
                            self.activityIndicator.stopAnimating()
                        } else {
                            println("error rooms")
                        }
                        
                        self.performSegueWithIdentifier("goToRoomsListViewFromSplashView", sender: self)
                })
            } else {

                JSSAlertView().warning(self, title: "Oups", text: "Something went wrong. Please try again later.")
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((2 * NSEC_PER_SEC))), dispatch_get_main_queue()) {
                    self.toggleView()
                }

               
            }
        })
       

    }
}
    
    


