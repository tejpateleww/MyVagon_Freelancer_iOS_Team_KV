//
//  SettingViewModel.swift
//  MyVagon
//
//  Created by Apple on 19/08/21.
//

import Foundation
class SettingViewModel {
    weak var settingVC : SettingVC? = nil
    
    func UpdateSetting(ReqModel:SettingsReqModel){
       
        Utilities.showHud()
        WebServiceSubClass.Settings(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status {
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                self.settingVC?.navigationController?.popViewController(animated: true)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func GetSettingList(ReqModel:GetSettingsListReqModel){
       
        Utilities.showHud()
        WebServiceSubClass.GetSettings(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status {
                
                
                self.settingVC?.arrNotification = [NotificationList(Title: "General Notifications", Details: [NotificationData(Title: NotificationTitle.AllNotification.Name,IsSelect: (response?.data?.notification == 0) ? false : true),
                    NotificationData(Title: NotificationTitle.Messages.Name, IsSelect: (response?.data?.message == 0) ? false : true)]),
                    NotificationList(Title: "Load Notifications", Details: [NotificationData(Title: "Bid received", IsSelect: (response?.data?.bidReceived == 0) ? false : true),
                                                              NotificationData(Title: NotificationTitle.Bidaccepted.Name, IsSelect: (response?.data?.bidAccepted == 0) ? false : true),
                                                              NotificationData(Title: NotificationTitle.Loadsassignedbydispacter.Name, IsSelect: (response?.data?.loadAssignByDispatcher == 0) ? false : true),
                                                              NotificationData(Title: NotificationTitle.Starttripreminder.Name, IsSelect: (response?.data?.startTripReminder == 0) ? false : true),
                                                              NotificationData(Title: NotificationTitle.Completetripreminder.Name, IsSelect: (response?.data?.completeTripReminder == 0) ? false : true),
                                                              NotificationData(Title: NotificationTitle.PODreminder.Name, IsSelect: (response?.data?.pdoRemider == 0) ? false : true),
                                                              NotificationData(Title: NotificationTitle.Matcheswithshipmentnearyou.Name, IsSelect: (response?.data?.matchShippmentNearYou == 0) ? false : true),
                                                              NotificationData(Title: NotificationTitle.Matcheswithshipmentnearlastdeliverypoint.Name, IsSelect: (response?.data?.matchShippmentNearDelivery == 0) ? false : true),
                                                              NotificationData(Title: NotificationTitle.RateShipper.Name, IsSelect: (response?.data?.rateShipper == 0) ? false : true)])]
                
                
             
                
                self.settingVC?.tblSettings.reloadData()
              
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
