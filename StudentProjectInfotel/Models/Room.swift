//
//  Room.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 18/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import Foundation

public class Room {
    
    let identifier: String
    let title: String
    let description: String?
    let numberOfStudents: Int16?
    let capacity: Int16?
    
    init(roomIdentifier: String, title: String, description: String?, numberOfStudents: Int16?, capacity: Int16) {
        self.identifier = roomIdentifier
        self.title = title
        self.description = description
        self.numberOfStudents = numberOfStudents
        self.capacity = capacity
    }
}