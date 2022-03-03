//
//  CardDeck.swift
//  PokerGameApp
//
//  Created by 백상휘 on 2022/02/24.
//

import Foundation

struct CardDeck {
    
    private var deck: [Card]
    
    init(deck: [Card]) {
        self.deck = deck
    }
    
    func count() -> Int {
        return deck.count
    }
    
    mutating func removeOne() -> Card? {
        guard let card = deck.last else { return nil }
        deck.removeLast()
        return card
    }
    
    mutating func reset() {
        deck = CardFactory.deckOfCard()
    }
}
