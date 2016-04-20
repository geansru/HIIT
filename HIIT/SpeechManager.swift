//
//  SpeechManager.swift
//  HIIT
//
//  Created by Dmitry Roytman on 20.04.16.
//  Copyright © 2016 Dmitry Roytman. All rights reserved.
//

import Foundation
import AVFoundation

class SpeechManager {
    static let shared = SpeechManager()
    
    func speech(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speakUtterance(utterance)
    }
}
