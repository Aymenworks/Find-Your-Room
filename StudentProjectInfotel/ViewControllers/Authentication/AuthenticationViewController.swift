//
//  AuthenticationViewController.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 05/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

/**
  AuthenticationViewController controller. It take care to authenticate the user,
*/
class AuthenticationViewController: UIViewController {
    
    /// The Facebook login view given by Facebook SDK.
    @IBOutlet private var facebookLoginView: FBLoginView!
    
    /// The Google Plus login view given by Google Plus SDK.
    @IBOutlet private var googlePlusLoginButton: GPPSignInButton!
    
    /// The bar button item that'll send a sign up request on click. Disabled by default. 
    /// Enabled when the email/password are filtered and OK.
    @IBOutlet private var signInBarButtonItem: UIBarButtonItem!
    
    @IBOutlet private var menuBarButtonItem: UIBarButtonItem!
    
    /// This class signs the user in with Google.
    private var signInGooglePlus: GPPSignIn!
    
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var emailImageView: UIImageView!
    @IBOutlet private var passwordImageView: UIImageView!
    @IBOutlet private var separatorEmailView: UIView!
    @IBOutlet private var separatorPasswordView: UIView!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBarHidden = false
        
        // Google+ settings
        self.signInGooglePlus = GPPSignIn.sharedInstance()
        self.signInGooglePlus.clientID = kClientId
        self.signInGooglePlus.scopes = [kGTLAuthScopePlusLogin]
        self.signInGooglePlus.delegate = self
        self.signInGooglePlus.shouldFetchGoogleUserEmail = true
        self.signInGooglePlus.shouldFetchGooglePlusUser = true
        self.signInGooglePlus.shouldFetchGoogleUserID = true
        
        // Facebook settings
        FBLoginView.self
        self.facebookLoginView.readPermissions = ["public_profile", "email"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - User Interaction -
    
    /**
    Called when the user tap on the Go keyboard button or the Sign Up bar button item.
    It send an http request to try to authenticate the user.
    :param: sender not used
    */
    @IBAction func signIn() {
        
        BFRadialWaveHUD.showInView(self.navigationController!.view, withMessage: "Authentication...")
        self.errorLabel.text = ""
        self.view.endEditing(true)
        
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        // Let's authenticate the user
        Facade.sharedInstance().authenticateUserWithEmail(email.encodeBase64(), password: password.md5()) {
            (jsonResponse, error) -> Void in
            
            // If everything is fine..
            if error == nil && jsonResponse? != nil && jsonResponse!.isOk() {
                
                // If the user exist
                if jsonResponse!.userExist() {

                    let userProfil = jsonResponse!["response"]["profil"]
                    let pictureUrl = "http://www.aymenworks.fr/assets/beacon/\(email.md5())/picture.jpg"

                    Member.sharedInstance().fillMemberProfilWithJSON(userProfil)
                    BFRadialWaveHUD.sharedInstance().updateMessage("Download your profil picture...")
                    

                    Facade.sharedInstance().serverProfilPictureWithURL(pictureUrl) { (image) -> Void in
                        
                        BFRadialWaveHUD.sharedInstance().showSuccessWithMessage("👍 Logged in !") { _ in }

                        // Error or not, the property is optional, so check if the image/error is nil or not is not necessary
                        Member.sharedInstance().profilPicture = image
                        Facade.sharedInstance().saveMemberProfil()

                        let schoolRooms = jsonResponse!["response"]["rooms"]
                        Facade.sharedInstance().addRoomsFromJSON(schoolRooms)
                        Facade.sharedInstance().fetchStudentsInsideRoom()
                        
                        doInMainQueueAfter(seconds: 1.6) {
                            BFRadialWaveHUD.sharedInstance().dismiss()
                            self.performSegueWithIdentifier("segueGoToHomeViewFromAuthenticationView", sender: self)
                        }
                    }
                    
                // Else, if he's not registred in the database..
                } else {
                    BFRadialWaveHUD.sharedInstance().dismiss()
                    self.errorLabel.text = "Invalid email or password. Please try again."
                    self.shakeForm()
                }

            // If a problem occured ( the serveur not received the parameters even crash )
            }  else {
                
                self.signInBarButtonItem.enabled = false
                BFRadialWaveHUD.sharedInstance().dismiss()

                let alertView = JSSAlertView().danger(self, title: "Authentication",
                    text: "Something went wrong. Please try again later.")
                
                alertView.addAction({ () -> Void in
                    self.signInBarButtonItem.enabled = true
                })
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true) // Hide the keyboard when touching outside the textfields
    }
    
    @IBAction func didClickOnMenuBarButtonIem() {
        println("display menu")
    }
    
    // MARK: - User Interface -
    
    /**
    Simple shake animations
    */
    func shakeForm() {
        doInMainQueueAfter(seconds: 0.4) {
            self.emailTextField.shake()
            self.passwordTextField.shake()
            self.emailImageView.shake()
            self.passwordImageView.shake()
            self.separatorEmailView.shake()
            self.separatorPasswordView.shake()
            self.errorLabel.shake()
        }
    }
    
    // MARK: - Inputs Validation -
    
    /**
    Check if email and password inputs aren't empty
    
    :returns: True  if an input is empty or contains less than four characters, false if not.
    */
    func canSignInButtonBeEnabled() -> Bool {
        return (!self.emailTextField.text.isEmpty && !self.passwordTextField.text.isEmpty)
    }

}

// MARK: - UITextField Delegate -

extension AuthenticationViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
        
        if string != " " {
            textField.text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            self.signInBarButtonItem.enabled = self.canSignInButtonBeEnabled()
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.errorLabel.text = ""
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        self.signInBarButtonItem.enabled = false
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // If the user tap the Next keyboard button, we redirect him to the next text field.
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        
        // Else if he tap de 'Go' keyboard button, ..
        } else if textField == self.passwordTextField {
            
            if self.canSignInButtonBeEnabled() {
                self.signIn()
                
            } else {

                textField.resignFirstResponder()
                
                let alertView = JSSAlertView().show(self, title: "Authentication", text: "You forgot to enter your email address !")
                alertView.setTextTheme(.Dark)
                alertView.addAction({ () -> Void in
                    self.emailTextField.becomeFirstResponder()
                    return
                })
            }
        }

        return true
    }
}

