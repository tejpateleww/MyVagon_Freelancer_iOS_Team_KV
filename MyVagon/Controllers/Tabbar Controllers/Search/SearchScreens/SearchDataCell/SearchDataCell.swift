//
//  SearchDataCell.swift
//  MyVagon
//
//  Created by Tej P on 01/02/22.
//

import UIKit

class SearchDataCell: UITableViewCell {
    
    //MARK: - Propertise
    @IBOutlet weak var vWContents: UIView!
    @IBOutlet weak var lblCompanyName: themeLabel!
    @IBOutlet weak var lblAmount: themeLabel!
    @IBOutlet weak var lblLoadId: themeLabel!
    @IBOutlet weak var lblTonMiles: themeLabel!
    @IBOutlet weak var lblDeadhead: themeLabel!
    @IBOutlet weak var tblSearchLocation: UITableView!
    @IBOutlet weak var tblSearchLocationHeight: NSLayoutConstraint!
    @IBOutlet weak var vWStatus: UIView!
    @IBOutlet weak var lblStatus: themeLabel!
    @IBOutlet weak var btnMainTap: UIButton!
    
    var arrLocations : [SearchLocation] = []
    var tblHeight:((CGFloat)->())?
    var btnMainTapCousure : (()->())?
    
    //MARK: - Life cycle method
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.vWStatus.roundCornerssingleSide(corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        self.vWContents.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.vWContents.layer.masksToBounds = false
        self.vWContents.layer.shadowRadius = 4
        self.vWContents.layer.borderColor = UIColor.black.cgColor
        self.vWContents.layer.cornerRadius = 15
        self.vWContents.layer.shadowOpacity = 0.1
        self.tblSearchLocation.delegate = self
        self.tblSearchLocation.dataSource = self
        self.tblSearchLocation.separatorStyle = .none
        self.tblSearchLocation.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        self.registerNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.tblSearchLocationHeight.constant = newsize.height
            }
        }
    }
    
    //MARK: - Custom method
    func registerNib(){
        let nib = UINib(nibName: SearchLocationCell.className, bundle: nil)
        self.tblSearchLocation.register(nib, forCellReuseIdentifier: SearchLocationCell.className)
    }
    
    func setData(data: SearchLoadsDatum?){
        selectionStyle = .none
        lblCompanyName.text = data?.shipperDetails?.companyName ?? ""
        lblAmount.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (data?.amount ?? "" ) : ""
        lblLoadId.text = "#\(data?.id ?? 0)"
        lblTonMiles.text =   "\(data?.totalWeight ?? ""), \(data?.distance ?? "") Km"
        let DeadheadValue = (data?.trucks?.locations?.first?.deadhead ?? "" == "0") ? data?.trucks?.truckType?.name ?? "" : "\(data?.trucks?.locations?.first?.deadhead ?? "") : \(data?.trucks?.truckType?.name ?? "")"
        lblDeadhead.text = DeadheadValue
        if (data?.isBid ?? 0) == 1 {
            lblStatus.text = bidStatus.BidNow.Name.localized
            vWStatus.backgroundColor = #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
        } else {
            lblStatus.text = bidStatus.BookNow.Name.localized
            vWStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
        }
        arrLocations = data?.trucks?.locations ?? []
        tblSearchLocation.reloadData()
        tblSearchLocation.layoutIfNeeded()
        tblSearchLocation.layoutSubviews()
    }
    
    //MARK: - IBAction method
    @IBAction func btnMainTapAction(_ sender: Any) {
        if let obj = self.btnMainTapCousure{
            obj()
        }
    }
    
}

//MARK: - UITableView Delegate and Data Source Methods
extension SearchDataCell : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSearchLocation.dequeueReusableCell(withIdentifier: SearchLocationCell.className) as! SearchLocationCell
        cell.setData(data: self.arrLocations[indexPath.row])
        if(indexPath.row == (self.arrLocations.count - 1)){
            cell.viewLine.isHidden = true
        }
        if(indexPath.row == 0){
            cell.imgLocation.image = UIImage(named: "ic_PickUp")
        }else if(indexPath.row == (self.arrLocations.count) - 1){
            cell.imgLocation.image = UIImage(named: "ic_DropOff")
        }else{
            cell.imgLocation.image = UIImage(named: "ic_pickDrop")
            cell.viewHorizontalLine.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
