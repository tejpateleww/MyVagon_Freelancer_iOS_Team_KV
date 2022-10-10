//
//  WebServicesSubclass.swift
//  Danfo_Rider
//
//  Created by Hiral Jotaniya on 04/06/21.
//

import Foundation
import UIKit
class WebServiceSubClass{


    //MARK: -Init
    class func InitApi(completion: @escaping (Bool,String,InitResModel?,Any) -> ()) {
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.Init.rawValue + "/" + kAPPVesion + "/" + "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)", responseModel: InitResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK:- Init
       class func SystemDateTime(completion: @escaping (Bool,String,SystemDateResModel?,Any) -> ()) {
           Utilities.showHud()
           URLSessionRequestManager.makeGetRequest(urlString: ApiKey.SystemDateTime.rawValue , responseModel: SystemDateResModel.self) { (status, message, response, error) in
               Utilities.hideHud()
            if status{
                SingletonClass.sharedInstance.SystemDate = response?.data ?? ""
            }
               completion(status, message, response, error)
           }
       }
       
    
    
    //MARK: -Login
    class func Login(reqModel: LoginReqModel, completion: @escaping (Bool,String,NewLoginResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.Login.rawValue, requestModel: reqModel, responseModel: NewLoginResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -Forgot Password
    class func ForgotPasswordOTP(reqModel: ForgotPasswordReqModel, completion: @escaping (Bool,String,VerifyResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.forgotpassword.rawValue, requestModel: reqModel, responseModel: VerifyResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -ResetNewPassword
    class func ResetNewPassword(reqModel: ResetNewPasswordReqModel, completion: @escaping (Bool,String,GeneralMessageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.ResetPassword.rawValue, requestModel: reqModel, responseModel: GeneralMessageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -ChangePassword
    class func ChangePassword(reqModel: ChangePasswordReqModel, completion: @escaping (Bool,String,GeneralMessageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.ChangePassword.rawValue, requestModel: reqModel, responseModel: GeneralMessageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: - ShipperDetail
    class func ShipperDetail(shipperID: String,completion: @escaping (Bool,String,ReviewResModel?,Any) -> ()) {
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.shipperDetail.rawValue + "/\(shipperID)", responseModel: ReviewResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -PostTruck
    class func PostTruck(reqModel: PostTruckReqModel, completion: @escaping (Bool,String,PostTruckResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.PostAvailability.rawValue, requestModel: reqModel, responseModel: PostTruckResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -Settings
    class func Settings(reqModel: SettingsReqModel, completion: @escaping (Bool,String,SettingsResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.Settings.rawValue, requestModel: reqModel, responseModel: SettingsResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -GetSettings
    class func GetSettings(reqModel: GetSettingsListReqModel, completion: @escaping (Bool,String,SettingsGetResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.GetSettings.rawValue, requestModel: reqModel, responseModel: SettingsGetResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -VerifyEmail
    class func VerifyEmail(reqModel: EmailVerifyReqModel, completion: @escaping (Bool,String,VerifyResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.EmailVerify.rawValue, requestModel: reqModel, responseModel: VerifyResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -VerifyPhone
    class func VerifyPhone(reqModel: MobileVerifyReqModel, completion: @escaping (Bool,String,VerifyResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.PhoneNumberVerify.rawValue, requestModel: reqModel, responseModel: VerifyResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK:- Register
    class func Register(reqModel: RegisterReqModel, completion: @escaping (Bool,String,RegisterResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.Register.rawValue, requestModel: reqModel, responseModel: RegisterResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    
    //MARK: -TruckType
    class func TruckType(completion: @escaping (Bool,String,TruckTypeListingResModel?,Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.TruckTypeListing.rawValue, responseModel: TruckTypeListingResModel.self, language: true) { (status, message, response, error) in
            if status{
                SingletonClass.sharedInstance.TruckTypeList = response?.data
            }
            completion(status, message, response, error)
        }
    }
    
    //MARK: -PackageListing
    class func PackageListing(completion: @escaping (Bool,String,PackageListingResModel?,Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.PackageListing.rawValue, responseModel: PackageListingResModel.self,language: true) { (status, message, response, error) in
            if status{
                SingletonClass.sharedInstance.PackageList = response?.data
            }
            completion(status, message, response, error)
        }
    }
    
    //MARK: -TruckUnit
    class func TruckUnit(completion: @escaping (Bool,String,TruckUnitResModel?,Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.TruckUnitListing.rawValue, responseModel: TruckUnitResModel.self, language: true) { (status, message, response, error) in
            if status{
                SingletonClass.sharedInstance.TruckunitList = response?.data
            }
            completion(status, message, response, error)
        }
    }
    
    //MARK: -TruckFeatures
    class func TruckFeatures(completion: @escaping (Bool,String,TruckFeaturesResModel?,Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.TruckFeatureListing.rawValue, responseModel: TruckFeaturesResModel.self, language: true) { (status, message, response, error) in
            if status{
                SingletonClass.sharedInstance.TruckFeatureList = response?.data
            }
            completion(status, message, response, error)
        }
    }
    
    //MARK: -TruckBrand
    class func TruckBrand(completion: @escaping (Bool,String,TruckBrandsResModel?,Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.TruckBrandListing.rawValue, responseModel: TruckBrandsResModel.self, language: true) { (status, message, response, error) in
            if status{
                SingletonClass.sharedInstance.TruckBrandList = response?.data
            }
            completion(status, message, response, error)
        }
    }
    
    //MARK: - Cancellation Reasons
    class func cancellationReasoneList(completion: @escaping (Bool,String,CancellationReasoneResModel?,Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.CancellationReason.rawValue, responseModel: CancellationReasoneResModel.self,language: true) { (status, message, response, error) in
            if status{
                SingletonClass.sharedInstance.cancellationReasons = response?.data
            }
            completion(status, message, response, error)
        }
    }
    //MARK: -ImageUpload
    class func ImageUpload(imgArr:[UIImage], completion: @escaping (Bool,String,ImageUploadResModel?,Any) -> ()){
        
        URLSessionRequestManager.makeMultipleImageRequest(urlString: ApiKey.TempImageUpload.rawValue, requestModel: [String:String](), responseModel: ImageUploadResModel.self, imageKey: "images[]", arrImageData: imgArr) { status, message, response, error in
            completion(status, message, response, error)
        }
        
    }
    
    //MARK: -DocumentUpload
    class func DocumentUpload(Documents:[UploadMediaModel], completion: @escaping (Bool,String,ImageUploadResModel?,Any) -> ()){
        
        URLSessionRequestManager.makeMultipleMediaUploadRequest(urlString: ApiKey.TempImageUpload.rawValue, requestModel: [String:String](), responseModel: ImageUploadResModel.self, mediaArr: Documents) { status, message, response, error in
            completion(status, message, response, error)
        }
        
        
     
        
    }
    //MARK: -GetShipmentList
    class func GetShipmentList(reqModel: ShipmentListReqModel, completion: @escaping (Bool,String,SearchResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.SearchLoads.rawValue, requestModel: reqModel, responseModel: SearchResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
//    //MARK: -SearchShipemnet
//    class func SearchShipment(reqModel: SearchLoadReqModel, completion: @escaping (Bool,String,SearchResModel?,Any) -> ()){
//        URLSessionRequestManager.makePostRequest(urlString: ApiKey.SearchLoads.rawValue, requestModel: reqModel, responseModel: SearchResModel.self) { (status, message, response, error) in
//            completion(status, message, response, error)
//        }
//    }
    
    //MARK: -BookNow
    class func BookNow(reqModel: BookNowReqModel, completion: @escaping (Bool,String,GeneralMessageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.BookNow.rawValue, requestModel: reqModel, responseModel: GeneralMessageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -BidRequest
    class func BidRequest(reqModel: PostTruckBidReqModel, completion: @escaping (Bool,String,BidRequestResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.BidRequest.rawValue, requestModel: reqModel, responseModel: BidRequestResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    
    //MARK: -PostedTruckResult
    class func PostedTruckResult(reqModel: PostTruckBidReqModel, completion: @escaping (Bool,String,SearchResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.PostAvailabilityResult.rawValue, requestModel: reqModel, responseModel: SearchResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -AcceptReject
    class func AcceptReject(reqModel: BidAcceptRejectReqModel, completion: @escaping (Bool,String,BidRequestResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.BidRequestAcceptreject.rawValue, requestModel: reqModel, responseModel: BidRequestResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK: -RejectBookingRequest
    class func RejectBookingRequest(reqModel: BidAcceptRejectReqModel, completion: @escaping (Bool,String,BidRequestResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.RejectBookingRequest.rawValue, requestModel: reqModel, responseModel: BidRequestResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK: -BidPost
    class func BidPost(reqModel: BidReqModel, completion: @escaping (Bool,String,GeneralMessageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.BidPost.rawValue, requestModel: reqModel, responseModel: GeneralMessageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -GetMyLoadesList
    class func GetMyLoadesList(reqModel: MyLoadsReqModel, completion: @escaping (Bool,String,MyLoadsNewResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.MyLoades.rawValue, requestModel: reqModel, responseModel: MyLoadsNewResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK:- ProfileEdit
    class func ProfileEdit(reqModel: ProfileEditReqModel, completion: @escaping (Bool,String,NewLoginResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.ProfileUpdate.rawValue, requestModel: reqModel, responseModel: NewLoginResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- GetDriverList
    class func GetDriverList(reqModel: GetDriverListReqModel, completion: @escaping (Bool,String,DriverListResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.ManageDriver.rawValue, requestModel: reqModel, responseModel: DriverListResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -Settings
    class func PermissionSettings(reqModel: ChangePermissionReqModel, completion: @escaping (Bool,String,DriverPermissionChangeResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.ChangePermission.rawValue, requestModel: reqModel, responseModel: DriverPermissionChangeResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- ArrivedAtLocation
    class func ArrivedAtLocation(reqModel: ArraivedAtLocationReqModel, completion: @escaping (Bool,String,BookingLoadDetailsResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.ArrivedAtLocation.rawValue, requestModel: reqModel, responseModel: BookingLoadDetailsResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK:- StartLoading
    class func StartLoading(reqModel: StartLoadingReqModel, completion: @escaping (Bool,String,BookingLoadDetailsResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.StartLoading.rawValue, requestModel: reqModel, responseModel: BookingLoadDetailsResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK:- Cancel Bid
    class func CancelBidRequest(reqModel: CancelBidReqModel, completion: @escaping (Bool,String,GeneralMessageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.CancelRequest.rawValue, requestModel: reqModel, responseModel: GeneralMessageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK:- Delete Bid
    class func DeleteBidRequest(reqModel: CancelBidReqModel, completion: @escaping (Bool,String,GeneralMessageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.DeleteRequest.rawValue, requestModel: reqModel, responseModel: GeneralMessageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK:- CompleteTrip
    class func CompleteTrip(reqModel: CompleteTripReqModel, completion: @escaping (Bool,String,BookingLoadDetailsResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.CompleteTrip.rawValue, requestModel: reqModel, responseModel: BookingLoadDetailsResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK:- StartJourney
    class func StartJourney(reqModel: StartJourneyReqModel, completion: @escaping (Bool,String,BookingLoadDetailsResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.StartJourney.rawValue, requestModel: reqModel, responseModel: BookingLoadDetailsResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- UploadPOD
    class func UploadPOD(reqModel: UploadPODReqModel, completion: @escaping (Bool,String,BookingLoadDetailsResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.UploadPOD.rawValue, requestModel: reqModel, responseModel: BookingLoadDetailsResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK:- LoadDetails
    class func LoadDetails(reqModel: LoadDetailsReqModel, completion: @escaping (Bool,String,BookingLoadDetailsResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.BookingLoadDetails.rawValue, requestModel: reqModel, responseModel: BookingLoadDetailsResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- RateShipper
    class func RateShipper(reqModel: RateReviewReqModel, completion: @escaping (Bool,String,GeneralMessageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.RateShipper.rawValue, requestModel: reqModel, responseModel: GeneralMessageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -NotificationList
    class func NotificationList(completion: @escaping (Bool,String,NotificationListResModel?,Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.NotificationList.rawValue + "/\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)", responseModel: NotificationListResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- RateShipper
    class func chatHistory(reqModel: chatMessageReqModel, completion: @escaping (Bool,String,ChatMessagesResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.chatMessages.rawValue, requestModel: reqModel, responseModel: ChatMessagesResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- RateShipper
    class func chatUserList(reqModel: chatListReqModel, completion: @escaping (Bool,String,ChatUserListResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.chatUsers.rawValue, requestModel: reqModel, responseModel: ChatUserListResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- Earning
    class func earningList(reqModel: EarningReqModel, completion: @escaping (Bool,String,EarningResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.statisticsDetail.rawValue, requestModel: reqModel, responseModel: EarningResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- Accept Payment
    class func AcceptPayment(reqModel: AcceptPaymentReqModel, completion: @escaping (Bool,String,GeneralMessageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.acceptPayment.rawValue, requestModel: reqModel, responseModel: GeneralMessageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -getSupportAPI
    class func getSupportAPI(completion: @escaping (Bool,String,SupportResModel?,Any) -> ()) {
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.contactUs.rawValue, responseModel: SupportResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -StatiscticList
    class func StatisticListAPI(reqModel: StatisticListReqModel, completion: @escaping (Bool,String,StatisticResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.statistics.rawValue, requestModel: reqModel, responseModel: StatisticResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: -Payment Deatil API
    class func getPaymentDeatilAPI(completion: @escaping (Bool,String,PaymentDetailResModel?,Any) -> ()) {
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.getPaymentDetails.rawValue + "/\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)", responseModel: PaymentDetailResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK:- Update Payment Details
    class func updatePaymentDetail(reqModel: PaymentDetailUpdateReqModel, completion: @escaping (Bool,String,GeneralMessageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.updatePaymentDetails.rawValue, requestModel: reqModel, responseModel: GeneralMessageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK: - LocationDetail
    class func LocationDetail(locationID: String,completion: @escaping (Bool,String,LocationDetailResModel?,Any) -> ()) {
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.locationDetail.rawValue + "/\(locationID)", responseModel: LocationDetailResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- Update Personal Info
    class func editPersonalInfo(reqModel: EditPersonalInfoReqModel, completion: @escaping (Bool,String,NewLoginResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.updateBasicDetails.rawValue, requestModel: reqModel, responseModel: NewLoginResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- Update Licence Details
    class func updateLicenceDetail(reqModel: EditLicenceDetailsReqModel, completion: @escaping (Bool,String,GeneralMessageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.updateLicenceDetails.rawValue, requestModel: reqModel, responseModel: GeneralMessageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: - edit tractor
    class func editTractorDetail(reqModel: EditTractorDetailReqModel, completion: @escaping (Bool,String,RegisterResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.tractorDetailEdit.rawValue, requestModel: reqModel, responseModel: RegisterResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK: - edit truck
    class func editTruckDetail(reqModel: EditTruckReqModel, completion: @escaping (Bool,String,RegisterResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.editTruckDetail.rawValue, requestModel: reqModel, responseModel: RegisterResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK: - Add Truck
    class func addTruck(reqModel: AddTruckReqModel, completion: @escaping (Bool,String,RegisterResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.addTruck.rawValue, requestModel: reqModel, responseModel: RegisterResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    //MARK:- Related Match
    class func GetRelatedMatchList(reqModel: RelatedMatchReqModel, completion: @escaping (Bool,String,SearchResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.relatedMatch.rawValue, requestModel: reqModel, responseModel: SearchResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- Start Trip
    class func StartTrip(reqModel: StartTripReqModel, completion: @escaping (Bool,String,StartTripResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.startTrip.rawValue, requestModel: reqModel, responseModel: StartTripResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- Decline Load
    class func declineLoad(reqModel: CancelBookRequestReqModel, completion: @escaping (Bool,String,StartTripResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.cancelBookRequest.rawValue, requestModel: reqModel, responseModel: StartTripResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- Remove Truck Detail
    class func removeTruckDetail(reqModel: RemoveTruckDetailReqModel, completion: @escaping (Bool,String,StartTripResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.removeTruckDetails.rawValue, requestModel: reqModel, responseModel: StartTripResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- trash-posted-truck
    class func trashPostedTruck(reqModel: TrashPostedTruck, completion: @escaping (Bool,String,StartTripResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.trashPostedTruck.rawValue, requestModel: reqModel, responseModel: StartTripResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    //MARK:- Make as default truck
    class func makeAsDefaultTruck(reqModel: MakeAsDefaultTruckReqModel, completion: @escaping (Bool,String,StartTripResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.makeAsDefaultTruck.rawValue, requestModel: reqModel, responseModel: StartTripResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    // Logout Driver
    class func logOutDriver(completion: @escaping (Bool,String,InitResModel?,Any) -> ()) {
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.logOut.rawValue, responseModel: InitResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    // getSetting
    class func getSetting(reqModel: GetSettingReqModel, completion: @escaping (Bool,String,GetSettingResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.driverGetSetting.rawValue, requestModel: reqModel, responseModel: GetSettingResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    // UpdateSetting
    class func updateSetting(reqModel: EditSettingsReqModel, completion: @escaping (Bool,String,GetSettingResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.driverEditSettings.rawValue, requestModel: reqModel, responseModel: GetSettingResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    // UpdateSetting
    class func changeLanguage(reqModel: LanguageChangeReqModel, completion: @escaping (Bool,String,ChangeLanguageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.changeLanguage.rawValue, requestModel: reqModel, responseModel: ChangeLanguageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    // DeleteUser
    class func deleteUser(reqModel: DeleteUserReqModel, completion: @escaping (Bool,String,ChangeLanguageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.deleteUser.rawValue, requestModel: reqModel, responseModel: ChangeLanguageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
}


