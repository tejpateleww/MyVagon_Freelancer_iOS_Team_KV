//
//  MyLoadsViewModel.swift
//  MyVagon
//
//  Created by Apple on 06/10/21.
//

import Foundation
import UIKit

class MyScheduleViewModel {
    weak var scheduleViewController : NewScheduleVC? = nil
    
    func getMyloads(ReqModel:MyLoadsReqModel){
        
        WebServiceSubClass.GetMyLoadesList(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            let index = self.scheduleViewController?.displayOptionArray.firstIndex(of: self.scheduleViewController?.optionMenuDropDown.selectedItem ?? "")
            let type = self.scheduleViewController?.optionArray[index ?? 0].lowercased().replacingOccurrences(of: " ", with: "_")
            if self.scheduleViewController?.CurrentFilterStatus.Name == ReqModel.status && ReqModel.type == type{
                DispatchQueue.main.async {
                    self.scheduleViewController?.refreshControl.endRefreshing()
                }
                self.scheduleViewController?.isTblReload = true
                self.scheduleViewController?.isNeedToReload = false
                self.scheduleViewController?.tblScheduleData.tableFooterView?.isHidden = true
                if status{
                    if ReqModel.page_num == "1"{
                        self.scheduleViewController?.arrMyScheduleData = []
                    }
                    var tempArrHomeData = [MyLoadsNewDatum]()
                    self.scheduleViewController?.arrMyScheduleData?.forEach({ element in
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
                    self.scheduleViewController?.arrMyScheduleData = dic
                    self.scheduleViewController?.isLoading = false
                    self.scheduleViewController?.tblScheduleData.beginUpdates()
                    if response?.data?.count != 0 || ReqModel.page_num == "1"{
                        self.scheduleViewController?.tblScheduleData.reloadData()
                    }
                    self.scheduleViewController?.tblScheduleData.layoutIfNeeded()
                    self.scheduleViewController?.tblScheduleData.endUpdates()
                    if response?.data?.count != 0 {
                        self.scheduleViewController?.isNeedToReload = true
                    }else {
                        self.scheduleViewController?.isNeedToReload = false
                    }
                } else {
                    self.scheduleViewController?.isLoading = false
                    self.scheduleViewController?.tblScheduleData.reloadData()
                    Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
                }
            }
        })
    }
    func GetSystemDate(){
        WebServiceSubClass.SystemDateTime{_, _, _, _ in}
    }
}
