//
//  StatisticsViewModel.swift
//  MyVagon
//
//  Created by Tej P on 18/02/22.
//

import Foundation

import Foundation

class StatisticsViewModel {
    
    weak var VC : StatisticsOneVC? = nil
    
    func WebServiceForStatiscticList(ReqModel:StatisticListReqModel){
        WebServiceSubClass.StatisticListAPI(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            self.VC?.isTblReload = true
            self.VC?.isLoading = false
            DispatchQueue.main.async {
                self.VC?.refreshControl.endRefreshing()
            }
            if status{
                self.VC?.arrData = response?.data ?? []
                self.VC?.tblStatistics.reloadData()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
