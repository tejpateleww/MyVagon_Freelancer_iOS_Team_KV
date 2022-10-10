//
//  SettingViewModel.swift
//  MyVagon
//
//  Created by Apple on 19/08/21.
//

import Foundation
class SettingViewModel {
    weak var settingVC : SettingVC? = nil
    func UpdateSetting(ReqModel:EditSettingsReqModel){
        Utilities.showHud()
        WebServiceSubClass.updateSetting(reqModel: ReqModel) { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                self.settingVC?.arrNotification = response
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
            self.settingVC?.tblSettings.reloadData()
        }
    }
    
    func GetSettingList(ReqModel:GetSettingReqModel){
        Utilities.showHud()
        WebServiceSubClass.getSetting(reqModel: ReqModel) { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                self.settingVC?.arrNotification = response
                self.settingVC?.tblSettings.reloadData()
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        }
    }
}
