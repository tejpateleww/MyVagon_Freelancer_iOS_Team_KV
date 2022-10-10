//
//  TruckCapacityType.swift
//  MyVagon
//
//  Created by Dhanajay  on 23/06/22.
//

import UIKit
class TruckCapacityType : Codable   {
    var capacity:String?
    var type:Int?
    
    init(Capacity:String,Type:Int) {
        self.capacity = Capacity
        self.type = Type
    }
    
    private enum CodingKeys : String, CodingKey {
        case capacity = "value", type = "id"
    }
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if capacity != nil{
            dictionary["value"] = capacity
        }
        if type != nil{
            dictionary["id"] = type
        }
        return dictionary
    }
    
    class func ConvetToDictonary(arrayDataCart : [TruckCapacityType]) -> [[String:Any]] {
        var arrayDataDictionaries : [[String:Any]] = []
        for objDataCart in arrayDataCart {
            print(objDataCart)
            
            arrayDataDictionaries.append(objDataCart.toDictionary());
        }
        return arrayDataDictionaries
    }
}
