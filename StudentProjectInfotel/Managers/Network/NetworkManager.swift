//
//  AuthenticationManager.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 04/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

// The google public key necesary to fetch the user url profile picture
private let publicKey = "AIzaSyCO_HPYCsvBm2Qwvszsa6pW7qjiDZ5Cwho"

// The googke user id
let kClientId = "630039187091-4unm8bftk7etj24a4budbhb6d8okr2ad.apps.googleusercontent.com"

/**
    The authentication network manager. It take care of the http request to authenticate, signin/up the user, 
    fetching its profil informations, uploading informations, etc ..
*/
class NetworkManager {
    
    // MARK: - SignIn -

    /**
    Will authenticate the user with email/password combinaison.
    
    :param: email    The encoded base64 user email.
    :param: password The hashed (MD5) user password.
    
    There, base 64 is used to encode non-http compatible characters that may be in the email or password
    */
    func authenticateUserWithEmail(email: String, password: String, completionHandler: (JSON?, NSError?) -> Void) {
        request(.POST, "http://www.aymenworks.fr/beacon/authenticateUser", parameters:["email": email, "password": password])
            .validate()
            .responseSwiftyJSON { (_, _, jsonResponse, error) in
                completionHandler(jsonResponse, error)
        }
    }
    
    // MARK: - Sign up -
    
    /**
    Will register the user on the database
    
    :param: email             The email user
    :param: password          The password user
    :param: lastName          The user last name
    :param: firstName         The user first name
    :param: completionHandler The callback containing the json server/error response that'll be executed after the request has finished
    */
    func signUpUserWithPassword(email: String, password: String, lastName: String, firstName: String,
        formation: String, schoolId: String, completionHandler: (JSON?, NSError?) -> Void) {
            
        request(.POST, "http://www.aymenworks.fr/beacon/signUpUserWithPassword", parameters:["email": email, "lastName": lastName, "firstName": firstName, "password": password, "formation" : formation, "schoolId" : schoolId])
            .validate()
            .responseSwiftyJSON { (request, httpResponse, jsonResponse, error) in
                completionHandler(jsonResponse, error)
        }
    }
    
    // MARK: - Facebook & Google Plus Sign In/Up -
    
    /**
    Will authenticate the user with email/password combinaison using Facebook or Google Plus fetched data.
    If the user is not on the database, he'll be automatically registered
    
    :param: email             The encoded base64 user email.
    :param: lastName          The encoded base64 user last name.
    :param: firstName         The encoded base64 user first name.
    :param: completionHandler The callback that'll be executed after the request has finished.
    */
    func authenticateUserWithFacebookOrGooglePlus(email: String, lastName: String, firstName: String,
        completionHandler: (JSON?, NSError?) -> Void) {
            
        request(.POST, "http://www.aymenworks.fr/beacon/authenticateUserWithFacebookOrGooglePlus",
            parameters:["email": email, "lastName": lastName, "firstName": firstName])
            .validate()
            .responseSwiftyJSON { (_, _, jsonResponse, error) in
                completionHandler(jsonResponse, error)
        }
    }
    
    // MARK:  Facebook
    
    /**
    Will fetch the facebook user profile picture thanks to its facebook user id
    
    :param: userId            The facebook user id
    :param: completionHandler The callback that'll be executed after the request has finished.
    */
    func facebookProfilePicture(userId: String, completionHandler: (UIImage?) -> Void) {
        request(.GET, "https://graph.facebook.com/\(userId)/picture?type=large")
            .validate()
            .responseImage { (_, _, image, _) -> Void in
                completionHandler(image)
            }
    }
    
    // MARK:  Google Plus
    
