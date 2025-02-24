//
//  RegisterViewController.swift
//  FoodOnYourMind(Swift)
//
//  Created by alec on 7/15/15.
//  Copyright (c) 2015 Computer. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passWord: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func parseSignup(){
        var userEmailAddress = email.text
        var userPassword = passWord.text
        var username = userName.text
        var firstname = firstName.text
        userEmailAddress = userEmailAddress.lowercaseString
        
        
        var user = PFUser()
        user.username = username
        user.password = userPassword
        user.email = userEmailAddress
        
        
        let newUser = User()

        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    let pointer = PFObject(className:"PersonalLists")
                    
                    user["UsersPersonalList"] = pointer
                    user.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
                        newUser.name = firstname
                        newUser.username = username
                        newUser.email = userEmailAddress
                        newUser.id = user.objectId
                        newUser.personalListID = pointer.objectId as String
                        // Get the default Realm
                        let realm = Realm()
                        //write user to db
                        realm.write {
                            realm.add(newUser)
                        }
                    }
                    
                    
                    //Alert sucess
                    let alertController = UIAlertController(title: nil, message:
                        "Success! Lets Get Cooking.", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
                        //ok go to main story
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewControllerWithIdentifier("MainNavigation") as! UIViewController
                        self.presentViewController(vc, animated: true, completion: nil)
                    }
                    
                    //Add Success Modal
                    alertController.addAction(ok)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                   
                    
                }
                
            } else {
                //Add failure pop up
                let alertController = UIAlertController(title: nil, message:
                    "There was a Problem Registering your account: \(error)", preferredStyle: UIAlertControllerStyle.Alert)
                //alert actions
                let ok: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
                }
              
                alertController.addAction(ok)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    
    }
    @IBAction func signUpUser(sender: AnyObject) {
        
        let alertController = UIAlertController(title: nil, message:
            "Please Read The EULA", preferredStyle: UIAlertControllerStyle.Alert)
        
        //alert actions
        let signup: UIAlertAction = UIAlertAction(title: "Signup", style: .Default) { action -> Void in
            self.parseSignup()
        }
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) {action -> Void in
            
        }
        alertController.addAction(cancel)
        alertController.addAction(signup)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
    }

    @IBAction func goBack(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("WViewController") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }

}
