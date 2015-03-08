//
//  RoomListViewController.swift
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
class RoomsListViewController: UIViewController {
    
    @IBOutlet private var roomsTableView: UITableView!
    @IBOutlet private var profilPictureButton: UIButton!
    @IBOutlet private var noResultsView: UIView!
    private var roomsFound: Bool  {
        return !Facade.sharedInstance().rooms().isEmpty
    }


    lazy private var profilMenuTableView: YALContextMenuTableView! = {
        
        let menu: YALContextMenuTableView  = YALContextMenuTableView(tableViewDelegateDataSource: self)
        let cellNib = UINib(nibName: "ContextMenuCell", bundle: nil)
        menu.animationDuration = 0.15
        menu.scrollEnabled = false
        menu.registerNib(cellNib, forCellReuseIdentifier: "ProfilMenuCell")
        
        return menu
    }()
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBarHidden = false
        self.profilPictureButton.setImage(Member.sharedInstance().profilPicture!, forState: .Normal)
        self.roomsTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.roomsFound {
            self.roomsTableView.hidden = true
            self.noResultsView.hidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - User Interaction -
    
    @IBAction func didClickOnProfilPicture() {
        self.profilMenuTableView.showInView(self.view, withEdgeInsets: UIEdgeInsetsZero, animated: true)
    }
    
    // MARK: - Storyboard Segues -
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToRoomDetailViewFromRoomsListView" {
            
            let detailViewController = segue.destinationViewController as RoomDetailViewController
            let cellSelected = sender as RoomCell
            detailViewController.roomTitle = cellSelected.room.title
            detailViewController.roomDescription = cellSelected.room.roomDescription
            detailViewController.numberOfStudents = cellSelected.room.numberOfStudents
        }
    }
}

// MARK: - UITableView Delegate -

extension RoomsListViewController: UITableViewDelegate, UITableViewDataSource, YALContextMenuTableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let customCell: UITableViewCell = {
            
            if tableView == self.profilMenuTableView {
                
                var cell = tableView.dequeueReusableCellWithIdentifier("ProfilMenuCell", forIndexPath: indexPath) as? ContextMenuCell
                if cell == nil {
                    cell = UITableViewCell(style: .Default, reuseIdentifier: "ProfilMenuCell") as? ContextMenuCell
                }
                
                cell!.menuTitleLabel.text = "Like Friend"
                return cell!
                
            } else {
                
                var cell: RoomCell?
                cell = tableView.dequeueReusableCellWithIdentifier("RoomCell", forIndexPath: indexPath)  as? RoomCell
                if cell == nil {
                    cell = UITableViewCell(style: .Default, reuseIdentifier: "RoomCell") as? RoomCell
                }
                
                cell!.room = Facade.sharedInstance().rooms()[indexPath.row]
                cell!.themeColor = UIColor.randomFlatColor()
                return cell!
            }
        }()
        
        return customCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roomsFound ? Facade.sharedInstance().rooms().count : 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView == self.profilMenuTableView ? CGFloat(65.0) : CGFloat(71.0)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let tableView = tableView as? YALContextMenuTableView {
            tableView.dismisWithIndexPath(indexPath)
        }
    }
    
    func contextMenuTableView(contextMenuTableView: YALContextMenuTableView!, didDismissWithIndexPath indexPath: NSIndexPath!) {
        println("index selected = \(indexPath.row)")
    }
    
}

