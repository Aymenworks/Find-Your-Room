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
    var roomTitle: String!
    var roomDescription: String!
    var numberOfStudents: Int!
    
    @IBOutlet private var memberTableView: UITableView!
    @IBOutlet private var roomTitleLabel: UILabel!
    @IBOutlet private var roomDescriptionLabel: UILabel!
    @IBOutlet private var numberOfStudentsLabel: UILabel!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.memberTableView.tableFooterView = UIView() // remove the empty lines at the end of the table view
        
        // The properties has been setted on the prepare for segue. See `RoomsListViewController`
        self.roomTitleLabel.text = self.roomTitle
        self.roomDescriptionLabel.text = self.roomDescription
        self.numberOfStudentsLabel.text = String(self.numberOfStudents)
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

extension RoomDetailViewController: UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let customCell: UITableViewCell = {
            
            var cell: UITableViewCell?
            
            if indexPath.row % 2 == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier("MemberCell") as? MemberCell
                if cell == nil {
                    cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "MemberCell") as MemberCell
                }
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("SeparatorCell") as? UITableViewCell
                if cell == nil {
                    cell = UITableViewCell(style: .Default, reuseIdentifier: "SeparatorCell")
                }
            }
            
            return cell!
        }()
        
        return customCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return  indexPath.row % 2 == 0 ? CGFloat(60.0) : CGFloat(14.0)
    }
}


