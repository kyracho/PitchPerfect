//
//  ContentView.swift
//  PitchPerfect Watch App
//
//  Created by Kyra Cho on 8/19/24.
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
        
        let sampleRate: Double = 44100.0
        audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)
        
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }
    
    private func generateToneBuffer(frequency: Float) -> AVAudioPCMBuffer {
        let frameCount = Int(audioFormat.sampleRate * 1.0) // 1-second buffer
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
            HStack {
                Button(action: {
                    tonePlayer.previousNote()
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.system(size: 40))
                }
                
                Text(tonePlayer.currentNoteName())
                    .font(.system(size: 25))
                    .padding()
                Button(action: {
                    tonePlayer.nextNote()
                }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 40))
                }
            }
            .padding(.bottom, 25)
            
            HStack {
                Button(action: {
                    tonePlayer.play()
                }) {
                    Text("Play")
                        .font(.system(size: 16))
                        .frame(width: 62, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.green)
                                .shadow(color: .green.opacity(0.5), radius: 5, x: 0, y: 2)
                        )
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    tonePlayer.stop()
                }) {
                    Text("Stop")
                        .font(.system(size: 16))
                        .frame(width: 62, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.red)
                                .shadow(color: .red.opacity(0.5), radius: 5, x: 0, y: 2)
                        )
                        .foregroundColor(.white)
                }
            }
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
