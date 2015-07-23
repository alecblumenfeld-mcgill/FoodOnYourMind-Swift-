//
//  CoreDataWraper.swift
//  FoodOnYourMind_Swift
//
//  Created by alec on 7/23/15.
//  Copyright (c) 2015 Computer. All rights reserved.
//

import Foundation
import CoreData
class dataWrapper {

    func newUser() -> User{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let ent = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
        var newUser = User(entity:ent!, insertIntoManagedObjectContext: context)
        return newUser
        
    }
}