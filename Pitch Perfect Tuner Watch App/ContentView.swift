//
//  ContentView.swift
//  Pitch Perfect Tuner Watch App
//
//  Created by Kyra Cho on 8/21/24.
//
import AVFoundation
import Foundation
import SwiftUI
import Accelerate
import WatchKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.brown // Set the background color for the entire screen
                    .edgesIgnoringSafeArea(.all) // Extend the background color to edges
                VStack {
                    // Customized title at the top
                    Text("Main Menu")
                        .font(.system(size: 14, weight: .bold)) // Adjust the font size and weight
                        .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                    
                    // Buttons with Outlines
                    NavigationLink(destination: Metronome()) {
                        Text("Metronome")
                            .font(.system(size: 14))
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Color.brown)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2) // White outline with 2-point thickness
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: TuneKitty()) {
                        Text("Tuner")
                            .font(.system(size: 14))
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Color.brown)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2) // White outline with 2-point thickness
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: PitchPerfect()) {
                        Text("Play a Note")
                            .font(.system(size: 14))
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Color.brown)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2) // White outline with 2-point thickness
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                .navigationBarHidden(true) // Optionally hide the navigation bar
            }
        }
    }
}

struct PitchPerfect: View {
    @StateObject private var tonePlayer = TonePlayer() // Use @StateObject for lifecycle management

    var body: some View {
        ZStack {
            Color.brown // Set the background color for the entire screen
                .edgesIgnoringSafeArea(.all) // Extend the background color to edges
            
            VStack {
                Text("Play a Note") // Title at the top
                    .font(.system(size: 14))
                    .padding(.bottom, 5)
                
                // The Pitch Perfect Tuner interface
                HStack {
                    Button(action: {
                        tonePlayer.previousNote() // Go to the previous note
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.system(size: 35))
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(
                                Color.brown
                                    .cornerRadius(5.0)
                            )
                    }
                    
                    Text(tonePlayer.currentNoteName())
                        .font(.system(size: 22))
                        .padding()
                    
                    Button(action: {
                        tonePlayer.nextNote() // Go to the next note
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 35))
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(
                                Color.brown
                                    .cornerRadius(5.0)
                            )
                    }
                }
                
                HStack {
                    GeometryReader { geometry in
                        Button(action: {
                            tonePlayer.start() // Explicitly start the audio engine
                            tonePlayer.play() // Start playing the tone
                        }) {
                            Text("Play")
                                .frame(width: geometry.size.width / 2.5 - 20) // Adjust width based on screen size
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(Color.brown)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 2)) // White outline with 2-point thickness
                        }
                        .buttonStyle(PlainButtonStyle())
                        .position(x: geometry.size.width / 4, y: geometry.size.height / 2)
                        
                        Button(action: {
                            tonePlayer.stopPlaying() // Stop playing the tone with a fade-out
                            tonePlayer.stop() // Explicitly stop the audio engine
                        }) {
                            Text("Stop")
                                .frame(width: geometry.size.width / 2.5 - 20) // Adjust width based on screen size
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(Color.brown)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 2)) // White outline with 2-point thickness
                        }
                        .buttonStyle(PlainButtonStyle())
                        .position(x: 3 * geometry.size.width / 4, y: geometry.size.height / 2)
                    }
                }
                .frame(height: 50) // Set a fixed height for the HStack
                .padding(.top, 10)
                
            }
            .padding()
            .navigationBarHidden(false)
        }
        .onAppear {
            tonePlayer.start() // Optionally start the engine when the view appears
        }
        .onDisappear {
            tonePlayer.stop() // Stop the engine when the view disappears
        }
    }
}

struct TuneKitty: View {

    var body: some View {
        ZStack {
            Color.brown // Set the background color for the entire screen
                .edgesIgnoringSafeArea(.all) // Extend the background color to edges

            VStack {
                Text("Chromatic Tuner")
                    .font(.system(size: 14))
                    .padding(.bottom, 20)

                // Display the detected frequency
                Text("Freq: 747.24 Hz")
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                // Display the detected note and the corresponding target frequency
                Text("Detected Note: F#5 \nIdeal Freq: 739.99Hz")
                    .font(.system(size: 16))
                    .padding(.top, 5)
            }
            .padding()
        
            }
        }
    }





struct Metronome: View {
    @StateObject var metronomePlayer = MetronomePlayer() // Use @StateObject for better lifecycle management
    
    @State private var crownValue: Double = 0.0 // Initial crown value

    init() {
        _crownValue = State(initialValue: Double(metronomePlayer.currentTempo)) // Initialize crownValue with the initial tempo
    }

    var body: some View {
        ZStack {
            Color.brown // Set the background color for the entire screen
                .edgesIgnoringSafeArea(.all) // Extend the background color to edges
            
            VStack {
                Text("Metronome") // Title at the top
                    .font(.system(size: 14))
                    .padding(.bottom, 5)
                
                HStack {
                    Button(action: {
                        if metronomePlayer.currentTempo > 40 {
                            metronomePlayer.stop() // Stop the metronome before changing the tempo
                            metronomePlayer.currentTempo -= 1 // Decrease tempo by 1
                        }
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.system(size: 36))
                            .padding(.horizontal, 10)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        if metronomePlayer.currentTempo < 200 {
                            metronomePlayer.stop() // Stop the metronome before changing the tempo
                            metronomePlayer.currentTempo += 1 // Increase tempo by 1
                        }
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 36))
                            .padding(.horizontal, 10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                Text("\(metronomePlayer.currentTempo) BPM") // Display current tempo
                    .font(.largeTitle)
                    .padding(.bottom, 10)
                    .focusable(true)
                    .digitalCrownRotation($crownValue, from: 40.0, through: 200.0, by: 1.0, sensitivity: .medium, isContinuous: false, isHapticFeedbackEnabled: true)
                    .onChange(of: crownValue) {
                        let newTempo = Int(crownValue)
                        if newTempo != metronomePlayer.currentTempo {
                            metronomePlayer.stop() // Stop the metronome before changing the tempo
                            metronomePlayer.currentTempo = newTempo // Update tempo based on crown rotation
                        }
                    }

                HStack {
                    GeometryReader { geometry in
                        Button(action: {
                            metronomePlayer.start() // Explicitly start the audio engine
                            metronomePlayer.play() // Start the metronome
                        }) {
                            Text("Play")
                                .frame(width: geometry.size.width / 2.5 - 20) // Adjust width based on screen size
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(Color.brown)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 2)) // White outline with 2-point thickness
                        }
                        .buttonStyle(PlainButtonStyle())
                        .position(x: geometry.size.width / 4, y: geometry.size.height / 2 - 10)
                        
                        Button(action: {
                            metronomePlayer.stop() // Stop the metronome and audio engine
                        }) {
                            Text("Stop")
                                .frame(width: geometry.size.width / 2.5 - 20) // Adjust width based on screen size
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(Color.brown)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 2)) // White outline with 2-point thickness
                        }
                        .buttonStyle(PlainButtonStyle())
                        .position(x: 3 * geometry.size.width / 4, y: geometry.size.height / 2 - 10)
                    }
                }
                .frame(height: 40) // Set a fixed height for the HStack
            }
        }
        .onAppear {
            metronomePlayer.start() // Start the audio engine when the view appears
        }
        .onDisappear {
            metronomePlayer.stop() // Stop the audio engine when the view disappears
        }
    }
}

@main
struct ConstantToneApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: ContentView {
        ContentView()
    }
}
