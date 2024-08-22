//
//  ContentView.swift
//  Pitch Perfect Tuner Watch App
//
//  Created by Kyra Cho on 8/21/24.
//
import SwiftUI
import AVFoundation

class TonePlayer: ObservableObject {
    private var audioEngine: AVAudioEngine
    private var playerNode: AVAudioPlayerNode
    private var audioFormat: AVAudioFormat
    private var currentBuffer: AVAudioPCMBuffer?
    
    @Published var currentNoteIndex: Int = 7 // Default to "G"
    
    // Frequencies for the 12 notes in the middle octave (C4 to B4)
    private let noteFrequencies: [Float] = [
        261.63, // C
        277.18, // C#
        293.66, // D
        311.13, // D#
        329.63, // E
        349.23, // F
        369.99, // F#
        392.00, // G
        415.30, // G#
        440.00, // A
        466.16, // A#
        493.88  // B
    ]
    
    private let noteNames: [String] = [
        " C ",
        "C#",
        " D ",
        "D#",
        " E ",
        " F ",
        "F#",
        " G ",
        "G#",
        " A ",
        "A#",
        " B "
    ]
    
    init() {
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        audioEngine.attach(playerNode)
        
        let sampleRate: Double = 4000.0 // Set sample rate to 4 kHz
        audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)
        
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }
    
    private func generateToneBuffer(frequency: Float) -> AVAudioPCMBuffer {
        let durationInSeconds: Double = 30.0 // 30 seconds = 30 seconds
        let frameCount = Int(audioFormat.sampleRate * durationInSeconds) // Calculate the total frame count for 30 seconds
        let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(frameCount))!
        buffer.frameLength = AVAudioFrameCount(frameCount)
        
        let bufferPointer = buffer.floatChannelData![0]
        let theta = 2.0 * Float.pi * frequency / Float(audioFormat.sampleRate)
        
        for frame in 0..<frameCount {
            bufferPointer[frame] = sin(theta * Float(frame))
        }
        
        return buffer
    }

    
    func play() {
        let frequency = noteFrequencies[currentNoteIndex]
        currentBuffer = generateToneBuffer(frequency: frequency)
        
        guard let buffer = currentBuffer else { return }
        
        playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        playerNode.play()
    }
    
    func stop() {
        playerNode.stop()
    }
    
    func nextNote() {
        currentNoteIndex = (currentNoteIndex + 1) % noteFrequencies.count
        stop()
        play()
    }
    
    func previousNote() {
        currentNoteIndex = (currentNoteIndex - 1 + noteFrequencies.count) % noteFrequencies.count
        stop()
        play()
    }
    
    func currentNoteName() -> String {
        return noteNames[currentNoteIndex]
    }
}

struct ContentView: View {
    @ObservedObject var tonePlayer = TonePlayer()

    var body: some View {
        VStack {
            // Title at the top
            Text("Pitch Perfect Tuner")
                .font(.system(size: 15))
                .padding(.bottom, 10)

            HStack {
                Button(action: {
                    tonePlayer.previousNote()
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.system(size: 40))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(
                            Color.black
                                .cornerRadius(5.0)
                        )
                }
                
                Text(tonePlayer.currentNoteName())
                    .font(.system(size: 23))
                    .padding()
                
                Button(action: {
                    tonePlayer.nextNote()
                }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 40))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(
                            Color.black
                                .cornerRadius(5.0)
                        )
                }
            }
            .padding(.bottom, 15)
            .padding(.top, 15)
 
            HStack {
                GeometryReader { geometry in
                    Button(action: {
                        tonePlayer.play()
                    }) {
                        Text("Play")
                            .frame(width: geometry.size.width / 2.5 - 20) // Adjust width based on screen size
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .leading, endPoint: .trailing)
                                    .cornerRadius(5.0)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .position(x: geometry.size.width / 4, y: geometry.size.height / 2)

                    Button(action: {
                        tonePlayer.stop()
                    }) {
                        Text("Stop")
                            .frame(width: geometry.size.width / 2.5 - 20) // Adjust width based on screen size
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .leading, endPoint: .trailing)
                                    .cornerRadius(5.0)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .position(x: 3 * geometry.size.width / 4, y: geometry.size.height / 2)
                }
            }
            .frame(height: 50) // Set a fixed height for the HStack

          
            .padding(.top, 10)
        }
        .padding()
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
    static var previews: some View {
        ContentView()
    }
}
