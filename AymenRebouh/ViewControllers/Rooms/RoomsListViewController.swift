//
//  RoomListViewController.swift
//  AymenRebouh
//
//  Created by Rebouh Aymen on 18/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import UIKit

/**
<#Description#>

- Profile: <#Profile description#>
- Logout:  <#Logout description#>
*/
private enum MenuAction: Int {
  case Profile = 0
  case Logout
}

/**
The home view controller for the authenticated users.
It take care of displaying the list of revisions rooms availables and some others informations
like the number of students present on theses rooms, rooms descrption, etc ..
*/
final class RoomsListViewController: UIViewController {
  
  @IBOutlet private weak var roomsTableView: UITableView!
  @IBOutlet private weak var addRoomButton: UIButton!
  
  lazy private var menu: MenuView = {
    
    let menu = MenuView(frame: nil)
    menu.backgroundColor = UIColor(red: 25.0/255, green: 26.0/255, blue: 37.0/255, alpha: 1.0)
    menu.delegate = self
    
    let items = Facade.sharedInstance.memberMenu().map() {
      MenuItem(image: UIImage(data: $0["thumbnail"] as! NSData)!)
    }
    
    menu.items = items
    
    return menu
    }()
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController!.navigationBarHidden = false
    self.roomsTableView.tableFooterView = UIView()
    self.roomsTableView.addSubview(menu)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.roomsTableView.reloadData()
    self.addRoomButton.hidden = !Facade.sharedInstance.isUserAdmin()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - User Interaction -
  
  @IBAction private func showMenu(sender: UIBarButtonItem) {
    self.menu.setRevealed(!self.menu.revealed, animated: true)
  }
  
  @IBAction private func refreshRooms(sender: UIBarButtonItem) {
    
    BFRadialWaveHUD.showInView(self.navigationController!.view, withMessage: NSLocalizedString("roomsUpdate", comment: ""))
    
    Facade.sharedInstance.roomsBySchoolId(Member.sharedInstance.schoolId!.encodeBase64(),
      completionHandler: { (jsonSchoolRooms, error) -> Void in
        
        if error == nil, let jsonSchoolRooms = jsonSchoolRooms where jsonSchoolRooms.isOk() {
          let schoolRooms = jsonSchoolRooms["response"]["rooms"]
          Facade.sharedInstance.addRoomsFromJSON(schoolRooms)
          Facade.sharedInstance.fetchPersonsProfilPictureInsideRoom()
          self.roomsTableView.reloadData()
          BFRadialWaveHUD.sharedInstance().dismiss()
          
        } else {
          BFRadialWaveHUD.sharedInstance().dismiss()
          JSSAlertView().danger(self, title: self.navigationItem.title!,
            text: NSLocalizedString("genericError", comment: ""))
        }
    })
  }
  
  // MARK: - Storyboard Segues -
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "goToRoomDetailViewFromRoomsListView" {
      let detailViewController = segue.destinationViewController as! RoomDetailViewController
      let cellSelected = sender as! RoomCell
      detailViewController.room = cellSelected.room
    }
  }
}

// MARK: - NavigationMenu Delegate -

extension RoomsListViewController: MenuViewDelegate {
  
  func menu(menu: MenuView, didSelectItemAtIndex index: Int) -> Void {
    
    let menuAction = MenuAction(rawValue: index)
    
    switch(menuAction!) {
    case .Profile:
      self.performSegueWithIdentifier("goToProfileViewFromRoomListVew", sender: self)
      
    case .Logout:
      let alertView = JSSAlertView().show(self,
        title: NSLocalizedString("logout.title", comment: ""),
        text: NSLocalizedString("logout.message", comment: ""),
        buttonText: NSLocalizedString("yes", comment: ""), cancelButtonText: NSLocalizedString("cancel", comment: ""))
      
      alertView.setTextTheme(.Dark)
      alertView.addAction({
        Facade.sharedInstance.logOut()
        FBSession.activeSession().closeAndClearTokenInformation()
        self.navigationController!.popToRootViewControllerAnimated(true)
      })
    }
  }
}

// MARK: - UITableView Delegate -

extension RoomsListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  private struct Storyboard {
    static let cellReuseIdenifier = "RoomCell"
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cellReuseIdenifier, forIndexPath: indexPath) as! RoomCell
    cell.room = Facade.sharedInstance.rooms()[indexPath.row]
    cell.themeColor = UIColor.randomFlatColor()
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Facade.sharedInstance.rooms().count
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return CGFloat(71.0)
  }
  
}

