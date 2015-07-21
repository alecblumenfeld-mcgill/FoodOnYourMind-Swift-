//
//  recipe.swift
//  TableDemo
//
//  Created by Alec on 6/20/15.
//  Copyright (c) 2015 alec. All rights reserved.
//

import Foundation
import Parse
import CoreData



//define new cell where recipie is linked in the cell value
var potato = ingredient(Name: "potato", Amount: "1 lb", ingredientType: "vegtable")
var tomato = ingredient(Name: "tomato", Amount: "1 lb", ingredientType: "vegtable")
var corn = ingredient(Name: "corn", Amount: "4 ears ", ingredientType: "vegtable")
//meat
var chicken = ingredient(Name: "chicken", Amount: ".5 lb", ingredientType: "meat")
var beef = ingredient(Name: "beef", Amount: ".25 lb", ingredientType: "meat")
var pork  = ingredient(Name: "pork", Amount: "1 lb", ingredientType: "meat")
//fruits
var peach = ingredient(Name: "peach", Amount: "3 peaches", ingredientType: "fruit")


//dummy data
var cornBeef = recipie(recipieName: "Corned Beef", recipieIngredients:  [beef, corn] )
var chickenStew = recipie(recipieName: "Chicken Stew", recipieIngredients:  [chicken, tomato, potato] )


class recipieList {
    
    
    
    
    var recipieList =  [recipie]()
    init () {
        //get user name
 
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext:NSManagedObjectContext = appDel.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        let fetchedUser = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as! [User]
        var username: String = ""
    
        if  fetchedUser.count > 0 {
            for user in fetchedUser {
                username = user.username
            }
        }

        
        //Get personal List
        var query = PFQuery(className:"PersonalList")
        query.whereKey("Owner", equalTo:username)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) list.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println(object.objectId)
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) ")
            }
        }

        
        
        
        
        
        self.recipieList.append(cornBeef)
        self.recipieList.append(chickenStew)
    }
    subscript(index: Int) -> recipie{
        return recipieList[index]
    }
    subscript(name : String) ->recipie?{
        for recipie in recipieList{
            if name == recipie.name{
                return recipie
            }
        }
        return nil
    }
    
    func getAllTypes()-> [String: [ingredient]] {
                var typeList = [String: [ingredient]]()
                for recipie in self.recipieList{
                    for ingredient in recipie.ingredients{
                        
                        if let val =  typeList[ingredient.type]{
                            typeList[ingredient.type]?.append(ingredient)
                        }
                        else{
                            typeList[ingredient.type as String] = [ingredient]
                        }
                        
                    }
                }
        return typeList
        }
    
    func getUncheckedTypes()-> [String: [ingredient]] {

        var typeList = [String: [ingredient]]()
            for recipie in self.recipieList{
                for ingredient in recipie.ingredients{
                    if ingredient.checked == true{
                        continue
                    }
                    if let val =  typeList[ingredient.type]{
                        typeList[ingredient.type]?.append(ingredient)
                    }
                    else{
                        typeList[ingredient.type as String] = [ingredient]
                    }
                    
                }
            }
            return typeList
        
        
        
    }
    
    func toggle(cellName: String, cellAmount : String ){
        for recipie in self.recipieList{
            for ingredient in recipie.ingredients{
                if ingredient.name == cellName && ingredient.amount == cellAmount{
                    ingredient.checked = !ingredient.checked
                    println("\(ingredient.name) is now \(ingredient.checked)")

                }
            }
        }
        
    }
    func remove( cellName : String, cellAmount : String ){
        for recipie in self.recipieList{
            for (index, ingredient) in enumerate(recipie.ingredients){
                if ingredient.name == cellName && ingredient.amount == cellAmount{
                    recipie.ingredients.removeAtIndex(index)
                    println("\(ingredient.name) is now removed")
                    
                }
            }
        }
        
    }
    
    func count () -> Int {
        var toRet = 0
        for recipie in self.recipieList{
            toRet += recipie.ingredients.count
        }
        return toRet
    }
    
    func add (Name : String, Amount: String , Unit: String, Type :String  ) {
    
        var temp = ingredient(Name: "\(Name)", Amount: "\(Amount) \(Unit)", ingredientType: "\(Type)")
        if self["Other"] != nil{
            self["Other"]?.ingredients.append(temp)
        }
        else{
            var Other = recipie(recipieName: "Other", recipieIngredients:  [temp] )
            recipieList.append(Other)
        
        }
            
        
        
            
    }
    
}
    
   



    



class recipie {
    var name:String
    var ingredients : [ingredient] = []
    var checked :Bool = false
    init(recipieName: String , recipieIngredients:[ingredient]){
        name = recipieName
        ingredients = recipieIngredients
        for ingredient in recipieIngredients{
        ingredient.recipieName = recipieName
        }
    }
    subscript(index: Int) -> ingredient{
        return ingredients[index]
    }
    
    func removeIngredient ( index: Int ){
        //
        
    }
    
    func getLeft()-> [ingredient]{
        var toRet = [ingredient]()
        for x in self.ingredients{
            if(x.checked == false){
                toRet.append(x)
            }
        }
        return toRet
    }
    
    func getChecked() -> [ingredient]{
        var toRet = [ingredient]()
        for x in self.ingredients{
            if(x.checked == true){
                toRet.append(x)
            }
        }
        return toRet
    }
    
    
}
class ingredient : PFObject, PFSubclassing {
    var name : String
    var amount : String
    var type : String
    var recipieName = ""
    var displayName: String? {
        get {
            return self["displayName"] as? String
        }
        set {
            self["displayName"] = newValue
        }
    }
    class func parseClassName() -> String {
        return "Ingredeint"
    }
    var checked :Bool = false
    
    init(Name:String, Amount:String, ingredientType: String){
        //self.super.init()
        name = Name
        amount = Amount
        type = ingredientType
        super.init()
    }
   

}