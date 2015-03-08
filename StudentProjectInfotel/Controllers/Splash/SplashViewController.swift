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
        
        doInMainQueueAfter(seconds: 0.6) {
            self.beaconImage.shake()
        }
    
        doInMainQueueAfter(seconds: 2) {
            
            if Facade.sharedInstance().isUserLoggedIn() {
                self.showUserLoggedInView()
                
            } else {
                self.performSegueWithIdentifier("goToWalkthroughViewFromSplashView", sender: self)
            }
        }
    }
    
    // MARK: - User Interface -
    
    func showUserLoggedInView() {
        self.beaconImage.hidden = true
        self.universityImage.hidden = true
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
        self.userProfilPicture.image = Member.sharedInstance().profilPicture
        self.userProfilPicture.hidden = false
        self.userName.text = Member.sharedInstance().fullName()
        self.userName.hidden = false
        
        doInMainQueueAfter(seconds: 2) {
            self.activityIndicator.stopAnimating()
            self.performSegueWithIdentifier("goToRoomsListViewFromSplashView", sender: self)
        }

    }
    
    

}
