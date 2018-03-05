//
//  AudioRecorder.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 05/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import Speech
import RxSwift

protocol AudioRecorderProtocol {
    func start()
    func stop()
    func pause()
}

class AudioRecorder: AudioRecorderProtocol {
    let audioEngine: AVAudioEngine
    let speechRecognizer: SFSpeechRecognizer?
    var request: SFSpeechAudioBufferRecognitionRequest
    var recognitionTask: SFSpeechRecognitionTask?
    var recordedText: Variable<String>
    
    init() {
        audioEngine = AVAudioEngine()
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        request = SFSpeechAudioBufferRecognitionRequest()
        recordedText = Variable<String>("")
        
        initAudioEngine()
        initSpeechRecognizer()
    }
    
    
    // MARK: - Recording Controls -
    private func initAudioEngine() {
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine
            .inputNode
            .installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { buffer, _ in
                self.request.append(buffer)
            })
        
        audioEngine.prepare()
    }
    
    private func initSpeechRecognizer() {
        guard let myRecognizer = speechRecognizer else {
            return
        }
        if !myRecognizer.isAvailable {
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { [weak self] result, error in
            if let result = result {
                self?.recordedText.value = result.bestTranscription.formattedString
            } else if let error = error {
                print(error)
            }
        })
    }
    
    func start() {
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
    }
    
    func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request = SFSpeechAudioBufferRecognitionRequest()
        recognitionTask = nil
    }
    
    func pause() {
        audioEngine.pause()
    }
}
