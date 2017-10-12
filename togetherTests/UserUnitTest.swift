//
//  UserUnitTest.swift
//  Toogether
//
//  Created by Евгений Богачев on 12.06.17.
//  Copyright © 2017 attaractive products. All rights reserved.
//

import XCTest
@testable import together

class UserUnitTest: XCTestCase {
    var user : User!
    
    override func setUp() {
        super.setUp()
        user = User()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShouldSetAll() {
        user.setName(newName: "name")
        user.setEmail(newEmail: "email")
        user.setPhoto(newPhoto: #imageLiteral(resourceName: "likeIcon"))
        user.setPhone(newPhone: "123")
        user.setTitle(newTitle: "title")
        user.setFriends(newFriends: ["I","You"])
        user.setDescription(newDescription: "clear")
        user.setSignedEvent(newSignedEvent: [1,2,3])
        user.setFollowersCount(newFollowersCount: 1)
        user.setNotificationId(newNotificationId: "1")
        
        assert(user.getName() == "name")
        assert(user.getEmail() == "email")
        assert(user.getPhoto() == #imageLiteral(resourceName: "likeIcon"))
        assert(user.getPhone() == "123")
        assert(user.getTitle() == "title")
        assert(user.getFriends() == ["I","You"])
        assert(user.getDescription() == "clear")
        assert(user.getSignedEvent() == [1,2,3])
        assert(user.getFollowersCount() == 1)
        assert(user.getNotificationId() == "1")
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
