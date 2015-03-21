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
    
    /// The list of the school rooms.
    lazy var rooms = [Room]()
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.rooms, forKey: "rooms")
    }
    
    init() {
        let fileManager = NSFileManager.defaultManager()
        let documentDirectory = fileManager.URLForDirectory(.DocumentDirectory, inDomain:.UserDomainMask
            , appropriateForURL: nil, create: false, error: nil)
        let saveRoomFileUrl = documentDirectory!.URLByAppendingPathComponent("rooms.bin")

        if let roomsData = NSData(contentsOfURL: saveRoomFileUrl, options:.DataReadingMappedIfSafe, error: nil) {
            if let unarchivedRooms = NSKeyedUnarchiver.unarchiveObjectWithData(roomsData) as? [Room] {
                self.rooms = unarchivedRooms
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        self.rooms = aDecoder.decodeObjectForKey("rooms") as [Room]
    }

    // MARK: - Room persistency -
    
    /**
    Add a room on the list of rooms of the current school.
    
    :param: room -
    */
    func addRoom(room: Room) {
        self.rooms += [room]
    }
    
    /**
    Save the list of rooms using the Archiving pattern to preserve class encapsuation concept
    and retrieving data from disk with all rooms with theirs properties alredy setted.
    */
    func saveRooms() {
        let fileManager = NSFileManager.defaultManager()
        let documentDirectory = fileManager.URLForDirectory(.DocumentDirectory, inDomain:.UserDomainMask
            , appropriateForURL: nil, create: false, error: nil)
        let saveFileUrl = documentDirectory!.URLByAppendingPathComponent("rooms.bin")
        let roomsData = NSKeyedArchiver.archivedDataWithRootObject(self.rooms)
        
        if roomsData.writeToURL(saveFileUrl, options:.AtomicWrite, error: nil) {
            println("rooms save succed")
        } else {
            println("error saving rooms")
        }
    }
    
    func addRoomsFromJSON(schoolRooms: JSON) {

        for room in self.rooms {
            Facade.sharedInstance().stopMonitoringBeacon(room.beacon)
        }
    
        self.rooms = []
    
        for (_, jsonRoom) in schoolRooms {
            self.addRoom(Room(jsonRoom: jsonRoom))
        }
    
        self.saveRooms()
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
        session.setObject(Member.sharedInstance().schoolId!, forKey: "schoolId")
        session.setObject(Member.sharedInstance().schoolName!, forKey: "schoolName")
        session.setBool(Member.sharedInstance().isAdmin!, forKey: "isAdmin")

        if let image = Member.sharedInstance().profilPicture {
            session.setObject(UIImageJPEGRepresentation(image, 80.0), forKey: "profilPicture")
        }
        
        session.synchronize()
    }
    
    /**
    Delete the current user profil from session
    */
    func logOut() {
        session.removeObjectForKey("lastName")
        session.removeObjectForKey("firstName")
        session.removeObjectForKey("email")
        session.removeObjectForKey("formation")
        session.removeObjectForKey("profilPicture")
        session.removeObjectForKey("schoolId")
        session.removeObjectForKey("schoolName")

        Member.sharedInstance().lastName = nil
        Member.sharedInstance().firstName = nil
        Member.sharedInstance().email = nil
        Member.sharedInstance().formation = nil
        Member.sharedInstance().profilPicture = nil
        Member.sharedInstance().schoolId = nil
        Member.sharedInstance().schoolName = nil
    }
    
    // MARK: - Plist Persistency -

    /**
    *  A singleton to get once the menu ( profil, home ) from the menu plist file.
    */
    struct SingletonPlistMenu {
        static var menuPlist: NSDictionary = {
            let menuPlistPath = NSBundle.mainBundle().pathForResource("Menu", ofType: "plist")
            let menuPlistData = NSFileManager.defaultManager().contentsAtPath(menuPlistPath!)
            let listOfMenus = NSPropertyListSerialization.propertyListWithData(menuPlistData!,
                options:0, format:nil,error: nil) as NSDictionary
            
            return listOfMenus
            }()
    }
    
    /**
    <#Description#>
    
    :returns: <#return value description#>
    */
    func memberMenu() -> [NSDictionary] {
        var dict = SingletonPlistMenu.menuPlist.objectForKey("MemberMenu") as [NSDictionary]
        return dict
    }

}


