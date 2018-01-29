//
//  CommandCenter.swift
//  SimpleTools
//
//  Created by amittal on 1/26/18.
//  Copyright © 2018 Brainfeaster. All rights reserved.
//

import Foundation

class CommandCenter : NSObject {
    
    var delegate: modulesProtocol?
    
    func loadConfig(){
        delegate?.layFoundation()
    }
    
    func loadConfigs() -> [String: modulesProtocol] {
        var rtnDict: [String : modulesProtocol] = [:]
        
        //objects for all modules would be present here and will be accessed by UIViewCtrl.
        let tempModule = RSMProcessor()
        rtnDict[tempModule.modName()] = tempModule //1.RSM Module
        
        return rtnDict;
    }
}

protocol modulesProtocol {
    func layFoundation()
    func jsMethods() -> [String]
    func jsMethod(jsFunc: String) -> String
}

