//
//  RoomHomeViewController.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 18/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import UIKit

/**
  The home view controller for the authenticated users.
  It take care of displaying the list of revisions rooms availables and some others informations
  like the number of students present on theses rooms, rooms descrption, etc ..
*/
class RoomsHomeViewController: UIViewController {
    
    @IBOutlet var roomsTableView: UITableView!
    @IBOutlet var profilPictureButton: UIButton!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBarHidden = false
        self.profilPictureButton.setImage(Member.sharedInstance().profilPicture!, forState: .Normal)
      //  self.sunnyRefreshControl = YALSunnyRefreshControl.attachToScrollView(self.roomsTableView, target: self, refreshAction: "reloadRooms")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - User Interaction -
    
    @IBAction func didClickOnProfilPicture() {
        // TODO: - didClickOnProfilPicture
    }
    
    // MARK: - Storyboard Segues -
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToDetailRoomViewFromRoomsHomeView" {
            
            let detailViewController = segue.destinationViewController as DetailRoomViewController
            let cellSelected = sender as RoomCell
            detailViewController.roomTitle = cellSelected.textLabel!.text
            detailViewController.roomDescription = cellSelected.detailTextLabel!.text
            detailViewController.numberOfStudents = cellSelected.numberOfStudents.text!.toInt()!
        }
    }
}

// MARK: - UITableView Delegate -

extension RoomsHomeViewController: UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("RoomCell") as? RoomCell
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "RoomCell") as? RoomCell
        }
        
        return cell!
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15//BeaconFacade.sharedInstance.rooms().count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as RoomCell).themeColor = UIColor.randomFlatColor()
        (cell as RoomCell).numberOfStudents.text = String(arc4random_uniform(30)+1)
    }
}

