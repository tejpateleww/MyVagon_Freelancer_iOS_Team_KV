//
//  SchedualDetailViewModel.swift
//  MyVagon
//
//  Created by Apple on 23/12/21.
//

import Foundation
import UIKit

class SchedualDetailViewModel {
    weak var schedualLoadDetailsViewController : SchedualLoadDetailsViewController? = nil
    
    func ArrivedAtLocation(ReqModel:ArraivedAtLocationReqModel) {
        Utilities.ShowLoaderButtonInButton(Button: schedualLoadDetailsViewController?.btnStartTrip ?? themeButton(), vc: schedualLoadDetailsViewController ?? UIViewController())
        WebServiceSubClass.ArrivedAtLocation(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.schedualLoadDetailsViewController?.btnStartTrip ?? themeButton(), vc: self.schedualLoadDetailsViewController ?? UIViewController())
            if status {
                SingletonClass.sharedInstance.CurrentTripStart = false
                self.schedualLoadDetailsViewController?.LoadDetails = response?.data
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
                self.schedualLoadDetailsViewController?.SetValue()
                self.schedualLoadDetailsViewController?.btnStartTrip.superview?.isHidden = false
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func StartLoading(ReqModel:StartLoadingReqModel) {
        Utilities.ShowLoaderButtonInButton(Button: schedualLoadDetailsViewController?.btnStartTrip ?? themeButton(), vc: schedualLoadDetailsViewController ?? UIViewController())
        WebServiceSubClass.StartLoading(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.schedualLoadDetailsViewController?.btnStartTrip ?? themeButton(), vc: self.schedualLoadDetailsViewController ?? UIViewController())
            if status {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
                self.schedualLoadDetailsViewController?.LoadDetails = response?.data
                self.schedualLoadDetailsViewController?.SetValue()
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func CancelBidRequest(ReqModel:CancelBidReqModel) {
        Utilities.showHud()
        WebServiceSubClass.CancelBidRequest(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status {
                self.schedualLoadDetailsViewController?.popBack()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                }
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func DeleteBidRequest(ReqModel:CancelBidReqModel) {
        Utilities.showHud()
        WebServiceSubClass.DeleteBidRequest(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status {
                self.schedualLoadDetailsViewController?.popBack()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                }
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func StartJourney(ReqModel:StartJourneyReqModel) {
        Utilities.ShowLoaderButtonInButton(Button: schedualLoadDetailsViewController?.btnStartTrip ?? themeButton(), vc: schedualLoadDetailsViewController ?? UIViewController())
        WebServiceSubClass.StartJourney(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.schedualLoadDetailsViewController?.btnStartTrip ?? themeButton(), vc: self.schedualLoadDetailsViewController ?? UIViewController())
            if status {
                SingletonClass.sharedInstance.CurrentTripStart = true
                self.schedualLoadDetailsViewController?.LoadDetails = response?.data
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
                self.schedualLoadDetailsViewController?.SetValue()
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func GetLoadDetails(ReqModel:LoadDetailsReqModel) {
        WebServiceSubClass.LoadDetails(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            if status {
                self.schedualLoadDetailsViewController?.isLoading = false
                self.schedualLoadDetailsViewController?.LoadDetails = response?.data
                self.schedualLoadDetailsViewController?.SetValue()
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func UploadPOD(ReqModel:UploadPODReqModel) {
        WebServiceSubClass.UploadPOD(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            if status {
                self.schedualLoadDetailsViewController?.LoadDetails = response?.data
                self.schedualLoadDetailsViewController?.SetValue()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func CompleteTrip(ReqModel:CompleteTripReqModel) {
        Utilities.ShowLoaderButtonInButton(Button: schedualLoadDetailsViewController?.btnStartTrip ?? themeButton(), vc: schedualLoadDetailsViewController ?? UIViewController())
        WebServiceSubClass.CompleteTrip(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.schedualLoadDetailsViewController?.btnStartTrip ?? themeButton(), vc: self.schedualLoadDetailsViewController ?? UIViewController())
            if status {
                SingletonClass.sharedInstance.isArriveAtPickUpLocation = false
                SingletonClass.sharedInstance.isArriveAtDropOffLocation = false
                SingletonClass.sharedInstance.CurrentTripStart = false
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
                self.schedualLoadDetailsViewController?.LoadDetails = response?.data
                self.schedualLoadDetailsViewController?.SetValue()
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func WebServiceImageUpload(images:[UIImage]){
        Utilities.showHud()
        WebServiceSubClass.ImageUpload(imgArr: images, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                if self.schedualLoadDetailsViewController?.LoadDetails?.status == MyLoadesStatus.completed.Name {
                    let reqModel = UploadPODReqModel()
                    reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
                    reqModel.booking_id = "\(self.schedualLoadDetailsViewController?.LoadDetails?.id ?? 0)"
                    reqModel.pod_image = response?.data?.images?.first ?? ""
                    self.UploadPOD(ReqModel: reqModel)
                    self.schedualLoadDetailsViewController?.btnStartTrip.setTitle(TripStatus.RateShipper.Name, for: .normal)
                    self.schedualLoadDetailsViewController?.btnStartTrip.superview?.isHidden = false
                } else {
                    let reqModel = CompleteTripReqModel()
                    reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
                    reqModel.booking_id = "\(self.schedualLoadDetailsViewController?.LoadDetails?.id ?? 0)"
                    reqModel.location_id = "\(SingletonClass.sharedInstance.CurrentTripSecondLocation?.id ?? 0)"
                    reqModel.pod_image = response?.data?.images?.first ?? ""
                    self.CompleteTrip(ReqModel: reqModel)
                    self.schedualLoadDetailsViewController?.btnStartTrip.setTitle(TripStatus.RateShipper.Name, for: .normal)
                    self.schedualLoadDetailsViewController?.btnStartTrip.superview?.isHidden = false
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
                }
            }
        })
    }
    
    func WebServiceAcceptPayment(ReqModel:AcceptPaymentReqModel){
        Utilities.showHud()
        WebServiceSubClass.AcceptPayment(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                self.schedualLoadDetailsViewController?.popBack()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                }
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
