//
//  BeaconPersistencyManager.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 21/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//


let session = NSUserDefaults.standardUserDefaults()

/**
  Memento pattern. It'll save/load the data.
*/
class PersistencyManager {
    
    /// The list of beacons we will use. See `Beacon`.
    lazy var beacons = [Beacon]()
    
    /// The list of the school rooms.
    lazy var rooms = [Room]()
    
    // MARK: - Beacon persistency -

    func addBeacon(beacon: Beacon) {
        self.beacons += [beacon]
    }
    
    // MARK: - Room persistency -
    
    func addRoom(room: Room) {
        self.rooms += [room]
    }
    
    // MARK: - User Persistency -
    
    /**
    Save the current user profil on session
    */
    func saveMemberProfilOnSession() {
        session.setObject(Member.sharedInstance().lastName, forKey: "lastName")
        session.setObject(Member.sharedInstance().firstName, forKey: "firstName")
        session.setObject(Member.sharedInstance().email, forKey: "email")
        session.setObject(Member.sharedInstance().formation, forKey: "formation")

        if let image = Member.sharedInstance().profilPicture {
            session.setObject(UIImageJPEGRepresentation(image, 80.0), forKey: "profilPicture")
        }
    }
    
    /**
    Delete the current user profil from session
    */
    func deleteUserProfilFromSession() {
        session.removeObjectForKey("lastName")
        session.removeObjectForKey("firstName")
        session.removeObjectForKey("email")
        session.removeObjectForKey("formation")
        session.removeObjectForKey("profilPicture")

    }
    
    func isUserLoggedIn() -> Bool {
        return (session.objectForKey("lastName") != nil)

    }

    

}


