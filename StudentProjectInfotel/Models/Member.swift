//
//  Member.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 20/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

class Member {
    
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
    
    private init(firstName: String?, lastName: String?, email: String?,  formation: String?, schoolId: String?, schoolName: String?, profilPicture: UIImage?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.formation = formation
        self.schoolId = schoolId
        self.schoolName = schoolName
        self.profilPicture = profilPicture
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

extension Member: Printable {
    
    /// What will be printed when printing the member object.
    var description: String {
            return "FirstName = \(self.firstName), LastName = \(self.lastName), email = \(self.email)"
    }
    
    func fullName() -> String {
        return "\(self.firstName!) \(self.lastName!)"
    }
}