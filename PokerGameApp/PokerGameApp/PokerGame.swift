//
//  PokerGame.swift
//  PokerGameApp
//
//  Created by 백상휘 on 2022/02/26.
//

import Foundation

class PokerGame {
    
    private let gameMembers: GameMembers
    private let dealer: Dealer
    
    private(set) var participantCount = NumberOfPerson.three
    private(set) var typeOfGame: TypeOfGame
    
    init(of type: TypeOfGame) {
        typeOfGame = type
        gameMembers = GameMembers(numberOf: participantCount, gameType: typeOfGame)
        dealer = Dealer(cards: CardFactory.deckOfCard(), gameType: typeOfGame)
        dealer.shuffleType = gameMembers.getFavoriteShuffle()
    }
    
    func drawCardsToAllMembers() {
        
        let cardCount = typeOfGame.cardCount
        let participants = gameMembers.members
        
        while isGameReady(cardCount) {
            
            for i in 0..<participantCount.rawValue+1 { // Plus 1 for Dealer.
                
                guard let card = dealer.draw() else { break }

                if i == 0, dealer.hasEnoughCards() == false {
                    dealer.addOne(card)
                    continue
                }
                
                if participants[i-1].hasEnoughCards() == false {
                    participants[i-1].addOne(card)
                }
            }
            
            dealer.shuffle()
        }
    }
    
    func shuffleAll() {
        dealer.shuffle()
    }
    
    func dealerCards() -> [Card] {
        dealer.cards
    }
    
    func setParticipantCount(_ count: NumberOfPerson) {
        participantCount = count
    }
    
    func setGameType(_ type: TypeOfGame) {
        typeOfGame = type
    }
    
    func getParticipant(at index: Int) -> PokerParticipant? {
        guard gameMembers.members.count >= index+1 else {
            return nil
        }
        
        return gameMembers.members[index]
    }
    
    private func isGameReady(_ n: Int) -> Bool {
        !gameMembers.hasEnoughCards() && !dealer.hasEnoughCards()
    }
    
    enum NumberOfPerson: Int {
        case two = 2
        case three = 3
        case four = 4
    }
}

extension PokerGame: CustomStringConvertible {
    var description: String {
        "딜러\(dealer.cards)" + gameMembers.members.reduce("", {"\($0)\n\($1.getName())\($1.getCountOfCards())"})
    }
}
