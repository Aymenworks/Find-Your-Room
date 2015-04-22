//
//  CLProximityExtension.swift
//  AymenRebouh
//
//  Created by Rebouh Aymen on 17/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import CoreLocation.CLLocation

extension CLProximity {
  
  func toString() -> String {
    
    var name = ""
    
    switch self {
      case .Immediate: name = "Close to me"
      case .Near: name = "Near"
      case .Far: name = "Far"
      case .Unknown: name = "Unknown"
    }
    
    return name
  }
}