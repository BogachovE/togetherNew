//
//  Event.swift
//  together
//
//  Created by ASda Bogasd on 20.01.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import Foundation
import SwiftDate

class EventModel {
    var id: UInt64!
    var title: String!
    var description: String!
    var photo: UIImage!
    var category: String!
    var ownerId: UInt64!
    var likes: Array<UInt64>!
    var location: String!
    var startTime: Date!
    var signedUsers: Array<UInt64>!
    var wishList: Array<WishModel>!
    var english = Region(tz: TimeZoneName.europeRome, cal: CalendarName.gregorian, loc: LocaleName.italian)
    
    
    
    init(title: String = "",
         description: String = "",
         id: UInt64 = 0,
         photo: UIImage = #imageLiteral(resourceName: "EventPhoto"),
         category: String = "",
         ownerId: UInt64 = 0,
         likes: Array<UInt64> = [0],
         location: String = "",
         startTime: Date = DateInRegion().absoluteDate,
         signedUsers: Array<UInt64> = [0],
         wishList: Array<WishModel> = [WishModel()]
        )
    {
        self.title = title
        self.id = id
        self.description = description
        self.photo = photo
        self.category = category
        self.ownerId = ownerId
        self.likes = likes
        self.location = location
        self.signedUsers = signedUsers
        self.wishList = wishList
        self.startTime = Date()
    }
    
    func setTitle(newTitle: String) -> Void {
        self.title = newTitle
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func setId(newId: UInt64) -> Void {
        self.id = newId
    }
    
    func getId() -> UInt64 {
        return self.id
    }
    
    func setDescription(newDescription: String) -> Void {
        self.description = newDescription
    }
    
    func getDescription() -> String {
        return self.description
    }
    
    func setPhoto(newPhoto: UIImage) -> Void {
        self.photo = newPhoto
    }
    
    func getPhoto() -> UIImage {
        return self.photo
    }
    
    func setCategory(newCategory: String) -> Void {
        self.category = newCategory
    }
    
    func getCategory() -> String {
        return self.category
    }
    
    func setOwnerId(newOwnerId: UInt64) -> Void {
        self.ownerId = newOwnerId
    }
    
    func getOwnerId() -> UInt64 {
        return self.ownerId
    }
    
    func setLikes(newLikes: Array<UInt64>) -> Void {
        self.likes = newLikes
    }
    
    func getLikes() -> Array<UInt64> {
        return self.likes
    }
    
    func setLocation(newLocation: String) -> Void {
        self.location = newLocation
    }
    
    func getLocation() -> String {
        return self.location
    }
    
    func setStartTime(newStartTime: String) -> Void {
        let date2 = try! newStartTime.date(format: .rss(alt: true), fromRegion: english)
        self.startTime = (date2?.absoluteDate)!
    }
    
    func getStartTime() -> String {
        let date = self.startTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_EN") as Locale
        let dateInFormat = dateFormatter.string(from: date!)
        return dateInFormat
    }
    
    func getStartTimeString() -> String {
        let startTimeString: String
        startTimeString = startTime.string()
        return startTimeString
    }
    
    
    func setSignedUsers(newSignedUsers: Array<UInt64>) -> Void {
        self.signedUsers = newSignedUsers
    }
    
    func getSignedUsers() -> Array<UInt64> {
        return self.signedUsers
    }
    
    func setWishList(newWishList: Array<WishModel>) -> Void {
        self.wishList = newWishList
    }
    
    func getWishList() -> Array<WishModel> {
        return self.wishList
    }
    
    func getWishCount() -> Int {
        if (self.wishList.count == 1 && self.wishList[0].getWishName() == "nope") {
            return 0
        } else {
            return self.wishList.count
        }
        
    }
    
    func addWish(wish: WishModel) -> Void {
        if (self.wishList[0].getWishName() == "nope"){
            self.wishList[0] = wish
        } else {
            self.wishList.append(wish)
        }
    }
    
    
    func likePressed(id: UInt64){
        if (isLiked(id: id)){
           likes.remove(at: likes.index(of: id)!)
        } else {
            likes.append(id)
        }
    }
    
    func isLiked(id: UInt64) -> Bool {
        if (likes.contains(id)) {
            return true
        } else {
            return false
        }
    }
    
    func getParticipantsCount() -> Int {
        if ( signedUsers.count == 1 && Int(signedUsers[0]) == 0) {
            return 0
        } else {
            return self.signedUsers.count
        }
    }
    
}


