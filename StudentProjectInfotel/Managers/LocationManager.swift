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
        println("LocationManager init")
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        if self.locationManager.respondsToSelector("requestAlwaysAuthorization") {
            self.locationManager.requestAlwaysAuthorization()
        }
        
        self.locationManager.startUpdatingLocation()
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
            for room in Facade.sharedInstance().rooms() {                   // For each beacon from our database
                if room.beacon == clBeacon {
                    println("J'ai trouvé des beacons dans les environs et qui m'appartient= \(room.beacon)")

                    // If that's our
                    if let lastProximity = room.beacon.lastSeenBeacon?.proximity {       // If the beacon has already apparead
                        if clBeacon.proximity == lastProximity || clBeacon.proximity == .Unknown { // If the beacon proximity hasn't changed
                            return
                        } else {
                            println("\(room.beacon) changed proximity")
                        }
                    }
                    room.beacon.lastSeenBeacon = clBeacon
                    println("J'envoie une requête au serveur pour indiquer ma présence avec ce beacon = \(room.beacon)")
                    Facade.sharedInstance().addMyPresenceToRoom(room.identifier,
                        userEmail: Member.sharedInstance().email!.encodeBase64(), completionHandler: { (json, error) -> Void in
                            println("add my presence json = \(json), error = \(error)")
                    })
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
      //  println("stop monitoring/scaning because entered the region")
      //  self.locationManager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
        
        Facade.sharedInstance().deleteMyPresenceFromRoom(Member.sharedInstance().email!.encodeBase64(), completionHandler: { (json, error) -> Void in
            println("json = \(json), error = \(error)")
        })

        println("You exited the region")
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
