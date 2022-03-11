//
//  LocationDetailVC.swift
//  MyVagon
//
//  Created by Dhanajay  on 08/03/22.
//

import UIKit

class LocationDetailVC: BaseViewController {

    
    @IBOutlet weak var lblTitleName: themeLabel!
    @IBOutlet weak var collectionAmenities: UICollectionView!
    @IBOutlet weak var collectionAmernitiesHeight: NSLayoutConstraint!
    var arrData = ["","","","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    func setupUI(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Shipper Details", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        self.lblTitleName.text = "Dodoni S.A."
        self.collectionAmenities.isScrollEnabled = false
    }
    
    func setupData(){
        self.collectionAmenities.dataSource = self
        self.collectionAmenities.delegate = self
        let uploadnib = UINib(nibName: AmenitiesCell.className, bundle: nil)
        self.collectionAmenities.register(uploadnib, forCellWithReuseIdentifier: AmenitiesCell.className)
        collectionAmernitiesHeight.constant = collectionAmenities.collectionViewLayout.collectionViewContentSize.height
        self.collectionAmenities.reloadData()
    }
}
extension LocationDetailVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionAmenities.dequeueReusableCell(withReuseIdentifier: AmenitiesCell.className, for: indexPath)as! AmenitiesCell
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2 - 10, height: 50)
    }
}

//MARK: - Web services
extension LocationDetailVC {
    
}
