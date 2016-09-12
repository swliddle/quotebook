//
//  TopicsViewController.swift
//  Founding Fathers Quote Book
//
//  Created by Steve Liddle on 9/8/16.
//  Copyright © 2016 Steve Liddle. All rights reserved.
//

import UIKit

class TopicsViewController : UITableViewController {
    
    // MARK: - Properties

    var selectedTopic: String?
    
    let quoteDeck = QuoteDeck.sharedInstance

    // MARK: - View controller lifecycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? QuoteViewController {
            destinationVC.topic = selectedTopic
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quoteDeck.tagSet.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell")!
        
        cell.textLabel?.text = quoteDeck.tagSet[indexPath.row].capitalized
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTopic = quoteDeck.tagSet[indexPath.row]
        performSegue(withIdentifier: "ShowQuote", sender: self)
    }
}
