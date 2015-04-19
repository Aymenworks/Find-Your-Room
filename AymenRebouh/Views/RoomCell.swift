//
//  BeaconCell.swift
//  iBeaconForgotMeNot
//
//  Created by Rebouh Aymen on 20/12/2014.
//  Copyright (c) 2014 Rebouh Aymen. All rights reserved.
//

import UIKit

final class RoomCell: UITableViewCell {
    
    @IBOutlet private weak var numberOfPersons: UILabel!
    @IBOutlet private weak var leftColorView: UIView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var roomDescription: UILabel!
    
    var themeColor: UIColor!  {
        didSet {
            self.textLabel!.textColor = themeColor
            self.leftColorView.backgroundColor = themeColor
        }
    }
    
    var room: Room! {
        didSet {
            self.title!.text = room.title
            self.roomDescription!.text = room.roomDescription
            let numberOfPersons = String(self.room.persons.count)
            let capacity = (room.capacity == nil) ? "" : "/\(room.capacity!)"
            self.numberOfPersons.text = numberOfPersons + capacity
        }
    }
    
}
