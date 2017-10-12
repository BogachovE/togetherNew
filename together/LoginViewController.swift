//
//  LoginViewController.swift
//  together
//
//  Created by ASda Bogasd on 15.01.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import OneSignal
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate  {
    
    @IBOutlet weak var passwordEdit: UITextField!
    @IBOutlet weak var emailEdit: UITextField!
    @IBOutlet weak var rememberMe: UIButton!
    
    var authManager: AuthManager = AuthManager()
    var myAccessToken: String!
    var pass: String!
    
    override func viewDidAppear(_ animated: Bool) {
        
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func fbPressed(_ sender: Any) {
        authManager.changeLoginType(type: FaceAuth())
        authManager.login(fromViewController: self)

    }
    
    @IBAction func donePressed(_ sender: Any) {
        standartLogin()
    }
    
    @IBAction func forgetPasswordPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Forget my password", message: "Plese enter your email", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addTextField { (emailTextView) in
            
        }
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                let textField = alert.textFields![0]
                self.findPassword(email: textField.text)
                FIRAuth.auth()?.sendPasswordReset(withEmail: textField.text!) { (error) in
                    if (error == nil) {
                        Toaster.makeToast(text: "We send you a mail", view: self)
                    }
                }
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
    }
    
    func standartLogin(){
        authManager.changeLoginType(type: StandartAuth(email: emailEdit.text!, password: passwordEdit.text!))
        authManager.login(fromViewController: self)
    }
    
    func findPassword(email: String!)  {
//            let emailQuery = ref.child("users").queryOrdered(byChild: "email").queryEqual(toValue: email)
//        emailQuery.observeSingleEvent(of: .value, with: {(snapshot) in
//            for item in snapshot.children {
//                let child = item as! FIRDataSnapshot
//                let dict = child.value as! NSDictionary
//                self.pass = dict.value(forKey: "password") as! String
//                print(dict.value(forKey: "password")!)
//            }
//            
//        })
   
    }
    
    
    
    @IBAction func googlePressed(_ sender: Any) {
        authManager.changeLoginType(type: GoogleAuth())
        authManager.login(fromViewController: self)
    }
    @IBAction func logout(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
   
    }
    
    func setUpViews(){
        underlined()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func underlined(){
        let borderBottom = CALayer()
        let borderBottom2 = CALayer()
        let borderWidth = CGFloat(2.0)
        
        borderBottom.borderColor = UIColor.gray.cgColor
        borderBottom.frame = CGRect(x: 0, y: emailEdit.frame.height - 1.0, width: emailEdit.frame.width , height: emailEdit.frame.height - 1.0)
        borderBottom.borderWidth = borderWidth
        
        borderBottom2.borderColor = UIColor.gray.cgColor
        borderBottom2.frame = CGRect(x: 0, y: passwordEdit.frame.height - 1.0, width: passwordEdit.frame.width , height: passwordEdit.frame.height - 1.0)
        borderBottom2.borderWidth = borderWidth
        
        emailEdit.layer.addSublayer(borderBottom)
        emailEdit.layer.masksToBounds = true
        passwordEdit.layer.addSublayer(borderBottom2)
        passwordEdit.layer.masksToBounds = true
    }

    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
