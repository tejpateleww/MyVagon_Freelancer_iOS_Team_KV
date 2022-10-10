//
//  HeaderOfLocationsTbl.swift
//  MyVagon
//


import UIKit
import UIView_Shimmer

class HeaderOfLocationsTbl: UITableViewHeaderFooterView,ShimmeringViewProtocol {

    //MARK: - Propertise
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblStatus: themeLabel!
    @IBOutlet weak var vwStatusShimmer: UIView!
    @IBOutlet weak var conHeightOfViewBidStatus: NSLayoutConstraint!
    @IBOutlet weak var LblShipperName: themeLabel!
    @IBOutlet weak var lblBidStatus: themeLabel!
    @IBOutlet weak var ViewStatusBidText: themeLabel!
    @IBOutlet weak var lblPrice: themeLabel!
    @IBOutlet weak var lblbookingID: themeLabel!
    @IBOutlet weak var lblDeadheadWithTruckType: themeLabel!
    @IBOutlet weak var lblWeightAndDistance: themeLabel!
    @IBOutlet weak var viewStatusBid: UIView!
    
    var bidStatus = BidStatus.all.rawValue
    var shimmeringAnimatedItems: [UIView]{
        [
            LblShipperName,
            viewStatusBid,
            lblbookingID,
            lblWeightAndDistance,
            lblDeadheadWithTruckType,
            lblPrice,
            vwStatusShimmer,
            lblBidStatus
        ]
    }
    
    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
        viewStatusBid.layer.cornerRadius = viewStatusBid.frame.height / 2
        viewStatusBid.clipsToBounds = true
        viewStatus.roundCornerssingleSide(corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        lblBidStatus.text = ""
    }
}
