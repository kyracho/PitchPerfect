//
//  TonePlayer.swift
//  Pitch Perfect Tuner Watch App
//
//  Created by Kyra Cho on 8/25/24.
//
import AVFoundation
import Foundation
import SwiftUI
import Accelerate
import WatchKit

class TonePlayer: ObservableObject {
    private var audioEngine: AVAudioEngine?
    private var playerNode: AVAudioPlayerNode?
    private var audioFormat: AVAudioFormat?
    private var currentBuffer: AVAudioPCMBuffer?
    
    @Published var currentNoteIndex: Int = 7 // Default to "G"
    
    // Frequencies corresponding to the 12 notes in the middle octave (C4 to B4)
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
    
    // Human-readable names for the 12 notes
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
    
    // Start the audio engine and player node
    func start() {
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        playerNode?.volume = 0.0 // Start with volume at 0 for fade-in
        audioEngine?.attach(playerNode!)
        
        let sampleRate: Double = 4410.0 // Set sample rate to 4.41 kHz
        audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        
        audioEngine?.connect(playerNode!, to: audioEngine!.mainMixerNode, format: audioFormat)
        
        do {
            try audioEngine?.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }
    
    // Stop the audio engine and clean up resources
    func stop() {
        audioEngine?.stop()
        playerNode?.stop()
        audioEngine = nil
        playerNode = nil
        audioFormat = nil
        currentBuffer = nil
    }
    
    // Generates an audio buffer containing a tone at the specified frequency
    private func generateToneBuffer(frequency: Float) -> AVAudioPCMBuffer {
        let durationInSeconds: Double = 30.0 // 30 seconds buffer length
        let sampleRate = audioFormat!.sampleRate
        let wavePeriod = sampleRate / Double(frequency) // Number of samples per wave cycle
        let numberOfCycles = durationInSeconds * Double(frequency) // Total number of cycles in the buffer
        let totalSamples = Int(wavePeriod * numberOfCycles) // Total number of samples
        
        let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat!, frameCapacity: AVAudioFrameCount(totalSamples))!
        buffer.frameLength = AVAudioFrameCount(totalSamples)
        
        let bufferPointer = buffer.floatChannelData![0]
        let theta = 2.0 * Float.pi / Float(wavePeriod) // Angle increment per sample
        
        // Generate the sine wave without any fade effects
        for frame in 0..<totalSamples {
            bufferPointer[frame] = sin(theta * Float(frame))
        }
        
        return buffer
    }

    // Plays the tone corresponding to the current note index with a fade-in effect
    func play() {
        guard let audioEngine = audioEngine, let playerNode = playerNode else {
            print("Audio engine or player node not initialized.")
            return
        }
        
        let frequency = noteFrequencies[currentNoteIndex]
        currentBuffer = generateToneBuffer(frequency: frequency)
        
        guard let buffer = currentBuffer else { return }
        
        playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        playerNode.play()
        
        // Apply fade-in effect
        fadeIn(duration: 0.3) // Set fade-in duration to 0.3 seconds
    }
    
    // Manually fades in the tone over a specified duration to 20% volume
    private func fadeIn(duration: TimeInterval = 0.3) {
        let fadeInSteps = 100 // Number of steps in the fade-in process
        let fadeInInterval = duration / TimeInterval(fadeInSteps)
        
        for step in 0..<fadeInSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + fadeInInterval * TimeInterval(step)) {
                let newVolume = 0.4 * (Float(step) / Float(fadeInSteps)) // Target 40% volume
                self.playerNode?.volume = newVolume
            }
        }
    }
    
    // Manually fades out the tone over a specified duration and stops playback
    private func fadeOutAndStop(duration: TimeInterval = 0.3, completion: @escaping () -> Void) {
        guard let playerNode = playerNode else { return }
        
        let fadeOutSteps = 100 // Number of steps in the fade-out process
        let fadeOutInterval = duration / TimeInterval(fadeOutSteps)
        let initialVolume = playerNode.volume
        
        for step in 0..<fadeOutSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + fadeOutInterval * TimeInterval(step)) {
                let newVolume = initialVolume * (1.0 - Float(step) / Float(fadeOutSteps))
                self.playerNode?.volume = newVolume
            }
        }
        
        // Stop the player node after the fade-out duration and execute the completion block
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.playerNode?.stop()
            self.playerNode?.volume = 0.0 // Reset volume for next play
            completion()
        }
    }
    
    // Stops playing the tone with a fade-out effect
    func stopPlaying() {
        fadeOutAndStop() {}
    }
    
    // Advances to the next note in the scale and plays it with a fade-out/fade-in effect
    func nextNote() {
        fadeOutAndStop {
            self.currentNoteIndex = (self.currentNoteIndex + 1) % self.noteFrequencies.count
            self.play() // Play the next note with fade-in
        }
    }

    // Goes back to the previous note in the scale and plays it with a fade-out/fade-in effect
    func previousNote() {
        fadeOutAndStop {
            self.currentNoteIndex = (self.currentNoteIndex - 1 + self.noteFrequencies.count) % self.noteFrequencies.count
            self.play() // Play the previous note with fade-in
        }
    }

    // Returns the name of the current note
    func currentNoteName() -> String {
        return noteNames[currentNoteIndex]
    }
}
