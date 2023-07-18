//
//  ContentView.swift
//  HighRollers
//
//  Created by Tien Bui on 17/7/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Customize your roll") {
                    Stepper("Number of dice: \(viewModel.diceNumber)", value: $viewModel.diceNumber, in: 1 ... 20)
                    
                    Picker("Type of dice", selection: $viewModel.selectedDiceType) {
                        ForEach(viewModel.diceTypes, id: \.self) { type in
                            Text("D\(type)")
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Button {
                        viewModel.roll()
                        
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "dice")
                            Text("Roll the dice!")
                            Image(systemName: "dice")
                            Spacer()
                        }
                    }
                }
                .disabled(viewModel.stoppedDice < viewModel.result.rolls.count && viewModel.isRolling == true)
                
                Section("Result") {
                    Text("Total rolled: ") +
                    Text("\(viewModel.result.totalRolled)")
                        .foregroundColor(.green)
                        .bold()
                        .font(.title)
                    
                    LazyVGrid(columns: viewModel.columns) {
                        ForEach(0 ..< viewModel.result.diceNumber, id: \.self) { rollNumber in
                            Text(String(viewModel.result.rolls[rollNumber]))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundColor(.black)
                                .background(.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                                .font(.title)
                                .padding(5)
                        }
                    }
                    .accessibilityElement()
                    .accessibilityLabel("Latest roll: \(viewModel.result.description)")
                }
                
                Section("History") {
                    
                    Button {
                        withAnimation {
                            viewModel.toggleShowsHistory()
                        }
                    } label: {
                        Label("Show history", systemImage: viewModel.showsHistory ? "chevron.down" : "chevron.right")
                        
                    }
                    
                    if viewModel.showsHistory == true {
                        ForEach(viewModel.results) { result in
                            VStack(alignment: .leading) {
                                Text("\(result.diceNumber) x D\(result.diceType), Total rolled: \(result.totalRolled)")
                                    .font(.headline)
                                Text(result.rolls.map(String.init).joined(separator: " "))
                            }
                            .accessibilityElement()
                            .accessibilityLabel("\(result.diceNumber) D\(result.diceType), \(result.description)")
                        }
                    }
                    
                    Button {
                        withAnimation {
                            viewModel.clearResults()
                        }
                    } label: {
                        Label("Clear result", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            
            .navigationTitle("High Rollers")
            .onReceive(viewModel.timer) { _ in
                if viewModel.isRolling == true {
                    withAnimation {
                        viewModel.updateDice()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
