//
//  URLSessionRequestManager.swift
//  Danfo_Rider
//
//  Created by Hiral Jotaniya on 04/06/21.
//


import UIKit
import Foundation
import SystemConfiguration

typealias CompletionResponse<R:Codable> = (Bool,Codable?,Any) -> ()
class URLSessionRequestManager {

    static func BEARER_HEADER() -> [String:String]{
        return  APIEnvironment.headers
    }
    
    static func NEW_BEARER_HEADER() -> String {
        return "\(APIEnvironment.BearerHeader)"
    }
    

    class func makeGetRequest<C:Codable>(urlString: String, responseModel: C.Type, language: Bool = false, completion: @escaping (_ status: Bool,_ apiMessage: String,_ modelObj: C?,_ dataDic: Any) -> ()) {

        if !Reachability.isConnectedToNetwork() {
            completion(false, UrlConstant.NoInternetConnection.localized, nil, NoInternetResponseDic)
            return
        }

        guard let url = URL(string: APIEnvironment.baseURL + urlString) else {
            completion(false, UrlConstant.SomethingWentWrong.localized, nil, SomethingWentWrongResponseDic)
            return
        }

        var request = URLRequest(url: url)

        request.httpMethod = GetRequestType.GET.rawValue
        
        var header = BEARER_HEADER()
        if language{
            header[UrlConstant.Localization] = "en"
        }
        request.allHTTPHeaderFields = header

        print("the url is \(url) and the headers are \(header)")

        CodableService.getResponseFromSession(request: request, codableObj: responseModel) { (status, apiMessage, obj, dic) in
            DispatchQueue.main.async {
                completion(status, apiMessage,obj,dic)
            }
        }
    }
    
//    class func makePostRequest<C:Codable, P:Encodable>(urlString: String, requestModel: P, responseModel: C.Type, completion: @escaping (_ status: Bool,_ apiMessage: String,_ modelObj: C?,_ dataDic: Any) -> ()){
//
//        if !Reachability.isConnectedToNetwork() {
//            completion(false, UrlConstant.NoInternetConnection, nil, NoInternetResponseDic)
//            return
//        }
//
//        guard let url = URL(string: APIEnvironment.baseURL + urlString) else {
//            completion(false, UrlConstant.SomethingWentWrong, nil, SomethingWentWrongResponseDic)
//            return
//        }
//
//        let boundary = RequestString.boundry.rawValue + "\(NSUUID().uuidString)"
//
//        var request = URLRequest(url: url)
//        request.httpMethod = GetRequestType.POST.rawValue
//        request.allHTTPHeaderFields = BEARER_HEADER()
//
//        if let bodyDic = try? requestModel.asDictionary(){
//            let dicData = bodyDic.percentEncoded()
//            request.httpBody = dicData
//
//            print("the url is \(url) and the parameters are \n \(bodyDic) and the headers are \(BEARER_HEADER())")
//        }
//
//     //   request.addValue(RequestString.multiplePartFormData.rawValue + boundary, forHTTPHeaderField: RequestString.contentType.rawValue)
//
//
//        CodableService.getResponseFromSession(request: request, codableObj: responseModel) { (status, apiMessage, obj, dic) in
//            completion(status, apiMessage,obj,dic)
//        }
//    }	
    class func makePostRequest<C:Codable, P:Encodable>(urlString: String, requestModel: P, responseModel: C.Type, completion: @escaping (_ status: Bool,_ apiMessage: String,_ modelObj: C?,_ dataDic: Any) -> ()) {
        var paramaterDic = [String: Any]()
        
        let langCode = Localize.currentLanguage()
        if !Reachability.isConnectedToNetwork() {
            completion(false, UrlConstant.NoInternetConnection.localized, nil, NoInternetResponseDic)
            return
        }

        guard let url = URL(string: APIEnvironment.baseURL + urlString) else {
            completion(false, UrlConstant.SomethingWentWrong.localized, nil, SomethingWentWrongResponseDic)
            return
        }

        let boundary = RequestString.boundry.rawValue + "\(NSUUID().uuidString)"

