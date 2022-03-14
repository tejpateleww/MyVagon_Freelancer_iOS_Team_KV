//
//  LocationDetailViewModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 14/03/22.
//

import Foundation
class LocationDetailViewModel{
    var locationDetailVC : LocationDetailVC? = nil
    
    func callWebServiceForLocationDetail(){
     
        WebServiceSubClass.LocationDetail(locationID: locationDetailVC?.locationId ?? "") { Status, apiMessage, response, error in
            if Status{
                self.locationDetailVC?.responceData = response
                self.locationDetailVC?.refressData()
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        }
    }
}
