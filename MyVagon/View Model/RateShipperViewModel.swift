//
//  RateShipperViewModel.swift
//  MyVagon
//
//  Created by Apple on 28/12/21.
//

import Foundation
import UIKit
class RateShipperViewModel {
    weak var reviewShipperVC : ReviewShipperVC? = nil
    
    func WebServiceForRate(ReqModel:RateReviewReqModel){
        Utilities.ShowLoaderButtonInButton(Button: reviewShipperVC?.btnRate ?? themeButton(), vc: reviewShipperVC ?? UIViewController())
        WebServiceSubClass.RateShipper(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.reviewShipperVC?.btnRate ?? themeButton(), vc: self.reviewShipperVC ?? UIViewController())
            if status{
                self.reviewShipperVC?.navigationController?.popToRootViewController(animated: true)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }

    
}
