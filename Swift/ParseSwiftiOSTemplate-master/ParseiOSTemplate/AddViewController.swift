//
//  AddViewController.swift
//  Food On Your Mind Shoping List
//
//  Created by alec on 7/13/15.
//  Copyright (c) 2015 alec. All rights reserved.
//

import UIKit
import RealmSwift
class AddViewController: UIViewController  {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var qtyField: UITextField!
    @IBOutlet weak var unitField: IQDropDownTextField!
    @IBOutlet weak var catField: IQDropDownTextField!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        unitField.isOptionalDropDown = false
        unitField.itemList = ["Cups", "Ozs", "Grams", ]
        catField.isOptionalDropDown = false
        catField.itemList = ["Fruit", "Dairy", "Meat"]
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Save(sender: AnyObject) {
        //generate object under parse
        //get current user and add ingredient to the parse object
        let users = Realm(path: Realm.defaultPath).objects(User)
        let currentUser = users[0]
        println(currentUser)
        
        
        
        let personalListID = currentUser["UsersPersonalList"]!.objectId //as! String
        var query = PFQuery(className:"PersonalLists")
        query.getObjectInBackgroundWithId(personalListID) {
            (personalList: PFObject?, error: NSError?) -> Void in
            if error == nil && personalList != nil {
                var newIngredient = PFObject(className:"Ingredients")
                newIngredient["ingredientType"] = self.catField.text
                newIngredient.save()
                personalList?.addUniqueObject(newIngredient, forKey: "ingredients")
                personalList?.save()
                
            } else {
                println(error)
            }
        }
        
        
        //save new ingred to realm
        let newIng = ingred()
        newIng.name = self.nameField.text
        newIng.type = self.catField.text
        // Get the default Realm
        let realm = Realm()
        // Add to the Realm inside a transaction
        realm.write {
            realm.add(newIng)
        }
        
        
        //go back to list
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MainNavigation") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func goBack(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MainNavigation") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
