//
//  EditTruckViewModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 16/03/22.
//

import Foundation
import UIKit

class EditTruckViewModel{
    var registerTruckListVC : RegisterTruckListVC?
    
    func callWebserviceForEditTruck(reqModel: EditTruckReqModel){
        Utilities.ShowLoaderButtonInButton(Button: registerTruckListVC?.btnContinue ?? themeButton(), vc: registerTruckListVC ?? UIViewController())
        WebServiceSubClass.editTruckDetail(reqModel: reqModel) { status, apiMessage, response, error in
            Utilities.HideLoaderButtonInButton(Button: self.registerTruckListVC?.btnContinue ?? themeButton(), vc: self.registerTruckListVC ?? UIViewController())
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
