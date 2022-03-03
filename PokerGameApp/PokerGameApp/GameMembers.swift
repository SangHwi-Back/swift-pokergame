//
//  PokerParticipants.swift
//  PokerGameApp
//
//  Created by 백상휘 on 2022/02/27.
//

import Foundation

class GameMembers {
    
    var members = [PokerParticipant]()
    
    init(numberOf person: PokerGame.NumberOfPerson, gameType type: TypeOfGame) {
        for _ in 0..<person.rawValue {
            members.append(PokerParticipant(of: type, as: String.randomAlphabet(length: (2...5).randomElement()!)))
        }
    }
    
    func getFavoriteShuffle() -> PokerCardAlgorithm {
        
        // 다수결을 할 참가자 수를 충족하지 못하면 유일한 참가자의 선호 알고리즘을 반환하거나 기본 타입을 반환.
        guard members.count <= 1 else {
            return members.first?.favoriteAlgorithm ?? .FisherYates
        }
        
        // 참가자의 선호 알고리즘 타입을 실시간으로 가져옵니다.
        var favoriteAlgorithms: [PokerCardAlgorithm] {
            members.map({$0.favoriteAlgorithm})
        }
        
        // favoriteAlgorithms 배열의 길이와, favoriteAlgorithms 로 만들어진 Set의 길이가 같다면
        // 다수결로 선호 알고리즘을 정할 수 없으므로, 참가자들의 선호 알고리즘을 다시 변경합니다.
        while favoriteAlgorithms.count == Set(favoriteAlgorithms).count {
            members.forEach({$0.makeMyMindAgain()})
        }
        
        // 알고리즘 타입 당 얼마나 많은 갯수가 있는지 확인하기 위해 Dictionary를 하나 만듭니다.
        var containerFavorite = Dictionary(uniqueKeysWithValues: Set(favoriteAlgorithms).map({($0, 0)}))
        
        for algorithm in favoriteAlgorithms {
            if containerFavorite.contains(where: { $0.key == algorithm }) {
                containerFavorite[algorithm] = containerFavorite[algorithm]! + 1
            }
        }
        
        return containerFavorite.max(by: { $0.value < $1.value })!.key
    }
    
    func hasEnoughCards() -> Bool {
        members.filter({ $0.typeOfGame.cardCount <= $0.getCountOfCards() }).count == members.count
    }
    
    func getNamesInMembers() -> String {
        members.reduce("", {$0+$1.getName()+"\n"})
    }
}

extension GameMembers: CustomStringConvertible {
    var description: String {
        members.reduce("", {$0+$1.getName()+"\n"})
    }
}
