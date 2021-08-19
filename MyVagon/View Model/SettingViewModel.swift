//
//  SettingViewModel.swift
//  MyVagon
//
//  Created by Apple on 19/08/21.
//

import Foundation
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
}
