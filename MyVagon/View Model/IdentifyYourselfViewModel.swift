//
//  IdentifyYourselfViewModel.swift
//  MyVagon
//
//  Created by Apple on 04/08/21.
//

import Foundation
import UIKit
class IdentifyYourselfViewModel {
    weak var identifyYourselfVC : IdentifyYourselfVC? = nil
    
    func WebServiceImageUpload(images:[UIImage],uploadFor:DocumentType){
        Utilities.showHud()
        WebServiceSubClass.ImageUpload(imgArr: images, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                print("ATDebug :: \(response?.data?.images?.count ?? 0)")
                response?.data?.images?.forEach({ element in
                    if uploadFor == .IdentityProof {
                        
                        SingletonClass.sharedInstance.RegisterData.Reg_id_proof = response?.data?.images ?? []
                    } else if uploadFor == .Licence {
                        SingletonClass.sharedInstance.RegisterData.Reg_license = response?.data?.images ?? []
                    }
                    
                })
               
              
            } else {
                if uploadFor == .IdentityProof {
                    self.identifyYourselfVC?.ImageViewIdentity = nil
                } else if uploadFor == .Licence {
                    self.identifyYourselfVC?.ImageViewLicence = nil
                } 
            }
        })
    }
    
}
enum DocumentType {
    case IdentityProof
    case Licence
    case Vehicle
    case Profile
}
