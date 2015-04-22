//
//  SignUpViewController.swift
//  AymenRebouh
//
//  Created by Rebouh Aymen on 06/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import UIKit

/**
SignUpViewController controller. Loaded when the user click on the sign up button. It'll send some user data (photo,
name, email and password ) to the server and redirect the user to the home view controller.
*/
final class SignUpViewController: UIViewController {
  
  @IBOutlet private weak var profilPictureButton: UIButton!
  @IBOutlet private weak var firstNameTextField: UITextField!
  @IBOutlet private weak var lastNameTextField: UITextField!
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var formationTextField: UITextField!
  @IBOutlet private weak var schoolIdTextField: UITextField!
  @IBOutlet private weak var signUpBarButtonItem: UIBarButtonItem!
  @IBOutlet private weak var errorLabel: UILabel!
  @IBOutlet private weak var formScrollView: UIScrollView!
  
  /// Setted lazy because the user can choose to not send a picture
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
  Called when the user tap on the profil picture. It'll present a native view controller provided by Apple
  containing the user albums photos.
  
  :param: sender not used
  */
  @IBAction private func chooseProfilPicture() {
    self.presentViewController(self.imagePickerController, animated: true, completion: nil)
  }
  
  /**
  Called when the user tap on the back bar button item. What's done is clear
  */
  @IBAction private func didClickOnBackButton() {
    self.navigationController!.popViewControllerAnimated(true)
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    self.view.endEditing(true)
    
    if DeviceInformation.isIphone5OrLess() {
      self.formScrollView.setContentOffset(CGPointZero, animated: true)
    }
  }
  
