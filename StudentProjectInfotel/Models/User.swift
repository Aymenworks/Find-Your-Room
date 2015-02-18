//
//  User.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 10/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

let defaults = NSUserDefaults.standardUserDefaults()

public class User {
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var profilPicture: UIImage?
    
    private init(firstName: String?, lastName: String?, email: String?, profilPicture: UIImage?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profilPicture = profilPicture
    }
    
    class var sharedInstance: User {
        struct Singleton {
            static var instance = User( firstName: defaults.objectForKey("lastName") as? String,
                                        lastName: defaults.objectForKey("lastName") as? String,
                                        email: defaults.objectForKey("email") as? String,
                                        profilPicture: defaults.objectForKey("profilPicture") == nil ?
                                            nil : UIImage(data: defaults.objectForKey("profilPicture") as NSData))
        }
        
        return Singleton.instance
    }
    
    func fillUserProfilWithJSON(userProfil: JSON) {
        self.firstName = userProfil["FIRSTNAME"].string!
        self.lastName = userProfil["LASTNAME"].string!
        self.email = userProfil["EMAIL"].string!
    }
    
    func fillUserProfil(#email: String, firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}

extension User: Printable {
    
    public var description: String {
        get {
            return "FirstName = \(self.firstName), LastName = \(self.lastName), email = \(self.email)"
        }
    }
}