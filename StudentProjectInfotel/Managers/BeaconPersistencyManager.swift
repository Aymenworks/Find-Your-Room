//
//  BeaconPersistencyManager.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 21/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import Foundation

/**
*  Memento pattern
*/
class BeaconPersistencyManager {
    
    /// The list of beacons we will use. See `Beacon`.
    var beacons: [Beacon]
    
    init() {
        self.beacons = [Beacon]()
    }
    
    func addBeacon(beacon: Beacon) {
        self.beacons += [beacon]
    }
}


