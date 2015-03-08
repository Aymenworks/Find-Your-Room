//
//  SignUpViewController.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 06/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

/**
  SignUpViewController controller. Loaded when the user click on the sign up button. It'll send some user data (photo,
    name, email and password ) to the server and redirect the user to the home view controller.
*/
class SignUpViewController: UIViewController {
    
    @IBOutlet private var profilPictureButton: UIButton!
    @IBOutlet private var firstNameTextField: UITextField!
    @IBOutlet private var lastNameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var formationTextField: UITextField!
    @IBOutlet private var schoolIdTextField: UITextField!
    @IBOutlet private var signUpBarButtonItem: UIBarButtonItem!
    @IBOutlet private var errorLabel: UILabel!
    
    /// Setted lazy because the user can't choose to not send a picture
    lazy private var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }()

    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - User Interaction -
    
    /**
    Called when the user tap on the profil picture. It'll present a native view controller ( by Apple ) 
    containing the user albums photos.
    
    :param: sender not used
    */
    @IBAction func chooseProfilPicture() {
        self.presentViewController(self.imagePickerController, animated: true, nil)
    }
    
    /**
    Called when the user tap on the back bar button item. What's done is clear
    */
    @IBAction func didClickOnBackButton() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    /**
    Called when the user tap on the Join keyboard button ( exposed when focus on password text field ) or the Sign Up bar button item.
    It send an http request to try to sign up the user.
    :param: sender not used
    */
    @IBAction func signUp() {
        
        BFRadialWaveHUD.showInView(self.navigationController!.view, withMessage: "Signing up...")
        self.errorLabel.text = ""
        self.view.endEditing(true)
        
        // Let's do encode inputs and hash the password
        var email     = self.emailTextField.text.encodeBase64()
        var firstName = self.firstNameTextField.text.encodeBase64()
        var lastName  = self.lastNameTextField.text.encodeBase64()
        let formation  = self.formationTextField.text.encodeBase64()
        let schoolId  = self.schoolIdTextField.text.encodeBase64()
        let password  = self.passwordTextField.text.md5()

        Facade.sharedInstance().signUpUserWithPassword( email, password: password, lastName: lastName, firstName: firstName, formation:formation, schoolId: schoolId)
            { (jsonResponse, error) -> Void in
                
            println("response = \(jsonResponse)")
            // If everything is fine..
            if error? == nil && jsonResponse? != nil && jsonResponse!.isOk() {
        
            // If the user has been registered
                if jsonResponse!.userHasBeenRegistered() {
        
                let userProfil = jsonResponse!["response"]["profil"]
                    Member.sharedInstance().fillMemberProfilWithJSON(userProfil)
                    
                    if let imageUserProfil = self.profilPictureButton.backgroundImageForState(.Normal) {
                            Facade.sharedInstance().uploadUserProfilPicture(imageUserProfil, withEmail: email,
                                completionHandler: { () -> Void in
                                    Member.sharedInstance().profilPicture = imageUserProfil
                                    self.userHasSignedUp()
                            })
                        
                    } else {
                        self.userHasSignedUp()
                    }
                   
                // Else if he's already registered..
                } else if jsonResponse!.userExist() {
                    
                    BFRadialWaveHUD.sharedInstance().dismiss()
                    JSSAlertView().info(self,
                        title: "Sign Up",
                        text: "An account with the same email already exists. Please login to your existing account.", buttonText: "Login", cancelButtonText: "Cancel").addAction({ self.didClickOnBackButton()})
                    
                // Else if the user hasn't been registered and doesn't exist on the database..
                } else  if !jsonResponse!.schoolExist() {
                    BFRadialWaveHUD.sharedInstance().dismiss()
                    JSSAlertView().danger(self, title: "Sign Up", text: "The School ID doesn't exist. Please try again.")
                
                } else {
                    self.showPopupSomethingWrong()
                }
        
            // If a problem occured ( the serveur not received the parameters even crash )
            } else {
                self.showPopupSomethingWrong()
            }
        }
    }
    
    // MARK: - User Interface -

    func showPopupSomethingWrong() {
        BFRadialWaveHUD.sharedInstance().dismiss()
        JSSAlertView().danger(self, title: "Sign Up", text: "Something went wrong. Please try again later.")
    }
    
    func userHasSignedUp() {
        BFRadialWaveHUD.sharedInstance().showSuccessWithMessage("👏 Signed up !")
        Facade.sharedInstance().saveMemberProfil()
        
        // And we redirect him on the home view ( x second for sample user experience after the signed up loading )
        doInMainQueueAfter(seconds: 1.2) {
            BFRadialWaveHUD.sharedInstance().dismiss()
            self.performSegueWithIdentifier("segueGoToHomeViewFromSignUpView", sender: self)
        }
    }
    
    // MARK: - Inputs Validation -

    /**
    Check if the user entered its first and last name
    
    :returns: true if the name/lastname textfield aren't empty, false if not
    */
    func hasName() -> Bool {
        return (!self.firstNameTextField.text.isEmpty && !self.lastNameTextField.text.isEmpty)
    }
    
    /**
    Check if the user entered an email address
    
    :returns: true if the email textfield isn't empty, false if not
    */
    func hasValidEmail() -> Bool {
        // TODO: - Regex or something like that to check email
        return (!self.emailTextField.text.isEmpty)
    }
    
    /**
    Check if the user entered a school Id
    
    :returns: true if the email school Id textfield isn't empty, false if not
    */
    func hasSchoolId() -> Bool {
        return (!self.schoolIdTextField.text.isEmpty)
    }
    
    /**
    Check if the user entered a formation
    
    :returns: true if the formation textfield isn't empty, false if not
    */
    func hasFormation() -> Bool {
        return (!self.formationTextField.text.isEmpty)
    }
    
    /**
    Check if the user entered a password composed by at least four characters
    
    :returns: true if the previous condition is valid, false if not
    */
    func hasValidPassword() -> Bool {
        let password = self.passwordTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        return (countElements(password) >= 4)
    }
    
    /**
    Check if an email and password, last name and first name inputs aren't empty 
    and if the password contain at least four characters

    :returns: True  if an input is empty or contains less than four characters, false if not.
    */
    func canSignUpButtonBeEnabled() -> Bool {
        return self.hasName() && self.hasValidEmail() && self.hasSchoolId() && self.hasValidPassword()
            && self.hasFormation()
    }
}

// MARK: - UIImagePicker Delegate -

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.profilPictureButton.setBackgroundImage(image, forState: .Normal)
    }
}

// MARK: - UITextField Delegate -

extension SignUpViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        if textField == self.passwordTextField && string == " "  {
            return false
        }
        
        textField.text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        self.signUpBarButtonItem.enabled = self.canSignUpButtonBeEnabled()
        
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.errorLabel.text = ""
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        self.signUpBarButtonItem.enabled = false
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        /* If the user tap the Next keyboard button, we redirect him to the next text field.
           Else if he tap the Join keyboard button after entering its password, we call 
            the signUp method, if all the inputs are valid.
        */
        switch(textField) {
           
            case self.firstNameTextField:   self.lastNameTextField.becomeFirstResponder()
            case self.lastNameTextField:    self.emailTextField.becomeFirstResponder()
            case self.emailTextField:       self.passwordTextField.becomeFirstResponder()
            case self.passwordTextField:    self.formationTextField.becomeFirstResponder()
            case self.formationTextField:    self.schoolIdTextField.becomeFirstResponder()

            case self.schoolIdTextField:
                if self.canSignUpButtonBeEnabled() {
                    self.signUp()
                }
            
            default: break
        }
        
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}