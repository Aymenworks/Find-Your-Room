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
    
    private(set) var name: String
    private(set) var uuid: NSUUID
    private(set) var major: CLBeaconMajorValue
    private(set) var minor: CLBeaconMinorValue
    private(set) var region: CLBeaconRegion
    dynamic var lastSeenBeacon: CLBeacon?
    
    init(name: String, uuid: NSUUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue) {
        
        self.name = name
        self.uuid = uuid
        self.major = major
        self.minor = minor
        region = CLBeaconRegion(proximityUUID: self.uuid, major: self.major, minor: self.minor, identifier: self.name)
        region.notifyEntryStateOnDisplay = true
    }
    
}

func == (left: Beacon, right: CLBeacon) -> Bool {
    
    return (left.uuid.isEqual(right.proximityUUID)
        && NSNumber(unsignedShort: left.major) == right.major
        && NSNumber(unsignedShort: left.minor) == right.minor)
}