  /**
  Called when the user tap on the Join keyboard button ( exposed when focus on password text field )
  or the Sign Up bar button item. It send an http request to try to sign up the user.
  :param: sender not used
  */
  @IBAction private func signUp() {
    
    SwiftSpinner.show(NSLocalizedString("signingUp", comment: ""), animated: true)
    self.errorLabel.text = " "
    self.view.endEditing(true)
    
    // Let's do encode inputs and hash the password
    var email     = self.emailTextField.text.encodeBase64()
    var firstName = self.firstNameTextField.text.encodeBase64()
    var lastName  = self.lastNameTextField.text.encodeBase64()
    let formation  = self.formationTextField.text.encodeBase64()
    let schoolId  = self.schoolIdTextField.text.encodeBase64()
    let password  = self.passwordTextField.text.md5()
    
    Facade.sharedInstance.signUpUserWithPassword( email, password: password, lastName: lastName,
      firstName: firstName, formation:formation, schoolId: schoolId)
      { (jsonResponse, error) -> Void in
        
        // If everything is fine..
        if error == nil, let jsonResponse = jsonResponse where jsonResponse.isOk() {
          
          // If the user has been registered
          if jsonResponse.userHasBeenRegistered() {
            
            let userProfil = jsonResponse["response"]["profil"]
            let schoolRooms = jsonResponse["response"]["rooms"]
            
            Member.sharedInstance.fillMemberProfilWithJSON(userProfil)
            Facade.sharedInstance.addRoomsFromJSON(schoolRooms)
            Facade.sharedInstance.fetchPersonsProfilPictureInsideRoom()
            
            if let imageUserProfil = self.profilPictureButton.backgroundImageForState(.Normal) {
              
              Facade.sharedInstance.uploadUserProfilPicture(imageUserProfil, withEmail: email,
                completionHandler: { () -> Void in
                  Member.sharedInstance.profilPicture = imageUserProfil
                  Facade.sharedInstance.saveMemberProfil()
                  
                  self.userHasSignedUp()
              })
              
            } else {
              self.userHasSignedUp()
            }
            
            // Else if he's already registered..
          } else if jsonResponse.userExist() {
            
            SwiftSpinner.hide()
            JSSAlertView().info(self,
              title: self.navigationItem.title!,
              text: NSLocalizedString("emailExistError", comment: ""),
              buttonText: NSLocalizedString("login", comment: ""), cancelButtonText: NSLocalizedString("cancel", comment: "")).addAction({ self.didClickOnBackButton()})
            
            // Else if the user hasn't been registered and doesn't exist on the database..
          } else  if !jsonResponse.schoolExist() {
            SwiftSpinner.hide()
            JSSAlertView().danger(self, title: self.navigationItem.title!, text: NSLocalizedString("schoolIdError", comment: ""))
            
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
  
  private func showPopupSomethingWrong() {
    SwiftSpinner.hide()
    JSSAlertView().danger(self, title: self.navigationItem.title!, text: NSLocalizedString("genericError", comment: ""))
  }
  
  private func userHasSignedUp() {
    SwiftSpinner.show(NSLocalizedString("signedUp", comment: ""), animated: false)
    Facade.sharedInstance.saveMemberProfil()
    
    // And we redirect him on the home view ( x second for sample user experience after the signed up loading )
    doInMainQueueAfter(seconds: 1.2) {
      SwiftSpinner.hide()
      self.performSegueWithIdentifier("segueGoToHomeViewFromSignUpView", sender: self)
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
  Check if the user entered an email address
  
  :returns: true if the email textfield isn't empty, false if not
  */
  private func hasValidEmail() -> Bool {
    // REGEX FROM http://stackoverflow.com/questions/3139619/check-that-an-email-address-is-valid-on-ios
    let regex = ".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*"
    return NSPredicate(format: "SELF MATCHES[c] %@", regex).evaluateWithObject(self.emailTextField.text)
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
    return (count(password) >= 4)
  }
  
  /**
  Check if an email and password, last name and first name inputs aren't empty
  and if the password contain at least four characters
  
  :returns: True  if an input is empty or contains less than four characters, false if not.
  */
  private func canSignUpButtonBeEnabled() -> Bool {
    return self.hasName() && self.hasValidEmail() && self.hasSchoolId() && self.hasValidPassword()
      && self.hasFormation()
  }
}

// MARK: - UIImagePicker Delegate -

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!,
    editingInfo: [NSObject : AnyObject]!) {
      
      self.dismissViewControllerAnimated(true, completion: nil)
      self.profilPictureButton.setBackgroundImage(image, forState: .Normal)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    println("cancel")
  }
}

// MARK: - UITextField Delegate -

extension SignUpViewController: UITextFieldDelegate {
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
    replacementString string: String) -> Bool {
      
      if textField == self.passwordTextField && string == " "  {
        return false
      }
      
      textField.text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
      self.signUpBarButtonItem.enabled = self.canSignUpButtonBeEnabled()
      
      return false
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    self.errorLabel.text = " "
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
      
    case self.firstNameTextField:
      self.lastNameTextField.becomeFirstResponder()
      
    case self.lastNameTextField:
      self.emailTextField.becomeFirstResponder()
      if DeviceInformation.isIphone5OrLess() {
        self.formScrollView.setContentOffset(CGPointMake(0.0, 40.0), animated: true)
      }
      
    case self.emailTextField:
      self.passwordTextField.becomeFirstResponder()
      if DeviceInformation.isIphone5OrLess() {
        self.formScrollView.setContentOffset(CGPointMake(0.0, 80.0), animated: true)
      }
      
    case self.passwordTextField:
      self.formationTextField.becomeFirstResponder()
      if DeviceInformation.isIphone5OrLess() {
        self.formScrollView.setContentOffset(CGPointMake(0.0, 126.0), animated: true)
      }
      
    case self.formationTextField:
      self.schoolIdTextField.becomeFirstResponder()
      
    case self.schoolIdTextField:
      
      if self.canSignUpButtonBeEnabled() {
        self.signUp()
        
      } else {
        textField.resignFirstResponder()
        let alertView = JSSAlertView().show(self, title: self.navigationItem.title!,
          text: NSLocalizedString("signUp.fillAllFields", comment: ""))
        alertView.setTextTheme(.Dark)
      }
      
    default:
      break
    }
    
    return true
  }
}