//
//  TypeColCell.swift
//  MyVagon
//
//  Created by Dhanajay  on 23/06/22.
//

import UIKit
import UIView_Shimmer

class TypesColCell : UICollectionViewCell,ShimmeringViewProtocol {
    @IBOutlet weak var lblTypes: themeLabel!
    @IBOutlet weak var BGView: UIView!
    var shimmeringAnimatedItems: [UIView]{
        [BGView]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTypes.textColor = UIColor.appColor(.themeButtonBlue)
        BGView.layer.cornerRadius = 17
        BGView.layer.borderWidth = 1
        BGView.backgroundColor = .clear
        BGView.layer.borderColor = UIColor.appColor(.themeButtonBlue).cgColor
    }
}
