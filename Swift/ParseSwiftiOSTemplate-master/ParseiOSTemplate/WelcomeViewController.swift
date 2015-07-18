//
//  WelcomeViewController.swift
//  FoodOnYourMind(Swift)
//
//  Created by alec on 7/15/15.
//  Copyright (c) 2015 Computer. All rights reserved.
//

import UIKit
import CoreData
class WelcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
     
        }
        
        
    override func viewDidLayoutSubviews() {
        if(checkIfLoggedin()){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("MainNavigation") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)

        }
        else{
            clearUsers()
        }
        
    }
    
    func checkIfLoggedin()->Bool{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext:NSManagedObjectContext = appDel.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "User")

        let fetchedUser = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as! [User]
        
        
        if  fetchedUser.count > 0 {
            for user in fetchedUser {
                return  Bool(user.loggedIn )
            }
           
        }
        else{
            //no users found
            return false
        }
        
        return false
    }
    
    func clearUsers(){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext:NSManagedObjectContext = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        let fetchedEntities = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as! [User]
        
        // Delete all user that may be in sql table
        for entity in fetchedEntities {
            managedObjectContext.deleteObject(entity)
        }
        managedObjectContext.save(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
