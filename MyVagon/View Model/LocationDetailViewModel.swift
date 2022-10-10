//
//  LocationDetailViewModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 14/03/22.
//

import Foundation
class LocationDetailViewModel{
    var locationDetailVC : SearchLocationVC? = nil
    
    func callWebServiceForLocationDetail(){
        Utilities.showHud()
        WebServiceSubClass.LocationDetail(locationID: locationDetailVC?.locationId ?? "") { Status, apiMessage, response, error in
            Utilities.hideHud()
            if Status{
                self.locationDetailVC?.responceData = response
                self.locationDetailVC?.refressData()
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        }
    }
}
