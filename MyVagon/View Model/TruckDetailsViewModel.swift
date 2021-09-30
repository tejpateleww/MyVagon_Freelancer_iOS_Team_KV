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
                print("ATDebug :: \(response?.data?.images?.count ?? 0)")
                response?.data?.images?.forEach({ element in
                    self.TruckDetail?.arrImages.append(element)
                })
                self.TruckDetail?.collectionImages.reloadData()
              
            }
        })
    }
}
