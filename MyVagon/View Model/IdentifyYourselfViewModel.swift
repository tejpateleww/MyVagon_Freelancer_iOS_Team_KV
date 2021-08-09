//
//  IdentifyYourselfViewModel.swift
//  MyVagon
//
//  Created by Apple on 04/08/21.
//

import Foundation
class IdentifyYourselfViewModel {
    weak var identifyYourselfVC : IdentifyYourselfVC? = nil
    
    func WebServiceForUploadDocument(Docs:[UploadMediaModel],DocumentType:DocumentType){
        Utilities.showHud()
        WebServiceSubClass.DocumentUpload(Documents: Docs, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                if DocumentType == .IdentityProof {
                    
                    SingletonClass.sharedInstance.Reg_IdentityProofDocument = response?.data?.images ?? []
                } else if DocumentType == .Licence {
                    SingletonClass.sharedInstance.Reg_LicenceDocument = response?.data?.images ?? []
                }
                
            } else {
                if DocumentType == .IdentityProof {
                    
                    self.identifyYourselfVC?.identityProofTF.text = ""
                } else if DocumentType == .Licence {
                    self.identifyYourselfVC?.licenceTF.text = ""
                }
            }
            
            SingletonClass.sharedInstance.SaveRegisterDataToUserDefault()
        })
    }
    
    func WebServiceForRegister(ReqModel:RegisterReqModel){
        Utilities.showHud()
        WebServiceSubClass.Register(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                SingletonClass.sharedInstance.clearSingletonClassForRegister()
                appDel.NavigateToHome()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    
}
enum DocumentType {
    case IdentityProof
    case Licence
}
