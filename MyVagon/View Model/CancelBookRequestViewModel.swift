//
//  CancelBookRequestViewModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 28/03/22.
//

import Foundation
import UIKit

class CancelBookRequestViewModel {
    
    var reasoneVC : PostedTruckCancelReqVC?
    func callwebServiceForDeclineBook(req: CancelBookRequestReqModel){
        Utilities.ShowLoaderButtonInButton(Button: self.reasoneVC?.btnDecline ?? themeButton(), vc:reasoneVC  ?? UIViewController())
        WebServiceSubClass.declineLoad(reqModel: req) { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.reasoneVC?.btnDecline ?? themeButton(), vc: self.reasoneVC ?? UIViewController())
            if status{
                self.reasoneVC?.dismiss(animated: true, completion: nil)
                appDel.NavigateToSchedual()
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        }
    }
}
