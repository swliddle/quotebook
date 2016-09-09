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

    let topics = [ "achieving", "action", "attitude", "character", "confession", "duty",
                   "excuses", "facts", "goal", "guilt", "happiness", "honor", "lies",
                   "lying", "motivational", "philosophy", "politics", "reputation",
                   "stubborn", "truth", "war", "wishes" ];

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell")!

        cell.textLabel?.text = topics[indexPath.row].capitalized

        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowQuote", sender: self)
    }
}
