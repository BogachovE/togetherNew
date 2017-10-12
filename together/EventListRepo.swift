//
//  EventRepo.swift
//  together
//
//  Created by Евгений Богачев on 29.08.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import Foundation
import PromiseKit

final class EventListRepo {

    private init() { }
    static let shared = EventListRepo()
    
    var eventList: [EventModel]!
    var selectedEventIndex: Int?
    
    func updateEventList() -> Promise<[EventModel]> {
        return Promise<[EventModel]>{fulfill, reject in
            EventRes.getAllEvents()
                .then{ eventList -> Void in
                        self.eventList = eventList
                    fulfill(eventList)
            }
        }
    }
    
    func getEventList() -> [EventModel] {
        if (eventList != nil) {
        return self.eventList
        } else {
            return [EventModel]()
        }
    }
    
    func setEventList(newEventList: [EventModel]) {
        self.eventList = newEventList
    }
    
    func getEventCount() -> Int {
        if (eventList != nil){
            return eventList.count
        } else {
            return 0
        }
    }
    
    func likePressed(index: Int, id: UInt64){
        eventList[index].likePressed(id: id)
        EventRes.updateEvent(event: eventList[index])
    }
    
    func setSelectedIndex(newIndex: Int) {
        self.selectedEventIndex = newIndex
    }
    
    func getSelectedIndex() -> Int {
        return self.selectedEventIndex!
    }
    
    func sendNewEvent(event: EventModel) -> Promise<Bool> {
        return Promise<Bool> { fulfill, reject in
            EventRes.loadEventCount()
                .then{ count -> Void in
                    event.setId(newId: UInt64(count))
                    EventRes.sendNewEvent(event: event)
                        .then{_ -> Void in
                            fulfill(true)
                            EventRes.addNewCount(newCount: count+1)
                    }
            }
        }
    }
    
    func removeEvent(eventId: UInt64) -> Promise<Bool> {
        return Promise<Bool>{ fulfill, reject in
            EventRes.removeEvent(eventId: eventId)
                .then{ _ in
                    fulfill(true)
            }
        }
    }
    
}
