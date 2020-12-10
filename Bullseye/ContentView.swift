//
//  ContentView.swift
//  Bullseye
//
//  Created by Rakibul Huda on 13/7/20.
//  Copyright © 2020 Rakibul Huda. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let midnightBlue = Color(red: 0,
                             green: 0.2,
                             blue: 0.4)
    
    @State var alertIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 1...100)
    var sliderValueRounded : Int {
        Int(sliderValue.rounded())
    }
    @State var score = 0
    @State var round = 1
    
    var body: some View {
        
        NavigationView{
            VStack {
                
                Spacer().navigationBarTitle("🎯 Bullseye 🎯")
                
                //Target row
                HStack {
                    Text("Put the bullseye as close as you can to:")
                        .modifier(LabelStyle())
                    Text("\(target)")
                        .font(.custom("Arial Rounded MT Bold", size: 24))
                        .foregroundColor(.yellow)
                        .shadow(color: .gray, radius: 5, x: 2, y: 2)
                }
                
                Spacer()
                
                //Slider row
                HStack {
                    Text("1")
                        .modifier(LabelStyle())
                    Slider(value: $sliderValue, in: 1...100)
                        .accentColor(.green)
                        .animation(.easeOut)
                    Text("100")
                        .modifier(LabelStyle())
                }
                
                Spacer()
                
                Button(action: {
                    alertIsVisible = true
                    print("Button pressed!")
                }) {
                    Text("Hit me!")
                    .modifier(ButtonLargeTextStyle())
                }
                .background(Image("Button"))
                .modifier(Shadow())
                .alert(isPresented: $alertIsVisible){
                    Alert(title: Text("\(alertTitle())"),
                          message: Text(scoringMessage()),
                          dismissButton: .default(Text("Dismiss")){
                            startNewRound()
                          })
                    
                }
                
                Spacer()
                
                //Score row
                HStack {
                    Button(action: {
                        startNewGame()
                    }) {
                        HStack{
                            Image("StartOverIcon")
                            Text("Start Over")
                                .modifier(ButtonSmallTextStyle())
                        }
                        
                        
                    }
                    .background(Image("Button"))
                    .modifier(Shadow())
                    Spacer()
                    
                    Text("Score:")
                        .modifier(LabelStyle())
                    Text("\(score)")
                        .modifier(ValueStyle())
                    
                    Spacer()
                    
                    Text("Round:")
                        .modifier(LabelStyle())
                    Text("\(round)")
                        .modifier(ValueStyle())
                    
                    Spacer()
                    
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image("InfoIcon")
                            Text("Info").modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("Button"))
                    .modifier(Shadow())
                }
                .padding(.bottom,20)
                .accentColor(midnightBlue)
            }.onAppear(perform: {
                startNewGame()
            }).background(Image("Background"))
        }
        
    }
    
    func pointsForCurrentRound() -> Int {
        let maximumNuber = 100
        let bonus = calculateBonus()
        if difference() == 1 {
            return maximumNuber - difference() + 1 + bonus
        } else {
            return maximumNuber - difference() + bonus
        }
    }
    
    func calculateBonus() -> Int {
        if difference() == 0 {
            return 100
        } else if difference() == 1 {
            return 50
        } else {
            return 0
        }
    }
    
    //    func sliderValueRounded() -> Int {
    //        return Int(sliderValue.rounded())
    //    }
    
    func difference() -> Int {
        return abs(sliderValueRounded - target)
    }
    
    func alertTitle() -> String {
        let title : String
        if difference() == 0 {
            title = "Perfect!"
        } else if difference() <= 5 {
            title = "You almost had it!"
        } else if difference() <= 10 {
            title = "Not bad."
        } else{
            title = "Are you even trying?"
        }
        
        return title
    }
    
    func scoringMessage() -> String {
        "Slider's value is \(sliderValueRounded).\n"
            + "Target value is \(target).\n"
            + "You scored \(pointsForCurrentRound())"
    }
    
    func startNewGame() {
        score = 0
        round = 1
        resetSliderAndTarget()
    }
    
    func startNewRound() {
        score += pointsForCurrentRound()
        round+=1
        resetSliderAndTarget()
    }
    
    func resetSliderAndTarget() {
        sliderValue = Double.random(in: 1...100)
        target = Int.random(in: 1...100)
    }
    
    struct LabelStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
                .foregroundColor(Color.white)
                .modifier(Shadow())
        } }
    
    struct ValueStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Rounded MT Bold", size: 24))
                .foregroundColor(Color.yellow)
                .modifier(Shadow())
        } }
    
    struct Shadow: ViewModifier {
        func body(content: Content) -> some View {
            content
                .shadow(color: Color.black, radius: 5, x: 2, y: 2)
        } }
    
    struct ButtonLargeTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
                .foregroundColor(Color.black)
        } }
    
    struct ButtonSmallTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Rounded MT Bold", size: 12))
                .foregroundColor(Color.black)
        } }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
            //added for landscape preview
            .previewLayout(.fixed(width: 550, height: 320))
    }
}
