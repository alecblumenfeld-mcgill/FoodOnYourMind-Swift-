//
//  AddViewController.swift
//  Food On Your Mind Shoping List
//
//  Created by alec on 7/13/15.
//  Copyright (c) 2015 alec. All rights reserved.
//

import UIKit
import CoreData
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
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Save(sender: AnyObject) {
        //get username
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
        
        //append ingredient
        var query = PFQuery(className:"PersonalLists")
        
        query.whereKey("owner", equalTo: username)
        let list = query.getFirstObject()
        
        
        
        
        //list.addUniqueObject(<#object: AnyObject!#>, forKey: <#String!#>)
        
        println(list)
        
        
        
        
        
        
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
