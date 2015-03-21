//
//  AddRoomViewController.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 16/03/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import UIKit

class AddRoomViewController: UIViewController {

    @IBOutlet private var roomTitleTextField: UITextField!
    @IBOutlet private var roomDescriptionTextField: UITextView!
    @IBOutlet private var roomCapacityTextField: UITextField!
    @IBOutlet private var beaconUUIDTextField: UITextField!
    @IBOutlet private var beaconMajorTextField: UITextField!
    @IBOutlet private var beaconMinorValueTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var addRoomButton: UIButton!
    
    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("addRoom", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Interaction -
    
    /**
    Called when the user tap on the back bar button item. What's done is clear
    */
    @IBAction func didClickOnBackButton() {
        self.navigationController!.popViewControllerAnimated(true)
    }

    @IBAction func addRoom() {
        
        BFRadialWaveHUD.showInView(self.navigationController!.view, withMessage: NSLocalizedString("addingRoom", comment: ""))
        self.view.endEditing(true)
        
        var schoolId     =  Member.sharedInstance().schoolId!
        var roomTitle = self.roomTitleTextField.text
        var roomDescription  = self.roomDescriptionTextField.text
        let roomCapacity  = self.roomCapacityTextField.text.toInt()!
        let beaconUUID  = self.beaconUUIDTextField.text
        let beaconMajor = self.beaconMajorTextField.text.toInt()!
        let beaconMinor = self.beaconMinorValueTextField.text.toInt()!
        
        Facade.sharedInstance().addRoom(schoolId, roomTitle: roomTitle.encodeBase64(), roomDescription: roomDescription.encodeBase64(),
            roomCapacity: roomCapacity, beaconUUID: beaconUUID, beaconMajor: beaconMajor, beaconMinor: beaconMinor) {
                (jsonResponse, error) -> Void in
                
                if error == nil && jsonResponse != nil && jsonResponse!.isOk() {
                    let schoolRooms = jsonResponse!["response"]["rooms"]
                    Facade.sharedInstance().addRoomsFromJSON(schoolRooms)
                    BFRadialWaveHUD.sharedInstance().dismiss()
                    self.navigationController!.popViewControllerAnimated(true)
                } else {
                    JSSAlertView().warning(self, title: NSLocalizedString("oops", comment: ""),
                        text: NSLocalizedString("genericError", comment: ""))
                }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.addRoomButton.enabled = self.canAddRoomButtonBeEnabled()
        self.view.endEditing(true)
    }
    
    // MARK: - Inputs Validation -

    func hasRoomInformations() -> Bool {
        return (!self.roomTitleTextField.text.isEmpty && !self.roomDescriptionTextField.text.isEmpty
            && !self.roomCapacityTextField.text.isEmpty)
    }
    
    /**
    Check if the user entered a correct uuid
    
    :returns: true if the email school Id textfield isn't empty, false if not
    */
    func hasCorrectBeaconUUID() -> Bool {
        let regex = "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"
        return NSPredicate(format: "SELF MATCHES[c] %@", regex)!.evaluateWithObject(self.beaconUUIDTextField.text)
    }
    
    /**
    Check if the user entered a major and minor identifier for the beacon
    
    :returns: true if the formation textfield isn't empty, false if not
    */
    func hasMajorAndMinorValue() -> Bool {
        return (!self.beaconMajorTextField.text.isEmpty && !self.beaconMinorValueTextField.text.isEmpty)
    }

    func canAddRoomButtonBeEnabled() -> Bool {
        return self.hasRoomInformations() && self.hasCorrectBeaconUUID() && self.hasMajorAndMinorValue()
    }
}

// MARK: - UITextField Delegate -

extension AddRoomViewController: UITextFieldDelegate {

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            
            textField.text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            self.addRoomButton.enabled = self.canAddRoomButtonBeEnabled()
            
            return false
    }

    func textFieldShouldClear(textField: UITextField) -> Bool {
        self.addRoomButton.enabled = false
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        /* If the user tap the Next keyboard button, we redirect him to the next text field.
        Else if he tap the Join keyboard button after entering its password, we call
        the signUp method, if all the inputs are valid.
        */
        switch(textField) {
            
            case self.roomTitleTextField:   self.roomDescriptionTextField.becomeFirstResponder()
            case self.roomDescriptionTextField:    self.roomCapacityTextField.becomeFirstResponder()
            case self.roomCapacityTextField:    self.beaconUUIDTextField.becomeFirstResponder()
            case self.beaconUUIDTextField:
                self.errorLabel.text = self.hasCorrectBeaconUUID() ? "" : NSLocalizedString("checkBeaconUUID", comment: "")
                self.beaconMajorTextField.becomeFirstResponder()
            
            case self.beaconMajorTextField:    self.beaconMinorValueTextField.becomeFirstResponder()
                
            case self.beaconMinorValueTextField:
                if self.canAddRoomButtonBeEnabled() {
                    self.addRoom()
                } else {
                    textField.resignFirstResponder()
                    let alertView = JSSAlertView().show(self, title: NSLocalizedString("addRoom", comment: ""), text: NSLocalizedString("fillAllFields", comment: ""))
                    alertView.setTextTheme(.Dark)
                }
            
            default: break
        }
        
        return true
    }
}
