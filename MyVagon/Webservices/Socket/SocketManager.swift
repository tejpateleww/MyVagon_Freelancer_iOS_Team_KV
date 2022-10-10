//
//  SocketManager.swift
//  Kuick
//
//  Created by Sj's iMac on 27/01/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

typealias CompletionBlock = ((JSON) -> ())?

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
 
    let manager = SocketManager(socketURL: URL(string: APIEnvironment.socketBaseURL)!, config: [.log(false), .compress,.connectParams(["x-api-key" : "password"])])
    
    lazy var socket = manager.defaultSocket
    
    var isSocketOn = false
    var isWaitingMessageDisplayed:Bool = false
    
    override private init() {
        super.init()
  
    }
    
    func establishConnection() {
        if self.isSocketOn == false {
            socketMethodsOns()
            socket.connect()
            
        }
        
    }
    func socketMethodsOns() {
        socket.on(clientEvent: .disconnect) { (data, ack) in
            
            print ("ATDebug :: SocketManager socket is disconnected")
           
        }
        socket.on(clientEvent: .statusChange) {data, ack in
            print("ATDebug :: SocketManager Status change: \(data)")
        }
        socket.on(clientEvent: .reconnect) { (data, ack) in
            print ("ATDebug :: SocketManager socket is reconnected")
           
        }
        
        socket.on(clientEvent: .connect) { data, ack in
            
            print ("ATDebug :: SocketManager socket is connected ")
          
            
            if !self.isSocketOn {
                self.isSocketOn = true
            }
            
        }
        socket.on(clientEvent: .error) { data, ack in
            print(data)
            print ("ATDebug :: SocketManager socket error \(data)")
        }
    }
    
    func closeConnection() {
        self.isSocketOn = false
//        socket.off(socketApiKeys.DriverUpdatedLocation.rawValue)
        socket.off(clientEvent: SocketClientEvent.connect)
        socket.off(clientEvent: SocketClientEvent.reconnect)
        socket.off(clientEvent: .disconnect)
        socket.disconnect()
    }
    
    func AllSocketOff() {

        socket.off(clientEvent: SocketClientEvent.connect)
        socket.off(clientEvent: SocketClientEvent.reconnect)
        socket.connect()
    }
    
    func socketCall(for key: String, completion: CompletionBlock = nil)
    {
        SocketIOManager.shared.socket.off(key)
        SocketIOManager.shared.socket.on(key, callback: { (data, ack) in
            let result = self.dataSerializationToJson(data: data)
            guard result.status else { return }
            if completion != nil { completion!(result.json) }
        })
    }
   
    func socketEmit(for key: String, with parameter: [String:Any]) {
        socket.emit(key, with: [parameter])
        print(" Socket Status : \(SocketIOManager.shared.socket.status)")
        print (" Parameter Emitted for key - \(key) :: \(parameter)")
    }
    
    func dataSerializationToJson(data: [Any],_ description : String = "") -> (status: Bool, json: JSON){
        let json = JSON(data)
//        print (description, ": \(json)")

        return (true, json)
    }
    
}
