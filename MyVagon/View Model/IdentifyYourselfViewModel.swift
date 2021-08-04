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
               
            } else {
                if DocumentType == .IdentityProof {
                    self.identifyYourselfVC?.identityProofTF.text = ""
                } else if DocumentType == .Licence {
                    self.identifyYourselfVC?.licenceTF.text = ""
                }
            }
        })
    }
}
enum DocumentType {
    case IdentityProof
    case Licence
}
