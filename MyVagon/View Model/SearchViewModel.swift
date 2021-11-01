//
//  SearchViewModel.swift
//  MyVagon
//
//  Created by Apple on 26/10/21.
//

import Foundation
import UIKit
class SearchViewModel {
    weak var searchOptionViewController : SearchOptionViewController? = nil
    weak var homeViewController : HomeViewController? = nil
    func SearchShipment(ReqModel:SearchLoadReqModel){
        Utilities.ShowLoaderButtonInButton(Button: searchOptionViewController?.btnSearchLoad ?? themeButton(), vc: searchOptionViewController ?? UIViewController())
      
        WebServiceSubClass.SearchShipment(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.searchOptionViewController?.btnSearchLoad ?? themeButton(), vc: self.searchOptionViewController ?? UIViewController())
            
            if status {
                self.searchOptionViewController?.navigationController?.popViewController(animated: true)
                self.homeViewController?.arrHomeData = response?.data
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    self.homeViewController?.isLoading = false
                }
                self.homeViewController?.tblLocations.reloadDataWithAutoSizingCellWorkAround()
                
               // self.homeViewController?.tblLocations.reloadData()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}