// MARK: - Facebook Login Delegate -

extension AuthenticationViewController: FBLoginViewDelegate {
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        
        if Facade.sharedInstance().isUserLoggedIn() {
            self.performSegueWithIdentifier("segueGoToHomeViewFromAuthenticationView", sender: self)
            
        } else {
            
            BFRadialWaveHUD.showInView(self.navigationController!.view, withMessage: "Authentication...")
            let email = user.objectForKey("email") as String
            
            Facade.sharedInstance().authenticateUserWithFacebookOrGooglePlus(email.encodeBase64(),
                lastName: user.last_name.encodeBase64(), firstName: user.first_name.encodeBase64(),
                completionHandler: { (jsonResponse, error) -> Void in
                
                println("jsonresponse = \(jsonResponse), error = \(error)")
                if error == nil && jsonResponse? != nil && jsonResponse!.isOk()
                    && (jsonResponse!.userExist() || jsonResponse!.userHasBeenRegistered()) {
                    
                    BFRadialWaveHUD.sharedInstance().updateMessage("Download your profil picture...")
                        
                    Facade.sharedInstance().facebookProfilePicture(user.objectID, completionHandler: { (image) -> Void in
                    
                        Facade.sharedInstance().uploadUserProfilPicture(image!, withEmail: email.encodeBase64(),
                            completionHandler: { () -> Void in
                                    
                                BFRadialWaveHUD.sharedInstance().showSuccessWithMessage("👍 Logged in !")
                                let userProfil = jsonResponse!["response"]["profil"]
                                let schoolRooms = jsonResponse!["response"]["rooms"]

                                Member.sharedInstance().fillMemberProfilWithJSON(userProfil)
                                Member.sharedInstance().profilPicture = image
                                Facade.sharedInstance().saveMemberProfil()
                                Facade.sharedInstance().addRoomsFromJSON(schoolRooms)
                                Facade.sharedInstance().fetchStudentsInsideRoom()
                                
                                doInMainQueueAfter(seconds: 1.2) {
                                    BFRadialWaveHUD.sharedInstance().dismiss()
                                    self.performSegueWithIdentifier("segueGoToHomeViewFromAuthenticationView", sender: self)
                                }
                            }
                        )
                    })

                } else {
                    FBSession.activeSession().closeAndClearTokenInformation()
                    BFRadialWaveHUD.sharedInstance().dismiss()
                    JSSAlertView().danger(self, title: "Authentication", text: "Something went wrong. Please try again later.")
                }
            })
        }
    }
    
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        
        var errorAuthentication = (title: "",descriptionError: "")
        let errorCategory = FBErrorUtility.errorCategoryForError(error)
        
        switch(errorCategory) {
            
            // the user refuses to log in
            case .UserCancelled:
                errorAuthentication.title = "Session error"
                errorAuthentication.descriptionError = "You cancelled the facebook authentication. Please log in again."
        
            case .AuthenticationReopenSession:
                errorAuthentication.title = "Something went wrong"
                errorAuthentication.descriptionError = "Please try again later."
       
            default: break
        }
        
        JSSAlertView().danger(self, title: errorAuthentication.title,
            text: errorAuthentication.descriptionError, buttonText: nil)
    }
}

