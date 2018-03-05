//
//  SpeechSynthesizer.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 05/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import AVFoundation

protocol SpeechSynthesizerProtocol {
    func speak(text: String)
}

class SpeechSynthesizer: SpeechSynthesizerProtocol {
    
    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
}
