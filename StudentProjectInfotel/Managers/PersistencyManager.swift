//
//  BeaconPersistencyManager.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 21/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//


/**
*  Memento pattern. It'll save/load the data.
*/
class PersistencyManager {
    
    /// The list of beacons we will use. See `Beacon`.
    lazy var beacons = [Beacon]()
    
    // MARK: - Beacon persistency -

    func addBeacon(beacon: Beacon) {
        self.beacons += [beacon]
    }
    
    // MARK: - User Persistency -
    
    /**
    Save the current user profil on session
    */
    func saveUserProfilOnSession() {
        NSUserDefaults.standardUserDefaults().setObject(User.sharedInstance.lastName, forKey: "lastName")
        NSUserDefaults.standardUserDefaults().setObject(User.sharedInstance.firstName, forKey: "firstName")
        NSUserDefaults.standardUserDefaults().setObject(User.sharedInstance.email, forKey: "email")
        
        if let image = User.sharedInstance.profilPicture {
            NSUserDefaults.standardUserDefaults().setObject(UIImageJPEGRepresentation(image, 80.0), forKey: "profilPicture")
        }
    }
    
    /**
    Delete the current user profil from session
    */
    func deleteUserProfilFromSession() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("lastName")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("firstName")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("email")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("profilPicture")
    }

    

}


