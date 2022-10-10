//
//  ShipperDetailsCell.swift
//  MyVagon
//
//  Created by Harsh Dave on 26/08/21.
//

import UIKit
import Cosmos
class ShipperDetailsCell: UITableViewCell {

    //MARK: - Propertise
    @IBOutlet weak var lblName: themeLabel!
    @IBOutlet weak var lblDate: themeLabel!
    @IBOutlet weak var lblMassage: themeLabel!
    @IBOutlet weak var viewRating: CosmosView!
    
    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Custom method
    func setUpData(data: Review){
        self.viewRating.isHidden = false
        self.lblName.text = data.fromUserId?.name
        self.lblMassage.text = data.review
        self.viewRating.rating = Double(data.rating ?? 0)
        self.viewRating.isUserInteractionEnabled = false
        self.lblDate.text = data.createdAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd HH:mm:ss", ToFormat: DateFormatForDisplay)
    }
}
