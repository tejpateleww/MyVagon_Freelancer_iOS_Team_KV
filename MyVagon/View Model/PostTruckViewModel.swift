//
//  PostTruckViewModel.swift
//  MyVagon
//
//  Created by Apple on 19/08/21.
//

import Foundation
import UIKit
class PostTruckViewModel {
    weak var postTruckViewController : PostTruckViewController? = nil
    
    func PostAvailability(ReqModel:PostTruckReqModel){
        Utilities.ShowLoaderButtonInButton(Button: self.postTruckViewController?.BtnPostATruck ?? themeButton(), vc: self.postTruckViewController ?? UIViewController())
       
        
        WebServiceSubClass.PostTruck(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.postTruckViewController?.BtnPostATruck ?? themeButton(), vc: self.postTruckViewController ?? UIViewController())
            
            if status {
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                appDel.NavigateToHome()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
