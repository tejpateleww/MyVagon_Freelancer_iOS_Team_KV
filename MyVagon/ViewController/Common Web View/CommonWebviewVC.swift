//
//  CommonWebviewVC.swift
//  MyVagon
//
//  Created by Apple on 02/08/21.
//

import UIKit
import WebKit

class CommonWebviewVC: BaseViewController,WKNavigationDelegate {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
 
    var customTabBarController: CustomTabBarVC?
    var strUrl = "http://13.36.112.48/"
    private let webView = WKWebView(frame: .zero)
    var strNavTitle = ""
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var vwWebMain: UIView!

    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
        setUp()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUp() {
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: strNavTitle, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        webView.backgroundColor = .clear
     
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.webView)
        NSLayoutConstraint.activate([
            self.webView.leftAnchor.constraint(equalTo: self.vwWebMain.leftAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.vwWebMain.bottomAnchor),
            self.webView.rightAnchor.constraint(equalTo: self.vwWebMain.rightAnchor),
            self.webView.topAnchor.constraint(equalTo: self.vwWebMain.topAnchor),
        ])
        self.webView.backgroundColor = .clear
        self.view.setNeedsLayout()
        let request = URLRequest(url: URL.init(string: "\(strUrl)")!)
        self.webView.navigationDelegate = self
     //   webView.scrollView.isScrollEnabled = false
//        webView.scrollView.bounces = false
       // webView.isUserInteractionEnabled = false
        self.webView.load(request)
       
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //Utilities.showHud()
    }
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)

    }
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       // Utilities.hideHud()
    }

    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    

}



