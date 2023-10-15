//
//  SpeechToText.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 12/10/2023.
//

import AVFoundation
import Speech
import SwiftUI

/// A class for handling speech-to-text conversion and recognition.
class SpeechToText: ObservableObject {
    var audioEngine = AVAudioEngine()  // Audio engine for recording
    var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))  // Speech recognition engine
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?  // Request for speech recognition
    var recognitionTask: SFSpeechRecognitionTask?  // Task for handling speech recognition

    @Published var isRecording = false  // Indicates whether recording is in progress
    @Published var transcript = ""  // The recognized speech transcript
    private var lastTranscript = ""  // Store the previous transcript to update the current one

    @AppStorage("OnDeviceRecognition") var onDeviceRecognition: Bool = true  // Setting for on-device recognition

    /// Toggle the recording of speech.
    ///
    /// - Parameter language: The target language for speech recognition.
    func toggleRecording(language: String) {

        languageChange(language: language)

        if isRecording {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            audioEngine.inputNode.removeTap(onBus: 0) // Remove tap for audio input
        } else {
            do {
                try startRecording()
            } catch {
                print("Could not start recording: \(error)")
            }
        }
        isRecording.toggle()  // Toggle the recording state
    }

    /// Change the language for speech recognition.
    ///
    /// - Parameter language: The target language for speech recognition.
    func languageChange(language: String) {
        let languages_long = ["English", "Spanish", "French", "German", "Chinese", "Japanese", "Russian", "Arabic"]
        let languages_short = ["en_US", "es_ES", "fr_FR", "de_DE", "zh_CN", "ja_JP", "ru_RU", "ar_SA"]

        if language == "Auto" {
            speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
        } else {
            speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: languages_short[languages_long.firstIndex(of: language)!]))
        }
    }

    /// Start the recording of speech.
    func startRecording() throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        if onDeviceRecognition {
            if let recognizer = speechRecognizer, recognizer.supportsOnDeviceRecognition {
                recognitionRequest?.requiresOnDeviceRecognition = true
            }
        }
        guard let recognitionRequest = recognitionRequest else { return }

        let inputNode = audioEngine.inputNode
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    let newTranscript = result.bestTranscription.formattedString
                    if self.lastTranscript != newTranscript {
                        let newContent = String(newTranscript.dropFirst(self.lastTranscript.count))
                        self.transcript += " " + newContent
                        self.lastTranscript = newTranscript
                    }
                }
            } else if let error = error {
                print("Recognition error: \(error)")
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }
}
