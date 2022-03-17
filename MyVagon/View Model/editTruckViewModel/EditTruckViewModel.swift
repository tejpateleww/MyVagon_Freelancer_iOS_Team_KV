//
//  EditTruckViewModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 16/03/22.
//

import Foundation
class EditTruckViewModel{
    func callWebserviceForEditTruck(reqModel: EditTruckReqModel){
        WebServiceSubClass.editTruckDetail(reqModel: reqModel) { status, apiMessage, response, error in
            if status{
                AppDelegate.shared.Logout()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                }
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        }
    }
}
