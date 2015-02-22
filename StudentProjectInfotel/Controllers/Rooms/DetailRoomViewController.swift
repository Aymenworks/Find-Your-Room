//
//  DetailRoomViewController.swift
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
class DetailRoomViewController: UIViewController {
    
    var roomTitle: String!
    var roomDescription: String!
    var numberOfStudents: Int!
    
    @IBOutlet private var memberTableView: UITableView!
    @IBOutlet var roomTitleLabel: UILabel!
    @IBOutlet var roomDescriptionLabel: UILabel!
    @IBOutlet var numberOfStudentsLabel: UILabel!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.memberTableView.tableFooterView = UIView()
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

extension DetailRoomViewController: UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MemberCell") as? MemberCell
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "MemberCell") as? MemberCell
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}


