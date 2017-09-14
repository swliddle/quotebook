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
    
    // MARK: - Outlets
    
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Properties
    
    var currentQuoteIndex = 0
    var topic: String?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseQuoteOfTheDay()
        updateUI()
    }
    
    // MARK: - Helpers
    
    private func chooseQuoteOfTheDay() {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "DDD"
        if let dayInYear = Int(formatter.string(from: Date())) {
            currentQuoteIndex = dayInYear % QuoteDeck.sharedInstance.quotes.count
        }
    }

    private func updateUI() {
        let currentQuote = QuoteDeck.sharedInstance.quotes[currentQuoteIndex]

        webView.loadHTMLString(currentQuote.htmlPage(), baseURL: nil)
    }

    // MARK: - Segues
    
    @IBAction func exitModalScene(_ segue: UIStoryboardSegue) {
        // Nothing to do; just need a target for the unwind segue
    }
    
    @IBAction func showTopicQuotes(_ segue: UIStoryboardSegue) {
        if let currentTopic = topic {
            title = currentTopic
        }
    }
}
