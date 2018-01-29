//
//  DummyJSONProcessor.swift
//  SimpleTools
//
//  Created by amittal on 1/26/18.
//  Copyright © 2018 Brainfeaster. All rights reserved.
//

import Foundation

class DummyJsonParser:NSObject{

func getDataFromURL(id : Int, handler:  @escaping (([String: Any]) -> Void)) {
    let idVal = "\(id)"
    // let url = URL(string: "https://jsonplaceholder.typicode.com/users/" + idVal)
    let url = URL(string: "http://164.100.47.193/android_rssfeed_ls/all_members.aspx")
    if let usableUrl = url {
        let request = URLRequest(url: usableUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            var json: Any
            do {
                print("\(data)")
                json = try JSONSerialization.jsonObject(with: data!)
                guard let dictionary = json as? [String: Any] else {
                    print("error in crating dictionary")
                    return;
                }
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
