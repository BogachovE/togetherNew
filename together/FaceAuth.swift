//
//  FaceAuth.swift
//  Toogether
//
//  Created by Евгений Богачев on 05.07.17.
//  Copyright © 2017 attaractive products. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import OneSignal

class FaceAuth: Loginable {
    var fromViewController : UIViewController!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    func login(fromViewController:UIViewController) {
        self.fromViewController = fromViewController
        let loginManager = LoginManager()
        loginManager.loginBehavior = LoginBehavior.native;
        
        loginManager.logIn([.publicProfile, .email], viewController: fromViewController) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.activityIndicator.center = fromViewController.view.center
                self.activityIndicator.hidesWhenStopped = true
                self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                fromViewController.view.addSubview(self.activityIndicator)
                
                self.activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                print("Logged in \(grantedPermissions) \(declinedPermissions) \(accessToken)")
                self.returnUserData()
            }
        }
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                OneSignal.idsAvailable({(_ userNotifId, _ pushToken) in
                    let user = UserModel()
                    user.setId(newId: UInt64(((result as! NSDictionary).value(forKey: "id"))as! String)!)
                    user.name = (result as! NSDictionary).value(forKey: "name") as! String
                    user.notificationId = userNotifId!
                    MainUserRepo.shared.readReturnedUser(user: user)
                        .then{ result -> Void in
                            if (result){
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                self.fromViewController.performSegue(withIdentifier: "fromLoginToMain", sender: self)
                            }
                    }
                })
                
            }
        })
    }

}
