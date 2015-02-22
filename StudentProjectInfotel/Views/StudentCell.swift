//
//  StudentCell.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 20/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

class MemberCell: UITableViewCell {
    
    @IBOutlet private var profilPicture: UIImageView!
    @IBOutlet private var name: UILabel!
    @IBOutlet private var formation: UILabel!
    
    var member: Member! {
        didSet {
            self.name.text = "\(member.firstName) \(member.lastName)"
            self.formation.text = member.formation
            self.profilPicture.image = member.profilPicture
        }
    }
}
