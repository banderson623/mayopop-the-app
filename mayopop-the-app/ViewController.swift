//
//  ViewController.swift
//  mayopop-the-app
//
//  Created by Brian Anderson on 8/12/15.
//  Copyright (c) 2015 Brian Anderson. All rights reserved.
//

import UIKit

// Note UIWebViewDeligate, is a protocol (interface) that we are going to implement.
// All the functions are optional overrides. We need this to detect
class ViewController: UIViewController, UIWebViewDelegate {
  
  @IBOutlet weak var webView: UIWebView!

  var webViewIsLoaded = false;
  var javascriptQueue = [String]();

  // required functions for all iOS views
  override func viewDidLoad() {
    super.viewDidLoad()

    // Set this class as the delegate (basically meaning it the functions implimenting
    // the protocol (interface) will be found in this file
    webView.delegate = self
    loadIndexPage()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // from UIWebViewDelegate protocol
  // Callback when the webpage is finished loading
  func webViewDidFinishLoad(web: UIWebView){
    webViewIsLoaded = true

    // Now that the page is loaded lets handle this javascript
    for javascript in javascriptQueue {
      executeJS(javascript)
    }
  }

  // Lets load up the index page, from the built location
  func loadIndexPage(){
    let localfilePath = NSBundle.mainBundle().URLForResource("index", withExtension: "html", subdirectory: "build")
    let request = NSURLRequest(URL: localfilePath!)
    webView.loadRequest(request)
  }

  // Execute Javascript in the context of the web
  func executeJS(js: String) -> String{
    var result = "";

    // We can only execute javascript if the page is loaded, if it is not
    // lets queue it up, and handle it later.
    if(!webViewIsLoaded){
      javascriptQueue.append(js)
    } else {
      println("Executing javascript: \(js)")
      result = webView.stringByEvaluatingJavaScriptFromString(js)!
    }
    return result
  }

}