        var request = URLRequest(url: url)
        request.httpMethod = GetRequestType.POST.rawValue
        request.setValue(langCode, forHTTPHeaderField: UrlConstant.Localization)
        request.setValue(NEW_BEARER_HEADER(), forHTTPHeaderField: UrlConstant.XApiKey)
        request.addValue(RequestString.multiplePartFormData.rawValue + boundary, forHTTPHeaderField: RequestString.contentType.rawValue)
        if let bodyDic = try? requestModel.asDictionary(){
            paramaterDic = bodyDic
            let dicData = bodyDic.percentEncoded()
            request.httpBody = dicData
            print("the url is \(url) and the parameters are \n \(bodyDic) and the headers are \(String(describing: request.allHTTPHeaderFields))")
        }

        let dataBody = RequestBodyClass.createDataBodyForWithoutMediaRequest(withParameters: paramaterDic, boundary: boundary)
        request.httpBody = dataBody
        CodableService.getResponseFromSession(request: request, codableObj: responseModel) { (status, apiMessage, obj, dic) in
            completion(status, apiMessage,obj,dic)
        }
    }

    class func makeImageUploadRequest<C:Codable, P:Encodable>(urlString: String, requestModel: P, responseModel: C.Type, image: UIImage, imageKey: String, completion: @escaping (_ status: Bool,_ apiMessage: String,_ modelObj: C?,_ dataDic: Any) -> ()){
        var paramaterDic = [String: Any]()

        if !Reachability.isConnectedToNetwork() {
            completion(false, UrlConstant.NoInternetConnection.localized, nil, NoInternetResponseDic)
            return
        }

        guard let url = URL(string: APIEnvironment.baseURL + urlString) else {
            completion(false, UrlConstant.SomethingWentWrong.localized, nil, SomethingWentWrongResponseDic)
            return
        }
        let boundary = RequestString.boundry.rawValue + "\(NSUUID().uuidString)"
              
              var request = URLRequest(url: url)
              request.httpMethod = GetRequestType.POST.rawValue
              request.allHTTPHeaderFields = BEARER_HEADER()
              
              if let bodyDic = try? requestModel.asDictionary(){
                  paramaterDic = bodyDic
                  let dicData = bodyDic.percentEncoded()
                  request.httpBody = dicData
              }
              
              guard let mediaImage = UploadMediaModel(mediaType: .Image, forKey: imageKey, withImage: image) else {
                  completion(false, UrlConstant.SomethingWentWrong.localized, nil, SomethingWentWrongResponseDic)
                  return
              }
              
              request.setValue(RequestString.multiplePartFormData.rawValue + boundary, forHTTPHeaderField: RequestString.contentType.rawValue)
              
              let dataBody = RequestBodyClass.createDataBodyForMediaRequest(withParameters: paramaterDic, media: [mediaImage], boundary: boundary)
              request.httpBody = dataBody
                  
              print("the url is \(url) and the parameters are \n \(paramaterDic) and the headers are \(BEARER_HEADER())")
              
              CodableService.getResponseFromSession(request: request, codableObj: responseModel) { (status, apiMessage, obj, dic) in
                  completion(status, apiMessage,obj,dic)
              }
        

    }

    class func makeMultipleImageRequest<C:Codable, P:Encodable>(urlString: String, requestModel: P, responseModel: C.Type, imageKey: String ,arrImageData : [UIImage]?, completion: @escaping (_ status: Bool,_ apiMessage: String,_ modelObj: C?,_ dataDic: Any) -> ()){
        var paramaterDic = [String: Any]()

        if !Reachability.isConnectedToNetwork() {
            completion(false, UrlConstant.NoInternetConnection.localized, nil, NoInternetResponseDic)
            return
        }

        guard let url = URL(string: APIEnvironment.baseURL + urlString) else {
            completion(false, UrlConstant.SomethingWentWrong.localized, nil, SomethingWentWrongResponseDic)
            return
        }

        let boundary = RequestString.boundry.rawValue + "\(NSUUID().uuidString)"

        var request = URLRequest(url: url)
        request.httpMethod = GetRequestType.POST.rawValue
        request.allHTTPHeaderFields = BEARER_HEADER()

