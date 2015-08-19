//
//  User.swift
//  FoodOnYourMind_Swift
//
//  Created by alec on 7/16/15.
//  Copyright (c) 2015 Computer. All rights reserved.
//

import Foundation
import RealmSwift


class User: Object {
    dynamic var name = ""
    dynamic var username = ""

    dynamic var id = ""
    dynamic var personalListID = ""
    dynamic var email = ""
    
    func currentUser()->User{
        let users = Realm(path: Realm.defaultPath).objects(User)
        return  users[0]
        
    }
}
