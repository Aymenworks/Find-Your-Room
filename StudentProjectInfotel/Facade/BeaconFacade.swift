//
//  BeaconFacade.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 22/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

/**
*  The Beacon facade pattern. So we can use more easly the
*  complex submodules that are Location, Network, Data persistency.
*/
public class BeaconFacade {
    
    private var beaconLocationManager: LocationManager? = LocationManager()
    
    // I set them lazy to avoid the instance of these big class that are not used at the beggining of the app.
    lazy private var authenticationManager = AuthenticationManager()
    lazy private var persistencyManager = PersistencyManager()

    /// A singleton object as the entry point to manage the beacons
    public class var sharedInstance: BeaconFacade {
        struct Singleton {
            static let instance = BeaconFacade()
        }
        return Singleton.instance
    }
    
    // MARK: - Lifecycle -
    
    private init() {}
    
    // MARK: - Persistency -
    
    // MARK: Beacons Persistency
    
    public func beacons() -> [Beacon] {
        return self.persistencyManager.beacons
    }
    
    public func addBeacon(beacon: Beacon) {
        self.persistencyManager.addBeacon(beacon)
    }
    
    // MARK: User Persistency
    
    public func saveUserProfil() {
        self.persistencyManager.saveUserProfilOnSession()
    }
    
    // MARK: - Beacon Location -
    
    public func startMonitoringBeacon(beacon: Beacon) {
        
        if beaconLocationManager != nil {
            beaconLocationManager!.startMonitoringBeacon(beacon)
            println("startMonitoringBeacon")

        } else {
            println("beaconLocationManager is nil")
        }
    }
    
    // MARK: - Networks -

    
    // MARK: Authentication
    
    public func authenticateUserWithEmail(email: String, password: String, completionHandler: (JSON?, NSError?) -> Void) {
        self.authenticationManager.authenticateUserWithEmail(email, password: password, completionHandler: completionHandler)
    }
    
    public func signUpUserWithPassword(email: String, password: String, lastName: String, firstName: String, completionHandler: (JSON?, NSError?) -> Void) {
        self.authenticationManager.signUpUserWithPassword(email, password: password, lastName: lastName, firstName: firstName, completionHandler: completionHandler)
    }
    
    // MARK: Facebook & Google Plus Sign In/Up

    public func authenticateUserWithFacebookOrGooglePlus(email: String, lastName: String, firstName: String, completionHandler: (JSON?, NSError?) -> Void) {
        self.authenticationManager.authenticateUserWithFacebookOrGooglePlus(email, lastName: lastName, firstName: firstName, completionHandler: completionHandler)
    }
        
    public func facebookProfilePicture(userId: String, completionHandler: (UIImage?) -> Void) {
        self.authenticationManager.facebookProfilePicture(userId, completionHandler)
    }
    
    public func googlePlusProfile(userId: String, completionHandler: (firstName: String?, lastName: String?, profilPicture: UIImage?, error: NSError?) -> Void) {
       self.authenticationManager.googlePlusProfile(userId, completionHandler: completionHandler)
    }
    
    // MARK: Download/Upload Server Image
    
    public func serverProfilPictureWithURL(urlImage: String, completionHandler: UIImage? -> Void) {
        self.authenticationManager.serverProfilPictureWithURL(urlImage, completionHandler: completionHandler)
    }
    
    public func uploadUserProfilPicture(image: UIImage, withEmail email: String, completionHandler: () -> Void) {
        self.authenticationManager.uploadUserProfilPicture(image, withEmail: email, completionHandler: completionHandler)
    }
}