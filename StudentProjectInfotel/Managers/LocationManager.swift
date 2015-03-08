//
//  BeaconLocationManager.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 21/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

/**
  The core location manager. It take care of the beacon/user location like starting ranging/monitoring
*/
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager: CLLocationManager!
    
    // MARK: - Lifecycle -
    
    override init() {
        
        super.init()
        println("init location")
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        if locationManager.respondsToSelector("requestAlwaysAuthorization") {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    // MARK: - Beacon Location -
    
    func startMonitoringBeacon(beacon: Beacon) {
        self.locationManager.startMonitoringForRegion(beacon.region)
        self.locationManager.startRangingBeaconsInRegion(beacon.region)
        self.locationManager.requestStateForRegion(beacon.region)
        self.locationManager.startUpdatingLocation()
    }
    
    func stopMonitoringBeacon(beacon: Beacon) {
        self.locationManager.stopMonitoringForRegion(beacon.region)
        self.locationManager.stopRangingBeaconsInRegion(beacon.region)
        self.locationManager.stopUpdatingLocation()
    }
    
    /**
    Called when a beacon come within range, move out of range, or when the range of an iBeacon changes.
    
    :param: manager The location manager object reporting the event.
    :param: beacons An array of CLBeacon objects representing the beacons currently in range.
    :param: region  The region object containing the parameters that were used to locate the beacons.
    */
    func locationManager(manager: CLLocationManager!,
                                    didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        var message = ""
        
        for clBeacon in beacons as [CLBeacon] {
            
            for beacon in Facade.sharedInstance().beacons() {
                
                if beacon == clBeacon {
                    
                    // If the beacon has already appeared
                    if let lastProximity = beacon.lastSeenBeacon?.proximity {
                        // If its proximity havn't changed, we don't update anything
                        if clBeacon.proximity == lastProximity || clBeacon.proximity == .Unknown {
                            return
                        }
                    }
                    
                    beacon.lastSeenBeacon = clBeacon
                    NSNotificationCenter.defaultCenter().postNotificationName("BeaconSendLocalNotification", object: self,
                        userInfo: ["message": "\(beacon.lastSeenBeacon!.proximity.toString()) \(beacon.name)"])
                }
            }
        }
        
        println("Beacon message = \(message)")
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
        } else {
            println("Not .Inside")
        }
    }
    
    /* There's no need to start monitoring/scaning if we're not at the area. So we begin to monitore only when 
        the user enter the region
    */
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
        manager.startUpdatingLocation()
        
        println("You entered the region")
    }
    
    // If we exit the area, there's no need to continue monitoring/scaning
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
        manager.stopUpdatingLocation()
        
        println("You exited the region")
    }
    
    // MARK: - Location Authorization -
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .Denied {
            println("denied")
        }
    }
}
