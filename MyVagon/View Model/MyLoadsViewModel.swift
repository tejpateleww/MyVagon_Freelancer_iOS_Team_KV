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
        self.scheduleViewController?.isNeedToReload = false
        
        WebServiceSubClass.GetMyLoadesList(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            
            self.scheduleViewController?.refreshControl.endRefreshing()
            if status{
                
                let numberOfCount = response?.data?.count ?? 0
                
                if ReqModel.page_num == "1" {
                    let tempArrHomeData = response?.data ?? []
                     var datesArray = tempArrHomeData.compactMap({$0.date})
                  
                    datesArray = datesArray.uniqued()
                    // let datesArray = self.MainSessionListArray.compactMap { $0.bookingDate} // return array of date
                    var dic = [[MyLoadsNewDatum]]() // Your required result
                    
                    datesArray.forEach { (element) in
                        
                        let NewDictonary =  tempArrHomeData.filter({$0.date == element})
                        
                        
                        dic.append(NewDictonary)
                    }
                    self.scheduleViewController?.arrMyLoadesData = dic
                    
                } else {
                    var tempArrHomeData = [MyLoadsNewDatum]()
                    self.scheduleViewController?.arrMyLoadesData?.forEach({ element in
                        tempArrHomeData.append(contentsOf: element)
                    })
                     
                    tempArrHomeData.append(contentsOf: response?.data ?? [])
                   
                    var datesArray = tempArrHomeData.compactMap({$0.date})
                  
                    datesArray = datesArray.uniqued()
                    
                    var dic = [[MyLoadsNewDatum]]() // Your required result
                    
                    datesArray.forEach { (element) in
                        
                        let NewDictonary =  tempArrHomeData.filter({$0.date == element})
                        
                        
                        dic.append(NewDictonary)
                    }
                    self.scheduleViewController?.arrMyLoadesData = dic
                    
                   
                }
                self.scheduleViewController?.isLoading = false
                self.scheduleViewController?.tblLocations.tableFooterView?.isHidden = true
                
                
                
                self.scheduleViewController?.tblLocations.reloadDataWithAutoSizingCellWorkAround()
                
                if numberOfCount == PageLimit {
                    self.scheduleViewController?.isNeedToReload = true
                }
                else {
                    self.scheduleViewController?.isNeedToReload = false
                }
                
            } else {
                self.scheduleViewController?.isLoading = false
                self.scheduleViewController?.tblLocations.tableFooterView?.isHidden = true
                
                
                
                self.scheduleViewController?.tblLocations.reloadDataWithAutoSizingCellWorkAround()
                
                    Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
                
            }
        })
    }
    func GetSystemDate(){
        WebServiceSubClass.SystemDateTime{_, _, _, _ in}
    }
  
    
}
