//
//  RSMProcessor.swift
//  SimpleTools
//
//  Created by amittal on 1/26/18.
//  Copyright © 2018 Brainfeaster. All rights reserved.
//  https://www.hackingwithswift.com/example-code/wkwebview/whats-the-difference-between-uiwebview-and-wkwebview

import Foundation
import CoreData
import UIKit

class RSMProcessor: NSObject, XMLParserDelegate,modulesProtocol {
    
    var items = [RSM_BO]()
    var item = RSM_BO()
    var foundCharacters = ""
    let jsFuncs = ["fillLocalDBFromService",
                   "getRSMLocalDBCount",
                   "getRSMJson"]
    var coreDataFilled = false
    
    
    func modName() -> String {
        return "RSM"
    }
    
    //JS BRIDGE
    func jsMethods() -> [String]{
        return jsFuncs
    }
    
    func jsMethod(jsFunc: String) -> String {
        switch jsFunc {
            case jsFuncs[0]:
                getXMLServiceData ()
                return "Done"
            case jsFuncs[1]:
                 callbackJSMethodWKwebview(meth:jsFuncs[1],para:"\(currentNoOfRecords())",processAs: jsInputType.number);
                return "Done"
            case jsFuncs[2]:
                getData(desFunc: jsFuncs[2])
                return "Done"
            default:
                print("Error")
                return "Error"
        }
    }
    
    func callbackJSMethodWKwebview(meth: String, para: String, processAs: jsInputType){
        if let wd = UIApplication.shared.delegate?.window {
            let vc = wd!.rootViewController
            if(vc is ViewController){
                let vci = vc as! ViewController
                vci.contactJSLayer(meth:meth,para:para, processAs: processAs);
            }
        }
    }
    
    //Module PROTOCOL
    func layFoundation() {
        //do something
    }
    