    /**
    Will fetch the google user profile thanks to its google user id
    
    :param: userId            The google user id
    :param: completionHandler The callback containing the user first name, last name, profile picture, that'll be executed after the request has finished.
    */
    func googlePlusProfile(userId: String, completionHandler: (firstName: String?, lastName: String?,
        profilPicture: UIImage?, error: NSError?) -> Void) {

        /**
        Will download the google user profile picture using the url fetched on the `googlePlusNameWithUserId` method
        
        :param: url               The url of the google user profile picture
        :param: firstName         Used only for the callback
        :param: lastName          Used only for to callback
        :param: completionHandler The callback containing the user first name, last name, profile picture, that'll be executed after the request has finished
        */
        func googlePlusProfilePictureWithURL(url: String, andFirstName firstName: String, #lastName: String,
            completionHandler: (String?, String?, UIImage?, NSError?) -> Void) {
                
                request(.GET, url)
                    .validate()
                    .responseImage { (_, _, image, error) -> Void in
                        completionHandler(firstName, lastName, image, error)
                    }
        }
        
        /**
        Will fetch the google user name, lastname and the url of its profile picture thanks to its google user id.

        :param: userId            The google user id
        :param: completionHandler The callback containing the user first name, last name, profile picture, that'll be executed after the request has finished
        */
        func googlePlusProfileWithUserId(userId: String, completionHandler: (firstName: String?, lastName: String?,
            profilPicture: UIImage?, error: NSError?) -> Void) {
            
            // We get the url profile picture with the user id
            request(.GET, "https://www.googleapis.com/plus/v1/people/\(userId)?fields=image,name&key=\(publicKey)")
                .validate()
                .responseSwiftyJSON { (_, _, jsonResponse, error) in
                    
                    let lastName =  jsonResponse["name"]["familyName"].string
                    let firstName =  jsonResponse["name"]["givenName"].string
                    
                    if let url = jsonResponse["image"]["url"].string {
                        googlePlusProfilePictureWithURL(url, andFirstName: firstName!, lastName: lastName!, completionHandler)
                            
                    } else {
                        completionHandler(firstName: firstName, lastName: lastName, profilPicture: nil, error: error)
                    }
                }
        }
        
        googlePlusProfileWithUserId(userId, completionHandler)
    }
    
    // MARK: - Download/Upload Server Image -
    
    /**
    Will fetch the user profile picture from the server.
    
    :param: urlImage          The url of the user hashed directory on the server
    :param: completionHandler The callback containing the user profile picture that'll be executed after the request has finished
    */
    func serverProfilPictureWithURL(urlImage: String, completionHandler: (UIImage?) -> Void) {
        request(.GET, urlImage)
            .validate()
            .responseImage { (_, _, image, _) -> Void in
                completionHandler(image)
        }
    }
    
