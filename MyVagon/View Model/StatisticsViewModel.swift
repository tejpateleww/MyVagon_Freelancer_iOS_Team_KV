//
//  StatisticsViewModel.swift
//  MyVagon
//
//  Created by Tej P on 18/02/22.
//

import Foundation

import UIKit

class StatisticsViewModel {
    
    weak var VC : StatisticsVC? = nil
    
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

class PaymentViewModel {
    
    weak var VC : PaymentsVC? = nil
    
    func WebServiceForPaymentDeatilList(){
        Utilities.showHud()
        WebServiceSubClass.getPaymentDeatilAPI(completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                //Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                self.VC?.paymentDetailData = response?.data
                self.VC?.setupDataAfterAPI()
                
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func WebServiceForPaymentDeatilUpdate(ReqModel:PaymentDetailUpdateReqModel){
        Utilities.ShowLoaderButtonInButton(Button: VC?.btnSave ?? themeButton(), vc: VC ?? UIViewController())
        WebServiceSubClass.updatePaymentDetail(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.VC?.btnSave ?? themeButton(), vc: self.VC ?? UIViewController())
            if status{
                appDel.Logout()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                }
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