        if let bodyDic = try? requestModel.asDictionary(){
            paramaterDic = bodyDic
            let dicData = bodyDic.percentEncoded()
            request.httpBody = dicData
        }

        var mediaArr = [UploadMediaModel]()
        if let dataDic = arrImageData{
            for each in dataDic{
                guard let mediaImage = UploadMediaModel(mediaType: .Image, forKey: imageKey, withImage: each) else {
                    completion(false, UrlConstant.SomethingWentWrong.localized, nil, SomethingWentWrongResponseDic)
                    return
                }
                mediaArr.append(mediaImage)
            }
        }

        request.setValue(RequestString.multiplePartFormData.rawValue + boundary, forHTTPHeaderField: RequestString.contentType.rawValue)

        let dataBody = RequestBodyClass.createDataBodyForMediaRequest(withParameters: paramaterDic, media: mediaArr, boundary: boundary)
        request.httpBody = dataBody

        print("the url is \(url) and the parameters are \n \(paramaterDic) and the headers are \(BEARER_HEADER())")

        CodableService.getResponseFromSession(request: request, codableObj: responseModel) { (status, apiMessage, obj, dic) in
            completion(status, apiMessage,obj,dic)
        }
    }

    class func makeMediaUploadRequest<C:Codable, P:Encodable>(urlString: String, requestModel: P, responseModel: C.Type, mediaType: MediaType,file_url: String, fileKey: String, completion: @escaping (_ status: Bool,_ apiMessage: String,_ modelObj: C?,_ dataDic: Any) -> ()){
        var paramaterDic = [String: Any]()

        if !Reachability.isConnectedToNetwork() {
            completion(false, UrlConstant.NoInternetConnection.localized, nil, NoInternetResponseDic)
            return
        }

        guard let url = URL(string: APIEnvironment.baseURL + urlString) else {
            completion(false, UrlConstant.SomethingWentWrong.localized, nil, SomethingWentWrongResponseDic)
            return
        }

        let boundary = RequestString.boundry.rawValue + "\(NSUUID().uuidString)"

        var request = URLRequest(url: url)
        request.httpMethod = GetRequestType.POST.rawValue
        request.allHTTPHeaderFields = BEARER_HEADER()

        if let bodyDic = try? requestModel.asDictionary(){
            paramaterDic = bodyDic
            let dicData = bodyDic.percentEncoded()
            request.httpBody = dicData
        }

        guard let mediaUrl = URL(string: file_url) else {
            completion(false, UrlConstant.SomethingWentWrong.localized, nil, SomethingWentWrongResponseDic)
            return
        }

        guard let mediaImage = UploadMediaModel(mediaType: mediaType, forKey: fileKey, fileUrl: mediaUrl) else {
            completion(false, UrlConstant.SomethingWentWrong.localized, nil, SomethingWentWrongResponseDic)
            return
        }

        request.setValue(RequestString.multiplePartFormData.rawValue + boundary, forHTTPHeaderField: RequestString.contentType.rawValue)

        let dataBody = RequestBodyClass.createDataBodyForMediaRequest(withParameters: paramaterDic, media: [mediaImage], boundary: boundary)
        print("BODY DIC: \(paramaterDic)")
        request.httpBody = dataBody

        print("the url is \(url) and the parameters are \n \(paramaterDic) and the headers are \(BEARER_HEADER())")

        print("REQUEST: \(request)")

        CodableService.getResponseFromSession(request: request, codableObj: responseModel) { (status, apiMessage, obj, dic) in
            completion(status, apiMessage,obj,dic)
        }
    }

    class func makeMultipleMediaUploadRequest<C:Codable, P:Encodable>(urlString: String, requestModel: P, responseModel: C.Type, mediaArr: [UploadMediaModel], completion: @escaping (_ status: Bool,_ apiMessage: String,_ modelObj: C?,_ dataDic: Any) -> ()){
        var paramaterDic = [String: Any]()

        if !Reachability.isConnectedToNetwork() {
            completion(false, UrlConstant.NoInternetConnection.localized, nil, NoInternetResponseDic)
            return
        }

