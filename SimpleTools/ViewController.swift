//
//  ViewController.swift
//  SimpleTools
//
//  Created by amittal on 9/28/17.
//  Copyright © 2017 Brainfeaster. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController,WKScriptMessageHandler {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var containerView : UIView! = nil
    var webView: WKWebView?
    let configs = CommandCenter().loadConfigs()
    
    override func loadView() {
        super.loadView()
        let theConfiguration = WKWebViewConfiguration()
        let contentController = theConfiguration.userContentController
        contentController.add(self, name: "messageBox")
        self.webView = WKWebView(frame: self.view.frame, configuration: theConfiguration)
        self.webView?.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        self.view = self.webView!
    }
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        if let fromJS = message.body as? Dictionary<String, AnyObject> {
            let module = fromJS["module"] as? String
            let method = fromJS["method"] as? String
            let callback = fromJS["callback"] as? String
            let args = fromJS["args"] as? [String]
            print("module \(module) & method \(method) & callback \(callback) & args \(args)")
            let callbackParam = self.configs[module!]?.jsMethod(jsFunc: method!)
                //webView!.evaluateJavaScript("\(callback)(\(callbackParam))")
        }
    }
    
    func contactJSLayer(meth: String, para: String, processAs: jsInputType ){
        var callString = "error"
        switch processAs {
        case .jsonObj:
                callString = "\(meth)(\(para))"
            break
        case .number:
                 callString = "\(meth)(\(para))"
            break
        case .string:
                 callString = "\(meth)('\(para)')"
            break
        default: break
        }
   
        print("calling JSCode \(callString)")
        webView!.evaluateJavaScript(callString);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url1 = NSURL(fileURLWithPath:Bundle.main.path(forResource: "appBase/index", ofType:"html")!)
        webView!.load(NSURLRequest(url:url1 as URL) as URLRequest)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest r: NSURLRequest, navigationType nt: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {

    }
    
    
}

enum jsInputType {
    case string
    case number
    case jsonObj
}


