//
//  Member.swift
//  AymenRebouh
//
//  Created by Rebouh Aymen on 20/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import Foundation.NSCoder
import UIKit.UIImage

// A member is a student who has signed up
final class Member: Person {
  
  required init(firstName: String?, lastName: String?, email: String?, formation: String?, schoolId: String?,
    schoolName: String?, isAdmin: Bool, profilPicture: UIImage?) {
      
      super.init(firstName: firstName, lastName: lastName, email: email, formation: formation, schoolId: schoolId,
        schoolName: schoolName, isAdmin: isAdmin, profilPicture: profilPicture)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  static var sharedInstance = Member(   firstName: session.objectForKey("firstName") as? String,
    lastName: session.objectForKey("lastName") as? String,
    email: session.objectForKey("email") as? String,
    formation: session.objectForKey("formation") as? String,
    schoolId: session.objectForKey("schoolId") as? String,
    schoolName: session.objectForKey("schoolName") as? String,
    isAdmin: session.boolForKey("isAdmin"),
    profilPicture: session.objectForKey("profilPicture") == nil ?
      nil : UIImage(data: session.objectForKey("profilPicture") as! NSData))
  
  func fillMemberProfilWithJSON(userProfil: JSON) {
    self.firstName = userProfil["FIRSTNAME"].string!
    self.lastName = userProfil["LASTNAME"].string!
    self.email = userProfil["EMAIL"].string!
    self.formation = userProfil["FORMATION"].string
    self.schoolId = userProfil["SCHOOL_ID"].string!
    self.schoolName = userProfil["SCHOOL_NAME"].string!
    self.isAdmin = userProfil["ADMIN"].string == "1" ? true : false
  }
  
  final func updateMemberWithFirstName(firstName: String, lastName: String, formation: String, schoolId: String) {
    self.firstName = firstName
    self.lastName = lastName
    self.formation = formation
    self.schoolId = schoolId
  }  
}