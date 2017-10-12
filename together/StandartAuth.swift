//
//  StandartAuth.swift
//  Toogether
//
//  Created by Евгений Богачев on 05.07.17.
//  Copyright © 2017 attaractive products. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class StandartAuth: Loginable {
    var email: String!
    var password: String!
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    func login(fromViewController:UIViewController) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (usser, error) in
            if (usser != nil) {
                print(usser?.email! as Any)
                
                MainUserRepo.shared.getCurrentUserByEmail(email: self.email)
                    .then{ user -> Void in
                        MainUserRepo.shared.setUser(newUser: user)
                        fromViewController.performSegue(withIdentifier: "fromLoginToMain", sender: fromViewController)
                }
            }
            if (error != nil) {
                print(error!)
                Toaster.makeToast(text: "Incorect email", view: fromViewController)
            }
            
        }
        
    }
}
