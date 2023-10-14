//
//  SpeechToText.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 12/10/2023.
//

import AVFoundation
import Speech
import SwiftUI

class SpeechToText: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    @Published var isRecording = false
    @Published var transcript = ""
    private var lastTranscript = ""

    @AppStorage("OnDeviceRecognition") var onDeviceRecognition: Bool = true

    func toggleRecording() {
        if isRecording {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            audioEngine.inputNode.removeTap(onBus: 0) // 移除 tap
        } else {
            do {
                try startRecording()
            } catch {
                print("Could not start recording: \(error)")
            }
        }
        isRecording.toggle()
    }

    private func startRecording() throws {
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
