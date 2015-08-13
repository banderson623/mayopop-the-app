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
  var javascriptQueue = [String]()
  var myMayoRecipe = MayoRecipe()

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

  // Lets load up the index page, from the build location
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

  // This is sort of the magic here, this captures requests/links and does something with them.

  // The protocol defined function for intercepting and inspecting
  // url requests made from the UIWebView. Returning true will
  // let the request be made, returning false cancels it.
  //
  // We use this to capture native calls!
  //
  func webView(webView: UIWebView,
    shouldStartLoadWithRequest request: NSURLRequest,
    navigationType nType: UIWebViewNavigationType) -> Bool {
      let urlString = request.URL?.absoluteString

      // If the string starts with 'ios:' then we know it is a call to a function here
      if (urlString!.substringToIndex(advance(urlString!.startIndex,4)) == "ios:") {
        let slicedURL = urlString!.componentsSeparatedByString(":")
        // Using the convention of ios:<function name>:<argument 1>:<argument 2>:...
        // we can pluck these out
        let functionName:String = slicedURL[1];
        let arguments: Array<String> = Array(slicedURL[2..<slicedURL.count])

//        println("got an ios function call: \(functionName)")
//        println("with arguments: \(arguments)")

        switch functionName {
        case "step":
          myMayoRecipe.onStepChange(arguments[0])
          executeJS("console.log(\"got it\")")
          break
        case "remindMe":
          scheduleReminder(arguments[0], message: arguments[1]);
          break
        case "log":
          println("console.log \(arguments)")
          break
        default : println("UNHANDLED \(functionName) (\(urlString))")
        }

        // we do not want to actually leave the page when this is triggered
        return false
      }

      // make sure real requests are requested
      return true
  }

  func scheduleReminder(timeInSeconds: String, message: String){
    println("sending message \(message) in \(timeInSeconds)");
    let seconds = NSTimeInterval(timeInSeconds.toInt()!)
    var notification = UILocalNotification()
    notification.timeZone = NSTimeZone.defaultTimeZone()
    notification.fireDate = NSDate(timeIntervalSinceNow: seconds)
    notification.alertBody = message;
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
  }

}

