//
//  AuthManager.swift
//  Toogether
//
//  Created by Евгений Богачев on 06.07.17.
//  Copyright © 2017 attaractive products. All rights reserved.
//

import Foundation
import UIKit

class AuthManager {
    var authStrategy: Loginable

    init() {
        self.authStrategy = StandartAuth(email: "nope", password: "nope")
    }
    
    
    func login(fromViewController : UIViewController) {
        self.authStrategy.login(fromViewController: fromViewController)
    }
    
    func changeLoginType(type: Loginable) {
        self.authStrategy = type
    }
    
    init(authStrategy: Loginable) {
        self.authStrategy = authStrategy
    }

}
