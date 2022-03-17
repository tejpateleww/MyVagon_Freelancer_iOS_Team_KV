//
//  EditTractorViewModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 16/03/22.
//

import Foundation
class EditTractorDetailViewModel{
    
    func callwebservice(reqModel: EditTractorDetailReqModel){
        WebServiceSubClass.editTractorDetail(reqModel: reqModel) {(status, apiMessage, response, error) in
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
