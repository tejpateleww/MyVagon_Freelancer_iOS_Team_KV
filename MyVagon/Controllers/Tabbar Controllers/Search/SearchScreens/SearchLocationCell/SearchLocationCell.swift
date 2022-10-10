//
//  SearchLocationCell.swift
//  MyVagon
//
//  Created by Tej P on 01/02/22.
//

import UIKit

class SearchLocationCell: UITableViewCell {
    
    //MARK: - Propertise
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewHorizontalLine: DottedLineView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblCompanyName: themeLabel!
    @IBOutlet weak var lblAddress: themeLabel!
    @IBOutlet weak var lblDateTime: themeLabel!
    @IBOutlet weak var imgLocation: UIImageView!

    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Custom method
    func setData(data: SearchLocation?){
        selectionStyle = .none
        viewLine.isHidden = false
        viewHorizontalLine.isHidden = true
        lblCompanyName.text = data?.companyName
        lblAddress.text = data?.dropLocation
        var StringForDateTime = ""
        StringForDateTime.append("\(data?.deliveredAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay) ?? "")")
        StringForDateTime.append(" ")
        if (data?.deliveryTimeTo ?? "") == (data?.deliveryTimeFrom ?? "") {
            StringForDateTime.append("\(data?.deliveryTimeTo ?? "")")
        } else {
            StringForDateTime.append("\(data?.deliveryTimeFrom ?? "")-\(data?.deliveryTimeTo ?? "")")
        }
        lblDateTime.text = StringForDateTime
    }

}
