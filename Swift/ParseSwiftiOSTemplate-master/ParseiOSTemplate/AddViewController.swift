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
    
//    @IBOutlet weak var nameField: UITextField!
//    @IBOutlet weak var qtyField: UITextField!
//    @IBOutlet weak var unitField: IQDropDownTextField!
    @IBOutlet weak var catField: IQDropDownTextField!
    @IBOutlet weak var textField: UITextField!
    let autocompleteTableView = UITableView(frame: CGRectMake(0,120,320,120), style: UITableViewStyle.Plain)
    
    var pastUrls = ["Men", "Women", "Cats", "Dogs", "Children"]
    var autocompleteUrls = [String]()
    
        
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

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String ) -> Bool
    {
        autocompleteTableView.hidden = false
        var substring = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        searchAutocompleteEntriesWithSubstring(substring)
        return true     // not sure about this - could be false
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        autocompleteUrls.removeAll(keepCapacity: false)
        
        for curString in pastUrls
        {
            var myString:NSString! = curString as NSString
            
            var substringRange :NSRange! = myString.rangeOfString(substring)
            
            if (substringRange.location  == 0)
            {
                autocompleteUrls.append(curString)
            }
        }
        
        autocompleteTableView.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteUrls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
        //var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(autoCompleteRowIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        var cell: UITableViewCell  = (tableView.dequeueReusableCellWithIdentifier(autoCompleteRowIdentifier) as? UITableViewCell)!
        let index = indexPath.row as Int
        
        cell.textLabel!.text = autocompleteUrls[index]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        textField.text = selectedCell.textLabel!.text
    }

    @IBAction func Save(sender: AnyObject) {
        //generate object under parse
        //get current user and add ingredient to the parse object
        let users = Realm(path: Realm.defaultPath).objects(User)
        let currentUser = users[0]
        var newIngredID = "NO ID";
        
        
        var query = PFQuery(className:"PersonalLists")
        query.getObjectInBackgroundWithId(currentUser.personalListID) {
            (personalList: PFObject?, error: NSError?) -> Void in
            if error == nil && personalList != nil {
                var newIngredient = PFObject(className:"Ingredients")
                newIngredient["ingredient"] = self.textField.text
                newIngredient["ingredientType"] = self.catField.text
                newIngredID = newIngredient.objectId
                newIngredient.save()
                personalList?.addUniqueObject(newIngredient, forKey: "ingredients")
                personalList?.save()
                
            } else {
                println(error)
            }
        }
        
        
        //save new ingred to realm
        let newIng = ingred()
        newIng.name = self.textField.text
        newIng.type = self.catField.text
        newIng.id = newIngredID
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
