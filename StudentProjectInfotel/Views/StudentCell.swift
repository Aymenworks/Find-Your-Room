//
//  StudentCell.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 20/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

class StudentCell: UITableViewCell {
    
    @IBOutlet private var profilPicture: UIImageView!
    @IBOutlet private var name: UILabel!
    @IBOutlet private var formation: UILabel!
    
    var student: Student! {
        didSet {
            self.name.text = "\(student.firstName!) \(student.lastName!)"
            self.formation.text = student.formation!
            self.profilPicture.image = student.profilPicture
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "downloadImage:", name: "DownloadImageNotification", object: nil)
        }
    }

    func downloadImage(notification: NSNotification) {
        println("downloadImage l'image de \(self.student.fullName()) = \(self.student.profilPicture)")
        self.profilPicture.image = self.student.profilPicture
    }
}
