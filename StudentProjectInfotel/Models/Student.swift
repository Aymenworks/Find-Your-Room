//
//  Student.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 11/03/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//


class Student: NSObject {

    var firstName: String?
    var lastName: String?
    var email: String?
    var formation: String?
    var schoolId: String?
    var schoolName: String?

    var profilPicture: UIImage? {
        didSet {
            if self.profilPicture == nil {
                self.profilPicture = UIImage(named: "portrait")
            }
        }
    }
    
    init (jsonStudent: JSON) {
        self.lastName = jsonStudent["LASTNAME"].string
        self.firstName = jsonStudent["FIRSTNAME"].string
        self.email = jsonStudent["USER_EMAIL"].string
        self.formation = jsonStudent["FORMATION"].string
    }
    
    required init(firstName: String?, lastName: String?, email: String?,  formation: String?,
        schoolId: String?, schoolName: String?, profilPicture: UIImage?) {
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
            self.formation = formation
            self.schoolId = schoolId
            self.schoolName = schoolName
            self.profilPicture = profilPicture
    }
    
    required init(coder aDecoder: NSCoder) {
        self.firstName = aDecoder.decodeObjectForKey("firstName") as? String
        self.lastName = aDecoder.decodeObjectForKey("lastName") as? String
        self.email = aDecoder.decodeObjectForKey("email") as? String
        self.formation = aDecoder.decodeObjectForKey("formation") as? String
        self.schoolId = aDecoder.decodeObjectForKey("schoolId") as? String
        self.schoolName = aDecoder.decodeObjectForKey("schoolName") as? String
        
        if let profilPictureData = aDecoder.decodeObjectForKey("profilPicture") as? NSData {
            self.profilPicture = UIImage(data: profilPictureData)
        }

    }
}

extension Student: NSCoding {
    
     func encodeWithCoder(aCoder: NSCoder) {
        
        if let firstName = self.firstName? {
            aCoder.encodeObject(firstName, forKey: "firstName")
        }
        
        if let lastName = self.lastName? {
            aCoder.encodeObject(lastName, forKey: "lastName")
        }
        
        if let email = self.email? {
            aCoder.encodeObject(email, forKey: "email")
        }
        
        if let formation = self.formation? {
            aCoder.encodeObject(formation, forKey: "formation")
        }
        
        if let schoolId = self.schoolId? {
            aCoder.encodeObject(schoolId, forKey: "schoolId")
        }
        
        if let schoolName = self.schoolName? {
            aCoder.encodeObject(schoolName, forKey: "schoolName")
        }
        
        if let profilPicture = self.profilPicture? {
            aCoder.encodeObject(UIImageJPEGRepresentation(profilPicture, 80.0) , forKey: "profilPicture")
        }
    }
}

extension Student: Printable {
    
    /// What will be printed when printing the member object.
    override var description: String {
        return "FirstName = \(self.firstName!), LastName = \(self.lastName!), email = \(self.email!)"
    }
    
    func fullName() -> String {
        return "\(self.firstName!) \(self.lastName!)"
    }
}
