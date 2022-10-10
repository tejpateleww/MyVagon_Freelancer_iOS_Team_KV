//
//  AttechmentService.swift
//  HC Pro Doctor
//
//  Created by Apple on 08/04/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Photos
import CoreLocation

class AttachmentHandler: NSObject{
    static let shared = AttachmentHandler()
    fileprivate var currentVC: UIViewController?
    //    private weak var presentationController: UIViewController?
    //MARK: - Internal Properties
    
    var imagePickedBlock: ((UIImage) -> Void)?
    var videoPickedBlock: ((NSURL) -> Void)?
    var filePickedBlock: ((URL) -> Void)?
    var locationPickedBlock:  ((CLLocation) -> Void)?
    var isRemoveNeeded : Bool = false
    
    //    var isVideo : Bool = false
    
    enum AttachmentType: String{
        case camera, video, photoLibrary, location
    }
    
    
    //MARK: - Constants
    struct Constants {
        static let actionFileTypeHeading = "Add a File"
        static let actionFileTypeDescription = "Choose a filetype to add..."
        static let camera = "Camera"
        static let phoneLibrary = "Phone Library"
        static let video = "Video"
        static let file = "File"
        static let location = "Location"
        static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
        static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
        static let alertForVideoLibraryMessage = "App does not have access to your video. To enable access, tap settings and turn on Video Library Access."
        static let settingsBtnTitle = "Settings"
        static let cancelBtnTitle = "Cancel"
    }
    
    
    
