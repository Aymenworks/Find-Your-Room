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
        
        println("bounds room list = \(self.view.bounds)")

        self.navigationController!.navigationBarHidden = false
        self.profilPictureButton.setImage(Member.sharedInstance().profilPicture!, forState: .Normal)
        self.roomsTableView.tableFooterView = UIView()
       
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
        self.profilMenuTableView.showInView(self.navigationController!.view, withEdgeInsets: UIEdgeInsetsZero, animated: true)
    }
    

    // MARK: - Storyboard Segues -
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToRoomDetailViewFromRoomsListView" {
            
            let detailViewController = segue.destinationViewController as RoomDetailViewController
            let cellSelected = sender as RoomCell
            detailViewController.room = cellSelected.room
        }
    }
}

// MARK: - UITableView Delegate -

extension RoomsListViewController: UITableViewDelegate, UITableViewDataSource, YALContextMenuTableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Member.sharedInstance().schoolName!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let customCell: UITableViewCell = {
            
            if tableView == self.profilMenuTableView {
                
                var cell = tableView.dequeueReusableCellWithIdentifier("ProfilMenuCell", forIndexPath: indexPath) as? ContextMenuCell
                if cell == nil {
                    cell = UITableViewCell(style: .Default, reuseIdentifier: "ProfilMenuCell") as? ContextMenuCell
                }
                
                cell!.menuTitleLabel.text = (Facade.sharedInstance().memberMenu()[indexPath.row]["title"] as String)
                let image = UIImage(data: Facade.sharedInstance().memberMenu()[indexPath.row]["thumbnail"] as NSData, scale: 2.0)
                cell!.menuImageView.image = image

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
        return tableView == self.profilMenuTableView ? Facade.sharedInstance().memberMenu().count :  Facade.sharedInstance().rooms().count
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

