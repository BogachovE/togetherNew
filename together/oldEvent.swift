//
//  Event.swift
//  together
//
//  Created by ASda Bogasd on 20.01.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import Foundation
import UIKit

class Event {
    var id: Int
    var title: String
    var description: String
    var contrebuted: Int
    var photo: UIImage
    var category: String
    var ownerId: UInt64
    var likes: Array<UInt64>
    var location: String
    var startTime: String
    var endTime: Date
    var signedUsers: Array<UInt64>
    var linkUrls: Array<String>
    var linkStrings: Array<String>
    var linkDone: Array<UInt64>
    
    
    
    init(title: String = "",
         description: String = "",
         id: Int = 0,
         photo: UIImage = #imageLiteral(resourceName: "EventPhoto"),
         contrebuted: Int = 0,
         category: String = "",
         ownerId: UInt64 = 0,
         likes: Array<UInt64> = [0],
         location: String = "",
         startTime: String = "",
         endTime: Date = Date(),
         signedUsers: Array<UInt64> = [0],
         linkUrls: Array<String> = [""],
         linkStrings: Array<String> = [""],
         linkDone: Array<UInt64> = [0]
        )
    {
        self.title = title
        self.id = id
        self.description = description
        self.photo = photo
        self.contrebuted = contrebuted
        self.category = category
        self.ownerId = ownerId
        self.likes = likes
        self.location = location
        self.startTime = startTime
        self.endTime = endTime
        self.signedUsers = signedUsers
        self.linkUrls = linkUrls
        self.linkStrings = linkStrings
        self.linkDone = linkDone
            }
}


