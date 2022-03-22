//
//  RelatedMatchViewModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 22/03/22.
//

import Foundation
class RelatedMatchViewModel{
    
    func callWebServiceForRelatedMatchList(reqModal: RelatedMatchReqModel){
        WebServiceSubClass.GetRelatedMatchList(reqModel: reqModal) { (status, apiMessage, response, error) in
            print("data Found",status)
        }
    }
    
}
