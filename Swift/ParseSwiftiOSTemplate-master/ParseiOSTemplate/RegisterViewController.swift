//
//  RegisterViewController.swift
//  FoodOnYourMind(Swift)
//
//  Created by alec on 7/15/15.
//  Copyright (c) 2015 Computer. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passWord: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func parseSignup(){
        var userEmailAddress = email.text
        var userPassword = passWord.text
        var username = userName.text
        var firstname = firstName.text
        userEmailAddress = userEmailAddress.lowercaseString
        
        //Add Agrement
        
        var user = PFUser()
        user.username = username
        user.password = userPassword
        user.email = userEmailAddress
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    let alertController = UIAlertController(title: nil, message:
                        "Success! Lets Get Cooking.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    //alert actions
                    let ok: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
                        
                    }
                    //Add Success Modal
                    alertController.addAction(ok)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                   
                    //addsave to coredata username
                }
                
            } else {
                //Add failure pop up
                let alertController = UIAlertController(title: nil, message:
                    "There was a Problem Registering your account", preferredStyle: UIAlertControllerStyle.Alert)
                
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
