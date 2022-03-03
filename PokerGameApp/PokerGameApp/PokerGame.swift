//
//  PokerGame.swift
//  PokerGameApp
//
//  Created by 백상휘 on 2022/02/26.
//

import Foundation

class PokerGame {
    
    let gameMembers: GameMembers
    let dealer: Dealer
    
    let participantCount = NumberOfPerson.three
    let game = TypeOfGame.SevenStudPoker
    
    init() {
        gameMembers = GameMembers(numberOf: participantCount, gameType: game)
        dealer = Dealer(cards: CardFactory.deckOfCard(), gameType: game)
        dealer.shuffleType = gameMembers.getFavoriteShuffle()
    }
    
    func drawCardsToAllMembers() {
        
        let cardCount = game.cardCount
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
    
    private func isGameReady(_ n: Int) -> Bool {
        !gameMembers.hasEnoughCards() && !dealer.hasEnoughCards()
    }
    
    enum NumberOfPerson: Int {
        case one = 1
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
