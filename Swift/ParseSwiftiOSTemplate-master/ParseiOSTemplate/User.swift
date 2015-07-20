//
//  User.swift
//  FoodOnYourMind_Swift
//
//  Created by alec on 7/16/15.
//  Copyright (c) 2015 Computer. All rights reserved.
//

import Foundation
import CoreData
@objc(User)
class User: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var loggedIn: NSNumber
    @NSManaged var email: String
    @NSManaged var username: String
    
}
