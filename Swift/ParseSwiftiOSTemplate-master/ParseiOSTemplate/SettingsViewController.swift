//
//  SettingsViewController.swift
//  Food On Your Mind
//
//  Created by alec on 7/15/15.
//  Copyright (c) 2015 alec. All rights reserved.
//

import UIKit
import RealmSwift
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Logout(sender: AnyObject) {
        
        //Logout by removing all data from local and then
        //go back to the home screen
        let realm = Realm()
        realm.write {
            realm.deleteAll()
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("WViewController") as! UIViewController
        self.presentViewController(vc, animated: false, completion: nil)
    }



}
