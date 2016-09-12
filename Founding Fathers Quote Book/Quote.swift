//
//  Quotes.swift
//  Founding Fathers Quote Book
//
//  Created by Steve Liddle on 9/9/16.
//  Copyright © 2016 Steve Liddle. All rights reserved.
//

import UIKit

class Quote {
    var text: String
    var speaker: String
    var tags: [String]
    
    init(text: String, speaker: String, tags: [String]) {
        self.text = text
        self.speaker = speaker
        self.tags = tags
    }
}
