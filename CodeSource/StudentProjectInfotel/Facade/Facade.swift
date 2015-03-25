//
//  BeaconFacade.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 22/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

/**
  The Facade pattern. So we can use more easily the complex submodules 
  that are Location, Network, Data persistency with a sample and reusable API.
*/
public class Facade {
    
    /// The location manager that'll manage the user, beacon, and rooms location ( geolocalisation )
    private var locationManager: LocationManager? = LocationManager()
    
    /// Manager 
    lazy private var networkManager = NetworkManager()
    
    /// To manage persistency ( session, plist, file.. )
    lazy private var persistencyManager = PersistencyManager()

    /// A singleton object as the entry point to manage the application
    public class func sharedInstance() -> Facade {
        struct Singleton {
            static let instance = Facade()
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
    
    Base 64 is used for the email input to encode non-http compatible characters.
    */
    public func authenticateUserWithEmail(email: String, password: String, completionHandler: (JSON?, NSError?) -> Void) {
        self.networkManager.authenticateUserWithEmail(email, password: password, completionHandler: completionHandler)
    }
    
    /**
    Will authenticate the user with email/password combinaison using Facebook or Google Plus fetched data ( user profil ).
    If the user is not on the database, he'll be automatically registered
    
    :param: email             The encoded base64 user email.
    :param: lastName          The encoded base64 user last name.
    :param: firstName         The encoded base64 user first name.
    :param: completionHandler The callback that'll be executed after the request has finished.
    */
    public func authenticateUserWithFacebookOrGooglePlus(email: String, lastName: String, firstName: String,
        completionHandler: (JSON?, NSError?) -> Void) {
            self.networkManager.authenticateUserWithFacebookOrGooglePlus(email, lastName: lastName, firstName: firstName, completionHandler: completionHandler)
    }
    
    // MARK: Rooms
    
    /**
    Get all rooms by a school and also the students present in the rooms
    
    :param: schoolId          The school ID
    :param: completionHandler The callback containing the json server/error response that'll be executed
                                after the request has finished
    */
    func roomsBySchoolId(schoolId: String, completionHandler: (JSON?, NSError?) -> Void) {
        self.networkManager.roomsBySchoolId(schoolId, completionHandler: completionHandler)
    }
    
    /**
    Will download all the user profile pictures containted on our array of room ( that contains array of students )
    */
    func fetchPersonsProfilPictureInsideRoom() {
        self.networkManager.fetchPersonsProfilPictureInsideRoom()
    }
    
    /**
    Add a room in the database with the beacon.
    
    :param: schoolId          The school ID
    :param: roomTitle         The title of the room ( ex : Hall II - Computer Science Room )
    :param: roomDescription   The description of the room ( ex : in front of .. )
    :param: roomCapacity      The room capacity ( max number of persons inside )
    :param: beaconUUID        The beacon UUID identifier
    :param: beaconMajor       The beacon major value
    :param: beaconMinor       The beacon minor value
    :param: completionHandler The callback containing the json server/error response that'll be executed
                                after the request has finished
    */
    func addRoom(schoolId: String, roomTitle: String, roomDescription: String,
        roomCapacity: Int, beaconUUID: String, beaconMajor: Int, beaconMinor: Int, completionHandler: (JSON?, NSError?) -> Void) {
            self.networkManager.addRoom(schoolId, roomTitle: roomTitle, roomDescription: roomDescription,
                roomCapacity: roomCapacity, beaconUUID: beaconUUID, beaconMajor: beaconMajor, beaconMinor: beaconMinor, completionHandler)
    }
    
    /**
    <#Description#>
    
    :param: roomId            <#roomId description#>
    :param: userEmail         <#userEmail description#>
    :param: completionHandler <#completionHandler description#>
    */
    func addMyPresenceToRoom(roomId: Int, userEmail: String, completionHandler: (JSON?, NSError?) -> Void) {
        self.networkManager.addMyPresenceInRoom(roomId, userEmail: userEmail, completionHandler: completionHandler)
    }
    
    /**
    <#Description#>
    
    :param: userEmail         <#userEmail description#>
    :param: completionHandler <#completionHandler description#>
    */
    func deleteMyPresenceFromRoom(userEmail: String, completionHandler: (JSON?, NSError?) -> Void) {
        self.networkManager.deleteMyPresenceFromRoom(userEmail, completionHandler: completionHandler)
    }
    
    // MARK: Sigining Up

    /**
    Will register the user on the database.
    
    :param: email             The email user
    :param: password          The password user
    :param: lastName          The user last name
    :param: firstName         The user first name
    :param: completionHandler The callback containing the json server/error response that'll be executed 
                                after the request has finished
    */
    public func signUpUserWithPassword(email: String, password: String, lastName: String,
                                       firstName: String, formation:String, schoolId: String,
                                       completionHandler: (JSON?, NSError?) -> Void) {
                                        
        self.networkManager.signUpUserWithPassword(email, password: password, lastName: lastName, firstName: firstName,
            formation:formation, schoolId: schoolId, completionHandler: completionHandler)
    }
    
    // MARK: User
    
