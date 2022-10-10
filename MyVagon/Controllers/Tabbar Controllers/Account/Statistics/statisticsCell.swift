//
//  statisticsCell.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/08/21.
//

import UIKit

class statisticsCell: UITableViewCell {
    
    //MARK: - Propertise
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblDetails: themeLabel!
    @IBOutlet weak var imgGreater: UIImageView!
    
    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Custom method
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
