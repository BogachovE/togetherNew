//
//  WishUnitTests.swift
//  Toogether
//
//  Created by Евгений Богачев on 19.06.17.
//  Copyright © 2017 attaractive products. All rights reserved.
//

import XCTest
@testable import together



class WishUnitTests: XCTestCase {
    var wish: Wish!
    
    override func setUp() {
        super.setUp()
       wish = Wish()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShouldSetWish() {
        wish.setWishUrl(newUrl: "clearURL")
        wish.setWishDone(newWishDone: 1)
        wish.setWishName(newWishName: "clearName")
        
        assert(wish.getWishUrl() == "clearURL")
        assert(wish.getWishDone() == 1)
        assert(wish.getWishName() == "clearName")
    }
    
    func testShouldMapped() {
        let jsonString = "{\"wishUrl\":\"www.url.com\",\"wishDone\": 3,\"wishName\":\"pizza\"}"
        
        wish = Wish(JSONString: jsonString)!
        assert(wish.getWishName() == "pizza")
        assert(wish.getWishDone() == 3)
        assert(wish.getWishUrl() == "www.url.com")
    }
    
}
