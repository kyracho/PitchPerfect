//
//  Metronome.swift
//  Pitch Perfect Tuner Watch App
//
//  Created by Kyra Cho on 8/25/24.
//
import AVFoundation
import Foundation
import SwiftUI
import Accelerate
import WatchKit

class MetronomePlayer: ObservableObject {
    private var audioEngine: AVAudioEngine? // Audio engine to handle audio playback
    private var playerNode: AVAudioPlayerNode? // Player node to play sound
    private var audioFormat: AVAudioFormat? // Audio format for sound playback
    private var timer: Timer? // Timer to schedule beats
    @Published var currentTempo: Int = 120 // Default tempo is 120 BPM

    // Start the audio engine and player node
    func start() {
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        audioEngine?.attach(playerNode!)
        
        // Set up audio format with a sample rate of 44100 Hz and 1 channel
        let sampleRate: Double = 44100.0
        audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        
        // Connect the player node to the main mixer node
        audioEngine?.connect(playerNode!, to: audioEngine!.mainMixerNode, format: audioFormat)
        
        // Start the audio engine
        do {
            try audioEngine?.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }
    
    // Function to generate the same click sound every time it's called
    private func generateClickSound(seed: UInt64 = 10) -> AVAudioPCMBuffer? {
        guard let audioFormat = audioFormat else { return nil }
        let frameCount = Int(audioFormat.sampleRate * 0.005) // Sound duration (0.005 seconds)
        let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(frameCount))!
        buffer.frameLength = AVAudioFrameCount(frameCount)
        
        var randomValue = seed
        let bufferPointer = buffer.floatChannelData![0]
        for frame in 0..<frameCount {
            // Linear Congruential Generator to create a pseudo-random value
            randomValue = (randomValue &* 1664525 &+ 1013904223) & 0xFFFFFFFF
            let normalizedValue = Float(randomValue) / Float(UInt32.max) * 2.0 - 1.0
            bufferPointer[frame] = normalizedValue
        }
        
        return buffer
    }
    
    func play() {
        guard let playerNode = playerNode, let buffer = generateClickSound(), timer == nil else { return } // Avoid multiple timers
        
        let interval = 60.0 / Double(currentTempo) // Calculate the interval between beats
        
        playerNode.volume = 0.4 // Set the volume to 40%
        
        // Play the first beat immediately
        playerNode.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
        playerNode.play()
        
        // Schedule subsequent beats
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.playerNode?.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
            self.playerNode?.play()
        }
    }
    
    func stop() {
        timer?.invalidate() // Stop the timer
        timer = nil
        playerNode?.stop() // Stop the player node
        audioEngine?.stop() // Stop the audio engine
        audioEngine = nil
        playerNode = nil
        audioFormat = nil
    }
}
