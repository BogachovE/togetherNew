//
//  Wish.swift
//  Toogether
//
//  Created by Евгений Богачев on 16.06.17.
//  Copyright © 2017 attaractive products. All rights reserved.
//

import Foundation

class WishModel {
    var wishUrl: String!
    var wishName: String!
    var wishDone: UInt64!
    
    init(wishUrl: String = "nope",
         wishName: String = "nope",
         wishDone: UInt64 = 0)
    {
        self.wishUrl = wishUrl
        self.wishName = wishName
        self.wishDone = wishDone
    }
    
    
    func getWishUrl() -> String {
        if self.wishUrl.lowercased().range(of:"http://") != nil {
            return self.wishUrl
        } else {
        return "http://" + self.wishUrl
        }
    }
    
    func setWishUrl(newUrl: String) -> Void {
        wishUrl = newUrl
    }
    
    func getWishName() -> String {
        return self.wishName
    }
    
    func setWishName(newWishName: String) -> Void {
        wishName = newWishName
    }
    
    func getWishDone() -> UInt64 {
        return self.wishDone
    }
    
    func setWishDone(newWishDone: UInt64) -> Void {
        wishDone = newWishDone
    }
    
    func isDone() -> (Bool, UInt64) {
        if (wishDone != 0){
            return (true, wishDone)
        } else {
            return (false, 0)
        }
    }
    
    func checkPressed(myId: UInt64) {
        let (isItDone, id) = isDone()
        if(isItDone){
            if(id == myId){
                wishDone = 0
            }
        } else {
            wishDone = myId
        }
    }
    
    
    
}
