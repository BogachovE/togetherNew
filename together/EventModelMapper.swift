//
//  EventModelMapper.swift
//  together
//
//  Created by Евгений Богачев on 29.08.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import Foundation
import UIKit

class EventModelMapper {
    static func eventToDictionary(event: EventModel) ->NSDictionary  {
        let dictionaryEvent: NSDictionary
        dictionaryEvent = [
            "id":event.id,
            "title":event.title,
            "description":event.description,
            "category":event.category,
            "ownerId":event.ownerId,
            "likes":event.likes,
            "location":event.location,
            "signedUsers": event.signedUsers,
            "wishList": wishListToArray(wishList: event.getWishList()),
            "startTime": event.getStartTime()
        ]
        return dictionaryEvent
    }
    
    static func dictionaryToEvent(eventDictionary: NSDictionary,image:UIImage = #imageLiteral(resourceName: "EventPhoto")) ->EventModel {
        var wishList: [WishModel]
        if let wishDictionary = eventDictionary.value(forKey: "wishList") as? NSDictionary {
            wishList = dictionaryToWithList(wishDictionary: wishDictionary)
        } else {
           let  wishDictionary = eventDictionary.value(forKey: "wishList") as! NSArray
            wishList = arrayToWishList(wishArray: wishDictionary)
        }
    
        let startTimeString = eventDictionary.value(forKey: "startTime")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_EN") as Locale
        let date = dateFormatter.date(from: startTimeString as! String)
        let event = EventModel(
            title: eventDictionary.value(forKey: "title") as! String,
            description: eventDictionary.value(forKey: "description") as! String,
            id: eventDictionary.value(forKey: "id") as! UInt64,
            photo: image,
            category: eventDictionary.value(forKey: "category") as! String,
            ownerId: eventDictionary.value(forKey: "ownerId") as! UInt64,
            likes: eventDictionary.value(forKey: "likes") as! Array<UInt64>,
            location: eventDictionary.value(forKey: "location") as! String,
            startTime: date!,
            signedUsers: eventDictionary.value(forKey: "signedUsers") as! Array<UInt64>,
            wishList: wishList
        )
        return event
    }
    
    static func dictionaryToWithList(wishDictionary: NSDictionary) -> [WishModel] {
        var wishList: [WishModel] = []
        for wishDict in wishDictionary {
            let wishDict = wishDict.value as! NSDictionary
                wishList.append(WishModel(wishUrl: wishDict.value(forKey: "link") as! String, wishName: wishDict.value(forKey: "title") as! String, wishDone: wishDict.value(forKey: "done") as! UInt64))
            
        }
        return wishList
    }
    
    static func arrayToWishList(wishArray: NSArray) -> [WishModel] {
        var wishList: [WishModel] = []
        for wishDict in wishArray {
            let wishDict = wishDict as! NSDictionary
            wishList.append(WishModel(wishUrl: wishDict.value(forKey: "link") as! String, wishName: wishDict.value(forKey: "title") as! String, wishDone: wishDict.value(forKey: "done") as! UInt64))
            
        }
        return wishList
    }
    
    static func wishListToArray(wishList: [WishModel]) -> NSArray {
        var wishArray: [NSDictionary] = []
        for wish in wishList {
            wishArray.append(["done" : wish.getWishDone(),
                              "link" : wish.getWishUrl(),
                              "title" : wish.getWishName()
                              ])
        }
        return wishArray as NSArray
    }
    

}
