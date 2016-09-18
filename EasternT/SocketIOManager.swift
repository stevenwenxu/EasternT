//
//  SocketIOManager.swift
//  SocketChat
//
//  Created by Gabriel Theodoropoulos on 1/31/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    func getConnected() {
        let socket = SocketIOClient(socketURL: URL(string: "https://easternt-3a493.firebaseapp.com")!, config: [.log(true), .forcePolling(true)])
        
        socket.on("connect") {data, ack in
            print("socket connected")
        }
        
        socket.on("currentAmount") {data, ack in
            if let cur = data[0] as? Double {
                socket.emitWithAck("canUpdate", cur)(0) {data in
                    socket.emit("update", ["amount": cur + 2.50])
                }
                
                ack.with("Got your currentAmount", "dude")
            }
        }
        
        socket.connect()

    }
    
}
