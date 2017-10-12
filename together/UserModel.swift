//
//  UserModel.swift
//  together
//
//  Created by Евгений Богачев on 23.08.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import Foundation
import UIKit


class UserModel {
    
    
    var id: UInt64
    var name: String!
    var email: String!
    var phone: String!
    var photo: UIImage!
    var friends: Array<UInt64>!
    var signedEvent: Array<Int>!
    var title: String!
    var followersCount: Int!
    var description: String!
    var notificationId: String!
    
    init(name: String = "",
         email: String = "",
         id: UInt64 = 0,
         phone: String = "",
         photo: UIImage = #imageLiteral(resourceName: "phone"),
         friends: Array<UInt64> = [0],
         signedEvent: Array<Int> = [0],
         title: String = "",
         followersCount:Int = 0,
         description: String = "In order to fill the non-existent fields of the user, go to the settings".localized,
         notificationId: String = ""
        ) {
        self.name = name
        self.id = id
        self.email = email
        self.phone = phone
        self.photo = photo
        self.friends = friends
        self.signedEvent = signedEvent
        self.title = title
        self.followersCount = followersCount
        self.description = description
        self.notificationId = notificationId
    }
    
    init(aDict: [String: AnyObject]) {
        self.name = aDict["name"] as! String
        self.id = aDict["id"] as! UInt64
        self.phone = aDict["phone"] as! String
        self.friends = aDict["friends"] as! Array<UInt64>
        self.signedEvent = aDict["signedEvent"] as! Array<Int> 
        self.followersCount = aDict["followersCount"] as! Int
        self.description = aDict["description"] as! String
        self.notificationId = aDict["notificationId"] as! String
        self.title = aDict["title"] as! String
        self.email = aDict["email"] as! String
    }
    
    func setId(newId: UInt64) {
        self.id = newId
    }
    func getId() -> UInt64 {
        return self.id
    }
    
    func getName() -> String {
        return name!
    }
    
    func setName(newName: String) -> Void {
        self.name = newName
    }
    
    func getEmail() -> String {
        return email
    }
   
    func setEmail(newEmail: String) -> Void {
        self.email = newEmail
    }
    
    func getPhone() -> String {
        return phone
    }
    
    func setPhone(newPhone: String) -> Void {
        self.phone = newPhone
    }
    
    func getPhoto() -> UIImage {
        return photo
    }
    
    func setPhoto(newPhoto: UIImage) -> Void {
        self.photo = newPhoto
    }
    
    func getFriends() -> Array<UInt64> {
        return friends
    }
    
    func setFriends(newFriends: Array<UInt64>) -> Void {
        self.friends = newFriends
    }
    
    func getFriendsCount() -> Int {
        if (friends.count == 1 && friends[0] == 0){
            return 0
        } else {
        return self.friends.count
        }
    }
    func getSignedEvent() -> Array<Int> {
        return signedEvent
    }
    
    func isFriend(userId: UInt64) -> Bool {
        return friends.contains(userId)
    }
    
    func setSignedEvent(newSignedEvent: Array<Int>) -> Void {
        self.signedEvent = newSignedEvent
    }
    
    func getTitle() -> String {
        return title
    }
    
    func setTitle(newTitle: String) -> Void {
        self.title = newTitle
    }
    
    func getFollowersCount() -> Int {
        return followersCount
    }
    
    func setFollowersCount(newFollowersCount: Int) -> Void {
        self.followersCount = newFollowersCount
    }
    
    func getDescription() -> String {
        return description
    }
    
    func setDescription(newDescription: String) -> Void {
        self.description = newDescription
    }
    
    func getNotificationId() -> String {
        return notificationId
    }
    
    func setNotificationId(newNotificationId: String) -> Void {
        self.notificationId = newNotificationId
    }
    
    func subscribePressed(userId: UInt64) {
        if (isFriend(userId: userId)){
            let index = friends.index(of: userId)
            friends.remove(at: index!)
        } else {
            friends.append(userId)
        }
    }
    
}
