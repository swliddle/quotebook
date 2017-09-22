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
    
    // MARK: - Constants
    
    private struct Key {
        static let CurrentQuoteIndex = "CurrentQuoteIndex"
        static let Topic = "Topic"
    }
    
    private struct Storyboard {
        static let QuoteOfTheDayTitle = "Quote of the Day"
        static let ShowTopicsSegueIdentifier = "ShowTopics"
        static let TodayTitle = "Today"
        static let TopicsTitle = "Topics"
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var toggleButton: UIBarButtonItem!
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Properties
    
    var currentQuoteIndex = 0
    var quotes: [Quote]!
    var topic: String?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(updatingCurrentIndex: true)
    }
    
    // MARK: - State restoration
    
    override func decodeRestorableState(with coder: NSCoder) {
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
    
    @IBAction func showQuoteOfTheDay() {
        topic = nil
        configure(updatingCurrentIndex: true)
    }
    
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
    
    @IBAction func toggleTopics(_ sender: UIBarButtonItem) {
        if sender.title == Storyboard.TopicsTitle {
            performSegue(withIdentifier: Storyboard.ShowTopicsSegueIdentifier, sender: sender)
        } else {
            showQuoteOfTheDay()
        }
    }
    
    // MARK: - Helpers
    
    private func chooseQuoteOfTheDay() {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "DDD"
        if let dayInYear = Int(formatter.string(from: Date())) {
            currentQuoteIndex = dayInYear % QuoteDeck.sharedInstance.quotes.count
        }
    }

    private func configure(updatingCurrentIndex needsUpdate: Bool) {
        if let currentTopic = topic {
            quotes = QuoteDeck.sharedInstance.quotesForTag(currentTopic)
            
            if needsUpdate {
                currentQuoteIndex = 0
            }
        } else {
            quotes = QuoteDeck.sharedInstance.quotes
            
            if needsUpdate {
                chooseQuoteOfTheDay()
            }
        }

        updateUI()
    }

    private func updateUI() {
        let currentQuote = quotes[currentQuoteIndex]

        if let currentTopic = topic {
            toggleButton.title = Storyboard.TodayTitle
            title = "\(currentTopic.capitalized) (\(currentQuoteIndex + 1) of \(quotes.count))"
        } else {
            toggleButton.title = Storyboard.TopicsTitle
            title = Storyboard.QuoteOfTheDayTitle
        }

        webView.loadHTMLString(currentQuote.html, baseURL: nil)
    }

    private func updateUIByToggling() {
        let quote = quotes[currentQuoteIndex]
        
        if let currentTopic = topic {
            // See http://bit.ly/2ctUdTI
            
            let fadeTextAnimation = CATransition()
            
            fadeTextAnimation.duration = 0.75
            fadeTextAnimation.type = kCATransitionFade
            
            navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
            navigationItem.title = "\(currentTopic.capitalized) (\(currentQuoteIndex + 1) of \(quotes.count))"
        }
        
        print("toggleQuote('\(quote.text)', '\(quote.speaker)')")
        webView.evaluateJavaScript("toggleQuote('\(quote.text)', '\(quote.speaker)')",
            completionHandler: nil)
    }

    // MARK: - Segues
    
    @IBAction func exitModalScene(_ segue: UIStoryboardSegue) {
        // In this case, there is nothing to do, but we need a target
    }
    
    @IBAction func showTopicQuotes(_ segue: UIStoryboardSegue) {
        configure(updatingCurrentIndex: true)
    }
}
