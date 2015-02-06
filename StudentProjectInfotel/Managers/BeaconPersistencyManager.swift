//
//  BeaconPersistencyManager.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 21/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import Foundation

/**
*  Memento pattern. It'll save/load the data.
*/
class BeaconPersistencyManager {
    
    /// The list of beacons we will use. See `Beacon`.
    var beacons: [Beacon]
    
    func addBeacon(beacon: Beacon) {
        self.beacons += [beacon]
    }
    
    // MARK: - Life Cycle
    
    init() {
        self.beacons = [Beacon]()
    }
}


