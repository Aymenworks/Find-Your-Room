//
//  Beacon.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 20/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import CoreLocation

/**
*  The beacon model class.
*/
public class Beacon : NSObject {
    
    var name: String
    var uuid: NSUUID
    var major: CLBeaconMajorValue
    var minor: CLBeaconMinorValue
    var region: CLBeaconRegion
    
    /// dynamic: Needed to create observer on it.
    dynamic var lastSeenBeacon: CLBeacon?
    
    // MARK: - Initialization
    
    init(name: String, uuid: NSUUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue) {
        self.name = name
        self.uuid = uuid
        self.major = major
        self.minor = minor
        region = CLBeaconRegion(proximityUUID: self.uuid, major: self.major, minor: self.minor, identifier: self.name)
        region.notifyEntryStateOnDisplay = true
    }
    
}

// MARK: - Overloading Operator

func == (left: Beacon, right: CLBeacon) -> Bool {
    
    return (left.uuid.isEqual(right.proximityUUID)
        && NSNumber(unsignedShort: left.major) == right.major
        && NSNumber(unsignedShort: left.minor) == right.minor)
}
