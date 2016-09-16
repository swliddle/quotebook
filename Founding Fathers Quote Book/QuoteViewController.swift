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

        updateUIByToggling()
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

    private func updateUIByToggling() {
        let quote = quotes[currentQuoteIndex]
        
        if let topicFilter = topic {
            // See http://bit.ly/2ctUdTI
            
            let fadeTextAnimation = CATransition()

            fadeTextAnimation.duration = 0.75
            fadeTextAnimation.type = kCATransitionFade
            
            navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
            navigationItem.title = "\(topicFilter.capitalized) (\(currentQuoteIndex + 1) of \(quotes.count))"
        }

        webView.stringByEvaluatingJavaScript(from: "toggleQuote('\(quote.text)', '\(quote.speaker)')")
    }

    private func updateUI() {
        let quote = quotes[currentQuoteIndex]
        
        if let topicFilter = topic {
            title = "\(topicFilter.capitalized) (\(currentQuoteIndex + 1) of \(quotes.count))"
        }

        webView.loadHTMLString(
            "<!DOCTYPE html>" +
            "<html>" +
                "<head>" +
                    "<title>Quote of the Day</title>" +
                    "<style>" +
                        "body { position: relative; } " +
                        ".quote { font-size: 24pt; font-style: italic; } " +
                        ".speaker { font-size: 18pt; padding-top: 1.5em; text-align: right; }" +
                        ".container { position: absolute; padding: 2em; left: 0; top: 0; transition: opacity 1s ease-in-out; }" +
                        "#quote1 { opacity: 1; }" +
                        "#quote2 { opacity: 0; }" +
                    "</style>" +
                    "<script type=\"text/javascript\">" +
                        "function toggleQuote(quote, speaker) {" +
                            "var q1 = document.getElementById('quote1');" +
                            "var q2 = document.getElementById('quote2');" +
                            "var style = window.getComputedStyle(q1);" +
                            "var t1 = q1, t2 = q2;" +
                            "if (style.opacity <= 0) {" +
                                "t1 = q2;" +
                                "t2 = q1;" +
                            "}" +
                            "t2.getElementsByClassName('quote')[0].innerHTML = quote;" +
                            "t2.getElementsByClassName('speaker')[0].innerHTML = '&mdash; ' + speaker;" +
                            "t1.style.opacity = 0;" +
                            "t2.style.opacity = 1;" +
                        "}" +
                    "</script>" +
                "</head>" +
                "<body>" +
                    "<div id=\"quote1\" class=\"container\">" +
                        "<div class=\"quote\">\(quote.text)</div>" +
                        "<div class=\"speaker\">&mdash; \(quote.speaker)</div>" +
                    "</div>" +
                    "<div id=\"quote2\" class=\"container\">" +
                        "<div class=\"quote\"></div>" +
                        "<div class=\"speaker\"></div>" +
                    "</div>" +
                "</body>" +
            "</html>",
            baseURL: nil)
    }
}
