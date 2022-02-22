//
//  AboutUsVC.swift
//  MyVagon
//
//  Created by Tej P on 22/02/22.
//

import UIKit
import SafariServices

class AboutUsVC: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var tblDataHeight: NSLayoutConstraint!
    var arrData : [String] = []
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preapreView()
    }
    
    //MARK: - Custom methods
    func preapreView(){
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        self.tblData.delegate = self
        self.tblData.dataSource = self
        self.tblData.separatorStyle = .none
        self.tblData.showsVerticalScrollIndicator = false
        self.tblData.showsHorizontalScrollIndicator = false
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "About MYVAGON", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        self.registerNib()
        
    }
    
    func setupData(){
        self.arrData = ["Privacy Policy","Terms and Conditions","About us"]
        self.tblData.reloadData()
    }
    
    func registerNib(){
        let nib2 = UINib(nibName: AboutCell.className, bundle: nil)
        self.tblData.register(nib2, forCellReuseIdentifier: AboutCell.className)
    }
    
    func previewDocument(strURL : String){
        guard let url = URL(string: strURL) else {return}
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
}


//MARK: - UITableView Delegate and Data Sourse Methods
extension AboutUsVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblData.dequeueReusableCell(withIdentifier: AboutCell.className) as! AboutCell
        cell.selectionStyle = .none
        cell.lblCategory.text = self.arrData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.arrData.count > 0){
            switch(indexPath.row){
            case 0 :
                let Link = SingletonClass.sharedInstance.initResModel?.privacyPolicy ?? ""
                self.previewDocument(strURL: Link)
                break
            case 1 :
                let Link = SingletonClass.sharedInstance.initResModel?.termsAndCondition ?? ""
                self.previewDocument(strURL: Link)
                break
            case 2 :
                let Link = SingletonClass.sharedInstance.initResModel?.aboutUs ?? ""
                self.previewDocument(strURL: Link)
                break
            default : break
            }
        }
    }
    
}
