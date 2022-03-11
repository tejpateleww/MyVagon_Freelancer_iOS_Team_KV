//
//  shipperDetailsVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/08/21.
//

import UIKit
import Charts
import Cosmos

class shipperDetailsVC: BaseViewController, ChartViewDelegate {
    
    let barChart = HorizontalBarChartView()
    @IBOutlet weak var viewHorizontalChart: UIView!
    @IBOutlet weak var tblShipperDetails: UITableView!
    @IBOutlet weak var tblShipperDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var vwRadius: UIView!
    @IBOutlet weak var btnShipper: UIButton!
    @IBOutlet weak var lblTotalReview: themeLabel!
    @IBOutlet weak var lblTotalRating: UILabel!
    @IBOutlet weak var viewTotalRating: CosmosView!
    @IBOutlet weak var lblPercentage5: themeLabel!
    @IBOutlet weak var lblPercentage4: themeLabel!
    @IBOutlet weak var lblPercentage3: themeLabel!
    @IBOutlet weak var lblPercentage2: themeLabel!
    @IBOutlet weak var lblPercentage1: themeLabel!
    
    var shipperData: ReviewResModel?
    var shipperViewModel = ShipperDetailViewModel()
    var arrRating = [0,0,0,0,0]
    var arrData : [Review] = []
    var shipperId = ""
    var isTblReload = false
    var isLoading = true {
        didSet {
            self.tblShipperDetails.isUserInteractionEnabled = !isLoading
            self.tblShipperDetails.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupdata()
        self.setUpUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setChartData()
    }
    
    func setupdata(){
        tblShipperDetails.delegate = self
        tblShipperDetails.dataSource = self
        tblShipperDetails.reloadData()
        barChart.delegate = self
        tblShipperDetails.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        let nib3 = UINib(nibName: NoDataTableViewCell.className, bundle: nil)
        self.tblShipperDetails.register(nib3, forCellReuseIdentifier: NoDataTableViewCell.className)
        self.callWebService()
    }
    
    func setUpUI(){
        setUpBarChart()
        vwRadius.layer.cornerRadius = 10
        btnShipper.layer.cornerRadius = 10
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Shipper Details", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        tblShipperDetails.separatorStyle = .none
    }
    
    @IBAction func btnChatShipperClick(_ sender: Any) {
        let controller = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: ChatListVC.storyboardID) as! ChatListVC
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let info = object, let collObj = info as? UITableView{
            if collObj == self.tblShipperDetails{
                self.tblShipperDetailsHeight.constant = tblShipperDetails.contentSize.height
            }
        }
    }
    fileprivate func setUpBarChart() {
        barChart.animate(yAxisDuration: 1.0)
        barChart.animate(xAxisDuration: 1.0)
        barChart.pinchZoomEnabled = false
        barChart.doubleTapToZoomEnabled = false
        barChart.leftAxis.drawLabelsEnabled = false
        barChart.legend.enabled = false
        barChart.leftAxis.drawGridLinesEnabled = false
        barChart.rightAxis.drawGridLinesEnabled = false
        
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.drawGridBackgroundEnabled = false
        barChart.rightAxis.drawLabelsEnabled =  false
      
        barChart.xAxis.enabled = false
        barChart.leftAxis.enabled = false
        barChart.rightAxis.enabled = false
        barChart.drawBordersEnabled = false
        barChart.minOffset = 0
        
        
        // bottom  underline of view
        
        let frame = CGRect(x: 0, y: barChart.frame.size.height - 1, width: barChart.frame.size.width
                           , height: 1)
        let border = UIView(frame: frame)
        border.backgroundColor = UIColor.init(hexString: "#9B51E0")
        barChart.addSubview(border)
    }
    func setChartData(){
        barChart.frame =  CGRect(x: 0, y: 0, width: self.viewHorizontalChart.frame.size.width, height: self.viewHorizontalChart.frame.size.height)
        barChart.drawBordersEnabled = true
        barChart.borderColor = .clear
        barChart.backgroundColor = .clear
        barChart.gridBackgroundColor = .clear
        viewHorizontalChart.addSubview(barChart)
        var entries =  [BarChartDataEntry]()

        for (ind,x) in arrRating.enumerated() {
           entries.append(BarChartDataEntry(x: Double(ind), y: Double(x)))
       }
        barChart.animate(xAxisDuration: 0.0, yAxisDuration: 1)
        let set =  BarChartDataSet(entries:entries)
        set.drawValuesEnabled = false
        set.colors  = [ChartColorTemplates.colorFromString("#9B51E0").withAlphaComponent(0.15),
                       ChartColorTemplates.colorFromString("#9B51E0").withAlphaComponent(0.32),
                       ChartColorTemplates.colorFromString("#9B51E0").withAlphaComponent(0.49),
                       ChartColorTemplates.colorFromString("#9B51E0").withAlphaComponent(0.71),
                       ChartColorTemplates.colorFromString("#9B51E0").withAlphaComponent(1.0)]
        let data =  BarChartData(dataSet: set)
        barChart.data = data
        self.lblTotalReview.text = "Reviews \(self.arrData.count)"
    }
}
extension shipperDetailsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrData.count > 0 {
            return arrData.count
        }else{
            return (!self.isTblReload) ? 10 : 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !self.isTblReload{
            let cell:ShipperDetailsCell = tblShipperDetails.dequeueReusableCell(withIdentifier: ShipperDetailsCell.className) as! ShipperDetailsCell
            cell.selectionStyle = .none
            cell.viewRating.isHidden = true
            return cell
        }else{
            if arrData.count > 0{
                let cell:ShipperDetailsCell = tblShipperDetails.dequeueReusableCell(withIdentifier: ShipperDetailsCell.className) as! ShipperDetailsCell
                cell.selectionStyle = .none
                cell.setUpData(data: self.arrData[indexPath.row])
                return cell
            }else{
                let NoDatacell = self.tblShipperDetails.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                NoDatacell.lblNoDataTitle.text = "No Reviews Found"
                NoDatacell.imgNoData.image = UIImage(named: "ic_deselected")
                return NoDatacell
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemBackground)
        } else {
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: UIColor.lightGray.withAlphaComponent(0.3))
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (!isTblReload){
            return UITableView.automaticDimension
        }else{
            if(arrData.count > 0){
                return UITableView.automaticDimension
            }else{
                return 200//tableView.frame.height
            }
        }
    }
}
// Web Services
extension shipperDetailsVC{
    
    func callWebService(){
        self.shipperViewModel.shipperDetailVC = self
        self.shipperViewModel.callWebServiceForShipperDetail()
    }
    
    func calculateRating(){
        self.lblTotalRating.text = "\(self.shipperData?.data?.shipperRating ?? 0)/5"
        self.viewTotalRating.rating = Double(self.shipperData?.data?.shipperRating ?? 0)
        if arrData.count > 0{
            self.lblPercentage1.text = "\(((self.shipperData?.data?.oneStarRatingCount ?? 0) * 100) / arrData.count) %"
            self.lblPercentage2.text = "\(((self.shipperData?.data?.twoStarRatingCount ?? 0) * 100) / arrData.count) %"
            self.lblPercentage3.text = "\(((self.shipperData?.data?.threeStarRatingCount ?? 0) * 100) / arrData.count) %"
            self.lblPercentage4.text = "\(((self.shipperData?.data?.fourStarRatingCount ?? 0) * 100) / arrData.count) %"
            self.lblPercentage5.text = "\(((self.shipperData?.data?.fiveStarRatingCount ?? 0) * 100) / arrData.count) %"
        }
    }
}