        guard let url = URL(string: APIEnvironment.baseURL + urlString) else {
            completion(false, UrlConstant.SomethingWentWrong.localized, nil, SomethingWentWrongResponseDic)
            return
        }

        let boundary = RequestString.boundry.rawValue + "\(NSUUID().uuidString)"

        var request = URLRequest(url: url)
        request.httpMethod = GetRequestType.POST.rawValue
        request.allHTTPHeaderFields = BEARER_HEADER()


        if let bodyDic = try? requestModel.asDictionary(){
            paramaterDic = bodyDic
            let dicData = bodyDic.percentEncoded()
            request.httpBody = dicData
        }

        request.setValue(RequestString.multiplePartFormData.rawValue + boundary, forHTTPHeaderField: RequestString.contentType.rawValue)
      

        let dataBody = RequestBodyClass.createDataBodyForMediaRequest(withParameters: paramaterDic, media: mediaArr, boundary: boundary)

        print("BODY DIC: \(paramaterDic)")
        request.httpBody = dataBody

        print("the url is \(url) and the parameters are \n \(paramaterDic) and the headers are \(BEARER_HEADER())")

        print("REQUEST: \(request)")

        CodableService.getResponseFromSession(request: request, codableObj: responseModel) { (status, apiMessage, obj, dic) in
            completion(status, apiMessage,obj,dic)
        }
    }
}




