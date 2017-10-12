//
//  EventRes.swift
//  together
//
//  Created by Евгений Богачев on 29.08.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import Foundation
import PromiseKit
import Firebase

class EventRes {
    static func getAllEvents() -> Promise<[EventModel]> {
        return Promise<[EventModel]>{fulfill, reject in
            getAllEventsInfo()
                .then{ eventList in
                    return getAllEventsImage(eventList: eventList)
                        .then{ eventList in
                            fulfill(eventList)
                    }
            }
        }
    }
    
    static func getAllEventsInfo() -> Promise<[EventModel]> {
        return Promise<[EventModel]>{fulfill, reject in
            let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
            var eventList: [EventModel] = []
            ref.child("events").observeSingleEvent(of: .value, with: { (snapshot) in
                if (snapshot.value != nil){
                    if let events = snapshot.value as? NSDictionary{
                        for event in events{
                            let event = event.value as! NSDictionary
                            eventList.append(EventModelMapper.dictionaryToEvent(eventDictionary: event))
                        }
                        
                    } else {
                        let events = snapshot.value as! NSArray
                        for event in events{
                            if (event is NSNull){
                            
                            } else {
                                let event = event as! NSDictionary
                                eventList.append(EventModelMapper.dictionaryToEvent(eventDictionary: event))
                            }
                        }
                    }
                    fulfill(eventList)
                } else {
                    reject(NSError(domain: "There are not events", code: 103, userInfo: nil))
                }
                
            })
        }
    }
    
    static func getAllEventsImage(eventList: [EventModel]) -> Promise<[EventModel]> {
        var promiseList: [Promise<UIImage>] = []
        for i in 0...eventList.count - 1 {
            let promise = Promise<UIImage>{ fullfill, reject in
                var image :UIImage = UIImage()
                let storageRef = FIRStorage.storage().reference(forURL: "gs://together-df2ce.appspot.com")
                let riversRef = storageRef.child("eventsPhoto/"+String(eventList[i].getId())+".jpg")
                riversRef.data(withMaxSize: 120 * 1024 * 1024) { data, error in
                    if let error = error {
                        reject(error)
                    } else {
                        // Data for "images/island.jpg" is returned
                        image = UIImage(data: data!)!
                        fullfill(image)
                    }
                }
            }
            promiseList.append(promise)
        }
        let promise = Promise<[EventModel]>{fullfill, reject in
            when(resolved: promiseList)
                .then{ results -> Void in
                    for i in 0...results.count - 1 {
                        switch results[i] {
                        case .fulfilled(let value): eventList[i].setPhoto(newPhoto: value)
                        default: break
                        }
                    }
                    fullfill(eventList)
            }
        }
        return promise
    }
    
    static func updateEvent(event: EventModel) -> Promise<Bool> {
        return Promise<Bool> { fulfill, reject in
            updateEventInfo(event: event)
                .then { _ in
                    sendNewEventImage(event: event)
                        .then{ _ in
                            fulfill(true)
                    }
            }
        }
    }
    
    static func updateEventInfo(event: EventModel) -> Promise<Bool> {
        return Promise<Bool>{ fulfill, reject in
           let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
            ref.child("events/\(event.getId())").setValue(EventModelMapper.eventToDictionary(event: event))
            fulfill(true)
        }
    }
    
    static func sendNewEvent(event: EventModel) -> Promise<Bool> {
        return Promise<Bool> { fulfill, reject in
            sendNewEventInfo(event: event)
                .then{ event in
                    return sendNewEventImage(event: event)
            }
                .then{ bool -> Void in
                       fulfill(true)
            }
        }
    }
    
    static func sendNewEventInfo(event: EventModel) -> Promise<EventModel> {
        return Promise { fulfill, reject in
            let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
            ref.child("events/\(event.getId())").setValue(EventModelMapper.eventToDictionary(event: event))
            fulfill(event)
        }
    }
    
    static func sendNewEventImage(event: EventModel) -> Promise<Bool> {
        return Promise{ fulfill, reject in
            let ref = FIRDatabase.database().reference()
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://together-df2ce.appspot.com")
            let data = UIImageJPEGRepresentation(event.getPhoto(), 0.5)
            let riversRef = storageRef.child("eventsPhoto/"+String(describing: event.getId())+".jpg")
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
    
    static func loadEventCount() -> Promise<Int> {
        return Promise<Int> { fulfill, reject in
            let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
            var eventList: [EventModel] = []
            ref.child("eventscount/").observeSingleEvent(of: .value, with: { (snapshot) in
                let count = snapshot.value as! Int
                fulfill(count)
            })
        }
    }
    
    static func addNewCount(newCount: Int){
         let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
          ref.child("eventscount/").setValue(newCount)
    }
    
    static func removeEvent(eventId: UInt64) -> Promise<Bool> {
        return Promise<Bool> { fulfill, reject in
            let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
            ref.child("events/\(eventId)").removeValue()
            fulfill(true)
        }
    }
    
}
