//
//  ParseHelper.swift
//  FoodOnYourMind_Swift
//
//  Created by alec on 8/2/15.
//  Copyright (c) 2015 Computer. All rights reserved.
//

import Foundation
import Parse
import RealmSwift

class ParseHelper{

    //gets a string and returns a list of strings from parse
    func queryIngredients (current: String) -> NSArray{
        var toRet = [String]()
        //query parse for the sub string
        var query = PFQuery(className:"Ingredients")
        query.whereKey("IngredientName", equalTo:"Sean Plott")
        query.whereKey("IngredientName", containsString: current)
        //get array
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
        
            println(objects)
            
            
        }
        
        
        return toRet
    
    }
}