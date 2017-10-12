//
//  WishListRepo.swift
//  together
//
//  Created by Bogachov on 05.09.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import Foundation

class WishListRepo {
    var wishList: [WishModel]!
    
    init(wishList: [WishModel] = [WishModel]()) {
        self.wishList = wishList
    }
    
    func getWishCount() -> Int {
        if (wishList.count == 1 && wishList[0].getWishName() == "nope") {
            return 1
        } else {
        return wishList.count + 1
        }
    }
    
    func getWishList() -> [WishModel] {
        if(wishList.count > 0){
        return self.wishList
        } else {
            return [WishModel()]
        }
    }
    
    func setWishList(newWishList: [WishModel]){
        if (wishList == nil) { wishList = []}
        self.wishList = newWishList
    }
    
    func removeWish(index: Int) {
        self.wishList.remove(at: index)
    }
    
    func addWish(wish: WishModel) {
        self.wishList.append(wish)
    }
}
