//
//  AddViewController.swift
//  Food On Your Mind Shoping List
//
//  Created by alec on 7/13/15.
//  Copyright (c) 2015 alec. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var qtyFeild: IQDropDownTextField!
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

           dismissViewControllerAnimated(true, completion: nil)
        //recipieList.add("test", Amount: "7" , Unit: "cuups", Type :"Food" )
        navigationController!.popViewControllerAnimated(true)

        
        
    }
    
    
    @IBAction func goBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        navigationController!.popViewControllerAnimated(true)
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
