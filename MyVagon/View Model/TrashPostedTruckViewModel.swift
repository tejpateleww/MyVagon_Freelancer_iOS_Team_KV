//
//  TrashPostedTruckViewModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 06/04/22.
//

import Foundation
class TrashPostedTruckViewModel{
    
    var newScheduleVC : NewScheduleVC?
    func webServiceToDelatePostedTruck(req: TrashPostedTruck){
        Utilities.showHud()
        WebServiceSubClass.trashPostedTruck(reqModel: req, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                self.newScheduleVC?.reloadSearchData()
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
