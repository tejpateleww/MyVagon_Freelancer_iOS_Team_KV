//
//  ViewPODViewController.swift
//  MyVagon
//
//  Created by Apple on 23/12/21.
//

import UIKit
import SDWebImage
class ViewPodVC: BaseViewController {
    
    //MARK: - Propertise
    @IBOutlet weak var podImageView: UIImageView!

    var imageURl = ""
    var customTabBarController: CustomTabBarVC?
    
    //MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "POD".localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        let strUrl = "\(APIEnvironment.PODImageURL)\(imageURl)"
        podImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        podImageView.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
}
