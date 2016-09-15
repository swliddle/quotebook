//
//  QuoteViewController.swift
//  Founding Fathers Quote Book
//
//  Created by Steve Liddle on 9/7/16.
//  Copyright © 2016 Steve Liddle. All rights reserved.
//

import UIKit

class QuoteViewController : UIViewController {
    
    // MARK: - Constants
    
    private struct Key {
        static let CurrentQuoteIndex = "CurrentQuoteIndex"
        static let Topic = "Topic"
    }

    // MARK: - Outlets
    
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: - Properties
    
    var currentQuoteIndex = 0
    var topic: String?
    var quotes: [Quote]!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()

        configure(updatingCurrentIndex: true)
    }
    
    // MARK: - State restoration
    
    override func decodeRestorableState(with coder: NSCoder) {
        print("decodeRestorableState")
        super.decodeRestorableState(with: coder)
        
        currentQuoteIndex = coder.decodeInteger(forKey: Key.CurrentQuoteIndex)
        
        if let savedTopic = coder.decodeObject(forKey: Key.Topic) as? String {
            topic = savedTopic
        }

        configure(updatingCurrentIndex: false)
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        coder.encode(currentQuoteIndex, forKey: Key.CurrentQuoteIndex)
        coder.encode(topic, forKey: Key.Topic)
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
    
    private func configure(updatingCurrentIndex needsUpdate: Bool) {
        if let selectedTopic = topic {
            quotes = QuoteDeck.sharedInstance.quotesForTag(selectedTopic)
            
            if needsUpdate {
                currentQuoteIndex = 0
            }
        } else {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "DDD"
            quotes = QuoteDeck.sharedInstance.quotes
            
            if needsUpdate {
                if let dayInYear = Int(formatter.string(from: Date())) {
                    currentQuoteIndex = dayInYear % quotes.count
                }
            }
        }
        
        updateUI()
    }

    private func increment(date: Date, by amount: Int = 1) -> Date {
        var dayComponent = DateComponents()
        
        dayComponent.day = amount
        
        return Calendar.current.date(byAdding: dayComponent, to: date)!
    }

    private func updateUI() {
        let quote = quotes[currentQuoteIndex]
        
        if let topicFilter = topic {
            title = "\(topicFilter.capitalized) (\(currentQuoteIndex + 1) of \(quotes.count))"
        }
        
        webView.loadHTMLString("<!DOCTYPE html><html><head><title>Quote of the Day</title><style>body { padding: 2em; } .quote { font-size: 24pt; font-style: italic; } .speaker { padding-top: 1.5em; text-align: right; }</style></head><body><div class=\"quote\">\(quote.text)</div><div class=\"speaker\">&mdash; \(quote.speaker)</div></body></html>", baseURL: nil)
    }
}
