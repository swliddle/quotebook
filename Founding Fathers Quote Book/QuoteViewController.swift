//
//  QuoteViewController.swift
//  Founding Fathers Quote Book
//
//  Created by Steve Liddle on 9/7/16.
//  Copyright © 2016 Steve Liddle. All rights reserved.
//

import UIKit

class QuoteViewController : UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: - Properties
    
    var quoteDate = Date()
    
    var topic: String?
    
    let quoteDeck = QuoteDeck.sharedInstance
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    // MARK: - Actions
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizerDirection.left {
            quoteDate = increment(date: quoteDate, by: -1)
        } else {
            quoteDate = increment(date: quoteDate)
        }

        updateUI()
    }
    
    // MARK: - Helpers
    
    func increment(date: Date, by amount: Int = 1) -> Date {
        var dayComponent = DateComponents()
        
        dayComponent.day = amount
        
        return Calendar.current.date(byAdding: dayComponent, to: date)!
    }

    func updateUI() {
        var quote: Quote?
        
        if let topicFilter = topic {
            title = topicFilter.capitalized
            
            quote = quoteDeck.quotesForTag(topicFilter).first
            
        } else {
            quote = quoteDeck.quoteOfTheDay(for: quoteDate)
        }
        
        if let selectedQuote = quote {
            webView.loadHTMLString("<!DOCTYPE html><html><head><title>Quote of the Day</title><style>body { padding: 2em; } .quote { font-size: 24pt; font-style: italic; } .speaker { padding-top: 1.5em; text-align: right; }</style></head><body><div class=\"quote\">\(selectedQuote.text)</div><div class=\"speaker\">&mdash; \(selectedQuote.speaker)</div></body></html>", baseURL: nil)
        }
    }
}
