//
//  Room.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 18/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import Foundation.NSObject

/**
  The Room model
*/
public class Room: NSObject {
    
    let identifier: Int!
    let title: String!
    let roomDescription: String?
    let capacity: Int?
    let beacon: Beacon!
    lazy var persons: [Person] = [Person]()
    
    init(jsonRoom: JSON) {
        
        self.identifier = jsonRoom["ID"].string!.toInt()!
        self.title  = jsonRoom["TITLE"].string
        self.roomDescription = jsonRoom["DESCRIPTION"].string
        self.capacity = jsonRoom["CAPACITY"].string?.toInt()

        self.beacon = Beacon(name: self.title, uuid: NSUUID(UUIDString: jsonRoom["IBEACON_UUID"].string!)!,
                                        major: jsonRoom["IBEACON_MAJOR"].uInt16Value,
                                        minor: jsonRoom["IBEACON_MINOR"].uInt16Value)
        
        super.init()

        Facade.sharedInstance().startMonitoringBeacon(self.beacon)
        
        for person in jsonRoom["PERSONS"].arrayValue {
            self.persons.append(Person(jsonPerson: person))
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.identifier = aDecoder.decodeIntegerForKey("roomIdentifier")
        self.title = aDecoder.decodeObjectForKey("roomTitle") as? String
        self.roomDescription = aDecoder.decodeObjectForKey("roomDescription") as? String
        self.capacity = aDecoder.decodeIntegerForKey("roomCapacity")
        self.beacon = aDecoder.decodeObjectForKey("beacon") as Beacon
        
        super.init()

        self.persons = aDecoder.decodeObjectForKey("personsInsideRoom") as [Person]
    }
}

extension Room: NSCoding {
    
    public func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeInteger(self.identifier, forKey: "roomIdentifier")
        aCoder.encodeObject(self.title, forKey: "roomTitle")
        aCoder.encodeObject(self.persons, forKey: "personsInsideRoom")
        aCoder.encodeObject(self.beacon, forKey: "beacon")

        if let roomDescription = self.roomDescription? {
            aCoder.encodeObject(roomDescription, forKey: "roomDescription")
        }
        
        if let capacity = self.capacity? {
            aCoder.encodeInteger(capacity, forKey: "roomCapacity")
        }

    }
}

extension Room: Printable {
    override public var description: String {
        return "title = \(self.title), description = \(self.roomDescription?), capacity = \(self.capacity?), persons inside = \(self.persons)"
    }
}
