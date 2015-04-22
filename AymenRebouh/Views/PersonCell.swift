//
//  PersonCell.swift
//  AymenRebouh
//
//  Created by Rebouh Aymen on 20/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import UIKit

final class PersonCell: UITableViewCell {
  
  @IBOutlet private weak var profilPicture: UIImageView!
  @IBOutlet private weak var name: UILabel!
  @IBOutlet private weak var formation: UILabel!
  
  final var person: Person! {
    didSet {
      self.name.text = "\(person.firstName) \(person.lastName)"
      self.formation.text = person.formation!
      self.profilPicture.image = person.profilPicture
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageDownloaded:", name: "DownloadImageNotification", object: nil)
    }
  }
  
  // MARK: - Lifecycle -
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  // MARK: - NSNotification Image Downloaded -
  
  final func imageDownloaded(notification: NSNotification) {
    self.profilPicture.image = self.person.profilPicture
  }
}
