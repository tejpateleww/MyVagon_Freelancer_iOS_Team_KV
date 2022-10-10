//
//  LocationSessionManager.swift
//  MyVagon
//
//  Created by Apple on 29/09/21.
//

import Foundation
import CoreLocation
import GoogleMaps

class SessionManager {
    let GOOGLE_DIRECTIONS_API_KEY = AppInfo.Google_API_Key
  

    func requestDirections(from start: CLLocationCoordinate2D, to end: [CLLocationCoordinate2D], completionHandler: @escaping ((_ response: GMSPath?, _ error: Error?) -> Void)) {
        
        guard let destination = end.last else {
            return
        }
        var wayPoints = ""
        for (index, point) in end.enumerated() {
            if index == 0 { // Skipping first location that is current location.
                            }
            wayPoints = wayPoints.count == 0 ? "\(point.latitude),\(point.longitude)" : "\(wayPoints)%7C\(point.latitude),\(point.longitude)"
        }
      
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(start.latitude),\(start.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&waypoints=\(wayPoints)&key=\(GOOGLE_DIRECTIONS_API_KEY)") else {
            let error = NSError(domain: "LocalDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create object URL"])
            print("Error: \(error)")
            completionHandler(nil, error)
            return
        }

        // Set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: url) { (data, response, error) in
            // Check if there is an error.
            guard error == nil else {
                DispatchQueue.main.async {
                    print("Google Directions Request Error: \((error!)).")
                    completionHandler(nil, error)
                }
                return
            }

            // Make sure data was received.
            guard let data = data else {
                DispatchQueue.main.async {
                    let error = NSError(domain: "GoogleDirectionsRequest", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to receive data"])
                    print("Error: \(error).")
                    completionHandler(nil, error)
                }
                return
            }

            do {
                // Convert data to dictionary.
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    DispatchQueue.main.async {
                        let error = NSError(domain: "GoogleDirectionsRequest", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to convert JSON to Dictionary"])
                        print("Error: \(error).")
                        completionHandler(nil, error)
                    }
                    return
                }

                // Check if the the Google Direction API returned a status OK response.
                guard let status: String = json["status"] as? String, status == "OK" else {
                    print(json["error_message"] as Any)
                    DispatchQueue.main.async {
                        let error = NSError(domain: "GoogleDirectionsRequest", code: 3, userInfo: [NSLocalizedDescriptionKey: "Google Direction API did not return status OK"])
                        print("Error: \(error).")
                        completionHandler(nil, error)
                    }
                    return
                }

                print("Google Direction API response:\n\(json)")

                // We only need the 'points' key of the json dictionary that resides within.
                if let routes: [Any] = json["routes"] as? [Any], routes.count > 0, let routes0: [String: Any] = routes[0] as? [String: Any], let overviewPolyline: [String: Any] = routes0["overview_polyline"] as? [String: Any], let points: String = overviewPolyline["points"] as? String {
                    // We need the get the first object of the routes array (route0), then route0's overview_polyline and finally overview_polyline's points object.
                    
                   
                    
                    if let path: GMSPath = GMSPath(fromEncodedPath: points) {
                        DispatchQueue.main.async {
//                            let polyLine = GMSPolyline(path: path)
//                            let newTempURL = "http://maps.google.com/maps/api/staticmap?markers=colro:blue|\(23.064263),\(72.518253)&\("size=\(2 * Int(1000))x\(2 * Int(500))")&     path=weight:2|color:orange|enc:\(path)&key=\(self.GOOGLE_DIRECTIONS_API_KEY)"
//                            print("ATDebug :: newTempURL of MAP \(newTempURL)")
//                            print("ATDebug :: path for \(points)")
//                            print("ATDebug :: polyLine for \(polyLine)")
//                            let TempUrl = "http://maps.google.com/maps/api/staticmap?markers=\(start.latitude),\(start.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&waypoints=\(wayPoints)&\("zoom=5&size=\(2 * Int(1000))x\(2 * Int(500))")&key=\(self.GOOGLE_DIRECTIONS_API_KEY)"
//                            print("ATDebug :: TempURL of MAP \(TempUrl)")
                            
                            completionHandler(path, nil)
                        }
                        return
                    } else {
                        DispatchQueue.main.async {
                            let error = NSError(domain: "GoogleDirections", code: 5, userInfo: [NSLocalizedDescriptionKey: "Failed to create GMSPath from encoded points string."])
                            completionHandler(nil, error)
                        }
                        return
                    }

                } else {
                    DispatchQueue.main.async {
                        let error = NSError(domain: "GoogleDirections", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to parse overview polyline's points"])
                        completionHandler(nil, error)
                    }
                    return
                }


            } catch let error as NSError  {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }

        }

        task.resume()
    }
}