// MARK: - Google Plus Login Delegate -

extension AuthenticationViewController: GPPSignInDelegate {
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        
        BFRadialWaveHUD.showInView(self.navigationController!.view, withMessage: "Authentication...")

        if error == nil {
            
            Facade.sharedInstance().googlePlusProfile(self.signInGooglePlus.userID, completionHandler: { (firstName, lastName, profilPicture, error) -> Void in
                
                if error == nil {
                
                    if Facade.sharedInstance().isUserLoggedIn() {
                        self.performSegueWithIdentifier("segueGoToHomeViewFromAuthenticationView", sender: self)
                        
                    } else {
                        
                        let email = self.signInGooglePlus.authentication.userEmail as String
                        
                        Facade.sharedInstance().authenticateUserWithFacebookOrGooglePlus(email.encodeBase64(),
                            lastName: lastName!.encodeBase64(), firstName: firstName!.encodeBase64(),
                            completionHandler: { (jsonResponse, error) -> Void in
                                                        
                            if error == nil && jsonResponse? != nil && jsonResponse!.isOk()
                                && (jsonResponse!.userExist() || jsonResponse!.userHasBeenRegistered()) {
                                    
                                    BFRadialWaveHUD.sharedInstance().updateMessage("Download your profil picture...")
                                    
                                    Facade.sharedInstance().uploadUserProfilPicture(profilPicture!, withEmail: email.encodeBase64(),
                                        completionHandler: { () -> Void in
                                            
                                            BFRadialWaveHUD.sharedInstance().showSuccessWithMessage("👍 Logged in !")

                                            let userProfil = jsonResponse!["response"]["profil"]
                                            let schoolRooms = jsonResponse!["response"]["rooms"]

                                            Member.sharedInstance().fillMemberProfilWithJSON(userProfil)
                                            Member.sharedInstance().profilPicture = profilPicture
                                            Facade.sharedInstance().saveMemberProfil()
                                            Facade.sharedInstance().addRoomsFromJSON(schoolRooms)
                                            Facade.sharedInstance().fetchStudentsInsideRoom()

                                            doInMainQueueAfter(seconds: 1.2) {
                                                BFRadialWaveHUD.sharedInstance().dismiss()
                                                self.performSegueWithIdentifier("segueGoToHomeViewFromAuthenticationView", sender: self)
                                            }
                                    })
                                }
                        })
                    }
                    
                } else {
                    BFRadialWaveHUD.sharedInstance().dismiss()
                    JSSAlertView().danger(self, title: "Google+ Authentication", text: "Something went wrong. Please try again later.")
                }
            })
        
        } else {
            BFRadialWaveHUD.sharedInstance().dismiss()
            JSSAlertView().danger(self, title: "Google+ Authentication", text: "Something went wrong. Please try again later.")
        }
    }
    
}
