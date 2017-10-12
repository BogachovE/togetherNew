//
//  UserRepo.swift
//  together
//
//  Created by Евгений Богачев on 25.08.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import Foundation
import PromiseKit
class UserRepo {
    static func addNewUser(user: UserModel) -> Promise<UserModel> {
        return Promise { fulfill, reject in
            if (user.getId() != 0) {
                UserRes.addNewUser(user: user)
            } else {
                UserRes.getUserCount()
                    .then{ count -> Void in
                        let newId = count + 1
                        user.setId(newId: UInt64(newId))
                        UserRes.addUserImage(user: user)
                            .then{ _ -> Void in
                        UserRes.addNewUser(user: user)
                        fulfill(user)
                        MainUserRepo.shared.setUser(newUser: user)
                        }
                }
            }
        }
    }
    
    static func getCurrentUser(userId: UInt64) -> Promise<UserModel> {
        return Promise<UserModel> { fulfill, reject in
            UserRes.getCurrentUser(userId: userId)
                .then{ user in
                    fulfill(user)
            }
        }
    }
    
    static func updateUser(user: UserModel) -> Promise<Bool> {
        return Promise<Bool> { fulfill, reject in
            UserRes.updateUser(user: user)
                .then{ bool in
                    fulfill(bool)
                }
                .catch{ error in
                    reject(error)
            }
        }
    }
    
}
