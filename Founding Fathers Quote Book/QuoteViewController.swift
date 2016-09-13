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
    
    var currentQuoteIndex = 0
    var topic: String?
    var quotes: [Quote]!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let selectedTopic = topic {
            quotes = QuoteDeck.sharedInstance.quotesForTag(selectedTopic)
            currentQuoteIndex = 0
        } else {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "DDD"
            quotes = QuoteDeck.sharedInstance.quotes
            
            if let dayInYear = Int(formatter.string(from: Date())) {
                currentQuoteIndex = dayInYear % quotes.count
            }
        }
        
        updateUI()
    }
    
    // MARK: - Actions
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            currentQuoteIndex -= 1
            
            if currentQuoteIndex < 0 {
                currentQuoteIndex = quotes.count - 1
            }
        } else {
            currentQuoteIndex += 1
            
            if currentQuoteIndex >= quotes.count {
                currentQuoteIndex = 0
            }
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
        let quote = quotes[currentQuoteIndex]
        
        if let topicFilter = topic {
            title = "\(topicFilter.capitalized) (\(currentQuoteIndex + 1) of \(quotes.count))"
        }
        
        webView.loadHTMLString("<!DOCTYPE html><html><head><title>Quote of the Day</title><style>body { padding: 2em; } .quote { font-size: 24pt; font-style: italic; } .speaker { padding-top: 1.5em; text-align: right; }</style></head><body><div class=\"quote\">\(quote.text)</div><div class=\"speaker\">&mdash; \(quote.speaker)</div></body></html>", baseURL: nil)
    }
}
