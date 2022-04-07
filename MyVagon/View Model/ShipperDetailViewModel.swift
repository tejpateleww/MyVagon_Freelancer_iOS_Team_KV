//
//  ShipperDetailViewModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 10/03/22.
//

import Foundation
class ShipperDetailViewModel{
    var shipperDetailVC: shipperDetailsVC? = nil
    
    func callWebServiceForShipperDetail(){
        Utilities.showHud()
        WebServiceSubClass.ShipperDetail(shipperID: shipperDetailVC?.shipperId ?? "") { Status, apiMessage, response, error in
            Utilities.hideHud()
            self.shipperDetailVC?.isTblReload = true
            if Status{
                self.shipperDetailVC?.shipperData = response
                self.shipperDetailVC?.arrData = response?.data?.review ?? []
                self.shipperDetailVC?.arrRating.removeAll()
                self.shipperDetailVC?.arrRating.append(response?.data?.oneStarRatingCount ?? 0)
                self.shipperDetailVC?.arrRating.append(response?.data?.twoStarRatingCount ?? 0)
                self.shipperDetailVC?.arrRating.append(response?.data?.threeStarRatingCount ?? 0)
                self.shipperDetailVC?.arrRating.append(response?.data?.fourStarRatingCount ?? 0)
                self.shipperDetailVC?.arrRating.append(response?.data?.fiveStarRatingCount ?? 0)
                self.shipperDetailVC?.isLoading = false
                self.shipperDetailVC?.setChartData()
                self.shipperDetailVC?.tblShipperDetails.reloadData()
                self.shipperDetailVC?.calculateRating()
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        }
    }
}
