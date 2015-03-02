//
//  BeaconFacade.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 22/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

/**
  The Beacon facade pattern. So we can use more easly the
  complex submodules that are Location, Network, Data persistency.
*/
public class BeaconFacade {
    
    /// To manage the user, beacon, and rooms location
    private var locationManager: LocationManager? = LocationManager()
    
    // I set them lazy to avoid the instance of these big class that are not used at the beggining of the app.
    lazy private var authenticationManager = AuthenticationManager()
    lazy private var persistencyManager = PersistencyManager()

    /// A singleton object as the entry point to manage the beacons
    public class func sharedInstance() -> BeaconFacade {
        struct Singleton {
            static let instance = BeaconFacade()
        }
        return Singleton.instance
    }
    
    // MARK: - Lifecycle -
    
    private init() {}

    // MARK: - Networks -
    
    // MARK: Authentication
    
    /**
    Will authenticate the user with email/password combinaison.
    
    :param: email    The encoded base64 user email.
    :param: password The hashed (MD5) user password.
    
    There, base 64 is used to encode non-http compatible characters that may be in the email or password
    */
    public func authenticateUserWithEmail(email: String, password: String, completionHandler: (JSON?, NSError?) -> Void) {
        self.authenticationManager.authenticateUserWithEmail(email, password: password, completionHandler: completionHandler)
    }
    
    /**
    Will register the user on the database
    
    :param: email             The email user
    :param: password          The password user
    :param: lastName          The user last name
    :param: firstName         The user first name
    :param: completionHandler The callback containing the json server/error response that'll be executed after the request has finished
    */
    public func signUpUserWithPassword(email: String, password: String, lastName: String, firstName: String, completionHandler: (JSON?, NSError?) -> Void) {
        self.authenticationManager.signUpUserWithPassword(email, password: password, lastName: lastName, firstName: firstName, completionHandler: completionHandler)
    }
    
    // MARK: Facebook & Google Plus Sign In/Up

    /**
    Will authenticate the user with email/password combinaison using Facebook or Google Plus fetched data.
    If the user is not on the database, he'll be automatically registered
    
    :param: email             The encoded base64 user email.
    :param: lastName          The encoded base64 user last name.
    :param: firstName         The encoded base64 user first name.
    :param: completionHandler The callback that'll be executed after the request has finished.
    */
    public func authenticateUserWithFacebookOrGooglePlus(email: String, lastName: String, firstName: String, completionHandler: (JSON?, NSError?) -> Void) {
        self.authenticationManager.authenticateUserWithFacebookOrGooglePlus(email, lastName: lastName, firstName: firstName, completionHandler: completionHandler)
    }
    
    /**
    Will fetch the facebook user profile picture thanks to its facebook user id
    
    :param: userId            The facebook user id
    :param: completionHandler The callback that'll be executed after the request has finished.
    */
    public func facebookProfilePicture(userId: String, completionHandler: (UIImage?) -> Void) {
        self.authenticationManager.facebookProfilePicture(userId, completionHandler)
    }
    
    /**
    Will fetch the google user profile thanks to its google user id
    
    :param: userId            The google user id
    :param: completionHandler The callback containing the user first name, last name, profile picture, that'll be executed after the request has finished.
    */
    public func googlePlusProfile(userId: String, completionHandler: (firstName: String?, lastName: String?, profilPicture: UIImage?, error: NSError?) -> Void) {
       self.authenticationManager.googlePlusProfile(userId, completionHandler: completionHandler)
    }
    
    // MARK: Download/Upload Server Image
    
    /**
    Will fetch the user profile picture from the server.
    
    :param: urlImage          The url of the user hashed directory on the server
    :param: completionHandler The callback containing the user profile picture that'll be executed after the request has finished
    */
    public func serverProfilPictureWithURL(urlImage: String, completionHandler: UIImage? -> Void) {
        self.authenticationManager.serverProfilPictureWithURL(urlImage, completionHandler: completionHandler)
    }
    
    /**
    Upload the user profil picture picture on its md5 hashed email directory on the server
    From http://stackoverflow.com/questions/26121827/uploading-file-with-parameters-using-alamofire
    
    :param: image             The user profil picture
    :param: email             The user email address. We use it to move the user profil picture picture on its md5 hashed email directory on the server
    :param: completionHandler The callback that'll be executed after the request has finished
    */
    public func uploadUserProfilPicture(image: UIImage, withEmail email: String, completionHandler: () -> Void) {
        self.authenticationManager.uploadUserProfilPicture(image, withEmail: email, completionHandler: completionHandler)
    }
    
    // MARK: - Persistency -
    
    // MARK: Beacons Persistency
    
    public func beacons() -> [Beacon] {
        return self.persistencyManager.beacons
    }
    
    public func addBeacon(beacon: Beacon) {
        self.persistencyManager.addBeacon(beacon)
    }
    
    // MARK: Rooms Persistency
    
    public func rooms() -> [Room] {
        return self.persistencyManager.rooms
    }
    
    public func addRoom(room: Room) {
        self.persistencyManager.addRoom(room)
    }
    
    // MARK: User Persistency
    
    /**
    Save the current user profil on session
    */
    public func saveMemberProfil() {
        self.persistencyManager.saveMemberProfilOnSession()
    }
    
    /**
    Check if the user is logged in
    
    :returns: true if he's logged, false if not
    */
    public func isUserLoggedIn() -> Bool {
        return self.persistencyManager.isUserLoggedIn()
    }
    
    // MARK: - Beacon Location -
    
    public func startMonitoringBeacon(beacon: Beacon) {
        
        if locationManager != nil {
            locationManager!.startMonitoringBeacon(beacon)
            println("startMonitoringBeacon")
            
        } else {
            println("beaconLocationManager is nil")
        }
    }
}