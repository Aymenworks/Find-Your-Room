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
class PersistencyManager: NSCoding {
    
    /// The list of beacons we will use. See `Beacon`.
    lazy var beacons = [Beacon]()
    
    /// The list of the school rooms.
    lazy var rooms = [Room]()
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.rooms, forKey: "rooms")
    }
    
    init() {
        let fileManager = NSFileManager.defaultManager()
        let documentDirectory = fileManager.URLForDirectory(.DocumentDirectory, inDomain:.UserDomainMask
            , appropriateForURL: nil, create: false, error: nil)
        let saveFileUrl = documentDirectory!.URLByAppendingPathComponent("rooms.bin")
        
        if let roomsData = NSData(contentsOfURL: saveFileUrl, options:.DataReadingMappedIfSafe, error: nil) {
            if let unarchivedRooms = NSKeyedUnarchiver.unarchiveObjectWithData(roomsData) as? [Room] {
                self.rooms = unarchivedRooms
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        self.rooms = aDecoder.decodeObjectForKey("rooms") as [Room]
    }
    
    // MARK: - Beacon persistency -

    func addBeacon(beacon: Beacon) {
        self.beacons += [beacon]
    }
    
    // MARK: - Room persistency -
    
    func addRoom(room: Room) {
        self.rooms += [room]
    }
    
    func saveRooms() {
        let fileManager = NSFileManager.defaultManager()
        let documentDirectory = fileManager.URLForDirectory(.DocumentDirectory, inDomain:.UserDomainMask
            , appropriateForURL: nil, create: false, error: nil)
        let saveFileUrl = documentDirectory!.URLByAppendingPathComponent("rooms.bin")
        let roomsData = NSKeyedArchiver.archivedDataWithRootObject(self.rooms)
        
        if roomsData.writeToURL(saveFileUrl, options:.AtomicWrite, error: nil) {
            println("rooms save succed")
        }
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
        session.setObject(Member.sharedInstance().schoolId, forKey: "schoolId")
        session.setObject(Member.sharedInstance().schoolName, forKey: "schoolName")
        
        if let image = Member.sharedInstance().profilPicture {
            session.setObject(UIImageJPEGRepresentation(image, 80.0), forKey: "profilPicture")
        }
        
        session.synchronize()
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
        session.removeObjectForKey("schoolId")
        session.removeObjectForKey("schoolName")
    }
    
    // MARK: - Rooms Persistency -

}


