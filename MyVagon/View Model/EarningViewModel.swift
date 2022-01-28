//
//  EarningViewModel.swift
//  MyVagon
//
//  Created by Tej P on 28/01/22.
//

import Foundation

class EarningListViewModel {
    
    weak var myEarningVC : MyEarningVC? = nil
    
    func WebServiceEarningList(ReqModel:EarningReqModel){
        WebServiceSubClass.earningList(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            if status{
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
