//
//  Dealer.swift
//  PokerGameApp
//
//  Created by 백상휘 on 2022/02/27.
//

import Foundation

typealias PokerCardAlgorithm = Dealer.CardAlgorithm

class Dealer {
    
    var deck: CardDeck // 덱은 카드의 저장소처럼 작동한다. 실제 딜러가 가질 수 있는 카드는 cards 배열에 저장된다.
    
    let shuffleSkill = ShuffleAlgorithm<Card>()
    let gameType: TypeOfGame
    var cards = [Card]()
    
    var shuffleType: CardAlgorithm = .FisherYates
    
    init(deck: CardDeck, gameType type: TypeOfGame) {
        self.deck = deck
        self.gameType = type
    }

    init(cards: [Card], gameType type: TypeOfGame) {
        deck = CardDeck(deck: cards)
        gameType = type
    }
    
    func draw() -> Card? {
        deck.removeOne()
    }
    
    func shuffle() {
        switch shuffleType {
        case .FisherYates:
            cards = shuffleSkill.fisherYatesAlgorithm(at: cards)
        case .Knuth:
            cards = shuffleSkill.knuthAlgorithm(at: cards)
        case .Ordinary:
            cards = shuffleSkill.ordinaryCardShuffle(at: cards)
        }
    }
    
    func hasEnoughCards() -> Bool {
        let count = gameType.cardCount
        return cards.count >= count
    }
    
    func addOne(_ card: Card) {
        cards.append(card)
    }
    
    func getCountOfCards() -> Int {
        cards.count
    }
    
    enum CardAlgorithm: String, CaseIterable {
        case FisherYates = "FisherYates"
        case Knuth = "Knuth"
        case Ordinary = "Ordinary"
        
        static func getRandomAlgorithm() -> CardAlgorithm {
            self.allCases.randomElement() ?? .FisherYates
        }
    }
}
