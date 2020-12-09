//
//  ContentView.swift
//  BrainGames
//
//  Created by Ryan Keys on 12/6/20.
//

import SwiftUI
import Darwin


//List of all colors used.
var colorList = ["red","orange","yellow","green","blue","purple"]
var score: Int = 0

//Returns random String object from colorList above.
func randomColorChoice() -> String {
    return colorList[Int.random(in: 0...colorList.count-1)]
}

//Returns Color based off a randomly selected colorList item.
func randomFontColor() -> (color: Color, name: String) {
    let color = randomColorChoice()
    
    if color == "red"{
        return (Color(.red),"red")
    }
    
    if color == "orange"{
        return (Color(.orange),"orange")
    }
    
    if color == "yellow"{
        return (Color(.yellow),"yellow")
    }
    
    if color == "green"{
        return (Color(.green),"green")
    }
    
    if color == "blue"{
        return (Color(.blue),"blue")
    }
    
    if color == "purple"{
        return (Color(.purple),"purple")
    }
    
    else {
        return (Color(.black),"black")
    }
}

func areColorsSame() -> Bool {
    if topWord == bottomColorName {
        return true
    }
    else {
        return false
    }
}

//Creates initial Variables for game
var topWord: String = randomColorChoice()
var bottomWord: String = randomColorChoice()
var bottomColor: (color: Color, name: String) = randomFontColor()
var bottomColorName: String = bottomColor.name
var sameColor: Bool = areColorsSame()
var startPrompt: String = "Does the meaning match the text color?"


// Creates the timer.
let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

//Handles yes or no button presses.
func buttonHandler(input: Bool, gameOver: Bool, isPaused: Bool? = false) {
    if gameOver == false && isPaused == false {
        if input == sameColor {
            score += 1
        }
        //Creates a new set of variables
        topWord = randomColorChoice()
        bottomWord = randomColorChoice()
        bottomColor = randomFontColor()
        bottomColorName = bottomColor.name
        sameColor = areColorsSame()
    }
}

struct ContentView: View {
    
    //Sets timer to 60 seconds. State variables must be inside struct
    @State var duration: Int = 60
    @State var headerText = startPrompt
    @State var paused: Bool = false
    @State var pauseButton: String = "pause"
    
    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

            HStack(alignment:.bottom){
                VStack{
                    HStack{
                        Button(action: {
                            self.paused.toggle()
                            if self.paused == true {
                                self.pauseButton = "play"
                                self.headerText = "Game Paused.\nPress Play to Resume:"
                            }
                            else{
                                self.pauseButton = "pause"
                                self.headerText = startPrompt
                            }
                        }) {
                            Image(systemName: self.pauseButton)
                                .font(.headline)
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                }
                        
                        Spacer()
                        
                        HStack{
                            Text("Timer:")
                                .padding(.leading)
                                .padding()
                            
                            Text("\(duration)").onReceive(timer) {input in
                                if self.paused == false {
                                    self.duration -= 1
                                    if self.duration <= 0 {
                                        self.duration = 0
                                        self.headerText = "Game Over.\nFinal Score: \(score)\nPlay Again?"
                                    }
                                }
                            }
                                .padding(.trailing)
                        }
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(5.0)

                        
            
                        
                        HStack{
                            Text("Score:")
                                .padding(.leading)
                                .padding()
                            
                            Text("\(score)")
                                .padding(.trailing)
                        }
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(5.0)
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Text("\(headerText)")
                        .padding()
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    Spacer()
                    Spacer()
                    
                    Text("\(topWord)")
                        .font(.largeTitle)
                        
                        .fontWeight(.semibold)
                        .frame(width: 300.0, height: 100.0)
                        .background(Color(.white))
                        .cornerRadius(5.0)
                        .padding()
                        
    
                    Text("\(bottomWord)")
                        .font(.largeTitle)
                        .foregroundColor(bottomColor.color)
                        .fontWeight(.semibold)
                        .frame(width: 300.0, height: 100.0)
                        .background(Color(.white))
                        .cornerRadius(5.0)
                        

                        

                        .padding()
                    
                    Spacer()
                    
                    HStack{
                        //No Button
                        Button(action: {
                            if self.paused == false {
                                if "\(self.duration)" == "0" {
                                    buttonHandler(input:false, gameOver:true)
                                    exit(0)
                                }
                                else {
                                    buttonHandler(input:false, gameOver:false)
                                }
                            }
                            else {
                                buttonHandler(input: false, gameOver: false, isPaused: true)
                            }
                        }) {
                            Text("No")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .frame(width: UIScreen.main.bounds.width/2, height: 100.0)
                                .background(Color.black.opacity(0.5))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        
                        //Yes Button
                        Button(action: {
                            if self.paused == false {
                                if "\(self.duration)" == "0" {
                                    buttonHandler(input:true, gameOver:true)
                                    self.duration = 60
                                    score = 0
                                    self.headerText = startPrompt
                                }
                                else {
                                    buttonHandler(input:true, gameOver:false)
                                }
                            }
                            else {
                                buttonHandler(input: true, gameOver: false, isPaused: true)
                            }
                        }){
                            Text("Yes")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .frame(width: UIScreen.main.bounds.width/2, height: 100.0)
                                .background(Color.black.opacity(0.5))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)

                        }
                        
                        
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

