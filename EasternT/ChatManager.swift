//
//  ChatManager.swift
//  EasternT
//
//  Created by Calvin Zhou on 2016-09-17.
//  Copyright © 2016 EasternT. All rights reserved.
//

import Foundation
import Quickblox

class ChatManager : NSObject, QBChatDelegate {
    
    func signupUser(userLogin: String, password: String) -> Void {
        let user = QBUUser()
        user.login = userLogin
        user.password = password
        QBRequest.signUp(user, successBlock: { (response, user) in
            print("successfully signup")
            }) { (response) in
               NSLog("Error: %@", response);
        }
    }
    
    func loginUser(userLogin: String, password:String) ->Void {
        let user = QBUUser()
        user.login = userLogin
        user.password = password
        QBRequest.logIn(withUserLogin: userLogin, password: password, successBlock: { (repsonse, user) in
            print("succeed login")
            }) { (response) in
                print("failed login")
                print("error", response)
        }
    }

    func disconnectUser() -> Void {
        if QBChat.instance().isConnected {
            QBChat.instance().disconnect(completionBlock: { (error) in
                print("Error in disconnecting Users", error)
            })
        }
    }
    
    func connectUser(user:QBUUser) -> Void {
        if (!QBChat.instance().isConnected) {
            QBChat.instance().connect(with: user) { (error) in
                print("why why why I don't understand " + error.debugDescription)
            }
        }

    }
    
    func createChatDialogAndSendMessage(dialogName: String, messageText: String, userIds: [NSNumber])->Void {
        let chatDialog = QBChatDialog(dialogID: nil, type: QBChatDialogType.group)
        chatDialog.name = dialogName
        chatDialog.occupantIDs = userIds
        QBRequest.createDialog(chatDialog, successBlock: { (response: QBResponse?, createdDialog : QBChatDialog?) -> Void in
            print("fuck yell")
            chatDialog.join(completionBlock: { (error) in
                print("fail to join the chat " + error.debugDescription)
            })
            let message: QBChatMessage = QBChatMessage()
            message.text = messageText
            let params : NSMutableDictionary = NSMutableDictionary()
            params["save_to_history"] = true
            message.customParameters = params
            chatDialog.occupantIDs?.forEach({ (occupantID) in
                message.recipientID = occupantID.uintValue
            })
            chatDialog.send(message, completionBlock: { (error) in
                print("Sending message in sendMessage method " + message.text! + error.debugDescription)
            });
        }) { (responce : QBResponse!) -> Void in
            print("error", responce)
        }
        
        QBChat.instance().addDelegate(self)

        
    }
    
    func chatRoomDidReceiveMessage(message: QBChatMessage!, fromDialogID dialogID: String!) {
        
    }
}
    
