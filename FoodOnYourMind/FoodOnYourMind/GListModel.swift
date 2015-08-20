
import Foundation
import Parse
import CoreData
import RealmSwift




//personal List
var personalList = recipie(recipieName: "Personal List", recipieIngredients:  [] )


class GListModel {
    
   
    
    func updatePersonalList(){
        let ingredlist = Realm(path: Realm.defaultPath).objects(ingred)
        let realm = Realm()
        let users = Realm(path: Realm.defaultPath).objects(User)
        let currentUser = users[0]
        //query parse for the username
        var query = PFQuery(className:"PersonalLists")
        query.whereKey("objectId", equalTo: currentUser.personalListID)
        query.includeKey("ingredients")
        
        //save the object to local data store
        var object = query.getFirstObject()

        var toAddtoDB = [ingred]()
        //add to qqueryueue for write
        if let personalList = object["ingredients"] as? NSArray{
            for ingredient in personalList{
                
                //get realm
                var toSave = ingred()
                var query = PFQuery(className:"Ingredients")
                query.whereKey("objectId", equalTo:ingredient as! String)
                let fetechedIngred = query.getFirstObject()
                toSave.parseId = fetechedIngred.objectId
                
                println(toSave.parseId)
                if let ingredName = fetechedIngred["ingredient"] as? String{
                    toSave.name = ingredName
                }
                if let ingredType =  fetechedIngred["ingredientType"] as? String{
                    toSave.type = ingredType
                }
                toAddtoDB += [toSave]
                
                
            }
            
            
            
            
            
            //admitidly adds to complexity but
            if let checkedItems = object["checkedIngredients"] as? NSArray{
                for checkedId in checkedItems{
                    for entry in toAddtoDB{
                        if checkedId as! String == toAddtoDB[0].parseId {
                            toAddtoDB[0].checked = true
                        }
                    }
                    
                    
                    
                }
            }
            
        
            //clear out old list
            
            realm.write {
                let oldIngreds = realm.objects(ingred)
                realm.delete(oldIngreds)
            }
            //save list to realm
            for toSave in toAddtoDB{
                realm.write {
                    
                    realm.add(toSave)
                }
                
            }
        }
        else{
            //TODO: ADD ALEART, COULD NOT GET ACOUNT INFO< NO INTERNET OR LOGOUT
        
        }
        

        
    }
    
    func getAllTypes()-> [String: [ingred]] {
        let ingredFromDB = Realm(path: Realm.defaultPath).objects(ingred)
        
        var typeList = [String: [ingred]]()
        for ingredient in ingredFromDB{
            
            if let val =  typeList[ingredient.type]{
                typeList[ingredient.type]?.append(ingredient)
            }
            else{
                typeList[ingredient.type as String] = [ingredient]
            }
            
        }
        
        return typeList
    }
    func getUncheckedTypes()-> [String: [ingred]] {
         let ingredFromDB = Realm(path: Realm.defaultPath).objects(ingred)
        
        var typeList = [String: [ingred]]()
        for ingredient in ingredFromDB{
            if ingredient.checked == true{
                continue
            }
            if let val =  typeList[ingredient.type]{
                typeList[ingredient.type]?.append(ingredient)
            }
            else{
                typeList[ingredient.type as String] = [ingredient]
            }
            
        }
        
        return typeList
       
        
        
        
    }
       
}

class ingred: Object {
    dynamic var name = ""
    dynamic var type = ""
    dynamic var quanity = ""
    dynamic var parseId = ""
    dynamic var checked = false
    dynamic var id = ""

    
    dynamic var owner: recip? // Can be optional
//    override static func primaryKey() -> String? {
//        return "id"
//    }
    
}
class recip: Object {
    dynamic var name = ""
    let ingredients = List<ingred>()
}


//DEPRECHIATED
//
//All of the following code will be excluded from the production build
//it was only used for scalfolding of the app before parse/realm
class recipieList {
    
