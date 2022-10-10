//
//  TrackingSocket.swift
//  MyVagon
//
//  Created by Tej P on 24/05/22.
//

import Foundation
import UIKit

extension TrackingVC {
    
    func SocketOnMethods() {
        
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
        }
        
        //Connect User On Socket
        SocketIOManager.shared.establishConnection()
        print("==============\(SocketIOManager.shared.socket.status)=====================",SocketIOManager.shared.socket.status.active)
    
    }
    
    func allSocketOffMethods() {
        print("\n\n", #function, "\n\n")
        SocketIOManager.shared.socket.off(socketApiKeys.updateLocation.rawValue)
    }
    
    func emitSocket_UpdateLocation(lat:Double,long:Double){
        let params = ["pickup_lat" : "\(lat)",
                      "pickup_lng" : "\(long)",
                      "lat" : "\(appDel.locationManager.CurrentLocation?.coordinate.latitude ?? 0.0)",
                      "lng" : "\(appDel.locationManager.CurrentLocation?.coordinate.longitude ?? 0.0)",
                      "driver_id" : "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)",
                      "shipper_id" : self.TripDetails?.shipperDetails?.id ?? 0] as [String : Any]
        SocketIOManager.shared.socketEmit(for: socketApiKeys.updateLocation.rawValue , with: params)
    }
}
