//
//  eventMaper.swift
//  together
//
//  Created by ASda Bogasd on 29.01.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import Foundation
import UIKit

class EventMaper{
    
    static func eventToDictionary(event: Event) ->NSDictionary  {
        let dictionaryEvent: NSDictionary
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let endTimeString = formatter.string(from: event.endTime)
        dictionaryEvent = [
            "id":event.id,
            "title":event.title,
            "description":event.description,
            "contrebuted":event.contrebuted,
            "category":event.category,
            "ownerId":event.ownerId,
            "likes":event.likes,
            "location":event.location,
            "startTime":event.startTime,
            "endTime": endTimeString,
            "signedUsers": event.signedUsers,
            "linkUrls": event.linkUrls,
            "linkStrings": event.linkStrings,
            "linkDone": event.linkDone
        ]
        return dictionaryEvent
    }
    
    static func dictionaryToEvent(eventDictionary: NSDictionary,image:UIImage = #imageLiteral(resourceName: "EventPhoto")) ->Event {
        let event: Event
        let dateFormatter = DateFormatter()
        let dateFormatter2 = DateFormatter()
        let dateFormatter3 = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm:ss a"
        dateFormatter2.dateStyle = DateFormatter.Style.medium
        dateFormatter2.timeStyle = .medium
        dateFormatter2.locale = NSLocale(localeIdentifier: "en_US_POS") as Locale!
        dateFormatter2.dateFormat = "dd MMM yyyy, hh:mm:ss"
        dateFormatter3.dateStyle = DateFormatter.Style.medium
        dateFormatter3.timeStyle = .medium
        dateFormatter3.locale = NSLocale(localeIdentifier: "ar_DZ") as Locale!
        //dateFormatter3.dateFormat = "dd MMM yyyy, hh:mm:ss"

        let startTimeString = eventDictionary.value(forKey: "startTime") as! String
        
        
       
        event = Event(
            title: eventDictionary.value(forKey: "title") as! String,
            description: eventDictionary.value(forKey: "description") as! String,
            id: eventDictionary.value(forKey: "id") as! Int,
            photo: image,
            contrebuted: eventDictionary.value(forKey: "contrebuted") as! Int,
            category: eventDictionary.value(forKey: "category") as! String,
            ownerId: eventDictionary.value(forKey: "ownerId") as! UInt64,
            likes: eventDictionary.value(forKey: "likes") as! Array<UInt64>,
            location: eventDictionary.value(forKey: "location") as! String,
            startTime: startTimeString,
            signedUsers: eventDictionary.value(forKey: "signedUsers") as! Array<UInt64>,
            linkUrls: eventDictionary.value(forKey: "linkUrls") as! Array<String>,
            linkStrings: eventDictionary.value(forKey: "linkStrings") as! Array<String>,
            linkDone: eventDictionary.value(forKey: "linkDone") as! Array<UInt64>
        )
        print("ownerIdInMaper = ", event.ownerId as Any)
        print("ownerIdInMaperDict = ", eventDictionary.value(forKey: "ownerId") as Any)
        return event
    }
    
    
}
