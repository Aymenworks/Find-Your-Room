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
    var profilPicture: UIImage?
    
    private init(firstName: String?, lastName: String?, email: String?,  formation: String?, profilPicture: UIImage?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.formation = formation
        self.profilPicture = profilPicture
    }
    
    class func sharedInstance() -> Member {
        struct Singleton {
            static var instance = Member(   firstName: session.objectForKey("firstName") as? String,
                                            lastName: session.objectForKey("lastName") as? String,
                                            email: session.objectForKey("email") as? String,
                                            formation: session.objectForKey("formation") as? String,
                                            profilPicture: session.objectForKey("profilPicture") == nil ?
                                                nil : UIImage(data: session.objectForKey("profilPicture") as NSData))
        }
        
        return Singleton.instance
    }
    
    func fullName() -> String {
        return "\(self.firstName!) \(self.lastName!)"
    }
    
    func fillMemberProfilWithJSON(userProfil: JSON) {
        self.firstName = userProfil["FIRSTNAME"].string!
        self.lastName = userProfil["LASTNAME"].string!
        self.email = userProfil["EMAIL"].string!
        self.formation = userProfil["FORMATION"].string!
    }
}



extension Member: Printable {
    
    var description: String {
            return "FirstName = \(self.firstName), LastName = \(self.lastName), email = \(self.email)"
    }
}