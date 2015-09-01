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
   

    var gModel = GListModel()
    var tableList = GListModel().getAllTypes()
    

    //keep track of slector
    var selector = 0
    
    
    
    
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        selector = sender.selectedSegmentIndex
        updateList(sender.selectedSegmentIndex)
    }
    
    func updateList( newSelector : Int){
        self.selector = newSelector
        switch selector{
        case 0:
            tableList = GListModel().getAllTypes()
        default:
            tableList = GListModel().getUncheckedTypes()
        }
        self.tableView.reloadData()
    }
    
    
    //number of sectons
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {return tableList.count}
    
    //number of rows within each section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Array(tableList.values)[section].count
    }
    
    //section headers
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(tableList.keys)[section]
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //initate cell
        var cell: IngredientListCell
        cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! IngredientListCell
        
        let ingred = Array(tableList.values)[indexPath.section][indexPath.row]
        cell.textLabel!.text = ingred.name
        cell.parseId = ingred.parseId 
        
        //set properties if checked off
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
    }
    
    
    
    //on click
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
       
        var currentCell = tableView.cellForRowAtIndexPath(indexPath) as! IngredientListCell?
        println(currentCell?.parseId)
        currentCell?.toggle()
        //TODO: ADD SOME SYNC FUNCTION FOR WHICH ITEAM ARE CHECKed
        self.updateList(self.selector)
        self.tableView.reloadData()
    }
    
    //on longpress
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        //get long press state
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        //get cell
        var locationInView = longPress.locationInView(tableView)
        var indexPath = tableView.indexPathForRowAtPoint(locationInView)
        let cell = tableView.cellForRowAtIndexPath(indexPath!) as! IngredientListCell?

        //alert controller init
        let alertController = UIAlertController(title: nil, message:    
            "Are you sure that you want to remove \(cell!.textLabel!.text!) from your shoping list?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let remove: UIAlertAction = UIAlertAction(title: "Remove", style: .Destructive) { action -> Void in
           
            var currentCell = self.tableView.cellForRowAtIndexPath(indexPath!) as! IngredientListCell?
            SwiftSpinner.show("Removing From List")
        
         
            
            /// need to run this code as block
            currentCell?.userDelete({(success:Bool) -> Void in
                println("value = \(success)")
                if success{
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 1))
                    dispatch_after(delayTime, dispatch_get_main_queue()){
                        GListModel().updatePersonalList()
                        self.updateList(self.selector)
                        self.tableView.reloadData()
                         SwiftSpinner.hide()
                    }
                    
                }
            
            
            
            
            })
            
            
        }
        
        //cancel
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Default) {action -> Void in
            
        }
        alertController.addAction(cancel)
        alertController.addAction(remove)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    override func  viewWillAppear(animated: Bool) {
        //update list on load
        
        self.updateList(self.selector)
        self.tableView.reloadData()

    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //addPullToRefresh
         self.tableView.addPullToRefresh({ [weak self] in
            GListModel().updatePersonalList()
            self?.updateList(self!.selector)
            self?.tableView.reloadData()

        })
        
        //addlongPressGestureRecognized
        var gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        gesture.minimumPressDuration = 1.0
        self.view.addGestureRecognizer(gesture)
        
        
        //view data
        self.tableView.reloadData()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

