//
//  DetailViewController.swift
//  christiansongs
//
//  Created by jijo on 3/9/15.
//  Copyright (c) 2015 jeesmon. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webViewSong: UIWebView!
    //var songObj : Songs!
    var isLoading : Bool = false
 
    var songObj: Songs? {
        
        didSet {
            
            
            NSURLCache.sharedURLCache().removeAllCachedResponses()

        }
    }
    
    var language : MasterViewController.LangType = MasterViewController.LangType.Malyalam
    
    var songFilePath : String {
        
        if language == MasterViewController.LangType.Malyalam {
            return songObj!.filename_ml
        }else{
            return songObj!.filename_en
        }
    }
    var songTitle : String {
        
        if language == MasterViewController.LangType.Malyalam {
            return songObj!.title_ml
        }else{
            return songObj!.title_en
        }
    }

    @IBAction func fontPlusClicked(sender: UIBarButtonItem) {
       
        var docpath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask , true)[0] as String
        docpath = docpath.stringByAppendingPathComponent("style.css")
        
        var filecontent = String(contentsOfFile: docpath, encoding: NSUTF8StringEncoding, error: nil)
        
        if filecontent != nil {
            
            let searchtxt = "font-size : "
            
            let range = filecontent!.rangeOfString(searchtxt)
            if range != nil {
                
                let newtext : String? = filecontent!.substringFromIndex(range!.endIndex)
                if newtext != nil {
                    
                    let newrange = newtext!.rangeOfString(";")

                    let fontsize : String = newtext!.substringToIndex(newrange!.startIndex)
                    if !fontsize.isEmpty {
                        var fontsizedouble : Double = (fontsize as NSString).doubleValue
                        fontsizedouble += 0.1
                        
                        self.webViewSong.stringByEvaluatingJavaScriptFromString("resizeText(\(fontsizedouble))")
                        //\\d+(\\.{0,1}(\\d+?))?
                        
                        let rangere = filecontent!.rangeOfString("\(searchtxt)[+-]?\\d*\\.?\\d+em;", options: NSStringCompareOptions.RegularExpressionSearch, range: Range(start:filecontent!.startIndex, end:filecontent!.endIndex), locale: NSLocale.currentLocale())
                        if rangere != nil {
                            
                            let newmodtext = filecontent!.stringByReplacingCharactersInRange(rangere!, withString: "\(searchtxt)\(fontsizedouble)em;")
                            
                            newmodtext.writeToFile(docpath, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
                        }
                        
                        
                    }
                    
                }
                
            }

        }
        //webViewSong.reload()

    }
    @IBAction func fontMinusClicked(sender: UIBarButtonItem) {
        
        var docpath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask , true)[0] as String
        docpath = docpath.stringByAppendingPathComponent("style.css")
        
        var filecontent = String(contentsOfFile: docpath, encoding: NSUTF8StringEncoding, error: nil)
        
        if filecontent != nil {
            
            let searchtxt = "font-size : "
            
            let range = filecontent!.rangeOfString(searchtxt)
            if range != nil {
                
                
                let newtext : String? = filecontent!.substringFromIndex(range!.endIndex)
                if newtext != nil {
                    
                    let newrange = newtext!.rangeOfString(";")
                    
                    let fontsize : String = newtext!.substringToIndex(newrange!.startIndex)
                    if !fontsize.isEmpty {
                        var fontsizedouble : Double = (fontsize as NSString).doubleValue
                        fontsizedouble -= 0.1
                        
                        self.webViewSong.stringByEvaluatingJavaScriptFromString("resizeText(\(fontsizedouble))")
                        //\\d+(\\.{0,1}(\\d+?))?
                        
                        let rangere = filecontent!.rangeOfString("\(searchtxt)[+-]?\\d*\\.?\\d+em;", options: NSStringCompareOptions.RegularExpressionSearch, range: Range(start:filecontent!.startIndex, end:filecontent!.endIndex), locale: NSLocale.currentLocale())
                        if rangere != nil {
                            
                            let newmodtext = filecontent!.stringByReplacingCharactersInRange(rangere!, withString: "\(searchtxt)\(fontsizedouble)em;")

                            newmodtext.writeToFile(docpath, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
                        }
                        
                        
                    }
                    
                }
                
            }
            
        }
        //webViewSong.reload()
    }
    @IBAction func settingsClicked(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func actionButtonClicked(sender : UIBarButtonItem){
    
        //let actionsht = UIActionSheet(title: "Christian Songs", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Bookmark", "Email")
        var actionSheet =  UIAlertController(title: "Christian Songs", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheet.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Bookmark", style: .Default) { action -> Void in
            //Code for launching the camera goes here
            self.performSegueWithIdentifier("presentBMAdd", sender: self)
        }
        actionSheet.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Email", style: .Default) { action -> Void in
            //Code for picking from camera roll goes here
        }
        actionSheet.addAction(choosePictureAction)
        
        //We need to provide a popover sourceView when using it on iPad
        actionSheet.popoverPresentationController?.barButtonItem = sender
        
        //Present the AlertController
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }

    

    func configureView() {
        
        // Update the user interface for the detail item.
        //println("songObj!.filename_ml = \(songObj!.filename_ml)!")
        
        
        //println("songpath = \(songpath)!")
        
        
        
        //let req = NSURLRequest(URL: NSURL(fileURLWithPath : songpath!)!)
        //webViewSong.loadRequest(req)
        
        
        let songpath = NSBundle.mainBundle().pathForResource(songFilePath, ofType: "")
        let text2 = String(contentsOfFile: songpath!, encoding: NSUTF8StringEncoding, error: nil)
        
        let docpath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask , true)[0] as String
        isLoading = true
        webViewSong.delegate = self
        webViewSong.loadHTMLString(text2, baseURL: NSURL(fileURLWithPath : docpath))
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if songObj != nil {
            
            self.configureView()
            self.navigationItem.title = songTitle
            
        }else{
            self.navigationItem.title = ""
        }
    }
    /*deinit {
        webViewSong = nil
    }*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "presentBMAdd" {
            
            let controller = (segue.destinationViewController as UINavigationController).topViewController as BMAddTableViewController
            
           
            var newBMTemp =  Dictionary<String, String>()
            
            newBMTemp["songtitle"] = songTitle
            newBMTemp["songs_id"] = songObj!.songs_id
            
            controller.folder = BMDao().getDefaultFolder()
            controller.newBM = newBMTemp
        }
    }
    // MARK: UIWebViewDelegate
    
    func webViewDidStartLoad(webView: UIWebView){
        
    }
    func webViewDidFinishLoad(webView: UIWebView){
        
        if isLoading == true {
            
            
            var docpath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask , true)[0] as String
            docpath = docpath.stringByAppendingPathComponent("style.css")
            
            var filecontent = String(contentsOfFile: docpath, encoding: NSUTF8StringEncoding, error: nil)
            
            if filecontent != nil {
                
                let searchtxt = "font-size : "
                
                let range = filecontent!.rangeOfString(searchtxt)
                if range != nil {
                    
                    let newtext : String? = filecontent!.substringFromIndex(range!.endIndex)
                    if newtext != nil {
                        
                        let newrange = newtext!.rangeOfString(";")
                        
                        let fontsize : String = newtext!.substringToIndex(newrange!.startIndex)
                        if !fontsize.isEmpty {
                            var fontsizedouble : Double = (fontsize as NSString).doubleValue

                            self.webViewSong.stringByEvaluatingJavaScriptFromString("resizeText(\(fontsizedouble))")
                            
                        }
                        
                    }
                    
                }
                
            }
        }
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError){
        
    }

}

