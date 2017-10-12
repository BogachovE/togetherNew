//
//  MainUserRepo.swift
//  together
//
//  Created by Евгений Богачев on 23.08.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import Foundation
import PromiseKit
import Firebase
final class MainUserRepo {
    
    // Can't init is singleton
    private init() { }
    
    // MARK: Shared Instance
    
    static let shared = MainUserRepo()
    
    // MARK: Local Variable
    
    var user  = UserModel()
    var credential: FIRAuthCredential!
    
    func getUser() -> UserModel {
        return self.user
    }
    
    func setUser(newUser: UserModel) {
        self.user = newUser
        saveDefaultUser(userId: newUser.getId())
    }
    
    func isUserDefaultExist() -> Bool {
        let userId = UserDefaults.standard.object(forKey: "userId")
        if (userId == nil || userId as! UInt64 == 0) {
            return false
        } else {
            user.setId(newId: UInt64((userId as! NSNumber).int64Value))
            return true
        }
    }
    
    func getCurrentUser(userId: UInt64) -> Promise<UserModel> {
        return Promise<UserModel>{ fulfill, reject in
            UserRes.getCurrentUser(userId: userId)
                .then{ user in
                    fulfill(user)
            }
        }
    }
    
    func loadDefaultUser() -> Promise<UserModel> {
        return Promise<UserModel>{ fulfill, reject in
            if (isUserDefaultExist()){
                UserRes.getCurrentUser(userId: user.getId())
                    .then{ user in
                        fulfill(user)
                }
            } else {
                reject(NSError(domain: "Can't load Default", code: 100, userInfo: nil))
            }
        }
    }
    
    func readReturnedUser(user: UserModel) -> Promise<Bool> {
        return Promise<Bool> { fulfill, reject in
           return UserRes.getCurrentUserInfoByEmail(email: user.getEmail())
                .then{ user ->Void in
                    self.saveDefaultUser(userId: user.getId())
                    self.setUser(newUser: user)
                    fulfill(true)
                }
                .catch{ error in
                    self.setUser(newUser: user)
                    UserRepo.addNewUser(user: user)
                        .then{ user -> Void in
                            MainUserRepo.shared.setUser(newUser: user)
                            self.saveDefaultUser(userId: user.getId())
                            fulfill(true)
                    }
            }
        }
    }
    
    func getCurrentUserByEmail(email: String) -> Promise<UserModel> {
        return Promise<UserModel>{fulfill, reject in
            UserRes.getCurrentUserInfoByEmail(email: email)
                .then{ user in
                    fulfill(user)
                }
                .catch{_ in
                    
            }
        }
    }

    
    func readGoogleReturnedUser(user: UserModel) -> Promise<Bool> {
        return Promise<Bool>{fulfill, reject in
            return UserRes.getCurrentUserInfoByEmail(email: user.getEmail())
                .then{ user ->Void in
                    self.saveDefaultUser(userId: user.getId())
                    self.setUser(newUser: user)
                    fulfill(true)
                }
                .catch{ error in
                    self.setUser(newUser: user)
                    UserRepo.addNewUser(user: user)
                    self.saveDefaultUser(userId: user.getId())
                    fulfill(true)
            }
            
        }
    }

    
    func saveDefaultUser(userId: UInt64){
        UserDefaults.standard.set(NSNumber(value: userId), forKey: "userId")
        UserDefaults.standard.synchronize()
    }
    
    func removeDefaultUser(){
        let defaults = UserDefaults.standard
        if let bundle = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: "com.products.attractive.togetherr")
            defaults.synchronize()
        }
    }
    
    func subscribePresed(userId: UInt64) {
        user.subscribePressed(userId: userId)
        UserRes.updateUser(user: user)
    }
    
    func getCredential() -> FIRAuthCredential {
        return credential
    }
    
    func setCredential(_credential: FIRAuthCredential){
        self.credential = _credential
    }
    
}
