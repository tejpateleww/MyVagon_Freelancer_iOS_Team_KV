//
//  MyLoadsViewModel.swift
//  MyVagon
//
//  Created by Apple on 06/10/21.
//

import Foundation
import UIKit
class MyLoadsViewModel {
    weak var scheduleViewController : ScheduleViewController? = nil
    
    func getMyloads(ReqModel:MyLoadsReqModel){
        WebServiceSubClass.GetMyLoadesList(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            
            self.scheduleViewController?.refreshControl.endRefreshing()
            if status{
               
                self.scheduleViewController?.arrMyLoadesData = response?.data
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.scheduleViewController?.isLoading = false
                }
                self.scheduleViewController?.tblLocations.reloadDataWithAutoSizingCellWorkAround()
               
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }

    
}
