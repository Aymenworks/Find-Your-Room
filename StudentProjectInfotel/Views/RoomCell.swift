//
//  BeaconCell.swift
//  iBeaconForgotMeNot
//
//  Created by Rebouh Aymen on 20/12/2014.
//  Copyright (c) 2014 Rebouh Aymen. All rights reserved.
//

class RoomCell: UITableViewCell {
    
    @IBOutlet var numberOfStudents: UILabel!
    @IBOutlet var leftColorView: UIView!
    
    var themeColor: UIColor!  {
        didSet {
            self.textLabel!.textColor = themeColor
            self.leftColorView.backgroundColor = themeColor
        }
    }
    
    var room: Room! {
        didSet {
            self.textLabel!.text = room.title
            self.detailTextLabel!.text = room.roomDescription
            let numberOfStudents = String(self.room.students.count)
            let capacity = (room.capacity == nil) ? "" : "/\(room.capacity!)"
            self.numberOfStudents.text = numberOfStudents + capacity
        }
    }
}
