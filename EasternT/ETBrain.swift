//
//  ETBrain.swift
//  EasternT
//
//  Created by Steven Xu on 2016-09-16.
//  Copyright © 2016 EasternT. All rights reserved.
//

import Foundation
import Speech

enum LanguageType: String {
    case english = "English"
    case chinese = "Chinese"
    case german = "German"

    static let allValues = [english, chinese, german]
}

let languageTypeStringMapA = [LanguageType.chinese: "zh-CHS",
                                    LanguageType.english: "en",
                                    LanguageType.german: "de"]

let languageTypeStringMapB = [LanguageType.chinese: "zh-CN",
                                    LanguageType.english: "en-US",
                                    LanguageType.german: "de-DE"]

class ETBrain : NSObject {

    func speechToText() -> String? {
        return nil
    }

    func textToSpeech(text: String, languageType: LanguageType) {
        var languageTypeString: String?
        
        languageTypeString = languageTypeStringMapB[languageType]!
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)

        let synth = AVSpeechSynthesizer()
        let myUtterance = AVSpeechUtterance(string: text)
        myUtterance.rate = 0.5
        myUtterance.voice = AVSpeechSynthesisVoice(language: languageTypeString)
        synth.speak(myUtterance)
    }

    func translate(from: String) -> String {
        let translateApiUrl = "https://api.datamarket.azure.com/data.ashx/Bing/microsofttranslatorspeech/v1/Translation"
        return ""
    }
}
