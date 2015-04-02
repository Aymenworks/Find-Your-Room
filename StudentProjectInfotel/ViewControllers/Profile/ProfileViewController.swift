//
//  ProfileViewController.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 13/03/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var profilPictureButton: UIButton!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var formationTextField: UITextField!
    @IBOutlet private weak var schoolIdTextField: UITextField!
    @IBOutlet private weak var updateProfilButton: UIButton!
    @IBOutlet private weak var formScrollView: UIScrollView!
    
    /// Setted lazy because the user can choose to not send a picture
    lazy private var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profilPictureButton.setBackgroundImage(Member.sharedInstance().profilPicture, forState: .Normal)
        self.profilPictureButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.firstNameTextField.text = Member.sharedInstance().firstName!
        self.lastNameTextField.text = Member.sharedInstance().lastName!
        self.formationTextField.text = Member.sharedInstance().formation!
        self.schoolIdTextField.text = Member.sharedInstance().schoolId!
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
    
    @IBAction func didClickOnBackButton(sender: UIBarButtonItem) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func updateUserAccount() {
        
        BFRadialWaveHUD.showInView(self.navigationController!.view, withMessage: NSLocalizedString("profilUpdate", comment: ""))
        self.view.endEditing(true)
        
        // Let's do encode inputs and hash the password
        var email     =  Member.sharedInstance().email!
        var firstName = self.firstNameTextField.text
        var lastName  = self.lastNameTextField.text
        let formation  = self.formationTextField.text
        let schoolId  = self.schoolIdTextField.text
        let password = self.passwordTextField.text
        
        Facade.sharedInstance().updateUserAccount( email.encodeBase64(), password: password.md5(),
            lastName: lastName.encodeBase64(), firstName: firstName.encodeBase64(),
            formation:formation.encodeBase64(), schoolId: schoolId.encodeBase64()) { (jsonResponse, error) -> Void in
                
            // If everything is fine..
            if error == nil && jsonResponse != nil && jsonResponse!.isOk() {
                
                // If the user profile has been updated
                if jsonResponse!["response"]["profilUpdateSuccess"].boolValue {
                    
                    Member.sharedInstance().firstName = firstName
                    Member.sharedInstance().lastName = lastName
                    Member.sharedInstance().email = email
                    Member.sharedInstance().formation = formation
                    Member.sharedInstance().schoolId = schoolId
                    Facade.sharedInstance().saveMemberProfil()

                    let schoolRooms = jsonResponse!["response"]["rooms"]
                    Facade.sharedInstance().addRoomsFromJSON(schoolRooms)
                    Facade.sharedInstance().fetchPersonsProfilPictureInsideRoom()
                    
                    if let imageUserProfil = self.profilPictureButton.backgroundImageForState(.Normal) {
                        Facade.sharedInstance().uploadUserProfilPicture(imageUserProfil, withEmail: Member.sharedInstance().email!.encodeBase64(),
                            completionHandler: { () -> Void in
                                Member.sharedInstance().profilPicture = imageUserProfil
                                Facade.sharedInstance().saveMemberProfil()
                                self.userHasUpdatedProfil()
                        })
                        
                    } else {
                        self.userHasUpdatedProfil()
                    }
                    
               } else if !jsonResponse!.schoolExist() {
                    
                    BFRadialWaveHUD.sharedInstance().dismiss()
                    JSSAlertView().danger(self, title: NSLocalizedString("profile", comment: ""), text: NSLocalizedString("schoolIdError", comment: ""))
                    
                } else {
                    self.showPopupSomethingWrong()
                }
                
                // If a problem occured ( the serveur not received the parameters even crash )
            } else {
                self.showPopupSomethingWrong()
            }
        }

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        self.updateProfilButton.enabled = self.canUpdateButtonBeEnabled()
        
        if DeviceInformation.isIphone5() {
            self.formScrollView.setContentOffset(CGPointZero, animated: true)
        }
    }
    
    // MARK: - User Interface -
    
    private func showPopupSomethingWrong() {
        BFRadialWaveHUD.sharedInstance().dismiss()
        JSSAlertView().danger(self, title: NSLocalizedString("profile", comment: ""), text: NSLocalizedString("genericError", comment: ""))
    }
    
    private func userHasUpdatedProfil() {
        BFRadialWaveHUD.sharedInstance().showSuccessWithMessage(NSLocalizedString("profileUpdated", comment: ""))
        
        // And we redirect him on the home view ( x second for sample user experience after the update profil loading )
        doInMainQueueAfter(seconds: 1.2) {
            BFRadialWaveHUD.sharedInstance().dismiss()
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // MARK: - Inputs Validation -
    
    /**
    Check if the user entered its first and last name
    
    :returns: true if the name/lastname textfield aren't empty, false if not
    */
    private func hasName() -> Bool {
        return (!self.firstNameTextField.text.isEmpty && !self.lastNameTextField.text.isEmpty)
    }
    
    /**
    Check if the user entered a school Id
    
    :returns: true if the email school Id textfield isn't empty, false if not
    */
    private func hasSchoolId() -> Bool {
        return (!self.schoolIdTextField.text.isEmpty)
    }
    
    /**
    Check if the user entered a formation
    
    :returns: true if the formation textfield isn't empty, false if not
    */
    private func hasFormation() -> Bool {
        return (!self.formationTextField.text.isEmpty)
    }
    
    /**
    Check if the user entered a password composed by at least four characters
    
    :returns: true if the previous condition is valid, false if not
    */
    private func hasValidPassword() -> Bool {
        let password = self.passwordTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        return (countElements(password) >= 4)
    }
    
    /**
    Check if an email and password, last name and first name inputs aren't empty
    and if the password contain at least four characters
    
    :returns: True  if an input is empty or contains less than four characters, false if not.
    */
    private func canUpdateButtonBeEnabled() -> Bool {
        return self.hasName() && self.hasSchoolId() && self.hasValidPassword()
            && self.hasFormation()
    }

}

// MARK: - UITextField Delegate -

extension ProfileViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            
        if textField == self.passwordTextField && string == " "  {
            return false
        }
            
        textField.text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        self.updateProfilButton.enabled = self.canUpdateButtonBeEnabled()
            
        return false
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        self.updateProfilButton.enabled = false
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        /* If the user tap the Next keyboard button, we redirect him to the next text field.
        Else if he tap the Join keyboard button after entering its password, we call
        the signUp method, if all the inputs are valid.
        */
        switch(textField) {
            
        case self.firstNameTextField:   self.lastNameTextField.becomeFirstResponder()
        case self.lastNameTextField:    self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:    self.formationTextField.becomeFirstResponder()
        case self.formationTextField:    self.schoolIdTextField.becomeFirstResponder()
            
        case self.schoolIdTextField:
            if self.canUpdateButtonBeEnabled() {
                self.updateUserAccount()
                
            } else {
                textField.resignFirstResponder()
                let alertView = JSSAlertView().show(self, title: NSLocalizedString("profile", comment: ""), text: "Please fill in all the fields.")
                alertView.setTextTheme(.Dark)
            }
            
        default: break
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) -> Bool {
        
        // If that's an iPhone 5/5s/5c
        if DeviceInformation.isIphone5() {
            
            if textField == self.passwordTextField {
                self.formScrollView.setContentOffset(CGPointMake(0.0, 40.0), animated: true)
            
            } else if textField == self.firstNameTextField || textField == self.lastNameTextField {
                self.formScrollView.setContentOffset(CGPointZero, animated: true)
            }
        }
        
        return true
    }
}

// MARK: - UIImagePicker Delegate -

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!,
        editingInfo: [NSObject : AnyObject]!) {
            
            self.dismissViewControllerAnimated(true, completion: nil)
            self.profilPictureButton.setBackgroundImage(image, forState: .Normal)
    }
}