//
//  LocationDetailVC.swift
//  MyVagon
//
//  Created by Dhanajay  on 08/03/22.
//

import UIKit

class SearchLocationVC: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var lblTitleName: themeLabel!
    @IBOutlet weak var lblAdderss: themeLabel!
    @IBOutlet weak var lblNote: themeLabel!
    @IBOutlet weak var lblPhoneNumber: themeLabel!
    @IBOutlet weak var viewShipperNote: UIView!
    @IBOutlet weak var viewAmernities: UIView!
    @IBOutlet weak var collectionAmenities: UICollectionView!
    @IBOutlet weak var collectionAmernitiesHeight: NSLayoutConstraint!
    @IBOutlet weak var lblAmenities: themeLabel!
    @IBOutlet weak var lblContect: themeLabel!
    @IBOutlet weak var lblShipperNotes: themeLabel!
    
    var locationId = ""
    var locationDetailViewModel = LocationDetailViewModel()
    var responceData: LocationDetailResModel?
    
    //MARK: - Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
    }
    
    //MARK: - Custom methods
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization() {
        self.lblShipperNotes.text = "Shipper Notes".localized
        self.lblContect.text = "Contact".localized
        self.lblAmenities.text = "Amenities".localized
    }
    
    func setupUI(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Location Details".localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        self.collectionAmenities.isScrollEnabled = false
    }
    
    func setupData(){
        self.collectionAmenities.dataSource = self
        self.collectionAmenities.delegate = self
        let uploadnib = UINib(nibName: AmenitiesCell.className, bundle: nil)
        self.collectionAmenities.register(uploadnib, forCellWithReuseIdentifier: AmenitiesCell.className)
        self.collectionAmenities.reloadData()
        self.callWebService()
    }
    
    func refressData(){
        self.lblNote.text = responceData?.data?.note ?? ""
        self.lblTitleName.text = responceData?.data?.name ?? ""
        self.lblPhoneNumber.text = responceData?.data?.phone ?? ""
        self.lblAdderss.text = responceData?.data?.address ?? ""
        self.viewShipperNote.isHidden = lblNote.text == ""
        self.viewAmernities.isHidden = responceData?.data?.addressAmenities?.count == 0
        self.collectionAmenities.reloadData()
        self.collectionAmernitiesHeight.constant = collectionAmenities.collectionViewLayout.collectionViewContentSize.height
    }
}

//MARK: - UICollectionView Delegate and Data Source Methods
extension SearchLocationVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responceData?.data?.addressAmenities?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionAmenities.dequeueReusableCell(withReuseIdentifier: AmenitiesCell.className, for: indexPath)as! AmenitiesCell
            cell.setupData(data: responceData?.data?.addressAmenities?[indexPath.row])
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2 - 10, height: 50)
    }
}

//MARK: - Web services
extension SearchLocationVC {
    func callWebService(){
        self.locationDetailViewModel.locationDetailVC = self
        self.locationDetailViewModel.callWebServiceForLocationDetail()
    }
}
