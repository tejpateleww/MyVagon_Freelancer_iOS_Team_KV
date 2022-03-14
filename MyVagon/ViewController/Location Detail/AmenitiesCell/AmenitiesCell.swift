//
//  AmenitiesCell.swift
//  MyVagon
//
//  Created by Dhanajay  on 08/03/22.
//

import UIKit

class AmenitiesCell: UICollectionViewCell {

    @IBOutlet weak var lblName: themeLabel!
    @IBOutlet weak var lblValue: themeLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupData(data: AddressAmenities?){
        self.lblName.text = data?.name
        self.lblValue.text = (data?.flag == 0) ? "No" : "Yes"
        self.lblValue.fontColor = ((data?.flag == 0) ? colors.red.value : UIColor(named: "ThemeGreenColor")) ?? .green
    }

}
