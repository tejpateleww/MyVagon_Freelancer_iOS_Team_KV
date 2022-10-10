//
//  TrackingCell.swift
//  MyVagon
//
//  Created by Tej P on 20/05/22.
//

import UIKit

class TrackingCell: UICollectionViewCell {
    
    //MARK: - Propertise
    @IBOutlet weak var imgRadio: UIImageView!
    @IBOutlet weak var imgRadioWidth: NSLayoutConstraint!
    @IBOutlet weak var imgTruck: UIImageView!

    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
