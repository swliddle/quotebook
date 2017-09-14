//
//  QuoteViewController.swift
//  Founding Fathers Quote Book
//
//  Created by Steve Liddle on 9/13/17.
//  Copyright © 2017 Steve Liddle. All rights reserved.
//

import UIKit
import WebKit

class QuoteViewController : UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadHTMLString("""
                                <!DOCTYPE html>
                                <html>
                                <head>
                                <title>Quote of the Day</title>
                                <meta name="viewport" content="initial-scale=1.0">
                                <style>
                                    body {
                                        padding: 1em;
                                        font-size: 24pt;
                                    }

                                    .quote {
                                        font-style: italic;
                                    }

                                    .speaker {
                                        text-align: right;
                                        padding-top: 1em;
                                    }

                                    .speaker::before {
                                        content: "— ";
                                    }
                                </style>
                                </head>
                                <body>
                                <div class="quote">Do you want to know who you are? Don&rsquo;t ask. Act!
                                                   Action will delineate and define you.</div>
                                <div class="speaker">Thomas Jefferson</div>
                                </body>
                                </html>
                               """, baseURL: nil)
    }
    
    @IBAction func exitModalScene(_ segue: UIStoryboardSegue) {
        // Nothing to do; just need a target for the unwind segue
    }
}
