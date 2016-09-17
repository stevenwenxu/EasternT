//
//  NetworkManager.swift
//  EasternT
//
//  Created by Steven Xu on 2016-09-17.
//  Copyright © 2016 EasternT. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let languageTypeStringMap = [LanguageType.chinese: "zh-CHS",
                                        LanguageType.english: "en",
                                        LanguageType.german: "de"]
    
    static var sharedInstance = NetworkManager()
    private init () {}
    
    func getTranslate(originText: String, from: LanguageType, to: LanguageType) {
        let requestHeaders: HTTPHeaders = [
            "Authorization": "Bearer rjxeiCmEBPmrvAFpVeQ7MVauUNfZgLc2eZ8Nd5G4nwo"
        ]
        
        let requestParameterMap: Parameters = ["text": originText,
                                               "from": NetworkManager.languageTypeStringMap[from]!,
                                               "to": NetworkManager.languageTypeStringMap[to]!]
        
        let urlBase = URL(string: "https://api.microsofttranslator.com/v2/Http.svc/Translate?")!
        let urlRequest = URLRequest(url: urlBase)
        let encodedURLRequest = try? URLEncoding.queryString.encode(urlRequest, with: requestParameterMap)
        guard let url = encodedURLRequest?.url?.absoluteString else {
            return
        }
        
        Alamofire.request(url, headers: requestHeaders).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
    
}
