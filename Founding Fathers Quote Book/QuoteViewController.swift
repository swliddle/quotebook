//
//  QuoteViewController.swift
//  Founding Fathers Quote Book
//
//  Created by Steve Liddle on 9/7/16.
//  Copyright © 2016 Steve Liddle. All rights reserved.
//

import UIKit

class QuoteViewController : UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var topic: String?
    
    let quoteDeck = QuoteDeck.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var quote: Quote?
        
        if let topicFilter = topic {
            title = topicFilter.capitalized
            
            quote = quoteDeck.quotesForTag(topicFilter).first
            
        } else {
            quote = quoteDeck.quoteOfTheDay()
        }

        if let selectedQuote = quote {
            webView.loadHTMLString("<!DOCTYPE html><html><head><title>Quote of the Day</title><style>body { padding: 2em; } .quote { font-size: 24pt; font-style: italic; } .speaker { padding-top: 1.5em; text-align: right; }</style></head><body><div class=\"quote\">\(selectedQuote.text)</div><div class=\"speaker\">&mdash; \(selectedQuote.speaker)</div></body></html>", baseURL: nil)
        }
    }
}
