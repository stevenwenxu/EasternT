//
//  SocketViewController.swift
//  EasternT
//
//  Created by Steven Xu on 2016-09-18.
//  Copyright © 2016 EasternT. All rights reserved.
//

import UIKit
import Starscream

class SocketViewController: RealTimeViewController, WebSocketDelegate {

    var socket: WebSocket?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.socket = WebSocket(url: URL(string: "ws://ubuntu1404-004.student.cs.uwaterloo.ca:5366")!)
        self.socket?.delegate = self
        socket?.connect()
    }

    func writeString(string: String) {
        self.socket?.write(string: self.toJSON(str: string))
    }

    func toJSON(str: String) -> String {
        let deviceName = UIDevice.current.identifierForVendor!.uuidString
        return "\(deviceName)\n\(str)"
    }

    func websocketDidConnect(_ socket: WebSocket) {
        NSLog("Socket connected")
    }

    func websocketDidDisconnect(_ socket: WebSocket, error: NSError?) {
        NSLog("socket disconnected")
    }

    func websocketDidReceiveMessage(_ socket: WebSocket, text: String) {
        NSLog("message: \(text)")
        let stringArr = text.components(separatedBy: "\n")
        if let deviceID = stringArr.first, let id = UIDevice.current.identifierForVendor?.uuidString {
            if deviceID != id {
                self.model.textToSpeech(text: stringArr.last!, languageType: self.languageTypeB)
            }
        }
    }

    func websocketDidReceiveData(_ socket: WebSocket, data: Data) {
        NSLog("data: something")
    }
}
