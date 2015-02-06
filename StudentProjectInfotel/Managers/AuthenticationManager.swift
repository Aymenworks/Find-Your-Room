//
//  AuthenticationManager.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 04/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import Foundation

class AuthenticationManager {
    
    
    class func getGooglePlusUserName() -> String? {
        
        
        // We create an instance to send request to Google+
        let plusService = GTLServicePlus()
        plusService.retryEnabled = true
        
        // Then the autorization agent
        plusService.authorizer = GPPSignIn.sharedInstance().authentication
        
        // We create the GTLQuery to get details about the user 
        let query = GTLQueryPlus.queryForPeopleGetWithUserId("me") as GTLQueryPlus
        
        plusService.executeQuery(query, completionHandler: { (ticket, person, error) -> Void in
            
            if error == nil {
                println("person name = \(person.displayName) and person = \(person)")
            
            } else {
                println("error = \(error)")
            }
        })
        
        return nil
    }
}