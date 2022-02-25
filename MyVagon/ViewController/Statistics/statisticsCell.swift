//
//  statisticsCell.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/08/21.
//

import UIKit

class statisticsCell: UITableViewCell {
    
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblDetails: themeLabel!
    @IBOutlet weak var imgGreater: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(data: StatisticListData){
        let color = UIColor(hexString: "#\(data.color ?? "")")
        self.vwMain.backgroundColor =  UIColor(hexString: "#\(data.color ?? "")").withAlphaComponent(0.13)
        self.lblNumber.font = CustomFont.PoppinsBold.returnFont(40)
        self.lblNumber.text = String(data.value ?? "0.0").uppercased()
        self.lblNumber.textColor = color
        self.lblDetails.text = data.name?.uppercased()
        self.lblDetails.fontColor = color
        self.imgGreater.tintColor = color
    }
}
