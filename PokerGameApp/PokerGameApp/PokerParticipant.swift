//
//  PokerParticipant.swift
//  PokerGameApp
//
//  Created by 백상휘 on 2022/02/27.
//

import Foundation

class PokerParticipant {
    
    private let name: String
    private(set) var favoriteAlgorithm: PokerCardAlgorithm
    private var cards = [Card]()
    private(set) var typeOfGame: TypeOfGame
    
    init(of type: TypeOfGame, as name: String) {
        self.typeOfGame = type
        self.name = name
        favoriteAlgorithm = PokerCardAlgorithm.getRandomAlgorithm()
    }
    
    func makeMyMindAgain(algorithm: PokerCardAlgorithm? = nil) {
        
        if let algorithm = algorithm {
            self.favoriteAlgorithm = algorithm
            return
        }
        
        favoriteAlgorithm = PokerCardAlgorithm.getRandomAlgorithm()
    }
    
    func hasEnoughCards() -> Bool {
        cards.count >= typeOfGame.cardCount
    }

    func addOne(_ card: Card) {
        cards.append(card)
    }
    
    func getCountOfCards() -> Int {
        cards.count
    }
    
    func getName() -> String {
        name
    }
    
    func getCards() -> [Card] {
        cards
    }
}

extension String {
    
    static var uppercaseAlphabet = (65...90).map {String(UnicodeScalar($0))}
    static var lowercaseAlphabet = (97...122).map {String(UnicodeScalar($0))}
    static var allAlphabet = (uppercaseAlphabet + lowercaseAlphabet)
    
    static func randomAlphabet(length: Int) -> String {
        return allAlphabet.randomElement() ?? ""
    }
}
