//
//  Beacon.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 20/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

/**
  The beacon model.
*/
public class Beacon {
    
    private(set) var name: String
    private var uuid: NSUUID
    private var major: CLBeaconMajorValue
    private var minor: CLBeaconMinorValue
    private(set) var region: CLBeaconRegion
    var lastSeenBeacon: CLBeacon?
    
    // MARK: - Initialization -
    
    init(name: String, uuid: NSUUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue) {
        self.name = name
        self.uuid = uuid
        self.major = major
        self.minor = minor
        region = CLBeaconRegion(proximityUUID: self.uuid, major: self.major, minor: self.minor, identifier: self.name)
        region.notifyEntryStateOnDisplay = true
    }
}

// MARK: - Overloading Operator -

func == (left: Beacon, right: CLBeacon) -> Bool {
    
    return (left.uuid.isEqual(right.proximityUUID)
        && NSNumber(unsignedShort: left.major) == right.major
        && NSNumber(unsignedShort: left.minor) == right.minor)
}
