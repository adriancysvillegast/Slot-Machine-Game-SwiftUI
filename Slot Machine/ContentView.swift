//
//  ContentView.swift
//  Slot Machine
//
//  Created by Adriancys Jesus Villegas Toro on 24/10/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    
    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    let haptics = UINotificationFeedbackGenerator()
    
    @State private var reels: Array = [0,1,2]
    @State private var showingInView: Bool = false
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    @State private var isActiveBet10: Bool = true
    @State private var isActiveBet20: Bool = false
    @State private var showModel: Bool = false
    @State private var animateSymbol: Bool = false
    @State private var animatingModal: Bool = false
    
    
    // MARK: - Functions
    
//    spin the reels
    func spinReels() {
        reels = reels.compactMap({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        playsound(sound: "spin", type: "mp3")
        haptics.notificationOccurred(.success)
    }
//    check the winning
    func checkWinning() {
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[0] == reels[2] {
            //    player wins
            playerWins()
            //    new highscore
            if coins > highScore {
                newHighScore()
            } else {
                playsound(sound: "win", type: "mp3")
            }
        } else {
            //    player loses
            playerLoses()
        }
    }

    func playerWins() {
        coins += betAmount * 10
    }

    func newHighScore() {
        highScore = coins
        UserDefaults.standard.set(highScore, forKey: "HighScore")
        playsound(sound: "high-score", type: "mp3")
    }
    
    func playerLoses() {
        coins -= betAmount
    }
    
    func activateBet20() {
        betAmount = 20
        isActiveBet20 = true
        isActiveBet10 = false
        playsound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func activateBet10() {
        betAmount = 10
        isActiveBet20 = false
        isActiveBet10 = true
        playsound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func isGameOver() {
        if coins <= 0 {
//            showModal
            showModel = true
            playsound(sound: "game-over", type: "mp3")
        }
    }
    
//    game over
    func resetGame() {
        UserDefaults.standard.set(0, forKey: "HighScore")
        highScore = 0
        coins = 100
        activateBet10()
        playsound(sound: "chimeup", type: "mp3")
    }
    
    
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // MARK: - background
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            
            // MARK: - Interface
            VStack(alignment: .center, spacing: 5) {
                
                // MARK: - Header
                LogoView()
                
                Spacer()
                
                // MARK: - Score
                HStack {
                    
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        
                        Text("\(highScore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                        
                        
                    }
                    .modifier(ScoreContainerModifier())
                }
                
                // MARK: - Slot Machine
                
                VStack(alignment: .center, spacing: 0) {
                    //image 1
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animateSymbol ? 1 : 0)
                            .offset(y: animateSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)), value: animateSymbol)
                            .onAppear {
                                self.animateSymbol.toggle()
                                playsound(sound: "riseup", type: "mp3")
                            }
                            
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        //image 2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[0]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animateSymbol ? 1 : 0)
                                .offset(y: animateSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)), value: animateSymbol)
                                .onAppear {
                                    self.animateSymbol.toggle()
                                }
                        }
                        Spacer()
                        //image 3
                        
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animateSymbol ? 1 : 0)
                                .offset(y: animateSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)), value: animateSymbol)
                                .onAppear {
                                    self.animateSymbol.toggle()
                                }
                        }
                    }
                    .frame(maxWidth: 500)
                    
                    
                    // spin button
                    Button {
                        
//                        set the default state: no animation
                        withAnimation {
                            self.animateSymbol = false
                        }
//                        spinthe reels with changing the symbols
                        
                        self.spinReels()
                        
//                        trigger animation after changing teh symbols
                        withAnimation {
                            self.animateSymbol = true
                        }
                        
//                        check winning
                        self.checkWinning()
                        
//                        game Over
                        self.isGameOver()
                    } label: {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                        
                    }

                }
                .layoutPriority(2)
                
                // MARK: - Footer
                Spacer()
                
                HStack {
//                    BET 20
                    HStack(alignment: .center, spacing: 10) {
                        Button {
                            self.activateBet20()
                        } label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor( isActiveBet20 ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsulModifier())
                        
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActiveBet20 ? 0 : 20)
                            .opacity(isActiveBet20 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                            
                    }
                    Spacer()
                    
//                    BET 10
                    HStack(alignment: .center, spacing: 10) {
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActiveBet10 ? 0 : -20)
                            .opacity(isActiveBet10 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                        
                        Button {
                            self.activateBet10()
                        } label: {
                            
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet10 ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsulModifier())
                    
                        
                    }
                    
                }
            }
            // MARK: - Button
            .overlay(alignment: .topLeading, content: {
                Button {
                    self.resetGame()
                } label: {
                    Image(systemName: "arrow.2.circlepath.circle")
                        .modifier(ButtonModofier())
                }

            })
            .overlay(alignment: .topTrailing, content: {
                Button {
                    self.showingInView = true
                } label: {
                    Image(systemName: "info.circle")
                        .modifier(ButtonModofier())
                }

            })
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showModel.wrappedValue ? 5 : 0, opaque: false)
            
            // MARK: - Popup
            
            if $showModel.wrappedValue {
                ZStack {
                    Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                    
//                    Modal
                    VStack(spacing: 0) {
//                        title
                        Text("Game Over")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
//                        message
                        VStack(alignment: .center, spacing: 16) {
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            
                            Text("Bad Luck, you lost all of the coins\n let's play again")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .layoutPriority(1)

                            Button {
                                self.showModel = false
                                
                                self.animatingModal = false
                                self.activateBet10()
                                self.coins = 100
                            } label: {
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .tint(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                            Capsule()
                                                .strokeBorder(lineWidth: 1.75)
                                                .foregroundColor(Color("ColorPink"))
                                    )
                            }

                
                        }
                        
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .opacity($animatingModal.wrappedValue ? 1 : 0)
                    .offset(y: $animatingModal.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: animatingModal)
                    .onAppear {
                        self.animatingModal = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingInView) {
            InfoView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
