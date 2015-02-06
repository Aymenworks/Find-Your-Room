//
//  BeaconFacade.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 22/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import Foundation

/**
*  The Beacon facade pattern.
*/
public class BeaconFacade : NSObject {
    
    private var beaconLocationManager: BeaconLocationManager?
    lazy private var beaconPersistencyManager = BeaconPersistencyManager()
    lazy private var authenticationManager = AuthenticationManager()
    
    /// A singleton object as the entry point to manage the beacons
    class var sharedInstance: BeaconFacade {
        struct Singleton {
            static let instance = BeaconFacade()
        }
        return Singleton.instance
    }
    
    // MARK: - Life Cycle
    
    override private init() {
        super.init()
        beaconLocationManager = BeaconLocationManager()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Authentication methods
    
    
    // MARK: - Beacon Persistency methods
    
    public func beacons() -> [Beacon] {
        return beaconPersistencyManager.beacons
    }
    
    public func addBeacon(beacon: Beacon) {
        beaconPersistencyManager.addBeacon(beacon)
    }
    
    // MARK: - Beacon Location methods
    
    public func startMonitoringBeacon(beacon: Beacon) {
        
        if beaconLocationManager != nil {
            beaconLocationManager!.startMonitoringBeacon(beacon)
            println("startMonitoringBeacon")

        } else {
            println("beaconLocationManager is nil")
        }
    }
}