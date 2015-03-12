//
//  RoomsNetworkManager.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 11/03/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

/**
The RoomsNetworkManager manager. It take care of the http request to get the list of rooms in a school, the users 
inside a room with their profil
*/
class RoomsNetworkManager {
    
    // MARK: - SignIn -
    
    /**
    Get the rooms of a school using the school ID and also the students inside.
    
    :param: schoolId    The school ID.
    */
    func roomsBySchoolId(schoolId: String, completionHandler: (JSON?, NSError?) -> Void) {
        request(.POST, "http://www.aymenworks.fr/beacon/roomsBySchool", parameters:["schoolId": schoolId])
            .validate()
            .responseSwiftyJSON { (request, _, jsonResponse, error) in
                completionHandler(jsonResponse, error)
        }
    }

}