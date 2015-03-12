//
//  ProfilViewController.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 10/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

class ProfilViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    @IBOutlet var profil: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("userInfo = \(Member.sharedInstance())")
        self.profil.image = Member.sharedInstance().profilPicture
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}