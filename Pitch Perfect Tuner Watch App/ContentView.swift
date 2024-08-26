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
                            .font(.system(size: 45))
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(
                                Color.brown
                                    .cornerRadius(5.0)
                            )
                    }
                    
                    Text(tonePlayer.currentNoteName())
                        .font(.system(size: 23))
                        .padding()
                    
                    Button(action: {
                        tonePlayer.nextNote() // Go to the next note
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 45))
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
//
//struct TuneKitty: View {
//    @StateObject var pitchDetector = PitchDetector() // Using @StateObject for better lifecycle management
//    
//    // Dictionary to map note names to their frequencies, including an octave below and two octaves above
//    private let noteFrequencies: [String: Float] = [
//        // Octave below (C3 to B3)
//        "C3": 130.81, "C#3": 138.59, "D3": 146.83, "D#3": 155.56,
//        "E3": 164.81, "F3": 174.61, "F#3": 185.00, "G3": 196.00,
//        "G#3": 207.65, "A3": 220.00, "A#3": 233.08, "B3": 246.94,
//
//        // Middle octave (C4 to B4)
//        "C4": 261.63, "C#4": 277.18, "D4": 293.66, "D#4": 311.13,
//        "E4": 329.63, "F4": 349.23, "F#4": 369.99, "G4": 392.00,
//        "G#4": 415.30, "A4": 440.00, "A#4": 466.16, "B4": 493.88,
//
//        // Octave above (C5 to B5)
//        "C5": 523.25, "C#5": 554.37, "D5": 587.33, "D#5": 622.25,
//        "E5": 659.25, "F5": 698.46, "F#5": 739.99, "G5": 783.99,
//        "G#5": 830.61, "A5": 880.00, "A#5": 932.33, "B5": 987.77,
//
//        // Two octaves above (C6 to B6)
//        "C6": 1046.50, "C#6": 1108.73, "D6": 1174.66, "D#6": 1244.51,
//        "E6": 1318.51, "F6": 1396.91, "F#6": 1479.98, "G6": 1567.98,
//        "G#6": 1661.22, "A6": 1760.00, "A#6": 1864.66, "B6": 1975.53
//    ]
//
//    var body: some View {
//        ZStack {
//            Color.brown // Set the background color for the entire screen
//                .edgesIgnoringSafeArea(.all) // Extend the background color to edges
//            
//            VStack {
//                Text("Chromatic Tuner")
//                    .font(.system(size: 14))
//                    .padding(.bottom, 20)
//                
//                // Display the detected frequency
//                Text("Freq: \(pitchDetector.detectedPitch) Hz")
//                    .font(.system(size: 16))
//                    .fontWeight(.bold)
//                    .padding(.bottom, 10)
//                
//                // Display the detected note and the corresponding target frequency
//                Text(noteAndFrequencyText())
//                    .font(.system(size: 16))
//                    .padding(.top, 5)
//            }
//            .padding()
//            .onChange(of: pitchDetector.detectedPitch) { _ in
//                // Trigger UI update on detected pitch change
//            }
//        }
//    }
//
//    // Function to generate the text for the detected note and target frequency
//    private func noteAndFrequencyText() -> String {
//        // Assuming detectedPitch is just the frequency in Hz
//        guard let frequency = Float(pitchDetector.detectedPitch) else {
//            return "Invalid frequency."
//        }
//
//        // Find the closest note and target frequency
//        guard let (note, targetFrequency) = closestNoteAndFrequency(for: frequency) else {
//            return "No matching note found."
//        }
//
//        return "Detected Note: \(note) \nIdeal Freq: \(Int(targetFrequency)) Hz"
//    }
//
//    // Function to find the closest note and its target frequency
//    private func closestNoteAndFrequency(for frequency: Float) -> (String, Float)? {
//        var closestNote: String?
//        var smallestDifference: Float = Float.greatestFiniteMagnitude
//
//        for (note, targetFrequency) in noteFrequencies {
//            let difference = abs(frequency - targetFrequency)
//            if difference < smallestDifference {
//                smallestDifference = difference
//                closestNote = note
//            }
//        }
//
//        if let note = closestNote, let targetFrequency = noteFrequencies[note] {
//            return (note, targetFrequency)
//        } else {
//            return nil
//        }
//    }
//}
//
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
                Text("Little Metronome") // Title at the top
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
                .padding(.bottom, 0)

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

                    .padding(.bottom, 0)

                HStack {
                    Button(action: {
                        metronomePlayer.start() // Explicitly start the audio engine
                        metronomePlayer.play() // Start the metronome
                    }) {
                        Text("Play")
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color.brown)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2)) // White outline with 2-point thickness
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        metronomePlayer.stop() // Stop the metronome and audio engine
                    }) {
                        Text("Stop")
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color.brown)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2)) // White outline with 2-point thickness
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.bottom, 12)
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


