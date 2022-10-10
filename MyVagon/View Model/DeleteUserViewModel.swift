//
//  DeleteUserViewModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 04/07/22.
//

import Foundation
class DeleteUserViewModel{
    
    func callWebServiceToDeleteUser(reqModel: DeleteUserReqModel){
        WebServiceSubClass.deleteUser(reqModel: reqModel) { (status, apiMessage, response, error) in
            if status {
                appDel.Logout()
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        }
    }
    
}
