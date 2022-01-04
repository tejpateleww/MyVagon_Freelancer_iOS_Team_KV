//
//  PostTruckViewModel.swift
//  MyVagon
//
//  Created by Apple on 19/08/21.
//

import Foundation
import UIKit
import FittedSheets
class PostTruckViewModel {
    weak var postTruckViewController : PostTruckViewController? = nil
    
    func PostAvailability(ReqModel:PostTruckReqModel){
        Utilities.ShowLoaderButtonInButton(Button: self.postTruckViewController?.BtnPostATruck ?? themeButton(), vc: self.postTruckViewController ?? UIViewController())
       
        
        WebServiceSubClass.PostTruck(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.postTruckViewController?.BtnPostATruck ?? themeButton(), vc: self.postTruckViewController ?? UIViewController())
            
            if status {
                
                let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: CommonAcceptRejectPopupVC.storyboardID) as! CommonAcceptRejectPopupVC
                
                let DescriptionAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1), NSAttributedString.Key.font: CustomFont.PoppinsMedium.returnFont(16)] as [NSAttributedString.Key : Any]
                
                let AttributedStringFinal = "You have ".Medium(color: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1), FontSize: 18)
              
                AttributedStringFinal.append("successfully".Medium(color: #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1), FontSize: 18))
                AttributedStringFinal.append(" posted your availability".Medium(color: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1), FontSize: 18))
              
                controller.TitleAttributedText = AttributedStringFinal
                
                
                
                if (response?.data?.count ?? 0) == 0 {
                    controller.DescriptionAttributedText = NSAttributedString(string: "No Matches Found", attributes: DescriptionAttribute)
                    controller.IsHideImage = true
                    controller.LeftbtnTitle = ""
                    controller.RightBtnTitle = "Okay"
                } else {
                    controller.DescriptionAttributedText = NSAttributedString(string: "\(response?.data?.count ?? 0) Matches Found", attributes: DescriptionAttribute)
                    controller.IsHideImage = true
                    controller.LeftbtnTitle = "Dismiss"
                    controller.RightBtnTitle = "Yes"
                }
      
                controller.modalPresentationStyle = .overCurrentContext
                controller.modalTransitionStyle = .coverVertical
                controller.LeftbtnClosour = {
                    controller.dismiss(animated: true, completion: {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
                    self.postTruckViewController?.navigationController?.popToRootViewController(animated: false)
                    })
                }
                controller.RightbtnClosour = {
                    controller.dismiss(animated: true, completion: {
                        if ( response?.data?.count ?? 0) == 0 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
                            self.postTruckViewController?.navigationController?.popToRootViewController(animated: false)
                        } else {
                            
                            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: PostedTruckBidsViewController.storyboardID) as! PostedTruckBidsViewController
                            controller.NumberOfCount = response?.data?.count ?? 0

                            controller.hidesBottomBarWhenPushed = true
                            controller.PostTruckID = "\(response?.data?.id ?? 0)"
                 
                            if var vcArray = self.postTruckViewController?.navigationController?.viewControllers {
                                vcArray.removeLast()
                                vcArray.append(controller)
                                self.postTruckViewController?.navigationController?.setViewControllers(vcArray, animated: false)
                            }
                       
                        }
                        
                    })
                   
                }
                let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(250) + appDel.GetSafeAreaHeightFromBottom())])
                self.postTruckViewController?.present(sheetController, animated: true, completion: nil)
                
               
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    func GetAttributedString(ChangeColor:String,String:String) -> NSMutableAttributedString {
      
        let rangeString = (String as NSString).range(of: String)
      
        let changeDiffColor = (String as NSString).range(of: ChangeColor)

        let OtherAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1), NSAttributedString.Key.font: CustomFont.PoppinsMedium.returnFont(18)] as [NSAttributedString.Key : Any]
        
        
        let ChangeDiffAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1), NSAttributedString.Key.font: CustomFont.PoppinsMedium.returnFont(18)] as [NSAttributedString.Key : Any]
        
        
         let attributedString = NSMutableAttributedString(string:String)
        attributedString.addAttributes(OtherAttribute, range: rangeString)
        
        attributedString.addAttributes(ChangeDiffAttribute, range: changeDiffColor)
        
        return attributedString
    }
}
