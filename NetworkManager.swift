//
//  NetworkManager.swift
//  EasternT
//
//  Created by Steven Xu on 2016-09-17.
//  Copyright © 2016 EasternT. All rights reserved.
//

import Foundation
import Alamofire

class TokenManager {
    private var token: String? = nil
    private let tokenUrl = "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"
    private let params: Parameters = ["grant_type"    : "client_credentials",
                                      "client_id"     : "EasternT",
                                      "client_secret" : "HiD0b1SGC+zEAPgXX5pxVA4r9MTcryBooO6nFFST+zA=",
                                      "scope"         : "http://api.microsofttranslator.com"]
    private let headers: HTTPHeaders = ["Content-Type" : "application/x-www-form-urlencoded"]

    static let sharedInstance = TokenManager()
    private init() {}

    func getToken() -> String? {
        return self.token
    }

    func refreshToken() {
        let timer = Timer.scheduledTimer(withTimeInterval: 500, repeats: true) { timer in
            Alamofire.request(self.tokenUrl,
                              method: .post,
                              parameters: self.params,
                              encoding: URLEncoding.httpBody,
                              headers: self.headers
            ).responseJSON { response in
                if let json = response.result.value as? [String : String] {
                    NSLog("Got token! \(json["access_token"])")
                    self.token = json["access_token"]
                } else {
                    NSLog("Mal-formed access token json: \(response.result.value)")
                }
            }
        }
        timer.fire()
    }
}

class NetworkManager {
    
    static let languageTypeStringMap = [LanguageType.chinese: "zh-CHS",
                                        LanguageType.english: "en",
                                        LanguageType.german: "de"]
    
    static let sharedInstance = NetworkManager()
    private init () {}

    func getTranslate(originText: String, from: LanguageType, to: LanguageType) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(TokenManager.sharedInstance.getToken()!)"
        ]
        
        let params: Parameters = ["text": originText,
                                               "from": NetworkManager.languageTypeStringMap[from]!,
                                               "to": NetworkManager.languageTypeStringMap[to]!]
        
        let url = "https://api.microsofttranslator.com/v2/Http.svc/Translate?"

        Alamofire.request(url,
                          method: .get,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: headers).responseString { response in
                            if let data = response.data,
                                let str = String(data: data, encoding: .utf8),
                                let result = self.parseTranslationXML(string: str) {
                                    NSLog("The translated result is: \(result)")
                            } else {
                                NSLog("Could not parse server translation data")
                            }
        }
    }

    private func parseTranslationXML(string: String) -> String? {
        let regex = try! NSRegularExpression(pattern: "<string xmlns=\"http://schemas.microsoft.com/2003/10/Serialization/\">(.*)</string>")
        let match = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))[0]
        return (string as NSString).substring(with: match.rangeAt(1))
    }
    
}
