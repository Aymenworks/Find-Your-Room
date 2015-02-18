//
//  CLProximityExtension.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 17/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

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