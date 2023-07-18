//
//  ContentView-ViewModel.swift
//  HighRollers
//
//  Created by Tien Bui on 17/7/2023.
//

import Foundation
import SwiftUI

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        
        @AppStorage("diceNumber") var diceNumber: Int = 4
        @AppStorage("diceSides") var selectedDiceType: Int = 6
        
        @Published var results: [RollResult]
        @Published var result: RollResult = RollResult.example
        
        @Published var isRolling = false
        
        @AppStorage("showsHistory") var showsHistory: Bool = true
        
        @State private var feedback = UIImpactFeedbackGenerator(style: .rigid)

        let diceTypes = [4, 6 , 8, 10, 12, 20, 100]
        
        let columns: [GridItem] = [
            .init(.adaptive(minimum: 50))
        ]
        
        let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        
        @Published var stoppedDice = 0
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("Saved")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                results = try JSONDecoder().decode([RollResult].self, from: data)
            } catch {
                results = []
            }
        }
        
        
        func save() {
            do {
                let data = try JSONEncoder().encode(results)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func roll() {
            result = RollResult(type: selectedDiceType, diceNumber: diceNumber)

            stoppedDice = -10
            
            isRolling.toggle()
        }
        
        func updateDice() {
            guard stoppedDice < result.diceNumber else { return }
            
            for i in stoppedDice..<result.diceNumber  {
                if i < 0 { continue }
                result.rolls[i] = Int.random(in: 1...selectedDiceType)

            }
            
            stoppedDice += 1
            
            feedback.impactOccurred(intensity: Double(stoppedDice) / Double(result.diceNumber))
            
            if stoppedDice == result.diceNumber {
                results.insert(result, at: 0)
                save()
                isRolling = false
            }
        }
        
        func clearResults() {
            results = []
            save()
        }
        
        func toggleShowsHistory() {
            showsHistory.toggle()
        }
    }
}
