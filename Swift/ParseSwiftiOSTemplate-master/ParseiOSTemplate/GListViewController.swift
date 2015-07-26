//
//  ViewController.swift
//  TableDemo
//
//  Created by Alec on 6/19/15.
//  Copyright (c) 2015 alec. All rights reserved.
//

import UIKit
//import Parse

class GListViewController: UIViewController, UITableViewDataSource {
    //segment controll
    
    @IBOutlet var listSelector: [UISegmentedControl]!
    @IBOutlet weak var tableView: UITableView!
   
    //initalize list
    var list =  recipieList()
    //initilize catagory list
    var typesList = recipieList().getAllTypes()
    //keep track of slector
    var selector = 0
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        selector = sender.selectedSegmentIndex
        updateList(sender.selectedSegmentIndex)
    }
    
    func updateList( newSelector : Int){
        selector = newSelector
        switch selector{
        case 0:
            typesList = list.getAllTypes()
        default:
            typesList = list.getUncheckedTypes()
        }
        self.tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch selector{
        case 0,1:
            return typesList.count
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selector{
        case 0,1:
            return Array(typesList.values)[section].count
        default:
            return list.recipieList.count
        }
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch selector{
        case 0,1:
            return Array(typesList.keys)[section]
        default:
            return nil
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //this is the section that i am having trouble with, i need to protype a new cell for the
        var cell: listCell
        switch selector{
                case 0,1:
                     cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! listCell
                    let ingredient = Array(typesList.values)[indexPath.section][indexPath.row]
                    cell.textLabel!.text = ingredient.name
                    cell.detailTextLabel?.text = ingredient.amount
                    if ingredient.checked == true{
                        cell.checkedImage.image = UIImage(named: "icon-check-green")
                        cell.backgroundColor = UIColor.lightGrayColor()
                        cell.textLabel!.alpha = 0.4
                        cell.detailTextLabel!.alpha = 0.4
                        cell.checkedImage!.alpha = 0.4

                    }
                    else{
                        cell.checkedImage.image = UIImage(named: "icon-check-grey")
                        cell.backgroundColor = UIColor.whiteColor()
                        cell.textLabel!.alpha = 1
                        cell.detailTextLabel!.alpha = 1
                        cell.checkedImage!.alpha = 1
                    }
                    return cell
                default:
                    cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! listCell
                    cell.textLabel!.text == "test"//list[0].name
                    return (cell)
        }
        
    }
    
        
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
       
        var currentCell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell?
        //currentCell.checkedImage.image = UIImage(named: "icon-check-green")
        let cellName = (currentCell!.textLabel!.text)
        let cellAmount = (currentCell!.detailTextLabel!.text)
        list.toggle(cellName! , cellAmount: cellAmount!)
        self.tableView.reloadData()


    }
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        //get long press state
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        //get cell
        var locationInView = longPress.locationInView(tableView)
        var indexPath = tableView.indexPathForRowAtPoint(locationInView)
        let cell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell?
        
        //alert controller init
        let alertController = UIAlertController(title: nil, message:    
            "Are you sure that you want to remove \(cell!.textLabel!.text!) from your shoping list?", preferredStyle: UIAlertControllerStyle.Alert)
        
       //alert actions
        let remove: UIAlertAction = UIAlertAction(title: "Remove", style: .Destructive) { action -> Void in
            self.list.remove(cell!.textLabel!.text!, cellAmount: cell!.detailTextLabel!.text!)
            self.updateList(self.selector)
            self.tableView.reloadData()
        }
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Default) {action -> Void in
            
        }
        alertController.addAction(cancel)
        alertController.addAction(remove)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        var gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        gesture.minimumPressDuration = 1.0
        self.view.addGestureRecognizer(gesture)
        
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

