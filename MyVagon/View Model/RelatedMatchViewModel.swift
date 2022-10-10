//
//  RelatedMatchViewModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 22/03/22.
//

import Foundation
class RelatedMatchViewModel{
    var relatedMatchesVC : RelatedMatchesVC?
    func callWebServiceForRelatedMatchList(reqModal: RelatedMatchReqModel){
        WebServiceSubClass.GetRelatedMatchList(reqModel: reqModal) { (status, apiMessage, response, error) in
            DispatchQueue.main.async {
                self.relatedMatchesVC?.refreshControl.endRefreshing()
            }
            self.relatedMatchesVC?.isTblReload = true
            self.relatedMatchesVC?.self.isLoading = false
            if status{
                self.relatedMatchesVC?.arrRelatedData = response?.data ?? []
                self.relatedMatchesVC?.tblRelatedData.reloadData()
                self.relatedMatchesVC?.tblRelatedData.layoutIfNeeded()
                self.relatedMatchesVC?.tblRelatedData.beginUpdates()
                self.relatedMatchesVC?.tblRelatedData.endUpdates()
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
            
        }
    }
    
}
