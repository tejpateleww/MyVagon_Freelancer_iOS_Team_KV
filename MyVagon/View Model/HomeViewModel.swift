//
//  HomeViewModel.swift
//  MyVagon
//
//  Created by Apple on 16/09/21.
//

import Foundation
import UIKit

class NewHomeViewModel {
    weak var newHomeVC : SearchVC? = nil
    
    func WebServiceSearchList(ReqModel:ShipmentListReqModel){
        
        self.newHomeVC?.isApiProcessing = true
        WebServiceSubClass.GetShipmentList(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            self.newHomeVC?.isApiProcessing = false
            DispatchQueue.main.async {
                self.newHomeVC?.refreshControl.endRefreshing()
            }
            self.newHomeVC?.isTblReload = true
            self.newHomeVC?.self.isLoading = false
//            self.newHomeVC?.sortBy = ""
            if status{
                if(self.newHomeVC?.self.isFilter ?? false == true){
                    if(response?.data?.count == 0){
                        if(self.newHomeVC?.PageNumber == 1){
                            self.newHomeVC?.arrFilterHomeData = response?.data ?? []
                        }else{
                            self.newHomeVC?.isStopPaging = true
                            return
                        }
                    }else{
                        if(self.newHomeVC?.PageNumber == 1){
                            self.newHomeVC?.arrFilterHomeData = response?.data ?? []
                        }else{
                            self.newHomeVC?.arrFilterHomeData.append(contentsOf: response?.data ?? [])
                        }
                    }
                    self.newHomeVC?.tblSearchData.reloadData()
                    self.newHomeVC?.tblSearchData.layoutIfNeeded()
                    self.newHomeVC?.tblSearchData.beginUpdates()
                    self.newHomeVC?.tblSearchData.endUpdates()
                    return
                }
                if(response?.data?.count == 0){
                    if(self.newHomeVC?.PageNumber == 1){
                        let tempArrHomeData = response?.data ?? []
                        var datesArray = tempArrHomeData.compactMap({$0.date})
                        datesArray = datesArray.uniqued()
                        self.newHomeVC?.numberOfSections = datesArray.count
                        var dic = [[SearchLoadsDatum]]() // Your required result
                        datesArray.forEach { (element) in
                            let NewDictonary =  tempArrHomeData.filter({$0.date == element})
                            dic.append(NewDictonary)
                        }
                        self.newHomeVC?.arrHomeData = dic
                    }else{
                        self.newHomeVC?.isStopPaging = true
                        return
                    }
                }else{
                    if(self.newHomeVC?.PageNumber == 1){
                        let tempArrHomeData = response?.data ?? []
                        var datesArray = tempArrHomeData.compactMap({$0.date})
                        datesArray = datesArray.uniqued()
                        self.newHomeVC?.numberOfSections = datesArray.count
                        var dic = [[SearchLoadsDatum]]() // Your required result
                        datesArray.forEach { (element) in
                            let NewDictonary =  tempArrHomeData.filter({$0.date == element})
                            dic.append(NewDictonary)
                        }
                        self.newHomeVC?.arrHomeData = dic
                    }else{
                        var tempArrHomeData = [SearchLoadsDatum]()
                        self.newHomeVC?.arrHomeData?.forEach({ element in
                            tempArrHomeData.append(contentsOf: element)
                        })
                        tempArrHomeData.append(contentsOf: response?.data ?? [])
                        var datesArray = tempArrHomeData.compactMap({$0.date})
                        datesArray = datesArray.uniqued()
                        var dic = [[SearchLoadsDatum]]() // Your required result
                        datesArray.forEach { (element) in
                            let NewDictonary =  tempArrHomeData.filter({$0.date == element})
                            dic.append(NewDictonary)
                        }
                        self.newHomeVC?.arrHomeData = dic
                    }
                }
                
                self.newHomeVC?.tblSearchData.reloadData()
                self.newHomeVC?.tblSearchData.layoutIfNeeded()
                self.newHomeVC?.tblSearchData.beginUpdates()
                self.newHomeVC?.tblSearchData.endUpdates()
                
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    
    func GetLoadDetails(ReqModel:LoadDetailsReqModel) {
        Utilities.showHud()
        WebServiceSubClass.LoadDetails(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status {
                self.newHomeVC?.gotoNewScheduleDetail(tripdata: (response?.data)!)
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}