    //MARK: - showAttachmentActionSheet
    // This function is used to show the attachment sheet for image, video, photo and file.
    func showAttachmentActionSheet(vc: UIViewController, isVideo : Bool = false) {
        currentVC = vc
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
            DispatchQueue.main.async {
                //                self.isVideo = false
                self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
            }
        }))
        if isVideo{
            actionSheet.addAction(UIAlertAction(title: Constants.video, style: .default, handler: { (action) -> Void in
                DispatchQueue.main.async {
                    //                    self.isVideo = true
                    self.authorisationStatus(attachmentTypeEnum: .video, vc: self.currentVC!)
                }
            }))
        }else{
            actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
                DispatchQueue.main.async {
                    
                    self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)}
            }))
        }
        
        
        
        //        actionSheet.addAction(UIAlertAction(title: Constants.file, style: .default, handler: { (action) -> Void in
        //            self.documentPicker()
        //        }))
        //
        //        actionSheet.addAction(UIAlertAction(title: Constants.location, style: .default, handler: { (action) -> Void in
        //            self.locationPickedBlock?(SingletonClass.sharedInstance.userCurrentLocation)
        //        }))
        //
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Authorisation Status
    func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController){
        currentVC = vc
        DispatchQueue.main.async {
            if attachmentTypeEnum == AttachmentType.camera{
                self.openCamera()
            }
            if attachmentTypeEnum == AttachmentType.photoLibrary{
                self.photoLibrary()
            }
            if attachmentTypeEnum == AttachmentType.video{
                self.videoLibrary()
            }
        }
        
    }
    private func showAlert(message: String) {
        Utilities.showAlertWithTitleFromVC(vc: currentVC ?? UIViewController(), title: AppName, message: message, buttons:  ["Later".localized, "Settings".localized]) {  (intIndex) in
            if intIndex == 1 {
                if let settingsAppURL = URL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    private func photoGalleryAsscessRequest(attachmentTypeEnum : AttachmentType) {
        PHPhotoLibrary.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            if result == .authorized {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if attachmentTypeEnum == AttachmentType.photoLibrary{
                        self.photoLibrary()
                    }
                    if attachmentTypeEnum == AttachmentType.video{
                        self.videoLibrary()
                    }
                }
            } else {
                self.showAlert(message: "\(AppName) would like to access gallery for select your picture and set as a your profile picture")
            }
        }
    }
    
    
    //MARK: - CAMERA PICKER
    //This function is used to open camera from the iphone and
    func openCamera(){
        
        DispatchQueue.main.async {
            
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                self.camera()
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        self.camera()
                    } else {
                        self.showAlert(message: "camera_access".localized)
                    }
                })
            }
        }
    }
    
    func camera(){
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let myPickerController = UIImagePickerController()
                myPickerController.navigationController?.isNavigationBarHidden = false
                myPickerController.delegate = self
                myPickerController.sourceType = .camera
                self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - PHOTO PICKER
    func photoLibrary(){
        
        if PHPhotoLibrary.authorizationStatus() == .authorized{
            self.library()
        }else{
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    self.library()
                }else{
                    self.addAlertForSettings(.photoLibrary)
                }
            })
        }
    }
    
    func library(){
        DispatchQueue.main.async{
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                DispatchQueue.main.async {
                    let myPickerController = UIImagePickerController()
                    myPickerController.delegate = self
                    myPickerController.sourceType = .photoLibrary
                    self.currentVC?.present(myPickerController, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: - VIDEO PICKER
    func videoLibrary(){
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                DispatchQueue.main.async {
                    let myPickerController = UIImagePickerController()
                    myPickerController.delegate = self
                    myPickerController.sourceType = .photoLibrary
                    myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
                    self.currentVC?.present(myPickerController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    //MARK: - FILE PICKER
    func documentPicker(){
        let importMenu = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String, kUTTypeText  as String, kUTTypePlainText as String, "com.microsoft.word.doc"], in: .import)//UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String, kUTTypeZipArchive  as String, kUTTypePNG as String, kUTTypeJPEG as String, kUTTypeText  as String, kUTTypePlainText as String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        currentVC?.present(importMenu, animated: true, completion: nil)
    }
    
    //MARK: - SETTINGS ALERT
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType){
        DispatchQueue.main.async { [self] in
            var alertTitle: String = ""
            if attachmentTypeEnum == AttachmentType.camera{
                alertTitle = Constants.alertForCameraAccessMessage
            }
            if attachmentTypeEnum == AttachmentType.photoLibrary{
                alertTitle = Constants.alertForPhotoLibraryMessage
            }
            if attachmentTypeEnum == AttachmentType.video{
                alertTitle = Constants.alertForVideoLibraryMessage
            }
            
            let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: Constants.settingsBtnTitle, style: .destructive) { (_) -> Void in
                let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: Constants.cancelBtnTitle, style: .default, handler: nil)
            cameraUnavailableAlertController .addAction(cancelAction)
            cameraUnavailableAlertController .addAction(settingsAction)
            currentVC?.present(cameraUnavailableAlertController , animated: true, completion: nil)
        }
    }
}

//MARK: - IMAGE PICKER DELEGATE
// This is responsible for image picker interface to access image, video and then responsibel for canceling the picker
extension AttachmentHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        if let image = info[.originalImage] as? UIImage//info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage)] as? UIImage
        //            {
        //            self.imagePickedBlock?(image)
        //        } else{
        //            print("Something went wrong in image")
        //        }
        //
        //
        //
        //        if let videoUrl = info[.mediaURL] as? NSURL{
        //            print("videourl: ", videoUrl)
        //            //trying compression of video
        //            let data = NSData(contentsOf: videoUrl as URL)!
        //            print("File size before compression: \(Double(data.length / 1048576)) mb")
        //            compressWithSessionStatusFunc(videoUrl)
        //        }
        //        else{
        //            print("Image is uploading")
        //        }
        currentVC?.dismiss(animated: true, completion: {
            if let image = info[.originalImage] as? UIImage//info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage)] as? UIImage
            {
                self.imagePickedBlock?(image)
            } else{
                print("Something went wrong in image")
            }
            
            
            
            if let videoUrl = info[.mediaURL] as? NSURL{
                print("videourl: ", videoUrl)
                //trying compression of video
                let data = NSData(contentsOf: videoUrl as URL)!
                print("File size before compression: \(Double(data.length / 1048576)) mb")
                self.compressWithSessionStatusFunc(videoUrl)
            }
            else{
                print("Image is uploading")
            }
        })
        //        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    //    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //            // process the selected single image, we don't want to process multiple images
    //
    //    }
    
    //MARK: Video Compressing technique
    fileprivate func compressWithSessionStatusFunc(_ videoUrl: NSURL) {
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MOV")
        compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                
                DispatchQueue.main.async {
                    self.videoPickedBlock?(compressedURL as NSURL)
                }
                
            case .failed:
                break
            case .cancelled:
                break
            @unknown default:
                print("Switch error")
            }
        }
    }
    
    // Now compression is happening with medium quality, we can change when ever it is needed
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset1280x720) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}

//MARK: - FILE IMPORT DELEGATE
extension AttachmentHandler: UIDocumentMenuDelegate, UIDocumentPickerDelegate{
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        currentVC?.present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("url", url)
        self.filePickedBlock?(url)
    }
    
    //    Method to handle cancel action.
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
}
