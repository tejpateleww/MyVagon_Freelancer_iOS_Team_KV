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
            DispatchQueue.main.async {
                self.myEarningVC?.refreshControl.endRefreshing()
            }
            self.myEarningVC?.isTblReload = true
            self.myEarningVC?.isLoading = false
            if status{
                self.myEarningVC?.arrData = response?.data ?? []
                self.myEarningVC?.tblEarning.reloadDataWithAutoSizingCellWorkAround()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
