//
//  GooglAuth.swift
//  Toogether
//
//  Created by Евгений Богачев on 05.07.17.
//  Copyright © 2017 attaractive products. All rights reserved.
//

import Foundation
import Firebase
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import OneSignal
import GoogleSignIn

class GoogleAuth: Loginable {
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    func login(fromViewController:UIViewController) {
        GIDSignIn.sharedInstance().signIn()
        self.activityIndicator.center = fromViewController.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        fromViewController.view.addSubview(self.activityIndicator)
    }
} 
