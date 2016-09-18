//
//  SocketIOManager.swift
//  EasternT
//
//  Created by Calvin Zhou on 2016-09-18.
//  Copyright © 2016 EasternT. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManger : NSObject {
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
