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
class RoomDetailViewController: UIViewController {
    
    // Not setted private because used in the RoomsListViewController at the prepare for segue event
    // See `RoomsListViewController`
    var room: Room!
    
    @IBOutlet private var personsTableView: UITableView!
    @IBOutlet private var roomTitleLabel: UILabel!
    @IBOutlet private var roomDescriptionLabel: UILabel!
    @IBOutlet private var numberOfPersonsLabel: UILabel!
    @IBOutlet var noPersonsFoundView: UIView!
    private var personsFound: Bool  {
        return !self.room.persons.isEmpty
    }

    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.personsTableView.tableFooterView = UIView() // remove the empty lines at the end of the table view
        self.title = self.room.title
        // The room propertu has been setted on the prepare for segue. See `RoomsListViewController`
        self.roomTitleLabel.text = self.room.title
        self.roomDescriptionLabel.text = self.room.roomDescription
        self.numberOfPersonsLabel.text = String(self.room.persons.count)
        
        if !self.personsFound {
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let customCell: PersonCell = {
            
           var cell = tableView.dequeueReusableCellWithIdentifier("PersonCell") as? PersonCell
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "PersonCell") as? PersonCell
            }
                
            cell!.person = self.room.persons[indexPath.row]
            
            return cell!
        }()
        
        return customCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.room.persons.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(60.0)
    }
}


