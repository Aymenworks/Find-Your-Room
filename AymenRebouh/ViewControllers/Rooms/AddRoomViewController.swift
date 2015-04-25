//
//  AddRoomViewController.swift
//  AymenRebouh
//
//  Created by Rebouh Aymen on 16/03/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import UIKit

final class AddRoomViewController: UIViewController {
  
  @IBOutlet private weak var roomTitleTextField: UITextField!
  @IBOutlet private weak var roomDescriptionTextView: UITextView!
  @IBOutlet private weak var roomCapacityTextField: UITextField!
  @IBOutlet private weak var beaconUUIDTextField: UITextField!
  @IBOutlet private weak var beaconMajorTextField: UITextField!
  @IBOutlet private weak var beaconMinorValueTextField: UITextField!
  @IBOutlet private weak var errorLabel: UILabel!
  @IBOutlet private weak var addRoomButton: UIButton!
  @IBOutlet private weak var formScrollView: UIScrollView!
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = NSLocalizedString("addRoom", comment: "")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - User Interaction -
  
  /**
  Called when the user tap on the back bar button item. What's done is clear
  */
  @IBAction private func didClickOnBackButton() {
    self.navigationController!.popViewControllerAnimated(true)
  }
  
  @IBAction func didClickOnHideKeyboard(sender: UIBarButtonItem) {
    if self.beaconUUIDTextField.isFirstResponder() {
      self.errorLabel.text = self.hasCorrectBeaconUUID() ? " " : NSLocalizedString("checkBeaconUUID", comment: "")
    }
    self.view.endEditing(true)
    self.formScrollView.setContentOffset(CGPointZero, animated: true)
  }
  
  @IBAction private func addRoom() {
    
    SwiftSpinner.show( NSLocalizedString("addingRoom", comment: ""), animated: true)
    self.view.endEditing(true)
    
    let schoolId        =  Member.sharedInstance.schoolId
    let roomTitle       = self.roomTitleTextField.text
    let roomDescription = self.roomDescriptionTextView.text
    let roomCapacity    = self.roomCapacityTextField.text.toInt()!
    let beaconUUID      = self.beaconUUIDTextField.text
    let beaconMajor     = self.beaconMajorTextField.text.toInt()!
    let beaconMinor     = self.beaconMinorValueTextField.text.toInt()!
    
    Facade.sharedInstance.addRoom(schoolId!, roomTitle: roomTitle.encodeBase64(),
      roomDescription: roomDescription.encodeBase64(),
      roomCapacity: roomCapacity, beaconUUID: beaconUUID,
      beaconMajor: beaconMajor, beaconMinor: beaconMinor) { jsonResponse, error in
        
        if error == nil, let jsonResponse = jsonResponse where jsonResponse.isOk() {
          
          let schoolRooms = jsonResponse["response"]["rooms"]
          Facade.sharedInstance.addRoomsFromJSON(schoolRooms)
          SwiftSpinner.hide()
          self.navigationController!.popViewControllerAnimated(true)
          
        } else {
          JSSAlertView().warning(self, title: NSLocalizedString("oops", comment: ""),
            text: NSLocalizedString("genericError", comment: ""))
        }
    }
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    
    self.addRoomButton.enabled = self.canAddRoomButtonBeEnabled()
    self.view.endEditing(true)
    
    if DeviceInformation.isIphone5OrLess() {
      self.formScrollView.setContentOffset(CGPointZero, animated: true)
    }
  }
  
  // MARK: - Inputs Validation -
  
  private func hasRoomInformations() -> Bool {
    return !self.roomTitleTextField.text.isEmpty && !self.roomDescriptionTextView.text.isEmpty
      && !self.roomCapacityTextField.text.isEmpty
  }
  
  /**
  Check if the user entered a correct uuid ( in uppercase )
  
  :returns: true if the email school Id textfield isn't empty, false if not
  */
  private func hasCorrectBeaconUUID() -> Bool {
    let regex = "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"
    return NSPredicate(format: "SELF MATCHES[c] %@", regex).evaluateWithObject(self.beaconUUIDTextField.text)
  }
  
  /**
  Check if the user entered a major and minor identifier for the beacon
  
  :returns: true if the formation textfield isn't empty, false if not
  */
  private func hasMajorAndMinorValue() -> Bool {
    return !self.beaconMajorTextField.text.isEmpty && !self.beaconMinorValueTextField.text.isEmpty
  }
  
  private func canAddRoomButtonBeEnabled() -> Bool {
    return self.hasRoomInformations() && self.hasCorrectBeaconUUID() && self.hasMajorAndMinorValue()
  }
}

// MARK: - UITextField Delegate -

extension AddRoomViewController: UITextFieldDelegate {
  
  private struct TextFieldRules {
    static let MaxUUIDCharacter = 36
    static let MaxMajorMinorCharacter = 5
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
    replacementString string: String) -> Bool {
      
      if textField == self.beaconUUIDTextField && count(textField.text) == TextFieldRules.MaxUUIDCharacter
        && string != "" {
          return false
      }
      
      textField.text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
      
      if textField == self.beaconMinorValueTextField && count(textField.text) == TextFieldRules.MaxMajorMinorCharacter {
        textField.resignFirstResponder()
        
      } else if textField == self.beaconMajorTextField &&  count(textField.text) == TextFieldRules.MaxMajorMinorCharacter {
        self.beaconMinorValueTextField.becomeFirstResponder()
      }
      
      self.addRoomButton.enabled = self.canAddRoomButtonBeEnabled()
      
      return false
  }
  
  func textFieldShouldClear(textField: UITextField) -> Bool {
    self.addRoomButton.enabled = false
    return true
  }
  
  func textFieldDidBeginEditing(textField: UITextField)  {
    if DeviceInformation.isIphone5OrLess() {
      self.formScrollView.setContentOffset(CGPoint(x: 0.0, y: 72.0), animated: true)
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    
    /* If the user tap the Next keyboard button, we redirect him to the next text field.
    Else if he tap the Join keyboard button after entering its password, we call
    the signUp method if all the inputs are valid.
    */
    switch(textField) {
      
    case self.roomTitleTextField:
      self.roomDescriptionTextView.becomeFirstResponder()
      
    case self.roomDescriptionTextView:
      self.roomCapacityTextField.becomeFirstResponder()
      
    case self.roomCapacityTextField:
      self.beaconUUIDTextField.becomeFirstResponder()
      
    case self.beaconUUIDTextField:
      self.errorLabel.text = self.hasCorrectBeaconUUID() ? " " : NSLocalizedString("checkBeaconUUID", comment: "")
      self.beaconMajorTextField.becomeFirstResponder()
      
    case self.beaconMajorTextField:
      self.beaconMinorValueTextField.becomeFirstResponder()
      
    case self.beaconMinorValueTextField:
      
      if self.canAddRoomButtonBeEnabled() {
        self.addRoom()
        
      } else {
        textField.resignFirstResponder()
        let alertView = JSSAlertView().show(self,
          title: NSLocalizedString("addRoom", comment: ""), text: NSLocalizedString("fillAllFields", comment: ""))
        alertView.setTextTheme(.Dark)
      }
      
    default:
      break
    }
    
    return true
  }
}

// MARK: - UITextView Delegate -

extension AddRoomViewController: UITextViewDelegate {
  
  func textViewDidBeginEditing(textView: UITextView) {
    if DeviceInformation.isIphone5OrLess() && self.formScrollView.contentOffset == CGPointZero {
      self.formScrollView.setContentOffset(CGPoint(x: 0.0, y: 71.0), animated: true)
    }
  }
}
