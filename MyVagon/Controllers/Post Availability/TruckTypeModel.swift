//
//  TruckTypeModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 22/06/22.
//

import Foundation
class TruckTypeModel : NSObject {
    var truckData : TruckSubCategory?
    var isSelected : Bool!
    
     init(TruckData:TruckSubCategory,IsSelected:Bool) {
        self.truckData = TruckData
        self.isSelected = IsSelected
    }
}
