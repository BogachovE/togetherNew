//
//  EventUnitTests.swift
//  Toogether
//
//  Created by Евгений Богачев on 19.06.17.
//  Copyright © 2017 attaractive products. All rights reserved.
//

import XCTest
@testable import together
@testable import SwiftDate

class EventUnitTests: XCTestCase {
    var event: Event!
    
    override func setUp() {
        super.setUp()
        event = Event()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShouldSetEvent() {
        let newWish = Wish()
        newWish.setWishName(newWishName: "clearWish")
        event.setId(newId: 1)
        event.setLikes(newLikes: [1,2,3])
        event.setPhoto(newPhoto: #imageLiteral(resourceName: "phone"))
        event.setTitle(newTitle: "clearTitle")
        event.setOwnerId(newOwnerId: 1)
        event.setCategory(newCategory: "clearCategory")
        event.setLocation(newLocation: "clearLocation")
        event.setWishList(newWishList: [newWish])
        event.setStartTime(newStartTime: "3 feb 2001 15:30:00 +0200")
        event.setDescription(newDescription: "clearDescription")
        event.setSignedUsers(newSignedUsers: [4,5,6])
        
        assert(event.getId() == 1)
        assert(event.getLikes() == [1,2,3])
        assert(event.getPhoto() == #imageLiteral(resourceName: "phone"))
        assert(event.getTitle() == "clearTitle")
        assert(event.getOwnerId() == 1)
        assert(event.getCategory() == "clearCategory")
        assert(event.getLocation() == "clearLocation")
        assert(event.getWishList()[0].getWishName() == "clearWish")
        assert(event.getDescription() == "clearDescription")
        print(event.getStartTimeString())
        assert(event.getStartTimeString() == "Feb 3, 2001, 3:30:00 PM")
        let english = Region(tz: TimeZoneName.europeRome, cal: CalendarName.gregorian, loc: LocaleName.italian)
        let date2 = try! "3 feb 2001 15:30:00 +0200".date(format: .rss(alt: true), fromRegion: english)
        assert(event.getStartTime() == date2?.absoluteDate)
        assert(event.getSignedUsers() == [4,5,6])
    }
    
    
    func testShouldWishAdded() {
        let newWish = Wish()
        newWish.setWishName(newWishName: "clearWish")
        event.addWish(wish: newWish)
        assert(event.getWishList()[0].getWishName() == "clearWish")
        newWish.setWishName(newWishName: "clearWish2")
        event.addWish(wish: newWish)
        assert(event.getWishList()[1].getWishName() == "clearWish2")
    }
    
}
