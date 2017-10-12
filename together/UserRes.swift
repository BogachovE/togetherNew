    //
    //  UserRes.swift
    //  together
    //
    //  Created by Евгений Богачев on 23.08.17.
    //  Copyright © 2017 Attractive Products. All rights reserved.
    //
    
    import Foundation
    import PromiseKit
    import Firebase
    
    
    class UserRes {
        static func getCurrentUser(userId: UInt64) -> Promise<UserModel>{
            return Promise{ fulfill, reject in
                getCurrentUserInfo(userId: userId)
                    .then{ user in
                        return getUserImage(user: user)
                    }
                    .then{ user -> Void in
                        fulfill(user)
                    }
                    .catch{ error in
                        reject(error)
                }
            }
        }
        
        static func getCurrentUserInfo(userId: UInt64) -> Promise<UserModel> {
            return Promise{ fulfill, reject in
                let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
                ref.child("users").child(String(userId)).observeSingleEvent(of: .value, with: { (snapshot) in
                    if(snapshot.exists()){
                        let value = snapshot.value as? [String:AnyObject]
                        fulfill(UserModel(aDict: value!))
                    } else {
                        reject(NSError(domain: "User didn't find", code: 101, userInfo: nil))
                    }
                })
            }
        }
        
        static func getCurrentUserInfoByEmail(email: String) -> Promise<UserModel> {
            return Promise{ fulfill, reject in
                let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
                let userQuery = ref.child("users").queryOrdered(byChild: "email").queryEqual(toValue: email)
                userQuery.observeSingleEvent(of: .value, with: { (snapshot) in
                    if (snapshot.exists()){
                        var userDict: NSDictionary
                        if let dict = snapshot.value as? NSDictionary {
                            for child in dict {
                                userDict = child.value as! NSDictionary
                                fulfill(UserModel(aDict: userDict as! [String : AnyObject]))
                            }
                        } else {
                            let dict = snapshot.value as! NSArray
                            userDict = dict[0] as! NSDictionary
                            fulfill(UserModel(aDict: userDict as! [String : AnyObject]))
                        }
                        
                    } else {
                        reject(NSError(domain: "User didn't find", code: 101, userInfo: nil))
                    }
                })
            }
        }
        
        static func getUserImage(user: UserModel) -> Promise<UserModel> {
            return Promise{fulfill, reject in
                let storageRef = FIRStorage.storage().reference(forURL: "gs://together-df2ce.appspot.com")
                let riversRef = storageRef.child("avatars/\(user.getId()).jpg")
                riversRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        reject(error)
                        fulfill(user)
                    } else {
                        user.photo = UIImage(data: data!)!
                        fulfill(user)
                    }
                }
            }
        }
        
        static func findUserByEmail(email: String) -> Promise<UserModel> {
            return Promise{ fulfill, reject in
                return getCurrentUserInfoByEmail(email: email)
                    .then{ user in
                        fulfill(user)
                    }
                    .catch{ error in
                        reject(error)
                }
            }
        }
        
        static func addNewUser(user: UserModel) {
            let newUser = UserModelMapper.userToDictionary(user: user)
            let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
            ref.child("users/\(user.getId())").setValue(newUser)
            getUserCount()
                .then{ count in
                    ref.child("users/count").setValue(count + 1)
            }
            
        }
        
        static func getUserCount() -> Promise<Int> {
            return Promise{ fulfill, reject in
                let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
                ref.child("users/count").observeSingleEvent(of: .value, with:{ snaphot in
                    if (snaphot.exists()){
                        fulfill(snaphot.value as! Int)
                    } else {
                        reject(NSError(domain: "Could not load users count", code: 102, userInfo: nil))
                    }
                })
            }
            
        }
        
        static func addUserImage(user: UserModel) -> Promise<Bool> {
            return Promise<Bool>{fulfill, reject in
                let ref = FIRDatabase.database().reference()
                let storage = FIRStorage.storage()
                let storageRef = storage.reference(forURL: "gs://together-df2ce.appspot.com")
                let data = UIImageJPEGRepresentation(user.getPhoto(), 0.1)//UIImagePNGRepresentation(user.getPhoto())
                let riversRef = storageRef.child("avatars/"+String(describing: user.getId())+".jpg")
                let uploadTask = riversRef.put(data!, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    if (error != nil){
                        reject(error!)
                    }
                    let downloadURL = metadata.downloadURL
                    if (data != nil){
                        fulfill(true)
                    }
                }
            }
        }
        
        static func updateUser(user: UserModel) -> Promise<Bool> {
            return Promise{ fulfill, reject in
                updateUserInfo(user: user)
                    .then{ user in
                        return addUserImage(user: user)
                    }
                    .then{ ready in
                        fulfill(ready)
                    }
                    .catch{ error in
                        reject(error)
                }
                
            }
        }
        
        static func updateUserInfo(user: UserModel) -> Promise<UserModel> {
            return Promise<UserModel> { fulfill, reject in
                let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
                ref.child("users/\(user.getId())").setValue(UserModelMapper.userToDictionary(user: user))
                fulfill(user)
            }
        }
        
        
        
        static func updatePass(email: String,
                               oldPass: String,
                               newPass: String,
                               oldUser: UserModel,
                               view: UIViewController
            ) -> Promise<Bool>{
            return Promise{fulfill, reject in
                let user =  FIRAuth.auth()?.currentUser
                let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: oldPass)
                user?.reauthenticate(with: credential) { error in
                    if (error != nil){
                        if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                            
                            switch errCode {
                            case .errorCodeInvalidEmail:
                                Toaster.makeToast(text: "Please enter correct mail adress", view: view.self)
                            case .errorCodeEmailAlreadyInUse:
                                Toaster.makeToast(text: "This adress in use", view: view.self)
                            case .errorCodeWrongPassword:
                                Toaster.makeToast(text: "Wrong Password", view: view.self)
                            case .errorCodeUserNotFound:
                                let alert = UIAlertController(title: "User not found", message: "creat it?", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                    FIRAuth.auth()?.createUser(withEmail: email, password: newPass, completion: { (_user: FIRUser?, error) in
                                        if error == nil {
                                            print("successful")
                                            self.addNewUser(user: oldUser)
                                            MainUserRepo.shared.setUser(newUser: oldUser)
                                            fulfill(true)
                                        }else{
                                            print("failure" ,error?.localizedDescription)
                                            Toaster.makeToast(text: (error?.localizedDescription)!, view: view)
                                        }
                                    })
                                    
                                }))
                                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                                view.present(alert, animated: true, completion: nil)
                            case .errorCodeUserMismatch:
                                Toaster.makeToast(text: "It is not your account", view: view.self)
                            default: print("Create User Error: \(error)")
                            }
                        }} else {
                        FIRAuth.auth()?.currentUser?.updatePassword(newPass) { (error) in
                            if (error != nil){
                                reject(error!)
                                print("Updating Pass error: \(error?.localizedDescription)")
                            } else {
                                fulfill(true)
                            }
                        }
                    }
                }
            }
        }
        
        static func setNewEmail(oldEmail: String, newEmail:String, pssword: String,oldUser: UserModel, view: UIViewController) -> Promise<Bool> {
            return Promise{ fulfill, reject in
                let user =  FIRAuth.auth()?.currentUser
                let credential = FIREmailPasswordAuthProvider.credential(withEmail: oldEmail, password: pssword)
                user?.reauthenticate(with: credential) { error in
                    if (error != nil){
                        if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                            
                            switch errCode {
                            case .errorCodeInvalidEmail:
                                Toaster.makeToast(text: "Please enter correct mail adress", view: view.self)
                            case .errorCodeEmailAlreadyInUse:
                                Toaster.makeToast(text: "This adress in use", view: view.self)
                            case .errorCodeWrongPassword:
                                Toaster.makeToast(text: "Wrong Password", view: view.self)
                            case .errorCodeUserNotFound:
                                let alert = UIAlertController(title: "User not found", message: "creat it?", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                    FIRAuth.auth()?.createUser(withEmail: newEmail, password: pssword, completion: { (_user: FIRUser?, error) in
                                        if error == nil {
                                            print("successful")
                                            oldUser.setEmail(newEmail: newEmail)
                                            self.addNewUser(user: oldUser)
                                            MainUserRepo.shared.setUser(newUser: oldUser)
                                            fulfill(true)
                                        }else{
                                            print("failure" ,error?.localizedDescription)
                                            Toaster.makeToast(text: (error?.localizedDescription)!, view: view)
                                        }
                                    })
                                    
                                }))
                                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                                view.present(alert, animated: true, completion: nil)
                                case .errorCodeUserMismatch:
                                Toaster.makeToast(text: "It is not your account", view: view.self)
                                default: print("Create User Error: \(error)")
                                }
                            }} else {
                            FIRAuth.auth()?.currentUser?.updateEmail(newEmail) { (error) in
                                if (error != nil){
                                    reject(error!)
                                    print("Updating Pass error: \(error?.localizedDescription)")
                                } else {
                                    oldUser.setEmail(newEmail: newEmail)
                                    MainUserRepo.shared.setUser(newUser: oldUser)
                                    UserRes.updateUser(user: oldUser)
                                        .then{ _ in
                                            fulfill(true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }
