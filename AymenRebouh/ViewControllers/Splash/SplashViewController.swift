//
//  SplashViewController.swift
//  AymenRebouh
//
//  Created by Rebouh Aymen on 21/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import UIKit

/**
*  <#Description#>
*/
final class SplashViewController: UIViewController {
  
  @IBOutlet private weak var estimoteImage: UIImageView!
  @IBOutlet private weak var estimoteReverseImage: UIImageView!
  @IBOutlet private weak var universityImage: UIImageView!
  @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet private weak var beaconImage: UIImageView!
  @IBOutlet private weak var userName: UILabel!
  @IBOutlet private weak var userProfilPicture: UIImageView!
  
  // MARK: - Lifecycle -
  
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
    doInMainQueueAfter(seconds: 0.6) { self.beaconImage.shake() }
    doInMainQueueAfter(seconds: 2.0) {
      
      if Facade.sharedInstance.isUserLoggedIn() {
        self.showUserLoggedInView()
        
      } else {
        self.performSegueWithIdentifier("goToWalkthroughViewFromSplashView", sender: self)
      }
    }
  }
  
  // MARK: - User Interface -
  
  private func toggleView() {
    self.beaconImage.hidden = !self.beaconImage.hidden
    self.universityImage.hidden = !self.universityImage.hidden
    self.activityIndicator.hidden = !self.activityIndicator.hidden
    self.activityIndicator.isAnimating() ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
    self.userProfilPicture.image = Member.sharedInstance.profilPicture
    self.userProfilPicture.hidden = !self.userProfilPicture.hidden
    self.userName.text = Member.sharedInstance.fullName()
    self.userName.hidden = !self.userName.hidden
  }
  
  private func showUserLoggedInView() {
    
    self.toggleView()
    
    Facade.sharedInstance.fetchUserProfile(Member.sharedInstance.email!.encodeBase64()) { jsonProfil, error -> Void in
      
      if error == nil, let jsonProfil = jsonProfil where jsonProfil.isOk() {
        
        let userProfil = jsonProfil["response"]["profil"]
        let pictureUrl = "http://www.aymenworks.fr/assets/beacon/\(Member.sharedInstance.email!.md5())/picture.jpg"
        
        Member.sharedInstance.fillMemberProfilWithJSON(userProfil)
        Facade.sharedInstance.serverProfilPictureWithURL(pictureUrl) { image  in
          
          Member.sharedInstance.profilPicture = image
          Facade.sharedInstance.saveMemberProfil()
          
          Facade.sharedInstance.roomsBySchoolId(Member.sharedInstance.schoolId!.encodeBase64()) { jsonSchoolRooms, error  in
              
              if error == nil, let jsonSchoolRooms = jsonSchoolRooms where jsonSchoolRooms.isOk() {
                let schoolRooms = jsonSchoolRooms["response"]["rooms"]
                let beaconsSchool = jsonSchoolRooms["response"]["beacons"]
                Facade.sharedInstance.addRoomsFromJSON(schoolRooms)
                Facade.sharedInstance.fetchPersonsProfilPictureInsideRoom()
              }
              
              self.performSegueWithIdentifier("goToRoomsListViewFromSplashView", sender: self)
          }
        }
        
      } else {
        
        JSSAlertView().danger(self, title: NSLocalizedString("oops", comment: ""),
          text: NSLocalizedString("genericError", comment: ""))
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((2 * NSEC_PER_SEC))), dispatch_get_main_queue()) {
          self.toggleView()
        }
      }
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "goToRoomsListViewFromSplashView" {
      self.toggleView()
    }
  }
}




