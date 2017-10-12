//
//  settingsViewController.swift
//  together
//
//  Created by ASda Bogasd on 24.01.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit

class settingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var photo: UIImageView!
    @IBOutlet var editDescription: UITextField!
    @IBOutlet var editTitle: UITextField!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet var editPhoneNumber: UITextField!
    @IBOutlet var editUserName: UITextField!
    @IBOutlet weak var editEmail: UITextField!
    
    var oldEmail: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainUserRepo.shared.getCurrentUser(userId: MainUserRepo.shared.getUser().getId())
            .then{ user -> Void in
                 MainUserRepo.shared.setUser(newUser: user)
                self.setUpView()
        }
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photo.image = selectedImage
        
        
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func userUpdate(){
        //        let userRepositories:UserRepositories = UserRepositories()
        //        userRepositories.loadUser(userId: UInt64(myId), withh: { (user) in
        //            let newUser: User
        //            newUser = user
        //            if(self.editUserName.text! != ""){newUser.name = self.editUserName.text!}
        //            if(self.editDescription.text! != ""){newUser.description = self.editDescription.text!}
        //            if(self.editTitle.text! != ""){newUser.title = self.editTitle.text!}
        //            if(self.editEmail.text! != ""){newUser.email = self.editEmail.text!}
        //            if (self.editEmail.text != ""){
        //            FIRAuth.auth()?.currentUser?.updateEmail(self.editEmail.text!) { (error) in
        //                // ...
        //                if (error != nil){ print("ERRORCHANGEEMAIL =", error!)}
        //            }
        //            }
        //            if (self.editPassword.text != ""){
        //            FIRAuth.auth()?.currentUser?.updatePassword(self.editPassword.text!) { (error) in
        //                // ...
        //                if (error != nil){ print("ERRORCHANGEPASSWORD =", error!)}
        //            }
        //            }
        //            if(self.editPhoneNumber.text! != ""){newUser.phone = self.editPhoneNumber.text!}
        //            //if(photo.image! != photo.image){newUser.name = photo.image!}
        //            //if(editPassword.text! != ""){newUser. = editPassword.text!}
        //            let userDictionary = UserMaper.userToDictionary(user: newUser)
        //            self.ref.child("users/" + String(self.myId)).setValue(userDictionary)
        //        })
    }
    
    
    
    //Actions
    @IBAction func logOutPressed(sender: AnyObject) {
        let defaults = UserDefaults.standard
        
        if let bundle = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: "com.products.attractive.togetherr")
            defaults.synchronize()
        }
        self.performSegue(withIdentifier: "fromSettingsToLogin", sender: self)
    }
    
    @IBAction func editPhotoPressed(sender: AnyObject) {
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
    
    @IBAction func changePassword(_ sender: Any) {
        let alert = UIAlertController(title: "Change password", message: "Please enter a valid email and password", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.text = MainUserRepo.shared.getUser().getEmail()
        }
        alert.addTextField { (textField) in
            textField.text = "Old password"
        }
        alert.addTextField { (textField) in
            textField.text = "New password"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
            let newUser = MainUserRepo.shared.getUser()
            newUser.setEmail(newEmail: (alert.textFields?[0].text!)!)
            UserRes.updatePass(email: (alert.textFields?[0].text!)!,
                               oldPass: (alert.textFields?[1].text!)!,
                               newPass: (alert.textFields?[2].text!)!,
                               oldUser: newUser,
                               view: self
            )
                .then{_ in
               self.performSegue(withIdentifier: "fromSettingsToFeed", sender: self)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeEmail(_ sender: Any) {
        let alert = UIAlertController(title: "Change password", message: "Please enter a valid email and password", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.text = "New email"
        }
        alert.addTextField { (textField) in
            textField.text = "Password"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
            let newUser = MainUserRepo.shared.getUser()
            UserRes.setNewEmail(oldEmail: MainUserRepo.shared.getUser().getEmail(),
                                newEmail:(alert.textFields?[0].text!)!,
                               pssword: (alert.textFields?[1].text!)!,
                               oldUser: newUser,
                               view: self
            )
                .then{_ in
                    self.performSegue(withIdentifier: "fromSettingsToFeed", sender: self)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //email: String, pssword: String,oldUser: UserModel, view: UIViewController
    @IBAction func saveButttonPressed(sender: AnyObject) {
        readNewUserFromView(user: MainUserRepo.shared.getUser())
            .then{ newUser -> Void in
                MainUserRepo.shared.setUser(newUser: newUser)
                UserRepo.updateUser(user: newUser)
                    .then{ result -> Void in
                        if (result){
                            self.performSegue(withIdentifier: "fromSettingsToFeed", sender: self)
                        }
                    }
                    .catch{ error in
                        Toaster.makeToast(text: error.localizedDescription, view: self)
                }
        }
        
    }
    
    
    
    //        userUpdate()
    //        ref = FIRDatabase.database().reference()
    //        let storage = FIRStorage.storage()
    //        storageRef = storage.reference(forURL: "gs://together-df2ce.appspot.com")
    //
    //        let data = photo.image!.jpeg(.lowest)
    //        if let imageData = photo.image!.jpeg(.lowest) {
    //            print(imageData.count)
    //        }
    //        let riversRef = storageRef.child("avatars/"+String(describing: myId)+".jpg")
    //        let uploadTask = riversRef.put(data!, metadata: nil) { (metadata, error) in
    //            guard let metadata = metadata else {
    //                // Uh-oh, an error occurred!
    //                return
    //            }
    //            // Metadata contains file metadata such as size, content-type, and download URL.
    //            let downloadURL = metadata.downloadURL
    //        }
    //        let observer = uploadTask.observe(.success) { snapshot in
    //            self.performSegue(withIdentifier: "fromSettingsToFeed", sender: self)
    //        }
    
    //   }
    
    func setUpView(){
        let user = MainUserRepo.shared.getUser()
        self.photo.layer.cornerRadius = self.photo.frame.size.width / 2;
        self.photo.clipsToBounds = true;
        self.photo.layer.borderWidth = 1.0
        self.photo.layer.borderColor = UIColor.white.cgColor
        self.photo.image = user.getPhoto()
        if ( user.getDescription() != ""){
            self.editDescription.text! = user.getDescription()
        }
        if ( user.getTitle() != ""){
            self.editTitle.text! = user.getTitle()
        }
        if ( user.getPhone() != ""){
            self.editPhoneNumber.text! = user.getPhone()
        }
        if ( user.getName() != ""){
            self.editUserName.text! = user.getName()
        }
        
        editEmail.text = user.getEmail()
        
    }
    
    func readNewUserFromView(user: UserModel) -> Promise<UserModel>{
        return Promise<UserModel>{ fulfill, reject in
                        if ( self.editDescription.text! != ""){
                            user.setDescription(newDescription: self.editDescription.text!)
                        }
                        
                        if ( self.editTitle.text! != ""){
                            user.setTitle(newTitle: self.editTitle.text!)
                        }
                        
                        
                        if ( self.editPhoneNumber.text! != ""){
                            user.setPhone(newPhone: self.editPhoneNumber.text!)
                        }
                        if ( self.editUserName.text! != "" ){
                            user.setName(newName: self.editUserName.text!)
                        }
                        
                        user.setPhoto(newPhoto: self.photo.image!)
                        fulfill(user)
                    }
        }
}





