//
//  PickLoadCell.swift
//  MyVagon
//
//  Created by Apple on 07/09/21.
//

import UIKit
import UIView_Shimmer

class PickLoadCell: UITableViewCell,ShimmeringViewProtocol {
    
    //MARK: - Propertise
    @IBOutlet weak var lblProductName: themeLabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var btnNotes: themeButton!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    
    var weight = ""
    var capecity = ""
    var type = ""
    var viewNotesClosour:(()->())?
    var shimmeringAnimatedItems: [UIView]{
        [
            lblProductName,
            lblWeight,
            btnNotes
        ]
    }
    
    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
        btnNotes.addTarget(self, action: #selector(btnViewNotes(_:)), for: .touchUpInside)
        self.viewStatus.roundCornerssingleSide(corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        self.btnNotes.setTitle("Notes".localized, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Custom method
    func setText(){
        let text = "\(weight)\(capecity) \(type)"
        let attrStri = NSMutableAttributedString.init(string: text)
        let nsRange = NSString(string: text).range(of: "\(weight)\(capecity)", options: String.CompareOptions.caseInsensitive)
        let scRange = NSString(string: text).range(of: type, options: String.CompareOptions.caseInsensitive)
        attrStri.addAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12),NSAttributedString.Key.foregroundColor : UIColor(named: "ThemeGrayColor") as Any], range: nsRange)
        attrStri.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor(named: "ThemeTamotoColor") as Any], range: scRange)
        lblWeight.attributedText = attrStri
    }
    
    //MARK: - IBAction method
    @objc func btnViewNotes(_ sender:Any) {
        if let click = self.viewNotesClosour {
            click()
        }
    }
}
