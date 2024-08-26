//
//  Chromatic Tuner.swift
//  Pitch Perfect Tuner Watch App
//
//  Created by Kyra Cho on 8/25/24.

import AVFoundation
import Foundation
import SwiftUI

class PitchDetector: ObservableObject {
    private var audioEngine: AVAudioEngine
    private var inputNode: AVAudioInputNode
    private var audioFormat: AVAudioFormat
    
    // A buffer to store recent frequency values for averaging
    private var frequencyBuffer: [Float] = []
    private let bufferSize = 10 // Adjust this for smoother or more responsive updates
    
    @Published var detectedPitch: String = ""
    
    init() {
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        audioFormat = inputNode.outputFormat(forBus: 0)
        
        startAudioSession()
    }
    
    private func startAudioSession() {
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, time in
            self.processAudio(buffer: buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio Engine couldn't start: \(error.localizedDescription)")
        }
    }
    
    private func processAudio(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else {
            return
        }

        let frameLength = Int(buffer.frameLength)
        var zeroCrossings = 0
        var lastValue: Float = channelData[0]

        for i in 1..<frameLength {
            let value = channelData[i]
            if (value > 0 && lastValue < 0) || (value < 0 && lastValue > 0) {
                zeroCrossings += 1
            }
            lastValue = value
        }
        
        // Calculate frequency based on zero crossings
        let frequency = Float(zeroCrossings) * Float(audioFormat.sampleRate) / Float(frameLength * 2)
        
        // Add the frequency to the buffer
        frequencyBuffer.append(frequency)
        
        // Keep only the last 'bufferSize' frequencies
        if frequencyBuffer.count > bufferSize {
            frequencyBuffer.removeFirst()
        }
        
        // Calculate the average frequency
        let averageFrequency = frequencyBuffer.reduce(0, +) / Float(frequencyBuffer.count)
        
        // Update the detected pitch on the main thread with only the averaged frequency
        DispatchQueue.main.async {
            self.detectedPitch = String(format: "%.2f", averageFrequency)
        }
    }
    
    func stop() {
        audioEngine.stop()
    }
}
