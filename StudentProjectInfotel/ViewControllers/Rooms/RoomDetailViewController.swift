//
//  RoomDetailViewController.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 19/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import UIKit

/**
The detail home view controller where more information about a room can be find.
It take care of displaying the list of students presents on this room and some others informations
like the number of students present on theses rooms, room descrption, etc ..
*/
final class RoomDetailViewController: UIViewController {
    
    @IBOutlet private weak var personsTableView: UITableView!
    @IBOutlet private weak var roomTitleLabel: UILabel!
    @IBOutlet private weak var roomDescriptionLabel: UILabel!
    @IBOutlet private weak var numberOfPersonsLabel: UILabel!
    @IBOutlet private weak var noPersonsFoundView: UIView!
    
    // Not setted private because used in the RoomsListViewController at the prepare for segue event
    // See `RoomsListViewController`
    var room: Room!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = self.room.title
        
        // The room property has been setted on the prepare for segue. See `RoomsListViewController`
        self.roomTitleLabel.text = self.room.title
        self.roomDescriptionLabel.text = self.room.roomDescription
        self.numberOfPersonsLabel.text = String(self.room.persons.count)
        
        if !self.room.persons.isEmpty {
            self.personsTableView.hidden = true
            self.noPersonsFoundView.hidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - User Interaction -
    
    @IBAction func didClickOnBackButton(sender: UIBarButtonItem) {
        self.navigationController!.popViewControllerAnimated(true)
    }
}

// MARK: - UITableView Delegate -

extension RoomDetailViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("studentPresent", comment: "")
    }
    
    private struct Storyboard {
        static let cellReuseIdenifier = "PersonCell"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cellReuseIdenifier, forIndexPath: indexPath) as! PersonCell
        cell.person = self.room.persons[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.room.persons.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(60.0)
    }
}


