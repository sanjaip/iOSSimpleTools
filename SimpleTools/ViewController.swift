//
//  ViewController.swift
//  SimpleTools
//
//  Created by amittal on 9/28/17.
//  Copyright © 2017 Brainfeaster. All rights reserved.
//

import UIKit
import CoreData
import WebKit

class ViewController: UIViewController,WKScriptMessageHandler {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var containerView : UIView! = nil
    var webView: WKWebView?
    
    
    
    override func loadView() {
        super.loadView()
          let theConfiguration = WKWebViewConfiguration()
        let contentController = theConfiguration.userContentController
        //http://www.joshuakehn.com/2014/10/29/using-javascript-with-wkwebview-in-ios-8.html
        // alert fix, at start to allow a JS script to overwrite it
       /* contentController.addUserScript( WKUserScript(
            source: "window.alert = function(message){window.webkit.messageHandlers.messageBox.postMessage({message:message});};",
            injectionTime: WKUserScriptInjectionTime.atDocumentStart,
            forMainFrameOnly: true
        ) )*/
        contentController.add(self, name: "messageBox")
        
        self.webView = WKWebView(frame: self.view.frame, configuration: theConfiguration)
        
        // and here things like: self.webView!.navigationDelegate = self
        self.view = self.webView!  // fill controllers view
    }
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        
        if message.name == "messageBox" {
            //let sentData = message.body as! Dictionary<String, String>
            print("\(message.body)")
            getData()
           
            //let message:String? = sentData["message"]
            
            //let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
            //alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment:"btnOK"), style: .default, handler: nil))
            //self.present(alertController, animated: true) {}
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var url: NSURL? = nil
        if let filePath = Bundle.main.path(forResource: "index.html", ofType: nil){
            url = NSURL(string: filePath)
        }
        
        print("index file FilePath: \(url?.path)")
        
        
        //let url = URL (string: "https://www.google.com")
        let requestObj = URLRequest(url: url! as URL)
        self.webView!.load(requestObj)
        
        let url1 = NSURL(fileURLWithPath:Bundle.main.path(forResource: "index", ofType:"html")!)
        
       // webView = WKWebView(frame:view.frame)
        webView!.load(NSURLRequest(url:url1 as URL) as URLRequest)
        
        /*let array = [ "one", "two" ]
        if let objectData = try? JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            print("\(objectString)")
        }*/
        
        
        populateCoreDataTables()
        //DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
         //  self.getData()
        //})
        
        //webView.loadRequest(requestObj)
    }

    
    //MARK: - UIWebView Delegate Methods
    func webView(webView: UIWebView, shouldStartLoadWithRequest r: NSURLRequest, navigationType nt: UIWebViewNavigationType) -> Bool {
        /*let urlString: NSString = r.URL!.description
        let protocolString: NSString = _protocolString
        
        if nt == .LinkClicked {
            if let fileUrl: String = r.URL!.path {
                //This is temporary fix because EOB pfd is not returning angularjs function call to native
                if (urlString as NSString).rangeOfString("/Documents/").location == NSNotFound && (urlString as NSString).rangeOfString(appBundle).location == NSNotFound{
                    if let path: String = (fileUrl as NSString).pathExtension {
                        if (path.caseInsensitiveCompare("pdf") == NSComparisonResult.OrderedSame){
                            let filePath: String = r.URL!.absoluteString!
                            let _relativePath = (filePath as NSString).substringFromIndex(7)
                            let relativePath: String = _relativePath as String
                            print("relativePath::\(relativePath)")
                            let httpUrl = "\(CFFramework.syncManager().urlForTargetPath())\(relativePath)"
                            showIndicator()
                            CFFramework.utilityManager().displayFileInDocumentController(httpUrl, mimeType: nil, fileType: "PDF", handleRedirection: false, completionBlock: {
                                self.hideIndicator()
                            })
                            return false
                        }
                    }
                }
            }
        }
        
        if urlString.rangeOfString(protocolString as String).location != NSNotFound{
            let functionName: NSString = functionNameInURL(urlString, withProtocol: protocolString)
            var argsList:NSArray = NSArray()
            argsList = argumentsInURL(urlString, funcName:functionName)
            handleFunction(functionName, withAruguments: argsList)
            return false;
        }*/
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
       // hideIndicator()
        populateCoreDataTables()
    }
    
    
    func populateCoreDataTables(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        // prints 1-10
        for i in 1...5 {
            getDataFromURL(id:i) {(addr) in
                let addrEntity = NSEntityDescription.entity(forEntityName: "Address", in:managedContext)!
                let addrMO = NSManagedObject(entity:addrEntity,insertInto:managedContext)
                addrMO.setValue(addr["street"] as? String, forKeyPath: "street")
                addrMO.setValue(addr["city"] as? String, forKeyPath: "city")
                addrMO.setValue(addr["suite"] as? String, forKeyPath: "suite")
                addrMO.setValue(addr["zipcode"] as? String, forKeyPath: "zipcode")
                
                let geoObj = addr["geo"] as? [String: Any]
                addrMO.setValue(Float((geoObj?["lat"] as? String)!), forKeyPath: "lat")
                addrMO.setValue(Float((geoObj?["lng"] as? String)!), forKeyPath: "lng")
                
                do{
                    try managedContext.save()
                }
                catch let error as NSError {
                    print("Could not save. \(error) \(error.userInfo)")
                }

            };
        }
    }
    
