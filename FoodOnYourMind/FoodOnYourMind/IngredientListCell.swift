//
//  listCell.swift
//  TableDemo
//
//  Created by Alec on 6/21/15.
//  Copyright (c) 2015 alec. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if((index) != nil) {
            self.removeAtIndex(index!)
        }
    }
}

class IngredientListCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet  var parseId: String?
    @IBOutlet weak var checkedImage: UIImageView!

    
   
    func toggle(){
        let realm = Realm()
        let searchString = "parseId = '\(self.parseId!)'"
        
        if let toUpdate = realm.objects(ingred).filter(searchString).first {
            realm.beginWrite()
            toUpdate.checked = !toUpdate.checked
            realm.commitWrite()
            println("Updated Local")
            
            
            
        }
        else{
            println("COULD NOT UP DATE LOCAL")
            
        }
        
    }
    func deleteLocal(){
        let realm = Realm()
        let searchString = "parseId = '\(self.parseId!)'"
            
        if let toDelete = realm.objects(ingred).filter(searchString).first {
            realm.write {
                realm.delete(toDelete)
            }
             println("DELTED LOCAL")
        
        
        
        }
        else{
            println("NOT DELTED LOCAL")

        }
        
        
        

        
        //}
        
    
    }
    func deleteParse(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            let currentUser = User().currentUser()
            
            var query = PFQuery(className:"PersonalLists")
            query.whereKey("objectId", equalTo: currentUser.personalListID)
            query.includeKey("ingredients")
            
            //save the object to local data store
            query.getFirstObjectInBackgroundWithBlock { (personalList: PFObject!, error: NSError!) in
                if (error == nil) && personalList != nil{
                    if let personalListIngredients = personalList["ingredients"] as? NSArray{
                        for ingredientID in personalListIngredients{
                            //query if it already exitists
                            //confirm removed from list
                            if(ingredientID as? String == self.parseId ){
                                (personalListIngredients as! NSMutableArray).removeObject(self.parseId!)
                                personalList.save()
                                println("DELTED PARSE")

                            }
                        }
                    }
                    else {
                        println(error)
                    }
                }
            }
        }
    }
    
    //delete taken
    func userDelete(completionHandler:(success:Bool) -> Void) {
        self.deleteLocal()
        self.deleteParse()
        completionHandler(success:true)
    }
    
    var recipie:String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
