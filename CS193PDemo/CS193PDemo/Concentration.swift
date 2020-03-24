//
//  Concentration.swift
//  CS193PDemo
//
//  Created by tidot on 2020/2/12.
//  Copyright © 2020 tidot. All rights reserved.
//

import Foundation

struct Concentration{
    
    //
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int?{
        get{
            cards.indices.filter { (index) -> Bool in
                cards[index].isFaceUp
            }.oneAndOnly
        }
        set{
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    init(numberOfPairOfCards: Int) {
        for _ in 1...numberOfPairOfCards{
            let card = Card()
            cards += [card, card]   //拥有相同图像的卡片的identifier相等
        }
    }
    
    mutating func chooseCard(at index: Int){
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                //check if cards match
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            }else{
                //either no card or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
}

extension Collection{
    var oneAndOnly: Element?{
        return count == 1 ? first : nil
    }
}
