//
//  StartViewController.swift
//  together
//
//  Created by Евгений Богачев on 23.08.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MainUserRepo.shared.loadDefaultUser()
            .then{ user -> Void in
                MainUserRepo.shared.setUser(newUser: user)
                self.performSegue(withIdentifier: "startToFeed", sender: self)
            }
            .catch{error in
                self.performSegue(withIdentifier: "startToLogin", sender: self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}
