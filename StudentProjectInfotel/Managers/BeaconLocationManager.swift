//
//  BeaconLocationManager.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 21/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import CoreLocation

/**
*  <#Description#>
*/
public class BeaconLocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager: CLLocationManager!
    
    // MARK: - Life Cycle
    
    override init() {
        
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        if locationManager.respondsToSelector("requestAlwaysAuthorization") {
            self.locationManager.requestAlwaysAuthorization()
            println("requestAlwaysAuthorization ok")
        }
    }
    
    // MARK: - Beacon Location
    
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
    
    // Called when a beacon come within range, move out of range, or when the range of an iBeacon changes.
    public func locationManager(manager: CLLocationManager!,
                                    didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        var message = ""
        
        for clBeacon in beacons as [CLBeacon] {
            
            for beacon in BeaconFacade.sharedInstance.beacons() {
                
                if beacon == clBeacon {
                    
                    // If the beacon already appeared
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

    // MARK: - User Location

    public func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("locationManager didFailWithError = \(error)")
    }
    
    public func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        println("locationManager monitoringDidFailForRegion = \(error)")
    }
    
    public func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        if state == .Inside {
            println(".Inside")
        } else {
            println("Not .Inside")
        }
    }
    
    /* There's no need to start monitoring/scaning if we're not at the area. So we begin to monitore only when 
        the user enter the region
    */
    public func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
        manager.startUpdatingLocation()
        
        println("You entered the region")
    }
    
    // If we exit the area, there's no need to continue monitoring/scaning
    public func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
        manager.stopUpdatingLocation()
        
        println("You exited the region")

    }
}

extension CLProximity {
    
    func toString() -> String {
        
        var name = ""
        
        switch self {
            case .Immediate:
                name = "Close to me"
            case .Near:
                name = "Near"
            case .Far:
                name = "Far"
            default:
                name = "Unkown"
        }
        
        return name
    }
}