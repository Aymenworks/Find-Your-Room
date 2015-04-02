//
//  BeaconLocationManager.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 21/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import CoreLocation

/**
  The core location manager. It take care of the beacon/user location like starting ranging/monitoring
*/
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    // MARK: - Lifecycle -
    
    override init() {
        
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        if self.locationManager.respondsToSelector("requestAlwaysAuthorization") {
            self.locationManager.requestAlwaysAuthorization()
        }
        
    }
    
    // MARK: - Beacon Location -
    
    func startMonitoringBeacon(beacon: Beacon) {
        self.locationManager.startMonitoringForRegion(beacon.region)
        self.locationManager.startRangingBeaconsInRegion(beacon.region)
        self.locationManager.requestStateForRegion(beacon.region)
    }
    
    func stopMonitoringBeacon(beacon: Beacon) {
        self.locationManager.stopMonitoringForRegion(beacon.region)
        self.locationManager.stopRangingBeaconsInRegion(beacon.region)
        self.locationManager.stopUpdatingLocation()
    }
    
    
    // Called when a beacon come within range, move out of range, or when the range of an iBeacon changes.
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!,
        inRegion region: CLBeaconRegion!) {
            
        // For each beacon around
        for clBeacon in beacons as [CLBeacon] {
            
            // For each beacon from our database
            for room in Facade.sharedInstance().rooms() {
                
                // If that's our
                if room.beacon == clBeacon {

                    // If the beacon has already apparead
                    if let lastProximity = room.beacon.lastSeenBeacon?.proximity {
                        
                        // If the beacon proximity hasn't changed
                        if clBeacon.proximity == lastProximity || clBeacon.proximity == .Unknown {
                            return
                        }
                    }
                    
                    room.beacon.lastSeenBeacon = clBeacon
                    Facade.sharedInstance().addMyPresenceToRoom(room.identifier,
                        userEmail: Member.sharedInstance().email!.encodeBase64(), completionHandler: { _ in })
                }
            }
        }
    }

    // MARK: - User Location -
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("locationManager didFailWithError = \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        println("locationManager monitoringDidFailForRegion = \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        if state == .Inside {
            println(".Inside")
        } else if state == .Outside {
            println("Not .Inside")
            Facade.sharedInstance().deleteMyPresenceFromRoom(Member.sharedInstance().email!.encodeBase64(), completionHandler: { (json, error) -> Void in})
        }
    }
    
    /* There's no need to start monitoring/scaning if we're not at the area. So we begin to monitore only when
        the user enter the region
    */
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("start monitoring/scaning because entered the region")
        self.locationManager.startRangingBeaconsInRegion(region as CLBeaconRegion)
        self.locationManager.startUpdatingLocation()
        
    }
    
    // If we exit the area, there's no need to continue monitoring/scaning
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        Facade.sharedInstance().deleteMyPresenceFromRoom(Member.sharedInstance().email!.encodeBase64(),
            completionHandler: { _ in })
    }
    
    // MARK: - Location Authorization -
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch(status) {
            case .Denied:
                println("denied")
            
            case .AuthorizedAlways:
                println("AuthorizedAlways")
                self.locationManager.startUpdatingLocation()

            default:break
        }
    }
}
