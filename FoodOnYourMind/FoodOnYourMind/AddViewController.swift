//
//  AddViewController.swift
//  Food On Your Mind Shoping List
//
//  Created by alec on 7/13/15.
//  Copyright (c) 2015 alec. All rights reserved.
//

import UIKit
import RealmSwift
class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    @IBOutlet weak var catField: IQDropDownTextField!
    @IBOutlet weak var textField: UITextField!
    let autocompleteTableView = UITableView(frame: CGRectMake(0,120,320,120), style: UITableViewStyle.Plain)
    
    
    var autocompleteList = [PFObject]()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        autocompleteTableView.scrollEnabled = true
        autocompleteTableView.hidden = true
        autocompleteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AutoCompleteRowIdentifier")
        
        
        self.view.addSubview(autocompleteTableView)

        catField.isOptionalDropDown = false
        catField.itemList = ["Fruit", "Dairy", "Meat"]
        

    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String ) -> Bool{
        autocompleteTableView.hidden = false
        var substring = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        searchAutocompleteEntriesWithSubstring(substring)
        return true     // not sure about this - could be false
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        
        // need to find a way to query with out capitlization
        var query = PFQuery(className:"Ingredients")
        
        //TODO: Add query for verififactions
        query.whereKey("ingredient", containsString: substring)
        
        
        //get array
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let ingredients = objects as? [PFObject]{
                self.autocompleteList.removeAll(keepCapacity: false)

                
                for ingredient in ingredients{
                    self.autocompleteList.append(ingredient )
                }
            }
            self.autocompleteTableView.reloadData()
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
        
        
        var cell: UITableViewCell  = (tableView.dequeueReusableCellWithIdentifier(autoCompleteRowIdentifier) as? UITableViewCell)!
        let index = indexPath.row as Int
        
        cell.textLabel!.text = autocompleteList[index]["ingredient"] as? String
        println(autocompleteList[index].objectId)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        //add to realm and to parse on id
        
        let index = indexPath.row as Int
        let selectedId = autocompleteList[index].objectId
        
        
        
        //get current user and add ingredient to the parse object
        let users = Realm(path: Realm.defaultPath).objects(User)
        let currentUser = users[0]
        
        
        
        var query = PFQuery(className:"PersonalLists")
        query.whereKey("objectId", equalTo: currentUser.personalListID)
        if var personalList = query.getFirstObject(){
            personalList.addUniqueObject(selectedId, forKey: "ingredients")
            personalList.save()
            
        }

        
        
        //save new ingred to realm
        let newIng = ingred()
        newIng.name = autocompleteList[index]["ingredient"] as! String
        newIng.type = autocompleteList[index]["ingredientType"] as! String
        newIng.parseId = selectedId
        //newIng.id = newIngredID
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

    @IBAction func Save(sender: AnyObject) {
        //generate New object under parse
        //get current user and add ingredient to the parse object
        
        let newIng = ingred()
        let currentUser = User().currentUser()
        
        
        var query = PFQuery(className:"PersonalLists")
        query.getObjectInBackgroundWithId(currentUser.personalListID) {
            (personalList: PFObject?, error: NSError?) -> Void in
            if error == nil && personalList != nil {
                var newIngredient = PFObject(className:"Ingredients")
                newIngredient["ingredient"] = self.textField.text
                newIngredient["ingredientType"] = self.catField.text
               
                newIngredient.save()
                
                newIng.parseId = newIngredient.objectId
                personalList?.addUniqueObject(newIngredient.objectId, forKey: "ingredients")
                personalList?.save()
                 println(newIngredient)
            } else {
                //Alert ERROR
                println(error)
            }
        }
        
        println( newIng.parseId)
        //save new ingred to realm
        newIng.name = self.textField.text
        newIng.type = self.catField.text
        
        //newIng.id = newIngredID
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
