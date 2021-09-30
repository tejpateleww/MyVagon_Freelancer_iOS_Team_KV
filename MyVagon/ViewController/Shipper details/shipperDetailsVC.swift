//
//  shipperDetailsVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/08/21.
//

import UIKit
import Charts

class shipperDetailsVC: BaseViewController, ChartViewDelegate {
    let barChart = HorizontalBarChartView()
    @IBOutlet weak var viewHorizontalChart: UIView!
    @IBOutlet weak var tblShipperDetails: UITableView!
    @IBOutlet weak var tblShipperDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var vwRadius: UIView!
    @IBOutlet weak var btnShipper: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarChart()
        vwRadius.layer.cornerRadius = 10
        btnShipper.layer.cornerRadius = 10
        tblShipperDetails.delegate = self
        tblShipperDetails.dataSource = self
        tblShipperDetails.reloadData()
        barChart.delegate = self
        tblShipperDetails.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Shipper Details", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        barChart.frame =  CGRect(x: 0, y: 0, width: self.viewHorizontalChart.frame.size.width, height: self.viewHorizontalChart.frame.size.height)
        barChart.drawBordersEnabled = true
        barChart.borderColor = .clear
        barChart.backgroundColor = .clear
        barChart.gridBackgroundColor = .clear
        viewHorizontalChart.addSubview(barChart)
         var entries =  [BarChartDataEntry]()

        for x in 1...5 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
        }
        barChart.animate(xAxisDuration: 0.0, yAxisDuration: 1)
        let set =  BarChartDataSet(entries:entries)
        
        set.colors  = [ChartColorTemplates.colorFromString("#9B51E0").withAlphaComponent(0.15),
                       ChartColorTemplates.colorFromString("#9B51E0").withAlphaComponent(0.32),
                       ChartColorTemplates.colorFromString("#9B51E0").withAlphaComponent(0.49),
                       ChartColorTemplates.colorFromString("#9B51E0").withAlphaComponent(0.71),
                       ChartColorTemplates.colorFromString("#9B51E0").withAlphaComponent(1.0)]
        let data =  BarChartData(dataSet: set)
        barChart.data = data

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
}
extension shipperDetailsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ShipperDetailsCell = tblShipperDetails.dequeueReusableCell(withIdentifier: ShipperDetailsCell.className) as! ShipperDetailsCell
        cell.selectionStyle = .none
        return cell
    }
}
