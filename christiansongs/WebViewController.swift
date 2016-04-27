//
//  WebViewController.swift
//  christiansongs
//
//  Created by jijo on 3/10/15.
//  Copyright (c) 2015 jeesmon. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webViewInfo: UIWebView!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let infopath = NSBundle.mainBundle().pathForResource("about", ofType: "html")
        let req = NSURLRequest(URL: NSURL(fileURLWithPath : infopath!))
        webViewInfo.scrollView.backgroundColor = UIColor.whiteColor()
        webViewInfo.loadRequest(req)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
