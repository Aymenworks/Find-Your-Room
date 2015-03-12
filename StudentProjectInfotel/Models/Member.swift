//
//  Member.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 20/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

class Member: Student {
    
    required init(firstName: String?, lastName: String?, email: String?,  formation: String?,
        schoolId: String?, schoolName: String?, profilPicture: UIImage?) {
            super.init(firstName: firstName, lastName: lastName, email: email,  formation: formation,
            schoolId: schoolId, schoolName: schoolName, profilPicture: profilPicture)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func sharedInstance() -> Member {
        struct Singleton {
            static var instance = Member(   firstName: session.objectForKey("firstName") as? String,
                                            lastName: session.objectForKey("lastName") as? String,
                                            email: session.objectForKey("email") as? String,
                                            formation: session.objectForKey("formation") as? String,
                                            schoolId: session.objectForKey("schoolId") as? String,
                                            schoolName: session.objectForKey("schoolName") as? String,
                                            profilPicture: session.objectForKey("profilPicture") == nil ?
                                                nil : UIImage(data: session.objectForKey("profilPicture") as NSData))
        }
        
        return Singleton.instance
    }
    
    func fillMemberProfilWithJSON(userProfil: JSON) {
        self.firstName = userProfil["FIRSTNAME"].string
        self.lastName = userProfil["LASTNAME"].string
        self.email = userProfil["EMAIL"].string
        self.formation = userProfil["FORMATION"].string
        self.schoolId = userProfil["SCHOOL_ID"].string
        self.schoolName = userProfil["SCHOOL_NAME"].string
    }
}