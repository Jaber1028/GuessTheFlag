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
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
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
                VStack(spacing: 15){
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
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 35))
                                .shadow(radius: 23)
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(.ultraThinMaterial.blendMode(.darken))
                .clipShape(RoundedRectangle(cornerRadius: 50))
                Spacer()
                Spacer()
                Text("Score is ???")
                    .foregroundStyle(Color.primary.blendMode(.plusDarker))
                    .font(.title).bold()
                Spacer()
                
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
                Text("Your score is ???")
            }
        }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
        }
        else {
            scoreTitle = "Wrong"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
