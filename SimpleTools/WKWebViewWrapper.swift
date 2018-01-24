//
//  WKWebViewWrapper.swift
//  SimpleTools
//
//  Created by amittal on 1/22/18.
//  Copyright © 2018 Brainfeaster. All rights reserved.
//  Used infomation from  https://mislavjavor.github.io/2016-03-08/WKWebView-advanced-tutorial/
/*
import Foundation
import WebKit

class WKWebViewWrapper : NSObject, WKScriptMessageHandler{
    
    wkWebView : WKWebView
    
    init(forWebView webView : WKWebView){
        wkWebView = webView
        super.init()
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        
    }
    
    let events = ["imagechanged", "documentReady"]
    
    func setUpPlayerAndEventDelegation(){
        
        var eventFunctions : Dictionary<String, (String)->Void> = Dictionary<String, (String)->Void>()
        
        let controller = WKUserContentController()
        wkWebView.configuration.userContentController = controller
        
        for eventname in eventNames {
            controller.addScriptMessageHandler(self, name: eventname)
            eventFunctions[eventname] = { _ in }
        }
        
        wkWebView.evaluateJavaScript("$(#tyler_durden_image).on('imagechanged', function(event, isSuccess) { window.webkit.messageHandlers.\(eventname).postMessage(JSON.stringify(isSuccess)) }", completionHandler: nil)
        
    }
    
    
}*/
