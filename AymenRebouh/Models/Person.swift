//
//  Person.swif
//  AymenRebouh
//
//  Created by Rebouh Aymen on 11/03/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import Foundation.NSObject
import UIKit.UIImage

class Person: NSObject {
  
  final var firstName: String!
  final var lastName: String!
  final var email: String!
  final var schoolName: String!
  final var schoolId: String!
  final var formation: String!
  final var isAdmin = false
  
  final var profilPicture: UIImage! {
    didSet {
      if self.profilPicture == nil {
        self.profilPicture = UIImage(named: "profil")
      }
    }
  }
  
  // MARK: - Lifecycle -
  
  init (jsonPerson: JSON) {
    println("json person = \(jsonPerson)")
    self.lastName = jsonPerson["LASTNAME"].string!
    self.firstName = jsonPerson["FIRSTNAME"].string!
    self.email = jsonPerson["USER_EMAIL"].string!
    self.schoolId = jsonPerson["SCHOOL_ID"].string!
    self.schoolName = jsonPerson["SCHOOL_NAME"].string!
    self.formation = jsonPerson["FORMATION"].string
    
    super.init()
  }
  
  required init(firstName: String?, lastName: String?, email: String?,  formation: String?,
    schoolId: String?, schoolName: String?, isAdmin: Bool, profilPicture: UIImage?) {
      
      self.firstName = firstName
      self.lastName = lastName
      self.email = email
      self.formation = formation
      self.schoolId = schoolId
      self.schoolName = schoolName
      self.isAdmin = isAdmin
      self.profilPicture = profilPicture
      
      super.init()
  }
  
  required init(coder aDecoder: NSCoder) {
    self.firstName = aDecoder.decodeObjectForKey("firstName") as? String
    self.lastName = aDecoder.decodeObjectForKey("lastName") as? String
    self.email = aDecoder.decodeObjectForKey("email") as? String
    self.formation = aDecoder.decodeObjectForKey("formation") as? String
    self.schoolId = aDecoder.decodeObjectForKey("schoolId") as? String
    self.schoolName = aDecoder.decodeObjectForKey("schoolName") as? String
    self.isAdmin = aDecoder.decodeBoolForKey("isAdmin")
    
    if let profilPictureData = aDecoder.decodeObjectForKey("profilPicture") as? NSData {
      self.profilPicture = UIImage(data: profilPictureData)
    }
  }
}

// MARK: - NSCoding Conformance Protocol -

extension Person: NSCoding {
  
  final func encodeWithCoder(aCoder: NSCoder) {
    
    aCoder.encodeObject(firstName, forKey: "firstName")
    aCoder.encodeObject(lastName, forKey: "lastName")
    aCoder.encodeObject(email, forKey: "email")
    aCoder.encodeObject(schoolId, forKey: "schoolId")
    aCoder.encodeObject(schoolName, forKey: "schoolName")
    aCoder.encodeBool(isAdmin, forKey: "isAdmin")
    
    if let formation = self.formation {
      aCoder.encodeObject(formation, forKey: "formation")
    }
    
    if let profilPicture = self.profilPicture {
      aCoder.encodeObject(UIImageJPEGRepresentation(profilPicture, 80.0) , forKey: "profilPicture")
    }
  }
}

// MARK: - Printable Conformance Protocol -

extension Person: Printable {
  
  /// What will be printed when printing the member object.
  override final var description: String {
    return "FirstName = \(self.firstName), LastName = \(self.lastName), email = \(self.email)"
  }
  
  final func fullName() -> String {
    return "\(self.firstName!) \(self.lastName!)"
  }
}
