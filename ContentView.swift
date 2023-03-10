//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by jacob aberasturi on 1/14/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var seenSoFarCountries = [String]()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var turnCount = 0
    @State private var gameOver = false
    
    // To be used to flip flag whenever clicked on
    @State private var selectedFlag = -1
    
    // Gets the setup for a flag Image (For project 3 Challenge)
    struct FlagImage: View {
        var num : Int
        var array: [String]
        
        var body: some View {
            Image(array[num])
                .renderingMode(.original)
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .shadow(radius: 23)
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            RadialGradient(stops: [
                .init(color: Color(red: 0.75, green: 0.04, blue: 0.08), location: 0.1),
                .init(color: Color(red: 1, green: 1, blue: 1), location: 0.65),
                .init(color: Color(red: 0.04, green: 0.04, blue: 0.60), location: 0.75)
            ], center: .top, startRadius: 200, endRadius: 940)
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.primary)
                
                if !gameOver {
                    Text("Turn: \(turnCount + 1) out of 8")
                    VStack(spacing: 25){
                        VStack {
                            Text("Tap the flag of")
                                .foregroundStyle(.primary)
                                .font(.subheadline.weight(.heavy))
                            Text(countries[correctAnswer])
                                .foregroundStyle(.primary)
                                .font(.largeTitle.weight(.semibold))
                        }
                        ForEach(0..<3) { number in
                            Button {
                                flagTapped(number)
                            } label: {
                                FlagImage(num: number, array: countries)
                            }
                            // gets the animation and by how much, but doesn't activate by itself
                            .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                            // This watches the value selectedFlag and runs animations when it detects it changed
                            .opacity(selectedFlag != -1 && number != selectedFlag ? 0.20 : 1)
                            .blur(radius: selectedFlag != -1 && number != selectedFlag ? 10 : 1)
                            .animation(.default, value: selectedFlag)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .background(.ultraThinMaterial.blendMode(.darken))
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    Spacer()
                    Spacer()
                }

                Text("Score is \(score)")
                    .foregroundStyle(Color.accentColor)
                    .font(.title).bold()
                Spacer()
                
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game Over!", isPresented: $gameOver) {
            Button("Reset?", action: resetGame)
        } message: {
            Text("Ending score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        }
        else {
            scoreTitle = "Wrong! This is actually \(countries[number])'s flag!"
        }
    
        selectedFlag = number
        turnCount += 1
        
        if turnCount < 8 {
            showingScore = true
        }
        else {
            gameOver = true
        }

    }
    
    func askQuestion() {
        selectedFlag = -1
        let correctFlag = countries[correctAnswer]
        showingScore = false
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        countries.remove(at: countries.firstIndex(of: correctFlag)!)
        seenSoFarCountries.append(correctFlag)

    }
    
    func resetGame() {
        selectedFlag = -1
        turnCount = 0
        score = 0
        gameOver = false
        countries.append(contentsOf: seenSoFarCountries)
        countries.shuffle()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
