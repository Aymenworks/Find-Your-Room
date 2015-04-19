//
//  Beacon.swift
//  AymenRebouh
//
//  Created by Rebouh Aymen on 20/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import CoreLocation

/**
The beacon model.
*/
final public class Beacon: NSObject {
    
    let name: String
    let uuid: NSUUID
    let major: CLBeaconMajorValue
    let minor: CLBeaconMinorValue
    let region: CLBeaconRegion
    
    /// This property stores the last CLBeacon instance seen for the current beacon. This is used to display the proximity information.
    var lastSeenBeacon: CLBeacon?
    
    // MARK: - Lyfecicle -
    
    init(name: String, uuid: NSUUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue) {
        self.name = name
        self.uuid = uuid
        self.major = major
        self.minor = minor
        region = CLBeaconRegion(proximityUUID: self.uuid, major: self.major, minor: self.minor, identifier: self.name)
        region.notifyEntryStateOnDisplay = true
        
        super.init()
    }
    
    // MARK: - NSCoding Protocol Conformance -
    
    
    required public init(coder aDecoder: NSCoder) {
        self.uuid = aDecoder.decodeObjectForKey("uuid") as! NSUUID
        self.major = (aDecoder.decodeObjectForKey("major") as! NSNumber).unsignedShortValue
        self.minor = (aDecoder.decodeObjectForKey("minor") as! NSNumber).unsignedShortValue
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.region = aDecoder.decodeObjectForKey("region") as! CLBeaconRegion
        super.init()
    }
}

// MARK: - NSCoding Protocol Conformance -

extension Beacon: NSCoding {
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.uuid, forKey: "uuid")
        aCoder.encodeObject(NSNumber(unsignedShort: self.major), forKey: "major")
        aCoder.encodeObject(NSNumber(unsignedShort: self.minor), forKey: "minor")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.region, forKey: "region")
    }
}

extension Beacon: Printable {
    override public var description: String {
        return "Beacon \(self.name) major = \(self.major), minor = \(self.minor) ranged \(self.lastSeenBeacon?.proximity.toString())."
    }
}

// MARK: - Overloading Operator -

func == (left: Beacon, right: CLBeacon) -> Bool {
    
    return (left.uuid.isEqual(right.proximityUUID)
        && NSNumber(unsignedShort: left.major) == right.major
        && NSNumber(unsignedShort: left.minor) == right.minor)
}
