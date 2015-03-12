//
//  Room.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 18/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

/**
  The Room model
*/
public class Room: NSObject {
    
    let identifier: Int!
    let title: String!
    let roomDescription: String?
    let capacity: Int?
    lazy var students: [Student] = [Student]()
    
    init(jsonRoom: JSON) {
        super.init()
        self.identifier = jsonRoom["ID"].string!.toInt()!
        self.title = jsonRoom["TITLE"].string
        self.roomDescription = jsonRoom["DESCRIPTION"].string
        self.capacity = jsonRoom["CAPACITY"].string?.toInt()
        
        for student in jsonRoom["STUDENTS"].arrayValue {
            self.students.append(Student(jsonStudent: student))
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init()
        self.identifier = aDecoder.decodeIntegerForKey("roomIdentifier")
        self.title = aDecoder.decodeObjectForKey("roomTitle") as? String
        self.roomDescription = aDecoder.decodeObjectForKey("roomDescription") as? String
        self.capacity = aDecoder.decodeIntegerForKey("roomCapacity")
        self.students = aDecoder.decodeObjectForKey("studentsInsideRoom") as [Student]
    }
}

extension Room: NSCoding {
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.identifier, forKey: "roomIdentifier")
        aCoder.encodeObject(self.title, forKey: "roomTitle")
        aCoder.encodeObject(self.students, forKey: "studentsInsideRoom")

        if let roomDescription = self.roomDescription? {
            aCoder.encodeObject(roomDescription, forKey: "roomDescription")
        }
        
        if let capacity = self.capacity? {
            aCoder.encodeInteger(capacity, forKey: "roomCapacity")
        }

    }
}

extension Room: Printable {
    
    /// What will be printed when printing the room object.
    override public var description: String {
        return "title = \(self.title), description = \(self.roomDescription?), capacity = \(self.capacity?), students inside = \(self.students)"
    }
}