    /**
    Will update the user profil on the database and then in session.
    
    :param: email             The new user email
    :param: password          The new user password
    :param: lastName          The new user last name
    :param: firstName         The new user first name
    :param: completionHandler The callback containing the json server/error response that'll be executed
    after the request has finished
    */
    public func updateUserAccount(email: String, password: String, lastName: String,
        firstName: String, formation:String, schoolId: String,
        completionHandler: (JSON?, NSError?) -> Void) {
            
            self.networkManager.updateUserAccount(email, password: password, lastName: lastName, firstName: firstName,
                formation:formation, schoolId: schoolId, completionHandler: completionHandler)
    }
    
    /**
    Will fetch the user profile ( name, school, formation, .. )
    
    :param: email             The user email
    :param: completionHandler The callback containing the json server/error response that'll be executed
    after the request has finished
    */
    func fetchUserProfile(email: String, completionHandler: (JSON?, NSError?) -> Void) {
        self.networkManager.fetchUserProfile(email, completionHandler: completionHandler)
    }
    
    /**
    Will fetch the facebook user profile picture thanks to its facebook user id
    
    :param: userId            The facebook user id
    :param: completionHandler The callback that'll be executed after the request has finished.
    */
    public func facebookProfilePicture(userId: String, completionHandler: (UIImage?) -> Void) {
        self.networkManager.facebookProfilePicture(userId, completionHandler)
    }
    
    /**
    Will fetch the google user profile thanks to its google user id
    
    :param: userId            The google user id
    :param: completionHandler The callback containing the user first name, last name,
    profile picture, that'll be executed after the request has finished.
    */
    public func googlePlusProfile(userId: String, completionHandler: (firstName: String?, lastName: String?,
        profilPicture: UIImage?, error: NSError?) -> Void) {
            self.networkManager.googlePlusProfile(userId, completionHandler: completionHandler)
    }
    
    /**
    Will fetch the user profile picture from the server.
    
    :param: urlImage          The url of the user hashed directory on the server
    :param: completionHandler The callback containing the user profile picture that'll be
    executed after the request has finished
    */
    public func serverProfilPictureWithURL(urlImage: String, completionHandler: UIImage? -> Void) {
        self.networkManager.serverProfilPictureWithURL(urlImage, completionHandler: completionHandler)
    }
    
    /**
    Upload the user profil picture picture on its md5 hashed email directory on the server
    
    From http://stackoverflow.com/questions/26121827/uploading-file-with-parameters-using-alamofire
    
    :param: image             The user profil picture
    :param: email             The encoded base64 user email address. We use it to move the user profil picture picture
    on its md5 hashed email directory on the server
    :param: completionHandler The callback that'll be executed after the request has finished
    */
    public func uploadUserProfilPicture(image: UIImage, withEmail email: String, completionHandler: () -> Void) {
        self.networkManager.uploadUserProfilPicture(image, withEmail: email, completionHandler: completionHandler)
    }
    
    // MARK: - Persistency -
    
    // MARK: Rooms Persistency
    
    /**
    Return the list of rooms of the current school.
    
    :returns: The list of rooms of the current school
    */
    public func rooms() -> [Room] {
        return self.persistencyManager.rooms
    }
    
    /**
    Add a room on the list of rooms of the current school.
    
    :param: room -
    */
    public func addRoom(room: Room) {
        self.persistencyManager.addRoom(room)
    }
    
    /**
    Save the list of rooms using the Archiving pattern to presevent class encapsuation concept
    and retrieving data from disk with all rooms with theirs properties alredy setted.
    */
    public func saveRooms() {
        self.persistencyManager.saveRooms()
    }
    
    /**
    <#Description#>
    
    :param: schoolRooms <#schoolRooms description#>
    */
    func addRoomsFromJSON(schoolRooms: JSON) {
       self.persistencyManager.addRoomsFromJSON(schoolRooms)
    }

    // MARK: User Persistency
    
    /**
    Save the current user profil on session
    */
    public func saveMemberProfil() {
        self.persistencyManager.saveMemberProfilOnSession()
    }
    
    /**
    Delete the current user profil from session
    */
    func logOut() {
        self.persistencyManager.logOut()
    }
    
    /**
    Check if the user is logged in
    
    :returns: true if he's logged, false if not
    */
    public func isUserLoggedIn() -> Bool {
        println("Member.sharedInstance().email = \(Member.sharedInstance().email)")
        println("Member.sharedInstance().isAdmin = \(Member.sharedInstance().isAdmin)")

        return Member.sharedInstance().email != nil
    }
    
    public func isUserAdmin() -> Bool {
        return Member.sharedInstance().isAdmin!
    }

    
    // MARK: - Beacon Location -
    
    /**
    <#Description#>
    
    :param: beacon <#beacon description#>
    */
    public func startMonitoringBeacon(beacon: Beacon) {
        if locationManager != nil {
            locationManager!.startMonitoringBeacon(beacon)
        }
    }
    
    /**
    <#Description#>
    
    :param: beacon <#beacon description#>
    */
    public func stopMonitoringBeacon(beacon: Beacon) {
        if locationManager != nil {
            locationManager!.stopMonitoringBeacon(beacon)
        }
    }
    
    // MARK: - Plist Persistency -
    
    /**
    <#Description#>
    
    :returns: <#return value description#>
    */
    public func memberMenu() -> [NSDictionary] {
        return self.persistencyManager.memberMenu()
    }

}