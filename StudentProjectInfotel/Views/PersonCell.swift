//
//  PersonCell.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 20/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

class PersonCell: UITableViewCell {
    
    @IBOutlet private var profilPicture: UIImageView!
    @IBOutlet private var name: UILabel!
    @IBOutlet private var formation: UILabel!
    
    var person: Person! {
        didSet {
            self.name.text = "\(person.firstName!) \(person.lastName!)"
            self.formation.text = person.formation!
            self.profilPicture.image = person.profilPicture
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "downloadImage:", name: "DownloadImageNotification", object: nil)
        }
    }

    func downloadImage(notification: NSNotification) {
        println("downloadImage l'image de \(self.person.fullName()) = \(self.person.profilPicture)")
        self.profilPicture.image = self.person.profilPicture
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
