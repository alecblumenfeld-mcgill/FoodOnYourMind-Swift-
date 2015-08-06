//
//  LoginViewController.swift
//  FoodOnYourMind(Swift)
//
//  Created by alec on 7/15/15.
//  Copyright (c) 2015 Computer. All rights reserved.
//

import UIKit
import RealmSwift
class LoginViewController: UIViewController {


    
    @IBOutlet weak var usernameFeild: UITextField!
  
    @IBOutlet weak var passwordFeild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        
        var userEmailAddress = usernameFeild.text.lowercaseString

        var userPassword = passwordFeild.text
        
        
        switch userEmailAddress.rangeOfString("@"){
            case nil :
                //username
                println("login with Username")
                PFUser.logInWithUsernameInBackground(userEmailAddress, password:userPassword) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil {
                        
                        var newUser = User()
                        
//                        
                        newUser.username = userEmailAddress
                        newUser.email = self.usernameFeild.text.lowercaseString
                        newUser.id = user!.objectId
                        //personal list has to be fetched seperatly becuse it does not exisit in pfusers only pf object
                        var query = PFQuery(className:"_User")
                        query.whereKey("objectId", equalTo: newUser.id)
                        let personalistID = query.getFirstObject()
                        newUser.personalListID = (personalistID["UsersPersonalList"].objectId)
                        //newUser.personalListID = personalListID
                        // Get the default Realm
                        let realm = Realm()
                        //write user to db
                        realm.write {
                            realm.add(newUser)
                        }
                        
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                          
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewControllerWithIdentifier("MainNavigation") as! UIViewController
                            self.presentViewController(vc, animated: true, completion: nil)
                        }
                    } else {
                        if let message: AnyObject = error!.userInfo!["error"] {
                            let alertController = UIAlertController(title: nil, message:
                                "There was a problem Loging, Please Check Your username and password", preferredStyle: UIAlertControllerStyle.Alert)
                            //alert actions
                            let ok: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) {action -> Void in
                                
                            }
                            alertController.addAction(ok)
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                        }
                    }
                }
            default:
                //login with email
                println("login with email")
                PFUser.logInWithUsernameInBackground(userEmailAddress, password:userPassword) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil {
                        dispatch_async(dispatch_get_main_queue()) {
                            //self.performSegueWithIdentifier("signInToNavigation", sender: self)
                            println(user)
                            
                            
                        }
                    } else {
                        
                        if let message: AnyObject = error!.userInfo!["error"] {
                            let alertController = UIAlertController(title: nil, message:
                                "There was a problem Loging, Please Check Your username and password", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            //alert actions
                            
                            let ok: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) {action -> Void in
                                
                            }
                            alertController.addAction(ok)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    }
            }
            
        }
        
        
        

    }
    @IBAction func goBack(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("WViewController") as! UIViewController
        self.presentViewController(vc, animated: false, completion: nil)
    }

}
