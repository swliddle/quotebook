//
//  QuoteDeck.swift
//  Founding Fathers Quote Book
//
//  Created by Steve Liddle on 9/14/17.
//  Copyright © 2017 Steve Liddle. All rights reserved.
//

import Foundation

class QuoteDeck {
    
    // MARK: - Properties
    
    var tagSet: [String] = []
    
    let quotes = [
        Quote(text: """
                        Do you want to know who you are? Don&rsquo;t ask. Act!
                        Action will delineate and define you.
                    """,
              speaker: "Thomas Jefferson",
              tags: [ "motivational", "action" ]),
        Quote(text: """
                        Facts are stubborn things; and whatever may be our wishes,
                        our inclinations, or the dictates of our passions, they cannot
                        alter the state of facts and evidence.
                    """,
              speaker: "John Adams",
              tags: [ "facts", "wishes", "stubborn" ]),
        Quote(text: "Great is the guilt of an unnecessary war.",
              speaker: "John Adams",
              tags: [ "guilt", "war" ]),
        Quote(text: """
                        Happiness depends more upon the internal frame of a person&rsquo;s
                        own mind, than on the externals in the world.
                    """,
              speaker: "George Washington",
              tags: [ "happiness" ]),
        Quote(text: "Human happiness and moral duty are inseparably connected.",
              speaker: "George Washington",
              tags: [ "duty", "happiness", "honor" ]),
        Quote(text: """
                        I must study politics and war that my sons may have liberty
                        to study mathematics and philosophy.
                    """,
              speaker: "John Adams",
              tags: [ "war", "politics", "philosophy" ]),
        Quote(text: "It is better to be alone than in bad company.",
              speaker: "George Washington",
              tags: [ "character", "honor", "reputation" ]),
        Quote(text: "It is better to offer no excuse than a bad one.",
              speaker: "George Washington",
              tags: [ "confession", "lies", "lying", "excuses", "truth" ]),
        Quote(text: """
                        Nothing can stop the man with the right mental attitude from achieving his
                        goal; nothing on earth can help the man with the wrong mental attitude.
                    """,
              speaker: "Thomas Jefferson",
              tags: [ "attitude", "achieving", "goal" ]),
        Quote(text: """
                        All of us who were engaged in the struggle must have observed frequent
                        instances of superintending providence in our favor. To that kind
                        providence we owe this happy opportunity of consulting in peace on the
                        means of establishing our future national felicity. And have we now
                        forgotten that powerful friend? Or do we imagine that we no longer need his
                        assistance? I have lived, Sir, a long time, and the longer I live, the more
                        convincing proofs I see of this truth-that God governs in the affairs of
                        men. And if a sparrow cannot fall to the Ground without his Notice, is it
                        probable that an Empire can rise without his Aid?
                    """,
              speaker: "Benjamin Franklin",
              tags: [ "religion", "providence" ])
    ]

    // MARK: - Singleton pattern
    
    static let sharedInstance = QuoteDeck()
    
    private init() {
        update()
    }
    
    // MARK: - Private helpers
    
    private func update() {
        tagSet = []
        
        for quote in quotes {
            for tag in quote.tags {
                if !tagSet.contains(tag) {
                    tagSet.append(tag)
                }
            }
        }
        
        tagSet = tagSet.sorted()
    }

    // MARK: - Public helpers
    
    func quotesForTag(_ tag: String) -> [Quote] {
        var matchingQuotes: [Quote] = []
        
        for quote in quotes {
            if quote.tags.contains(tag) {
                matchingQuotes.append(quote)
            }
        }
        
        return matchingQuotes
    }
}