/*

import UIKit
import Foundation
import SystemConfiguration

typealias CompletionResponse<R:Codable> = (Bool,Codable?,Any) -> ()
class URLSessionRequestManager {
    
    static func BEARER_HEADER() -> [String:String]{
        return  APIEnvironment.headers
    }
    
    class func makeGetRequest<C:Codable>(isIot: Bool = false, urlString: String, responseModel: C.Type, completion: @escaping ( status: Bool, apiMessage: String, modelObj: C?, dataDic: Any) -> ()) {
        
        if !Reachability.isConnectedToNetwork() {
            completion(false, UrlConstant.NoInternetConnection, nil, NoInternetResponseDic)
            return
        }
        
        guard let url = URL(string: (isIot ? APIEnvironment.iotURL : APIEnvironment.baseURL) + urlString) else {
            completion(false, UrlConstant.SomethingWentWrong, nil, SomethingWentWrongResponseDic)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = GetRequestType.GET.rawValue
      
        request.allHTTPHeaderFields = BEARER_HEADER()
        
        print("the url is \(url) and the headers are \(BEARER_HEADER())")
        
        CodableService.getResponseFromSession(request: request, codableObj: responseModel) { (status, apiMessage, obj, dic) in
            DispatchQueue.main.async {
                completion(status, apiMessage,obj,dic)
            }
           
        }
    }
    
    class func  makePostRequest<C:Codable, P:Encodable>(isIot: Bool = false, urlString: String, requestModel: P, responseModel: C.Type, completion: @escaping ( status: Bool, apiMessage: String, modelObj: C?, dataDic: Any) -> ()) {
        
        if !Reachability.isConnectedToNetwork() {
            completion(false, UrlConstant.NoInternetConnection, nil, NoInternetResponseDic)
            return
        }
        
        guard let url = URL(string: (isIot ? APIEnvironment.iotURL : APIEnvironment.baseURL) + urlString) else {
            completion(false, UrlConstant.SomethingWentWrong, nil, SomethingWentWrongResponseDic)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = GetRequestType.POST.rawValue
        request.allHTTPHeaderFields = BEARER_HEADER()
        var dicData:Data?
        if let bodyDic = try? requestModel.asDictionary(){
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            if let addOnsData = try? encoder.encode(requestModel){
                dicData = addOnsData
            }
            request.httpBody = dicData
            print("the url is \(url) and the parameters are \n \(bodyDic) and the headers are \(BEARER_HEADER())")
        }
     
        CodableService.getResponseFromSession(request: request, codableObj: responseModel) { (status, apiMessage, obj, dic) in
            completion(status, apiMessage,obj,dic)
        }
    }
    
    class func makeImageUploadRequest<C:Codable, P:Encodable>(isIot: Bool = false, urlString: String, requestModel: P, responseModel: C.Type, image: UIImage, imageKey: String, completion: @escaping ( status: Bool, apiMessage: String, modelObj: C?, dataDic: Any) -> ()){
        var paramaterDic = [String: Any]()
        
        if !Reachability.isConnectedToNetwork() {
            completion(false, UrlConstant.NoInternetConnection, nil, NoInternetResponseDic)
            return
        }
        
        guard let url = URL(string: (isIot ? APIEnvironment.iotURL : APIEnvironment.baseURL) + urlString) else {
            completion(false, UrlConstant.SomethingWentWrong, nil, SomethingWentWrongResponseDic)
            return
        }
        
        let boundary = RequestString.boundry.rawValue + "\(NSUUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.httpMethod = GetRequestType.POST.rawValue
        request.allHTTPHeaderFields = BEARER_HEADER()
        
        if let bodyDic = try? requestModel.asDictionary(){
            paramaterDic = bodyDic
            let dicData = bodyDic.percentEncoded()
            request.httpBody = dicData
        }
        
        guard let mediaImage = UploadMediaModel(mediaType: .Image, forKey: imageKey, withImage: image) else {
            completion(false, UrlConstant.SomethingWentWrong, nil, SomethingWentWrongResponseDic)
            return
        }
        
        request.setValue(RequestString.multiplePartFormData.rawValue + boundary, forHTTPHeaderField: RequestString.contentType.rawValue)
        
        let dataBody = RequestBodyClass.createDataBodyForMediaRequest(withParameters: paramaterDic, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
            
        print("the url is \(url) and the parameters are \n \(paramaterDic) and the headers are \(BEARER_HEADER())")
        
        CodableService.getResponseFromSession(request: request, codableObj: responseModel) { (status, apiMessage, obj, dic) in
            completion(status, apiMessage,obj,dic)
        }
        
    }
    
    class func makeMultipleImageRequest<C:Codable, P:Encodable>(isIot: Bool = false, urlString: String, requestModel: P, responseModel: C.Type, imageKey: String ,arrImageData : [UIImage]?, completion: @escaping ( status: Bool, apiMessage: String, modelObj: Any?, dataDic: Any) -> ()){
        var paramaterDic = [String: Any]()
        
        if !Reachability.isConnectedToNetwork() {
            completion(false, UrlConstant.NoInternetConnection, nil, NoInternetResponseDic)
            return
        }
        
        guard let url = URL(string: (isIot ? APIEnvironment.iotURL : APIEnvironment.baseURL) + urlString) else {
            completion(false, UrlConstant.SomethingWentWrong, nil, SomethingWentWrongResponseDic)
            return
        }
        
        let boundary = RequestString.boundry.rawValue + "\(NSUUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.httpMethod = GetRequestType.POST.rawValue
        request.allHTTPHeaderFields = BEARER_HEADER()
        
        if let bodyDic = try? requestModel.asDictionary(){
            paramaterDic = bodyDic
            let dicData = bodyDic.percentEncoded()
            request.httpBody = dicData
        }
        
        var mediaArr = [UploadMediaModel]()
        if let dataDic = arrImageData{
            for each in dataDic{
                guard let mediaImage = UploadMediaModel(mediaType: .Image, forKey: imageKey, withImage: each) else {
                    completion(false, UrlConstant.SomethingWentWrong, nil, SomethingWentWrongResponseDic)
                    return
                }
                mediaArr.append(mediaImage)
            }
        }
        
        request.setValue(RequestString.multiplePartFormData.rawValue + boundary, forHTTPHeaderField: RequestString.contentType.rawValue)
        
        let dataBody = RequestBodyClass.createDataBodyForMediaRequest(withParameters: paramaterDic, media: mediaArr, boundary: boundary)
        request.httpBody = dataBody
            
        print("the url is \(url) and the parameters are \n \(paramaterDic) and the headers are \(BEARER_HEADER())")
        
        CodableService.getResponseFromSession(request: request, codableObj: responseModel) { (status, apiMessage, obj, dic) in
            completion(status, apiMessage,obj,dic)
        }
    }
    
    class func makeMediaUploadRequest<C:Codable, P:Encodable>(isIot: Bool = false, urlString: String, requestModel: P, responseModel: C.Type, mediaType: MediaType,file_url: String, fileKey: String, completion: @escaping ( status: Bool, apiMessage: String, modelObj: C?, dataDic: Any) -> ()){
        var paramaterDic = [String: Any]()
        
        if !Reachability.isConnectedToNetwork() {
            completion(false, UrlConstant.NoInternetConnection, nil, NoInternetResponseDic)
            return
        }
        
        guard let url = URL(string: (isIot ? APIEnvironment.iotURL : APIEnvironment.baseURL) + urlString) else {
            completion(false, UrlConstant.SomethingWentWrong, nil, SomethingWentWrongResponseDic)
            return
        }
        
        let boundary = RequestString.boundry.rawValue + "\(NSUUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.httpMethod = GetRequestType.POST.rawValue
        request.allHTTPHeaderFields = BEARER_HEADER()
        
        if let bodyDic = try? requestModel.asDictionary(){
            paramaterDic = bodyDic
            let dicData = bodyDic.percentEncoded()
            request.httpBody = dicData
        }
        
        guard let mediaUrl = URL(string: file_url) else {
            completion(false, UrlConstant.SomethingWentWrong, nil, SomethingWentWrongResponseDic)
            return
        }
        
        guard let mediaImage = UploadMediaModel(mediaType: mediaType, forKey: fileKey, fileUrl: mediaUrl) else {
            completion(false, UrlConstant.SomethingWentWrong, nil, SomethingWentWrongResponseDic)
            return
        }
        
        request.setValue(RequestString.multiplePartFormData.rawValue + boundary, forHTTPHeaderField: RequestString.contentType.rawValue)
        
        let dataBody = RequestBodyClass.createDataBodyForMediaRequest(withParameters: paramaterDic, media: [mediaImage], boundary: boundary)
        print("BODY DIC: \(paramaterDic)")
        request.httpBody = dataBody
            
        print("the url is \(url) and the parameters are \n \(paramaterDic) and the headers are \(BEARER_HEADER())")
        
        print("REQUEST: \(request)")
        
        CodableService.getResponseFromSession(request: request, codableObj: responseModel) { (status, apiMessage, obj, dic) in
            completion(status, apiMessage,obj,dic)
        }
    }
    
    class func makeMultipleMediaUploadRequest<C:Codable, P:Encodable>(isIot: Bool = false, urlString: String, requestModel: P, responseModel: C.Type, mediaArr: [UploadMediaModel], completion: @escaping ( status: Bool, apiMessage: String, modelObj: C?, dataDic: Any) -> ()){
        var paramaterDic = [String: Any]()
        
        if !Reachability.isConnectedToNetwork() {
            completion(false, UrlConstant.NoInternetConnection, nil, NoInternetResponseDic)
            return
        }
        
        guard let url = URL(string: (isIot ? APIEnvironment.iotURL : APIEnvironment.baseURL) + urlString) else {
            completion(false, UrlConstant.SomethingWentWrong, nil, SomethingWentWrongResponseDic)
            return
        }
        
        let boundary = RequestString.boundry.rawValue + "\(NSUUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.httpMethod = GetRequestType.POST.rawValue
        request.allHTTPHeaderFields = BEARER_HEADER()
        
        if let bodyDic = try? requestModel.asDictionary(){
            paramaterDic = bodyDic
            let dicData = bodyDic.percentEncoded()
            request.httpBody = dicData
        }
        
        request.setValue(RequestString.multiplePartFormData.rawValue + boundary, forHTTPHeaderField: RequestString.contentType.rawValue)
        
        let dataBody = RequestBodyClass.createDataBodyForMediaRequest(withParameters: paramaterDic, media: mediaArr, boundary: boundary)
        
        print("BODY DIC: \(paramaterDic)")
        request.httpBody = dataBody
            
        print("the url is \(url) and the parameters are \n \(paramaterDic) and the headers are \(BEARER_HEADER())")
        
        print("REQUEST: \(request)")
        
        CodableService.getResponseFromSession(request: request, codableObj: responseModel) { (status, apiMessage, obj, dic) in
            completion(status, apiMessage,obj,dic)
        }
    }
}

 */
