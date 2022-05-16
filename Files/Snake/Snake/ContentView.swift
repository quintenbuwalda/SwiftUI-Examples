//
//  ContentView.swift
//  Snake
//
//  Created by Quinten Buwalda on 7/4/22.
//

import SwiftUI

enum direction {
    case up, down, left, right
}

let defaults = UserDefaults.standard

struct ContentView: View {
    @Binding var preference: Preference
    @State private var data = Preference.Data()
    
    @State var startPos : CGPoint = .zero
    @State var isStarted = true
    @State var gameOver = false
    @State var gameStarted = false
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State var dir = direction.down
    
    @State var posArray = [CGPoint(x: 0, y: 0)]
    @State var foodPos = CGPoint(x: 0, y: 0)
    
    @State var currentScore : Int = 0
    @State var highScore = defaults.integer(forKey: "highScore")
    
    @State private var willMoveToNextScreen = false
    
        
    @State var colorArray : [Color] = [.blue, .mint]
    
    let snakeSize : CGFloat = 20
    
    var body: some View {
        ZStack {
            colorArray[1].opacity(0.3)
            ZStack {
                ForEach (0..<posArray.count, id: \.self) { index in
                    Rectangle()
                        .frame(width: self.snakeSize, height: self.snakeSize)
                        .position(self.posArray[index])
                }
                Rectangle()
                    .fill(colorArray[0])
                    .frame(width: snakeSize, height: snakeSize)
                    .position(foodPos)
            }
            
            ZStack(alignment:.trailing) {
                VStack {
                    if self.gameOver {
                        Text("Score: \(String(currentScore))")
                        Text("High Score: \(String(highScore))")
                    }
                    
                    if !self.gameStarted {
                        HStack {
                            Button("Press to start!") {
                                self.gameStarted.toggle()
                                self.highScore = defaults.integer(forKey: "highScore")
                                if gameOver {
                                    gameOver.toggle()
                                    currentScore = 0
                                }
                                self.posArray[0] = self.changeRectPos()
                            }
                            .tint(.blue)
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.roundedRectangle(radius: 10))
                            .controlSize(.large)
                            
                            
                            
                            Button(action: {willMoveToNextScreen = true}) {
                                Image(systemName: "gearshape.fill")
                                    .foregroundColor(Color.white)
                            }
                            .padding()
                            .background(Color.blue)
                            .mask(Circle())
                        }
                    }
                }
            }
            
        }.onAppear() {
            self.foodPos = self.changeRectPos()
            self.posArray[0] = self.changeRectPos()
        }
        .gesture(DragGesture()
        .onChanged { gesture in
            if self.isStarted {
                self.startPos = gesture.location
                self.isStarted.toggle()
            }
        }
        .onEnded {  gesture in
            let xDist =  abs(gesture.location.x - self.startPos.x)
            let yDist =  abs(gesture.location.y - self.startPos.y)
            if self.startPos.y <  gesture.location.y && yDist > xDist {
                self.dir = direction.down
            }
            else if self.startPos.y >  gesture.location.y && yDist > xDist {
                self.dir = direction.up
            }
            else if self.startPos.x > gesture.location.x && yDist < xDist {
                self.dir = direction.right
            }
            else if self.startPos.x < gesture.location.x && yDist < xDist {
                self.dir = direction.left
            }
            self.isStarted.toggle()
            }
        )
            .onReceive(timer) { (_) in
                if !self.gameOver && self.gameStarted {
                    self.changeDirection()
                    if self.posArray[0] == self.foodPos {
                        self.posArray.append(self.posArray[0])
                        self.foodPos = self.changeRectPos()
                        self.currentScore = self.incrementScore()
                    }
                }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $willMoveToNextScreen){
            NavigationView {
                EditView(data: $data)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Settings")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                willMoveToNextScreen = false
                                self.highScore = defaults.integer(forKey: "highScore")
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                willMoveToNextScreen = false
                                preference.update(from: data)
                                self.colorArray = self.data.theme.colorArray
                                self.highScore = defaults.integer(forKey: "highScore")
                                print("dataa")
                                print(self.data.theme)
                                print(colorArray)
//                                if preference.data.reScore == true {
//                                    UserDefaults.standard.set(highScore, forKey: "highScore")
//                                    data = Preference.Data(theme: preference.data.theme, speed: preference.data.speed, reScore: false)
//                                    preference.update(from: data)
//                                }
                            }
                        }
                    }
            }
        }
    }
    
    let minX = UIScreen.main.bounds.minX
    let maxX = UIScreen.main.bounds.maxX
    let minY = UIScreen.main.bounds.minY
    let maxY = UIScreen.main.bounds.maxY
    func changeDirection () {
        if self.posArray[0].x < minX || self.posArray[0].x > maxX && !gameOver{
            highScore = checkHighScore()
            gameOver.toggle()
            gameStarted.toggle()
            posArray = [CGPoint(x: -1, y: -1)]
        }
        else if self.posArray[0].y < minY || self.posArray[0].y > maxY  && !gameOver {
            highScore = checkHighScore()
            gameOver.toggle()
            gameStarted.toggle()
            posArray = [CGPoint(x: -1, y: -1)]
        }
        var prev = posArray[0]
        if dir == .down {
            self.posArray[0].y += snakeSize
        } else if dir == .up {
            self.posArray[0].y -= snakeSize
        } else if dir == .left {
            self.posArray[0].x += snakeSize
        } else if dir == .right {
            self.posArray[0].x -= snakeSize
        }
        
        for index in 1..<posArray.count {
            let current = posArray[index]
            posArray[index] = prev
            prev = current
        }
    }
    
    func changeRectPos() -> CGPoint {
        let rows = Int(maxX/snakeSize)
        let cols = Int((maxY)/snakeSize)
        
        let randomX = Int.random(in: 1..<rows) * Int(snakeSize)
        var randomY = Int.random(in: 1..<cols) * Int(snakeSize)
        
        while (randomY < 60) {randomY = Int.random(in: 1..<cols) * Int(snakeSize)}
        
        return CGPoint(x: randomX, y: randomY)
    }
    
    func incrementScore() -> Int {
        let score = currentScore
        
        return score + 1
    }
    
    func checkHighScore() -> Int {
        let score = currentScore
        
        if score > highScore {highScore = score}
        
        UserDefaults.standard.set(highScore, forKey: "highScore")
        
        return highScore
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(preference: .constant(Preference.sampleData[0]))
    }
}
