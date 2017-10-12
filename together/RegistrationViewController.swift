//
//  ViewController.swift
//  together
//
//  Created by ASda Bogasd on 12.01.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import UIKit
import Firebase
import OneSignal



class RegistratonViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var editUserName: UITextField!
    @IBOutlet weak var editPhoneNumber: UITextField!
    @IBOutlet weak var editEmail: UITextField!
    @IBOutlet weak var editPassword: UITextField!
    @IBOutlet weak var photoEdit: UIImageView!

    
    var activeTextField = UITextField()
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == editUserName) {
            editPhoneNumber.becomeFirstResponder()
        } else if (textField == editPhoneNumber) {
            editEmail.becomeFirstResponder()
        }else if (textField == editEmail) {
            editPassword.becomeFirstResponder()
        } else { dismissKeyboard()
                    }
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        editUserName.delegate = self
        editPhoneNumber.delegate = self
        editEmail.delegate = self
        editPassword.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
    
  
    @IBAction func donePressed(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: editEmail.text!, password: editPassword.text!, completion: { (user: FIRUser?, error) in
            if error == nil {
                print("successful")
                self.addnewUser()
            }else{
                print("failure" ,error?.localizedDescription)
                Toaster.makeToast(text: (error?.localizedDescription)!, view: self)
            }
        })
        
      
    }
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoEdit.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

    
    func underlined(){
        let borderBottom = CALayer()
        let borderBottom2 = CALayer()
        let borderBottom3 = CALayer()
        let borderBottom4 = CALayer()
        let borderWidth = CGFloat(2.0)
       
        borderBottom.borderColor = UIColor.gray.cgColor
        borderBottom.frame = CGRect(x: 0, y: editUserName.frame.height - 1.0, width: editUserName.frame.width , height: editUserName.frame.height - 1.0)
        borderBottom.borderWidth = borderWidth
        
        borderBottom2.borderColor = UIColor.gray.cgColor
        borderBottom2.frame = CGRect(x: 0, y: editUserName.frame.height - 1.0, width: editUserName.frame.width , height: editUserName.frame.height - 1.0)
        borderBottom2.borderWidth = borderWidth
        
        borderBottom3.borderColor = UIColor.gray.cgColor
        borderBottom3.frame = CGRect(x: 0, y: editUserName.frame.height - 1.0, width: editUserName.frame.width , height: editUserName.frame.height - 1.0)
        borderBottom3.borderWidth = borderWidth

        borderBottom4.borderColor = UIColor.gray.cgColor
        borderBottom4.frame = CGRect(x: 0, y: editUserName.frame.height - 1.0, width: editUserName.frame.width , height: editUserName.frame.height - 1.0)
        borderBottom4.borderWidth = borderWidth

        
        editUserName.layer.addSublayer(borderBottom2)
        editUserName.layer.masksToBounds = true
        editEmail.layer.addSublayer(borderBottom3)
        editEmail.layer.masksToBounds = true
        editPassword.layer.addSublayer(borderBottom4)
        editPassword.layer.masksToBounds = true
        editPhoneNumber.layer.addSublayer(borderBottom)
        editPhoneNumber.layer.masksToBounds = true
    }
    
    @IBAction func editPhotoPressed(_ sender: Any) {
        // Hide the keyboard.
        //        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
       func addnewUser(){
        OneSignal.idsAvailable({(_ userId, _ pushToken) in
            print("UserId:\(userId)")
            if pushToken != nil {
                print("pushToken:\(pushToken)")
            }
            let user = UserModel(name: self.editUserName.text!, email: self.editEmail.text!, phone: self.editPhoneNumber.text!, photo: self.photoEdit.image!, notificationId: userId!)
            MainUserRepo.shared.readReturnedUser(user: user)
                .then{ _ -> Void in
                    MainUserRepo.shared.setUser(newUser: user)
                 self.performSegue(withIdentifier: "fromRegisterToMain", sender: self)
            }
                .catch{_ in 
                    Toaster.makeToast(text: "sorry", view: self)
            }
           
        })
        
    }
    
    func setUpView() {
        underlined()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        self.photoEdit.layer.cornerRadius = self.photoEdit.frame.size.width / 2;
        self.photoEdit.clipsToBounds = true;
        self.photoEdit.layer.borderWidth = 1.0
        self.photoEdit.layer.borderColor = UIColor.white.cgColor

    }
}