    /**
    Upload the user profil picture picture on its md5 hashed email directory on the server
    From http://stackoverflow.com/questions/26121827/uploading-file-with-parameters-using-alamofire
    
    :param: image             The user profil picture
    :param: email             The user email address. We use it to move the user profil picture picture on its md5 hashed email directory on the server
    :param: completionHandler The callback that'll be executed after the request has finished
    */
    func uploadUserProfilPicture(image: UIImage, withEmail email: String, completionHandler: () -> Void) {
        
        func urlFormating(urlString:String,withImageData imageData:NSData) -> (newUrl: URLRequestConvertible, data: NSData) {
            
            var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
            let boundaryConstant = "NET-POST-boundary-\(arc4random())-\(arc4random())"
            let contentType = "multipart/form-data;boundary="+boundaryConstant
            mutableURLRequest.HTTPMethod = Method.POST.rawValue
            mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            
            // Ajout de l'image
            let uploadData = NSMutableData()
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"picture.jpg\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Type: image/jpg\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData(imageData)
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"email\"\r\n\r\n\(email)".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            // Ajout de l'email
            uploadData.appendData("Content-Disposition: form-data; name=email\"\r\n\r\n\(email)".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            return (ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
        }
        
        let imageData = UIImageJPEGRepresentation(image, 80.0)
        let urlRequest = urlFormating("http://www.aymenworks.fr/beacon/uploadPicture", withImageData: imageData)
        
        upload(urlRequest.newUrl, urlRequest.data)
            .validate()
            .responseSwiftyJSON { (request, response, JSON, error) in
                println("upload picture response = \(response), json = \(JSON)")
                completionHandler()
        }
    }
    
    // MARK: - User Profile -
    
    /**
    Fetch the user profil information( name, lastname, school, ..)
    
    :param: email             The user email used ( id in the database ) to authenticate him
    :param: completionHandler The callback that'll be executed after the request has finished
    */
    func fetchUserProfile(email: String, completionHandler: (JSON?, NSError?) -> Void) {
        request(.POST, "http://www.aymenworks.fr/beacon/fetchUserProfile",
            parameters:["email": email])
            .validate()
            .responseSwiftyJSON { (_, _, jsonResponse, error) in
                completionHandler(jsonResponse, error)
        }
    }
    
    /**
    Will update the user profil on the database and then in session.
    
    :param: email             The new user email
    :param: password          The new user password
    :param: lastName          The new user last name
    :param: firstName         The new user first name
    :param: completionHandler The callback containing the json server/error response that'll be executed
    after the request has finished
    */
    func updateUserAccount(email: String, password: String, lastName: String, firstName: String,
        formation: String, schoolId: String, completionHandler: (JSON?, NSError?) -> Void) {
            
            request(.POST, "http://www.aymenworks.fr/beacon/updateUserAccount", parameters:["email": email, "lastName": lastName, "firstName": firstName, "password": password, "formation" : formation, "schoolId" : schoolId])
                .validate()
                .responseSwiftyJSON { (request, httpResponse, jsonResponse, error) in
                    completionHandler(jsonResponse, error)
            }
    }

    // MARK: Rooms
    
    /**
    Get the rooms of a school using the school ID and also the students inside.
    
    :param: schoolId    The school ID.
    */
    func roomsBySchoolId(schoolId: String, completionHandler: (JSON?, NSError?) -> Void) {
        request(.POST, "http://www.aymenworks.fr/beacon/schoolDataByID", parameters:["schoolId": schoolId])
            .validate()
            .responseSwiftyJSON { (_, _, jsonResponse, error) in
                completionHandler(jsonResponse, error)
        }
    }
    
    /**
    <#Description#>
    */
    func fetchPersonsProfilPictureInsideRoom() {
        
        var numberOfImagesToDownload = 0
        var numberOfImagesDownloaded = 0
        
        Facade.sharedInstance().rooms().map({ numberOfImagesToDownload += $0.persons.count })
        var pictureUrl: String
        for room in Facade.sharedInstance().rooms() {
            for person in room.persons {
                pictureUrl = "http://www.aymenworks.fr/assets/beacon/\(person.email!.md5())/picture.jpg"
                Facade.sharedInstance().serverProfilPictureWithURL(pictureUrl) { image -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("DownloadImageNotification", object: nil)
                    person.profilPicture = image
                    numberOfImagesDownloaded++
                    
                    // If we have downloaded all the pictures, we save it.
                    if numberOfImagesDownloaded == numberOfImagesToDownload {
                        Facade.sharedInstance().saveRooms()
                    }
                }
            }
        }
    }
    
    /**
    <#Description#>
    
    :param: schoolId          <#schoolId description#>
    :param: roomTitle         <#roomTitle description#>
    :param: roomDescription   <#roomDescription description#>
    :param: roomCapacity      <#roomCapacity description#>
    :param: beaconUUID        <#beaconUUID description#>
    :param: beaconMajor       <#beaconMajor description#>
    :param: beaconMinor       <#beaconMinor description#>
    :param: completionHandler <#completionHandler description#>
    */
    func addRoom(schoolId: String, roomTitle: String, roomDescription: String,
        roomCapacity: Int, beaconUUID: String, beaconMajor: Int, beaconMinor: Int, completionHandler: (JSON?, NSError?) -> Void) {
            request(.POST, "http://www.aymenworks.fr/beacon/addRoom", parameters:["schoolId": schoolId, "roomTitle": roomTitle,
                "roomDescription": roomDescription, "roomCapacity": roomCapacity, "beaconUUID": beaconUUID, "beaconMajor": beaconMajor,
                "beaconMinor": beaconMinor])
                .validate()
                .responseSwiftyJSON { (_, _, jsonResponse, error) in
                    completionHandler(jsonResponse, error)
            }
    }
    
    /**
    <#Description#>
    
    :param: roomId            <#roomId description#>
    :param: userEmail         <#userEmail description#>
    :param: completionHandler <#completionHandler description#>
    */
    func addMyPresenceInRoom(roomId: Int, userEmail: String, completionHandler: (JSON?, NSError?) -> Void) {
        println("j'envoie room = \(roomId) et email = \(userEmail)")
        request(.POST, "http://www.aymenworks.fr/beacon/addMyPresenceInRoom", parameters:["roomId": roomId,
            "userEmail": userEmail])
            .validate()
            .responseSwiftyJSON { (_, _, jsonResponse, error) in
                completionHandler(jsonResponse, error)
        }
    }
    
    /**
    <#Description#>
    
    :param: roomId            <#roomId description#>
    :param: userEmail         <#userEmail description#>
    :param: completionHandler <#completionHandler description#>
    */
    func deleteMyPresenceFromRoom(userEmail: String, completionHandler: (JSON?, NSError?) -> Void) {
        request(.POST, "http://www.aymenworks.fr/beacon/deleteMyPresenceFromRoom", parameters:["userEmail": userEmail])
            .validate()
            .responseSwiftyJSON { (_, _, jsonResponse, error) in
                completionHandler(jsonResponse, error)
        }
    }
    

}