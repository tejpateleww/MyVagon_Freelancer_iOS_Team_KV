//
//  TruckCapacityCell.swift
//  MyVagon
//
//  Created by Dhanajay  on 23/06/22.
//

import UIKit
class TruckCapacityCell : UICollectionViewCell {
    @IBOutlet weak var lblCapacity: themeLabel!
    @IBOutlet weak var btnRemove: themeButton!
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var btnView: UIView!
    
    var RemoveClick : (() -> ())?
    
    override func awakeFromNib() {
        BGView.layer.cornerRadius = 17
        BGView.layer.borderWidth = 1
        BGView.backgroundColor = .clear
        BGView.layer.borderColor = UIColor.appColor(.themeButtonBlue).cgColor
        super.awakeFromNib()
    }
    
    @IBAction func btnRemoveClick(_ sender: themeButton) {
        if let click = RemoveClick {
            click()
        }
    }
}