    func getData(){
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Address")
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            var builtJson: [Any] = []
            

            
            for result in results as [NSManagedObject] {
                let lat = "\(result.value(forKey: "lat") as! Float? ?? 0.0)"
                let lng = "\(result.value(forKey: "lng") as! Float? ?? 0.0)"
                let geo = ["lat":lat,
                           "lng":lng]
                
                let street = result.value(forKey: "street") as! String? ?? ""
                let city = result.value(forKey: "city") as! String? ?? ""
                let suite = result.value(forKey: "suite") as! String? ?? ""
                let zipcode = result.value(forKey: "zipcode") as! String? ?? ""
                
                if(street+city+suite+zipcode != "")
                {
                let addrObj = ["street": street,
                            "city": city ,
                            "suite": suite,
                            "zipcode": zipcode,
                            "geo":geo] as [String:Any]
                builtJson.append(addrObj)
                }
            }
            //print("Json data: \(builtJson)")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: builtJson, options:[])
                print("Json data: \(jsonData)")
                let cleanJsonData = jsonData.base64EncodedData(options: .endLineWithLineFeed)
                
                
                
                if let stringJSON = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                    let start = "var abcd='"
                    let stop = "'"
                   
                    //let finalString = start + "\(stringJSON)" + stop
                    //let stringJSONProcessed = stringJSON.replacingOccurrences(of: "\"", with:"")
                    //let tester = "asasasasd"
                    //let base = stringJSON.lengthOfBytes(using: String.Encoding.utf8.rawValue)
                    
                    //write to file
                    // Save data to file
                    let fileName = "Test"
                    let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    
                    //let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("js")
                    //print("FilePath: \(fileURL.path)")
                    
                   /* 
                     //let writeString = "Write this text to the fileURL as text in iOS using Swift"
                    do {
                        // Write to the file
                       try jsonData.write(to: fileURL, atomically: true, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                    } catch let error as NSError {
                        print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
                    }
                    
                    var readString = "" // Used to store the file contents
                    do {
                        // Read the file contents
                        readString = try String(contentsOf: fileURL)
                    } catch let error as NSError {
                        print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
                    }
                    //print("File Text: \(readString)")
                    
                    */
                    
                    
                    
                    self.webView?.evaluateJavaScript("abcd('\(stringJSON)')", completionHandler: { result, error in
                        print("Completed Javascript evaluation.")
                        print("Result: \(result)")
                        print("Error: \(error)")
                    })
                    
                    // print("json as string \(stringJSONProcessed) at \(base)")
                    //self.webView.stringByEvaluatingJavaScript(from: "abcd('\(tester)')")
                    //https://www.hackingwithswift.com/example-code/wkwebview/whats-the-difference-between-uiwebview-and-wkwebview
                    
                }
                /*let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                if let dictFromJSON = decoded as? [String:String] {
                    print("converted jSON data: \(dictFromJSON)")
                    
                }*/
               
            } catch {
                print(error.localizedDescription)
            }
            /*let arrT = [ "one", "two" ]
            let arrTe = [ "one": arrT ] as [String : Any]
            let arrTes = [ "one": arrTe ] as [String : Any]
            let arrTest = [ "one": arrTes ] as [String : Any]
            let dic = ["2": arrTest ,
                       "1": "A",
                       "3": "C"] as [String : Any]
            
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                print("Json data: \(jsonData)")
                if let stringJSON = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                    print("json as string \(stringJSON)")
                }
                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                // here "decoded" is of type `Any`, decoded from JSON data
                // you can now cast it with the right type
                if let dictFromJSON = decoded as? [String:String] {
                    // use dictFromJSON
                    print("converted jSON data: \(dictFromJSON)")
                    
                }
            } catch {
                print(error.localizedDescription)
            }*/
            

           
           /* var productArray = Array<(id: Int,quantity: Int)>()
            productArray += [(123, 1000)]
            productArray += [(456, 50)]
            let productDictArray = productArray.map { (product) -> [String : Int] in
                [
                    "id": product.id,
                    "quantity": product.quantity
                ]
            }
            let jsonObject: [String: AnyObject] = [
                "order": 1,
                "client" : 1,
                "plats": productDictArray
            ]
            
            // encode the Array into a JSON string
            // convert to Data, then convert to String
            if let jsonData = try? JSONEncoder().encode(addrObjS),
                let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                
                // [{"name":"Foo","longitude":20,"latitude":1},{"name":"Foo","longitude":20,"latitude":2},{"name":"Foo","longitude":20,"latitude":3}]
                
                // decode the JSON string back into an Array
                // convert to Data, then convert to [addrObjS]
                if let vendorData = jsonString.data(using: .utf8),
                    let vendorArray = try? JSONDecoder().decode([AddressObject].self, from: addrObjS) {
                    print(vendorArray)
                    
                    // [__lldb_expr_8.Vendor(name: "Foo", latitude: 1.0, longitude: 20.0), __lldb_expr_8.Vendor(name: "Foo", latitude: 2.0, longitude: 20.0), __lldb_expr_8.Vendor(name: "Foo", latitude: 3.0, longitude: 20.0)]
                }
            }*/
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func convertToDictionary(rslt: NSManagedObject) -> [String : Any] {
        let result = rslt
        let dic: [String: Any] = ["street":result.value(forKey: "street") ?? "",
                                  "city":result.value(forKey: "city") ?? "",
                                  "suite":result.value(forKey: "suite") ?? "",
                                  "zipcode":result.value(forKey: "zipcode") ?? "",
                                  "lat":result.value(forKey: "lat") ?? "",
                                  "lng":result.value(forKey: "lng") ?? ""]
        return dic
    }
    
    func getDataFromURL(id : Int, handler:  @escaping (([String: Any]) -> Void)) {
        let idVal = "\(id)"
        let url = URL(string: "https://jsonplaceholder.typicode.com/users/" + idVal)
        if let usableUrl = url {
            let request = URLRequest(url: usableUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                // 1
                var json: Any
                do {
                    json = try JSONSerialization.jsonObject(with: data!)
                    guard let dictionary = json as? [String: Any] else {
                        print("error in crating dictionary")
                        return;
                    }
                    //print("printing dictionary \(dictionary)")
                    let temp = dictionary["address"] as? [String: Any]
                    handler(temp!)
                } catch {
                    print(error)
                }
                
                
            })
            task.resume()
        }
    }

}

public struct AddressObject {
    var street: String
    var city: String
    var suite: String
    var zipcode: String
    var lat: String
    var lng: String
    
    init(street: String,
         city: String,
         suite: String,
         zipcode: String,
         lat: String,
         lng: String){
        self.street=street
        self.city=city
        self.suite=suite
        self.zipcode=zipcode
        self.lat=lat
        self.lng=lng
    }
}