    var recipieList =  [recipie]()
    init () {


        self.updatePersonalList()

    }
    
    
    subscript(index: Int) -> recipie{
        return recipieList[index]
    }
    subscript(name : String) ->recipie?{
        for recipie in recipieList{
            if name == recipie.name{
                return recipie
            }
        }
        return nil
    }
    func updatePersonalList(){
//        var currentUser = PFUser.currentUser()
//        let personalListID = currentUser["UsersPersonalList"].objectId
//        var query = PFQuery(className:"PersonalLists")
//        query.getObjectInBackgroundWithId(personalListID) {
//            (personalList: PFObject?, error: NSError?) -> Void in
//            if error == nil && personalList != nil {
//
//            } else {
//                println(error)
//            }
//        }

        
    }
    
    func getAllTypes()-> [String: [ingredient]] {
                var typeList = [String: [ingredient]]()
                for recipie in self.recipieList{
                    for ingredient in recipie.ingredients{
                        
                        if let val =  typeList[ingredient.type]{
                            typeList[ingredient.type]?.append(ingredient)
                        }
                        else{
                            typeList[ingredient.type as String] = [ingredient]
                        }
                        
                    }
                }
        return typeList
        }
    
    func getUncheckedTypes()-> [String: [ingredient]] {

        var typeList = [String: [ingredient]]()
            for recipie in self.recipieList{
                for ingredient in recipie.ingredients{
                    if ingredient.checked == true{
                        continue
                    }
                    if let val =  typeList[ingredient.type]{
                        typeList[ingredient.type]?.append(ingredient)
                    }
                    else{
                        typeList[ingredient.type as String] = [ingredient]
                    }
                    
                }
            }
            return typeList
        
        
        
    }
    
    func toggle(cellName: String, cellAmount : String ){
        for recipie in self.recipieList{
            for ingredient in recipie.ingredients{
                if ingredient.name == cellName && ingredient.amount == cellAmount{
                    ingredient.checked = !ingredient.checked
                    println("\(ingredient.name) is now \(ingredient.checked)")

                }
            }
        }
        
    }
    func remove( cellName : String, cellAmount : String ){
        for recipie in self.recipieList{
            for (index, ingredient) in enumerate(recipie.ingredients){
                if ingredient.name == cellName && ingredient.amount == cellAmount{
                    recipie.ingredients.removeAtIndex(index)
                    println("\(ingredient.name) is now removed")
                    
                }
            }
        }
        
    }
    
    func count () -> Int {
        var toRet = 0
        for recipie in self.recipieList{
            toRet += recipie.ingredients.count
        }
        return toRet
    }
    
    func add (Name : String, Amount: String , Unit: String, Type :String  ) {
    
        var temp = ingredient(Name: "\(Name)", Amount: "\(Amount) \(Unit)", ingredientType: "\(Type)")
        if self["Other"] != nil{
            self["Other"]?.ingredients.append(temp)
        }
        else{
            var Other = recipie(recipieName: "Other", recipieIngredients:  [temp] )
            recipieList.append(Other)
        
        }
            
        
        
            
    }
    
}
    
   



    



class recipie {
    var name:String
    var ingredients : [ingredient] = []
    var checked :Bool = false
    init(recipieName: String , recipieIngredients:[ingredient]){
        name = recipieName
        ingredients = recipieIngredients
        for ingredient in recipieIngredients{
        ingredient.recipieName = recipieName
        }
    }
    subscript(index: Int) -> ingredient{
        return ingredients[index]
    }
    
    func removeIngredient ( index: Int ){
        //
        
    }
    
    func getLeft()-> [ingredient]{
        var toRet = [ingredient]()
        for x in self.ingredients{
            if(x.checked == false){
                toRet.append(x)
            }
        }
        return toRet
    }
    
    func getChecked() -> [ingredient]{
        var toRet = [ingredient]()
        for x in self.ingredients{
            if(x.checked == true){
                toRet.append(x)
            }
        }
        return toRet
    }
    
    
}
class ingredient : PFObject, PFSubclassing {
    var name : String
    var amount : String
    var type : String
    var recipieName = ""
    var displayName: String? {
        get {
            return self["displayName"] as? String
        }
        set {
            self["displayName"] = newValue
        }
    }
    class func parseClassName() -> String {
        return "Ingredeint"
    }
    var checked :Bool = false
    
    init(Name:String, Amount:String, ingredientType: String){
        //self.super.init()
        name = Name
        amount = Amount
        type = ingredientType
        super.init()
    }
   

}

