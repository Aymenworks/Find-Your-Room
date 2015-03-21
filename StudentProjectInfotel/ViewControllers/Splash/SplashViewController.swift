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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBarHidden = true
        self.estimoteImage.shake(direction: 2.3, shakes: -20, duration: 2.8)
        self.estimoteReverseImage.shake(direction: 2.3, shakes: -20, duration: 2.8)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        doInMainQueueAfter(seconds: 0.6) {
            self.beaconImage.shake()
        }
    
        doInMainQueueAfter(seconds: 2.5) {
            
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
        
        Facade.sharedInstance().fetchUserProfile(Member.sharedInstance().email!.encodeBase64(), completionHandler: { (jsonProfil, error) -> Void in
            
            if error == nil && jsonProfil != nil && jsonProfil!.isOk() {
                let userProfil = jsonProfil!["response"]["profil"]
                Member.sharedInstance().fillMemberProfilWithJSON(userProfil)

                let pictureUrl = "http://www.aymenworks.fr/assets/beacon/\(Member.sharedInstance().email!.md5())/picture.jpg"
                println("picture url = \(pictureUrl)")
                Facade.sharedInstance().serverProfilPictureWithURL(pictureUrl) { (image) -> Void in
                    
                    Member.sharedInstance().profilPicture = image
                    Facade.sharedInstance().saveMemberProfil()

                    Facade.sharedInstance().roomsBySchoolId(Member.sharedInstance().schoolId!.encodeBase64(),
                        completionHandler: { (jsonSchoolRooms, error) -> Void in
                            
                        println("json response = \(jsonSchoolRooms)")
                            
                        if error == nil && jsonSchoolRooms != nil && jsonSchoolRooms!.isOk() {
                            let schoolRooms = jsonSchoolRooms!["response"]["rooms"]
                            let beaconsSchool = jsonSchoolRooms!["response"]["beacons"]

                            Facade.sharedInstance().addRoomsFromJSON(schoolRooms)
                            Facade.sharedInstance().fetchPersonsProfilPictureInsideRoom()
                            self.activityIndicator.stopAnimating()
                        }
                            
                        self.performSegueWithIdentifier("goToRoomsListViewFromSplashView", sender: self)
                    })
                }
            } else {
                JSSAlertView().warning(self, title: NSLocalizedString("oops", comment: ""),
                    text: NSLocalizedString("genericError", comment: ""))
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((2 * NSEC_PER_SEC))), dispatch_get_main_queue()) {
                    self.toggleView()
                }
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToRoomsListViewFromSplashView" {
            self.toggleView()
        }
    }
}
    
    


