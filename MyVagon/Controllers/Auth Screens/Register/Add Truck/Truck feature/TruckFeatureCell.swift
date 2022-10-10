//
//  TruckFeatureCell.swift
//  MyVagon
//
//  Created by Dhanajay  on 04/03/22.
//

import UIKit

class TruckFeatureCell: UITableViewCell {
    
    //MARK: - Propertise
    @IBOutlet weak var vWContainer: UIView!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblFeature: UILabel!

    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Custom method
    func setupUI(){
        self.vWContainer.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.vWContainer.layer.masksToBounds = false
        self.vWContainer.layer.shadowRadius = 4
        self.vWContainer.layer.borderColor = UIColor.black.cgColor
        self.vWContainer.layer.cornerRadius = 15
        self.vWContainer.layer.shadowOpacity = 0.1
    }
    
}
