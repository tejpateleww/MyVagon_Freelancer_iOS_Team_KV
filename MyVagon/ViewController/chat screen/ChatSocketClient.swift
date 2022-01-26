//
//  ChatSocketClient.swift
//  HC Pro Doctor
//
//  Created by Apple on 06/04/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation
import SwiftyJSON

extension chatVC{
    
    //MARK:- Socket On All
    func ChatSocketOnMethods() {
        
        SocketIOManager.shared.socket.on(clientEvent: .disconnect) { (data, ack) in
            print ("socket is disconnected please reconnect")
            SocketIOManager.shared.isSocketOn = false
        }
        
        SocketIOManager.shared.socket.on(clientEvent: .reconnect) { (data, ack) in
            print ("socket is reconnected")
            SocketIOManager.shared.isSocketOn = true
        }
        
        print("===========\(SocketIOManager.shared.socket.status)========================",SocketIOManager.shared.socket.status.active)
        SocketIOManager.shared.socket.on(clientEvent: .connect) {data, ack in
            print ("socket connected")
            SocketIOManager.shared.isSocketOn = true
            self.ChatSocketOffMethods()
            self.allChatSocketOnMethods()
        }
        
        if(SocketIOManager.shared.socket.status == .connected){
            self.ChatSocketOffMethods()
            self.allChatSocketOnMethods()
        }
        
        SocketIOManager.shared.establishConnection()
        print("==============\(SocketIOManager.shared.socket.status)=====================",SocketIOManager.shared.socket.status.active)
    }
    
    //MARK:- Active Socket Methods
    func allChatSocketOnMethods() {
        onSocket_ReceiveMessage()
    }
    
    //MARK:- Deactive Socket Methods
    func ChatSocketOffMethods() {
        SocketIOManager.shared.socket.off(socketApiKeys.SendMessage.rawValue)
        SocketIOManager.shared.socket.off(socketApiKeys.ReceiverMessage.rawValue)
    }
    
    //MARK:- On Methods
    
    func onSocket_ReceiveMessage(){
        SocketIOManager.shared.socketCall(for: socketApiKeys.ReceiverMessage.rawValue) { (json) in
            print(#function, "\n ", json)
            let dict = json
            print(dict)
            self.callChatHistoryAPI()
            
//            let chatObj : chatHistoryDatum = chatHistoryDatum()
//            chatObj.id = dict["id"].stringValue
//            chatObj.bookingId = dict["booking_id"].stringValue
//            chatObj.message =  dict["message"].stringValue
//            chatObj.receiverId =  dict["receiver_id"].stringValue
//            chatObj.receiverType = dict["receiver_type"].stringValue
//            chatObj.senderId =  dict["sender_id"].stringValue
//            chatObj.senderType = dict["sender_type"].stringValue
//            chatObj.createdAt = dict["created_at"].stringValue
//
//            self.arrayChatHistory.append(chatObj)
//            self.filterArrayData(isFromDidLoad: true)
        }
    }
    
    //MARK:- Emit Methods
    func emitSocket_SendMessage(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.SendMessage.rawValue, with: param)
    }
    
    
}
