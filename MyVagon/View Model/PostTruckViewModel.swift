//
//  PostTruckViewModel.swift
//  MyVagon
//
//  Created by Apple on 19/08/21.
//

import Foundation
import UIKit
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
      
                controller.DescriptionAttributedText = NSAttributedString(string: response?.data?.matches ?? "", attributes: DescriptionAttribute)
                controller.IsHideImage = true
                controller.LeftbtnTitle = "Dismiss"
                controller.RightBtnTitle = "Yes"
              
                controller.modalPresentationStyle = .overCurrentContext
                controller.modalTransitionStyle = .coverVertical
                controller.LeftbtnClosour = {
                    appDel.NavigateToHome()
                }
                controller.RightbtnClosour = {
                    appDel.NavigateToHome()
                }
                self.postTruckViewController?.present(controller, animated: false, completion:  {

                    
                    controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)

                })
                
                // Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
               // appDel.NavigateToHome()
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
extension String {
    func Bold(color:UIColor,FontSize:CGFloat)-> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : CustomFont.PoppinsBold.returnFont(FontSize),
            .foregroundColor : color
        ]
        return NSMutableAttributedString(string: self, attributes:attributes)
    }
    
    func Medium(color:UIColor,FontSize:CGFloat)-> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : CustomFont.PoppinsMedium.returnFont(FontSize),
            .foregroundColor : color
        ]
        return NSMutableAttributedString(string: self, attributes:attributes)
    }
    
    func Regular(color:UIColor,FontSize:CGFloat)-> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : CustomFont.PoppinsRegular.returnFont(FontSize),
            .foregroundColor : color
        ]
        return NSMutableAttributedString(string: self, attributes:attributes)
    }

}
