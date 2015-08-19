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
    //initilize catagory list
    var typesList = GListModel().getAllTypes()
    //keep track of slector
    var selector = 0
    
    
    
    var gModel = GListModel()
    var gList = GListModel().getAllTypes()
    
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        selector = sender.selectedSegmentIndex
        updateList(sender.selectedSegmentIndex)
    }
    
    func updateList( newSelector : Int){
        selector = newSelector
        switch selector{
        case 0:
            typesList = gList
        default:
            var foo = "bar"
            //typesList = list.getUncheckedTypes()
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
       
            return Array(typesList.values)[section].count
  
        
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
        var cell: listCell
        switch selector{
                case 0,1:
                     cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! listCell
                    let ingred = Array(typesList.values)[indexPath.section][indexPath.row]
                    cell.textLabel!.text = ingred.name
                    cell.id = ingred.id 
                     
                    //if ingredient.checked == true
                    if ingred.checked{
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
        let cellName = (currentCell!.textLabel!.text)
        let cellAmount = (currentCell!.detailTextLabel!.text)
        //list.toggle(cellName! , cellAmount: cellAmount!)
        
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
            //self.gModel.remove(cell!.textLabel!.text!, cellAmount: cell!.detailTextLabel!.text!)
            self.updateList(self.selector)
            self.tableView.reloadData()
        }
        //cancel
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Default) {action -> Void in
            
        }
        alertController.addAction(cancel)
        alertController.addAction(remove)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //long press gesture
        var gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        gesture.minimumPressDuration = 1.0
        self.view.addGestureRecognizer(gesture)
        
        //update list
        GListModel().updatePersonalList()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

