//
//  ETBrain.swift
//  EasternT
//
//  Created by Steven Xu on 2016-09-16.
//  Copyright © 2016 EasternT. All rights reserved.
//

import Foundation
import Speech

class ETBrain : NSObject {

    func speechToText() -> String? {
        return nil
    }

    static func textToSpeech(text: String, languageType: LanguageType) {
        var languageTypeString: String?
        
        switch languageType {
        case LanguageType.english:
            languageTypeString = "en-US"
        case LanguageType.german:
            languageTypeString = "de-DE"
        case LanguageType.chinese:
            languageTypeString = "zh-CN"
        default:
            NSLog("Fatal: undefined language type")
            return
        }
        
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
