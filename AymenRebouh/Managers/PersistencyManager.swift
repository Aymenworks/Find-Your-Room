//
//  BeaconPersistencyManager.swift
//  AymenRebouh
//
//  Created by Rebouh Aymen on 21/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import Foundation.NSCoder

/**
  Contains the list of the files names we use/interact with
*/
private struct FilesName {
    static let Room = "rooms.bin"
}

/// No setted private because we use it too on the Member singleton
let session = NSUserDefaults.standardUserDefaults()

/**
Memento pattern. It'll save/load the data.
*/
final class PersistencyManager: NSCoding {
    
    /// The list of the school rooms.
    lazy var rooms = [Room]()
    
    // MARK: - Lifecycle -
    
    init() {
        
        let fileManager = NSFileManager.defaultManager()
        
        let documentDirectory = fileManager.URLForDirectory(.DocumentDirectory, inDomain:.UserDomainMask,
            appropriateForURL: nil, create: false, error: nil)
        
        let saveRoomFileUrl = documentDirectory!.URLByAppendingPathComponent(FilesName.Room)
        
        if let roomsData = NSData(contentsOfURL: saveRoomFileUrl, options:.DataReadingMappedIfSafe, error: nil),
            unarchivedRooms = NSKeyedUnarchiver.unarchiveObjectWithData(roomsData) as? [Room] {
                self.rooms = unarchivedRooms
        }
    }
    
    // MARK: - NSCoding Protocol Conformance -
    
    @objc required init(coder aDecoder: NSCoder) {
        self.rooms = aDecoder.decodeObjectForKey("rooms") as! [Room]
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.rooms, forKey: "rooms")
    }
    
    // MARK: - Room persistency -
    
    /**
    Add a room on the list of rooms of the current school.
    
    :param: room -
    */
    func addRoom(room: Room) {
        self.rooms.append(room)
    }
    
    /**
    Save the list of rooms using the Archiving pattern to preserve class encapsuation concept
    and retrieving data from disk with all rooms with theirs properties alredy setted.
    */
    func saveRooms() {
        
        let fileManager = NSFileManager.defaultManager()
        
        let documentDirectory = fileManager.URLForDirectory(.DocumentDirectory, inDomain:.UserDomainMask,
            appropriateForURL: nil, create: false, error: nil)
        
        let saveFileUrl = documentDirectory!.URLByAppendingPathComponent(FilesName.Room)
        let roomsData = NSKeyedArchiver.archivedDataWithRootObject(self.rooms)
        
        roomsData.writeToURL(saveFileUrl, options:.AtomicWrite, error: nil)
    }
    
    func addRoomsFromJSON(schoolRooms: JSON) {
        
        for room in self.rooms {
            Facade.sharedInstance.stopMonitoringBeacon(room.beacon)
        }
        
        self.rooms = []
        
        for (_, jsonRoom) in schoolRooms {
            self.rooms.append(Room(jsonRoom: jsonRoom))
        }
        
        self.saveRooms()
    }
    
    // MARK: - User Persistency -
    
    /**
    Save the current user profil on session
    */
    func saveMemberProfilOnSession() {
        
        session.setObject(Member.sharedInstance.lastName, forKey: "lastName")
        session.setObject(Member.sharedInstance.firstName, forKey: "firstName")
        session.setObject(Member.sharedInstance.email, forKey: "email")
        session.setObject(Member.sharedInstance.formation, forKey: "formation")
        session.setObject(Member.sharedInstance.schoolId, forKey: "schoolId")
        session.setObject(Member.sharedInstance.schoolName, forKey: "schoolName")
        session.setBool(Member.sharedInstance.isAdmin, forKey: "isAdmin")
        
        if let image = Member.sharedInstance.profilPicture {
            session.setObject(UIImageJPEGRepresentation(image, 80.0), forKey: "profilPicture")
        }
        
        session.synchronize()
    }
    
    func saveJSONMemberProfilOnSession(memberProfil: JSON) {
        
        let firstName = memberProfil["FIRSTNAME"].string!
        let lastName = memberProfil["LASTNAME"].string!
        let email = memberProfil["EMAIL"].string!
        let formation = memberProfil["FORMATION"].string
        let schoolId = memberProfil["SCHOOL_ID"].string!
        let schoolName = memberProfil["SCHOOL_NAME"].string!
        let isAdmin = memberProfil["ADMIN"].string == "1" ? true : false
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
        
        Member.sharedInstance.lastName = ""
        Member.sharedInstance.firstName = ""
        Member.sharedInstance.email = ""
        Member.sharedInstance.formation = nil
        Member.sharedInstance.profilPicture = nil
        Member.sharedInstance.schoolId = ""
        Member.sharedInstance.schoolName = ""
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
                options:0, format:nil,error: nil) as! NSDictionary
            
            return listOfMenus
            }()
    }
    
    /**
    <#Description#>
    
    :returns: <#return value description#>
    */
    func memberMenu() -> [NSDictionary] {
        let dict = SingletonPlistMenu.menuPlist.objectForKey("MemberMenu") as! [NSDictionary]
        return dict
    }
    
}


