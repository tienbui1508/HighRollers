//
//  Result.swift
//  HighRollers
//
//  Created by Tien Bui on 17/7/2023.
//

import Foundation

struct RollResult: Identifiable, Codable {
    var id = UUID()
    var diceNumber: Int
    var diceType: Int
    var rolls = [Int]()
    var description: String {
        rolls.map(String.init).joined(separator: " ")
    }
    var totalRolled: Int {
        var totalRolled = 0
        for roll in rolls {
            totalRolled += roll
        }
        return totalRolled
    }
    
    init(type: Int, diceNumber: Int) {
        self.diceType = type
        self.diceNumber = diceNumber
        
        for _ in 0..<diceNumber {
            let roll = Int.random(in: 1...type)
            rolls.append(roll)
        }
    }
    
    init(type: Int, diceNumber: Int, rolls: [Int]) {
        self.diceType = type
        self.diceNumber = diceNumber
        self.rolls = rolls
        
    }
    
    static let example = RollResult(type: 6, diceNumber: 4, rolls: [0, 0, 0, 0])
    
}
