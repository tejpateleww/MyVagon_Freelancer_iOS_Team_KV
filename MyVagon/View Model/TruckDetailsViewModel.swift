//
//  RegisterViewModel.swift
//  MyVagon
//
//  Created by Apple on 04/08/21.
//

import Foundation
import UIKit
class TruckDetailsViewModel {
    
    weak var TruckDetail : TruckDetailVC? = nil
    
    func WebServiceImageUpload(images:[UIImage]){
        Utilities.showHud()
        WebServiceSubClass.ImageUpload(imgArr: images, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
               
                response?.data?.images?.forEach({ element in
                    self.TruckDetail?.arrImages.append(element)
                })
                self.TruckDetail?.collectionImages.reloadData()
              
            }
        })
    }
}

class AddTruckViewModel{
    
    weak var TruckDetail : AddTruckVC? = nil
    
    func WebServiceImageUpload(images:[UIImage]){
        Utilities.showHud()
        WebServiceSubClass.ImageUpload(imgArr: images, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
               
                response?.data?.images?.forEach({ element in
                    self.TruckDetail?.arrImages.append(element)
                })
                self.TruckDetail?.collectionImages.reloadData()
                self.TruckDetail?.heightConstrentImagcollection.constant = (self.TruckDetail?.collectionImages.bounds.width ?? 0) / 3 - 10
              
            }
        })
    }
    
    func webServiceForAddTruck(reqModel: AddTruckReqModel){
        Utilities.ShowLoaderButtonInButton(Button: TruckDetail?.btnSave ?? themeButton(), vc: TruckDetail ?? UIViewController())
        WebServiceSubClass.addTruck(reqModel: reqModel) { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.TruckDetail?.btnSave ?? themeButton(), vc: self.TruckDetail ?? UIViewController())
            if status{
                AppDelegate.shared.Logout()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                }
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        }
    }
    
}

class TractorDetailViewModel{
    
    weak var TruckDetail : TractorDetailVC? = nil
    
    func WebServiceImageUpload(images:[UIImage]){
        Utilities.showHud()
        WebServiceSubClass.ImageUpload(imgArr: images, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
               
                response?.data?.images?.forEach({ element in
                    self.TruckDetail?.arrImages.append(element)
                })
                self.TruckDetail?.collectionImages.reloadData()
                self.TruckDetail?.heightConstrentImagcollection.constant = (self.TruckDetail?.collectionImages.bounds.width ?? 0) / 3 - 10
              
            }
        })
    }
}
