//
//  SchedualDetailViewModel.swift
//  MyVagon
//
//  Created by Apple on 23/12/21.
//

import Foundation
import UIKit

class TrackingViewModel {
    weak var VC : TrackingVC? = nil
    
    func GetLoadDetails(ReqModel:LoadDetailsReqModel) {
        VC?.btnLocTracking.showLoading()
        WebServiceSubClass.LoadDetails(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            self.VC?.btnLocTracking.hideLoading()
            if status {
                self.VC?.TripDetails = response?.data
                self.VC?.isZoomEnable = true
                self.VC?.setupData()
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func ArrivedAtLocation(ReqModel:ArraivedAtLocationReqModel) {
        VC?.btnLocTracking.showLoading()
        WebServiceSubClass.ArrivedAtLocation(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            self.VC?.btnLocTracking.hideLoading()
            if status {
                self.VC?.TripDetails = response?.data
                self.VC?.isZoomEnable = true
                self.VC?.setupData()
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func StartLoading(ReqModel:StartLoadingReqModel) {
        VC?.btnLocTracking.showLoading()
        WebServiceSubClass.StartLoading(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            self.VC?.btnLocTracking.hideLoading()
            if status {
                self.VC?.TripDetails = response?.data
                self.VC?.setupData()
               
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func WebServiceImageUpload(images:[UIImage]){
        VC?.btnLocTracking.showLoading()
        WebServiceSubClass.ImageUpload(imgArr: images, completion: { (status, apiMessage, response, error) in
            self.VC?.btnLocTracking.hideLoading()
            if status{
                self.VC?.CallAPIForCompleteTrip(podImage: response?.data?.images?.first ?? "")
//                let reqModel = UploadPODReqModel()
//                reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
//                reqModel.booking_id = "\(self.VC?.TripDetails?.id ?? 0)"
//                reqModel.pod_image = response?.data?.images?.first ?? ""
//                self.UploadPOD(ReqModel: reqModel)
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
        
    }
    
    func UploadPOD(ReqModel:UploadPODReqModel) {
        VC?.btnLocTracking.showLoading()
        WebServiceSubClass.UploadPOD(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            self.VC?.btnLocTracking.hideLoading()
            if status {
                self.VC?.TripDetails = response?.data
                self.VC?.completeTrip()
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func CompleteTrip(ReqModel:CompleteTripReqModel) {
        self.VC?.btnLocTracking.showLoading()
        WebServiceSubClass.CompleteTrip(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            self.VC?.btnLocTracking.hideLoading()
            if status {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                }
                NotificationCenter.default.post(name: .PostCompleteTrip, object: nil)
                self.VC?.popToScheduleScreen()
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
}

class SchedualDetailViewModel {
    weak var schedualLoadDetailsViewController : ScheduleDetailVC? = nil
    
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
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                self.schedualLoadDetailsViewController?.LoadDetails = response?.data
                self.schedualLoadDetailsViewController?.SetValue()
                self.schedualLoadDetailsViewController?.btnStartTrip.setTitle(TripStatus.RateShipper.Name.localized, for: .normal)
                self.schedualLoadDetailsViewController?.btnStartTrip.superview?.isHidden = false
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
                    self.schedualLoadDetailsViewController?.LoadDetails?.podURL = response?.data?.images?.first ?? ""
                }
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
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
    
    func WebServiceStartTrip(ReqModel:StartTripReqModel){
        Utilities.ShowLoaderButtonInButton(Button: schedualLoadDetailsViewController?.btnStartTrip ?? themeButton(), vc: schedualLoadDetailsViewController ?? UIViewController())
        WebServiceSubClass.StartTrip(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.schedualLoadDetailsViewController?.btnStartTrip ?? themeButton(), vc: self.schedualLoadDetailsViewController ?? UIViewController())
            if status{
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                self.schedualLoadDetailsViewController?.LoadDetails?.status = MyLoadesStatus.inprocess.Name
                self.schedualLoadDetailsViewController?.SetValue()
                self.schedualLoadDetailsViewController?.btnStartTrip.superview?.isHidden = true
                self.schedualLoadDetailsViewController?.reloadAfterStartTrip()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
                
               // SingletonClass.sharedInstance.CurrentTripStart = true
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
