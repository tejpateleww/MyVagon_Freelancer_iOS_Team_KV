//
//  AmenitiesCell.swift
//  MyVagon
//
//  Created by Dhanajay  on 08/03/22.
//

import UIKit

class AmenitiesCell: UICollectionViewCell {

    //MARK: - Propertise
    @IBOutlet weak var lblName: themeLabel!
    @IBOutlet weak var lblValue: themeLabel!
    
    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Custom method
    func setupData(data: AddressAmenities?){
        self.lblName.text = data?.name
        self.lblValue.text = (data?.flag == 0) ? "No".localized : "Yes".localized
        self.lblValue.fontColor = ((data?.flag == 0) ? colors.red.value : UIColor(named: "ThemeGreenColor")) ?? .green
    }
}