    //Check current no of records
    func currentNoOfRecords () -> Int {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return 0
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RSM")
        do
        {
            let count = try managedContext.count(for: fetchRequest)
             print("\(count)")
            return count
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
    
    
    //SERVICE ASYNC CALL
    func getXMLServiceData () {
        let url = URL(string: "http://164.100.47.193/android_rssfeed_ls/all_members.aspx")
        if let usableUrl = url {
            let request = URLRequest(url: usableUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                do {
                    // let xmlData = data?.dataUsingEncoding(String.Encoding.utf8)!
                    let parser = XMLParser(data: data!)
                    parser.delegate = self;
                    parser.parse()
                }
            })
            task.resume()
        }
    }

    //CORE DATA - Write
    func populateCoreDataTables(){
        guard let appDelegate =  UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        //let RSMEntity = NSEntityDescription.entity(forEntityName: "RSM", in:managedContext)!
        //let rsmMO = NSManagedObject(entity:RSMEntity,insertInto:managedContext)
        
        /*for (NSDictionary *entries in dataArray){
   
        }
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }*/
        
        for index in 0...self.items.count - 1 {
            let item1: RSM_BO = items[index]
            let RSMItem = NSEntityDescription.insertNewObject(forEntityName: "RSM",into: managedContext) as! RSM
         
            RSMItem.constituencies = item1.Constituencies
            RSMItem.emailID = item1.EmailID
            RSMItem.localaddress = item1.Localaddress
            RSMItem.localphone = item1.Localphone
            RSMItem.memberId=item1.memberId
            RSMItem.name=item1.Name
            RSMItem.paddress=item1.Paddress
            RSMItem.party = item1.Party
            RSMItem.permanentphone = item1.Permanentphone
            RSMItem.sno = item1.Sno
            RSMItem.state = item1.State
            
            //print("item to be processesd \(item1.toJSON())")

            /*let geoObj = addr["geo"] as? [String: Any]
            rsmMO.setValue(Float((geoObj?["lat"] as? String)!), forKeyPath: "lat")
            rsmMO.setValue(Float((geoObj?["lng"] as? String)!), forKeyPath: "lng")*/
        }
            do{
                //if(item1.isValidObject()){
                   
                    try managedContext.save()
                //}
                //else{
                // print("not saving \(item1.toJSON())")
                //}
            }
            catch let error as NSError {
                print("Could not save. \(error) \(error.userInfo)")
            }
        
        coreDataFilled = true;
        print("save to CoreData ended!!!!")
        callbackJSMethodWKwebview(meth:"callBack_fillLocalDBFromService",para:"Done",processAs: jsInputType.string);
    }
    
    //CORE DATA - Read
    func getData(desFunc: String){
        guard let appDelegate =
             UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RSM")
        do {
            let resultsRaw = try managedContext.fetch(fetchRequest)
            var RSMArray : [Any] = []
            let  results = resultsRaw as! [RSM]
            for result in results {
                let item1 = RSM_BO()
                item1.Constituencies = result.value(forKey: "constituencies") as! String? ?? ""
                item1.EmailID = result.value(forKey: "emailID") as! String? ?? ""
                item1.Localaddress = result.value(forKey: "localaddress") as! String? ?? ""
                item1.Localphone = result.value(forKey: "localphone") as! String? ?? ""
                item1.memberId = result.value(forKey: "memberId") as! String? ?? ""
                item1.Name = result.value(forKey: "name") as! String? ?? ""
                item1.Paddress = result.value(forKey: "paddress") as! String? ?? ""
                item1.Party = result.value(forKey: "party") as! String? ?? ""
                item1.Permanentphone = result.value(forKey: "permanentphone") as! String? ?? ""
                item1.Sno = result.value(forKey: "sno") as! String? ?? ""
                item1.State = result.value(forKey: "state") as! String? ?? ""
                RSMArray.append(item1.toJSON())
            }
            do {
                let finalJSON = notPrettyString(from: RSMArray)
                print("final JSON: \(finalJSON)")
                callbackJSMethodWKwebview(meth:desFunc,para:finalJSON!,processAs: jsInputType.jsonObj);
                
            } catch {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    
    
   
   //PARSER FUNCTIONS
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        /* if elementName == "tag" {
         //let tempTag = Tag();
         if let name = attributeDict["name"] {
         // tempTag.name = name;
         }
         if let c = attributeDict["count"] {
         if let count = Int(c) {
         // tempTag.count = count;
         }
         }
         // self.item.tag.append(tempTag);
         }*/
    }
    
    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: []) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string;
        // print("\(self.foundCharacters) ")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("parsing ended!!!! count: \(self.items.count)")
        populateCoreDataTables()
        /*for item in self.items {
         print("\(item.author)\n\(item.desc)");
         for tags in item.tag {
         if let count = tags.count {
         print("\(tags.name), \(count)")
         } else {
         print("\(tags.name)")
         }
         }
         print("\n")
         }*/
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        let badchar = CharacterSet(charactersIn: "\"")
        let val = self.foundCharacters.components(separatedBy: badchar).joined()
        if elementName == "Sno" {
            self.item.Sno = val
        }
        if elementName == "memberId" {
            self.item.memberId = val
        }
        if elementName == "Name" {
            self.item.Name = val
        }
        if elementName == "Party" {
            self.item.Party = val
        }
        if elementName == "Constituencies" {
            self.item.Constituencies = val
        }
        if elementName == "State" {
            self.item.State = val
        }
        if elementName == "Paddress" {
            self.item.Paddress = val
        }
        if elementName == "Permanentphone" {
            self.item.Permanentphone = val
        }
        if elementName == "Localaddress" {
            self.item.Localaddress = val
        }
        if elementName == "Localphone" {
            self.item.Localphone = val
        }
        if elementName == "EmailID" {
            self.item.EmailID = val
        }
        if elementName == "Member" {
            let tempItem = RSM_BO();
            tempItem.Constituencies = self.item.Constituencies
            tempItem.EmailID = self.item.EmailID
            tempItem.Localaddress = self.item.Localaddress
            tempItem.Localphone = self.item.Localphone
            tempItem.memberId=self.item.memberId
            tempItem.Name=self.item.Name
            tempItem.Paddress=self.item.Paddress
            tempItem.Party = self.item.Party
            tempItem.Permanentphone = self.item.Permanentphone
            tempItem.Sno = self.item.Sno
            tempItem.State = self.item.State
            
            self.items.append(tempItem)
        }
        self.foundCharacters = ""
    }
}

class RSM_BO {
    var Sno: String?;
    var memberId: String?;
    var Name: String?;
    var Party: String?;
    var Constituencies: String?;
    var State: String?;
    var Paddress: String?;
    var Permanentphone: String?;
    var Localaddress: String?;
    var Localphone: String?;
    var EmailID: String?;
    
    func isValidObject() -> Bool{
        var rtnVal = false;
        
        if((self.Sno != nil) &&
        (self.memberId != nil) &&
        (self.Name != nil) &&
        (self.Party != nil) &&
        (self.Constituencies != nil) &&
        (self.State != nil) &&
        (self.Paddress != nil) &&
        (self.Permanentphone != nil) &&
        (self.Localaddress != nil) &&
        (self.Localphone != nil) &&
        (self.EmailID != nil) &&
        (self.Permanentphone != nil)){
            rtnVal = true;
        }
        return rtnVal;
    }
    
    func chkForNil() -> Bool{
        return self.Sno!.isEmpty ||
            self.memberId!.isEmpty ||
            self.Name!.isEmpty ||
            self.Party!.isEmpty ||
            self.Constituencies!.isEmpty ||
            self.State!.isEmpty ||
            self.Paddress!.isEmpty ||
            self.Permanentphone!.isEmpty ||
            self.Localphone!.isEmpty ||
            self.Localaddress!.isEmpty ||
            self.EmailID!.isEmpty
    }
    
    func toJSON() -> [String:Any] {
        var dictionary: [String : Any] = [:]
        dictionary["Sno"] = self.Sno
        dictionary["memberId"] = self.memberId
        dictionary["Name"] = self.Name
        dictionary["Party"] = self.Party
        dictionary["Constituencies"] = self.Constituencies
        dictionary["State"] = self.State
        dictionary["Paddress"] = self.Paddress
        dictionary["Permanentphone"] = self.Permanentphone
        dictionary["Localaddress"] = self.Localaddress
        dictionary["Localphone"] = self.Localphone
        dictionary["EmailID"] = self.EmailID
        return dictionary
    }
    
}
