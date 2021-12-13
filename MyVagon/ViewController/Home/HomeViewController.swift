//
//  HomeViewController.swift
//  MyVagon
//
//  Created by Apple on 29/07/21.
//

import UIKit
import FSCalendar
import FittedSheets

class HomeViewController: BaseViewController, UITextFieldDelegate {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var isLoading = true {
        didSet {
            tblLocations.isUserInteractionEnabled = !isLoading
            tblLocations.reloadData()
        }
    }
    var PageNumber = 0
    var arrHomeData : [[SearchLoadsDatum]]?
    
    var isNeedToReload = false
    var homeViewModel = HomeViewModel()
    var arrStatus = ["All","Pending","Scheduled","In-Progress","Past"]
  
    var selectedIndex = 1
    
    var customTabBarController: CustomTabBarVC?
    var refreshControl = UIRefreshControl()
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var tblLocations: UITableView!
    @IBOutlet weak var conHeightOfCalender: NSLayoutConstraint!
    @IBOutlet weak var calender: ThemeCalender!
    @IBOutlet weak var collectionOfHistory: UICollectionView!
    
    @IBOutlet weak var TextFieldSearch: themeTextfield!
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLoading = true
        let latStr = String(21.298100)
            let   longStr = String(70.251404)
        
        
        
        
        
        
        
// "https://maps.googleapis.com/maps/api/directions/json?origin=Grodno&destination=Minsk&mode=driving&key=YOUR_API_KEY"
//        let staticMapUrl = "http://maps.google.com/maps/api/staticmap?markers=color:blue|\(latStr),\(longStr)&\("zoom=10&size=400x300")&sensor=true&key=\(AppInfo.Google_API_Key)"
        
        let staticMapUrl = "https://maps.googleapis.com/maps/api/staticmap?size=600x400&path=enc%3AohqfIc_jpCkE%7DCx%40mJdDa%5BbD%7BM%7D%40e%40_MgKiQuVOoFlF%7DVnCnBn%40aDlDkN%7DDwEt%40%7DM%7DB_TjBy%7C%40lEgr%40lMa%60BhSi%7C%40%7COmuAxb%40k%7BGh%5E_%7BFjRor%40%7CaAq%7DC~iAomDle%40i%7BA~d%40ktBbp%40%7DqCvoA%7DjHpm%40uuDzH%7Dm%40sAg%7DB%60Bgy%40%7CHkv%40tTsxAtCgl%40aBoeAwKwaAqG%7B%5CeBc_%40p%40aZx%60%40gcGpNg%7CBGmWa%5CgpFyZolF%7BFgcDyPy%7CEoK_%7BAwm%40%7BqFqZaiBoNsqCuNq%7BHk%60%40crG%7B%5DqkBul%40guC%7BJ%7D%5DaNo%7B%40waA%7DmFsLc_%40_V%7Dh%40icAopBcd%40i_A_w%40mlBwbAiiBmv%40ajDozBibKsZ%7DvAkLm%5DysAk%7DCyr%40i%60BqUkp%40mj%40uoBex%40koAk_E_hG%7B%60Ac%7DAwp%40soAyk%40ogAml%40%7Bg%40qKsNeJw%5DeuA%7D%60Fkm%40czBmK%7Bg%40wCed%40b%40_e%40dT%7BgCzx%40csJrc%40ejFtGi%60CnB_pFhCa%60Gw%40%7Du%40wFwaAmP%7BoA%7Dj%40etBsRm_AiGos%40aCyy%40Lic%40tFohA~NeoCvC_%7CAWm~%40gb%40w~DuLex%40mUk_Ae_%40o_Aol%40qmAgv%40_%7DAaf%40qhAkMcl%40mHwn%40iCuq%40Nqi%40pF%7D%7CE~CyiDmFkgAoUedAcb%40ku%40ma%40cl%40mUko%40sLwr%40mg%40awIoA_aApDe~%40dKytAfw%40kyFtCib%40%7DA%7Bj%40kd%40usBcRgx%40uFwb%40%7BCulAjJmbC~CumAuGwlA_%5Du_C_PqyB%7BI%7DiAwKik%40%7DUcr%40ya%40up%40%7DkB%7DoCoQ%7Da%40aMyf%40an%40wjEimBuwKiYybC%7DLuyBoJ%7DhBuMieAwd%40i%7BB%7B~%40g%60D_Si%5Dsi%40%7Bk%40cPeSuH_T%7DNct%40kNcmC_Gyr%40mq%40_~AkmA%7DkCksByrE_N%7Bc%40oAcs%40%60J%7Bi%40t%7DByaHxNqt%40tGgxA%7CJ%7BkGeJ_aDsQi_HmFwuAmI%7BdA_XijByFgv%40%7DAiwBxDocAdM%7BlAtSmcAfUmaAptAmbGh~AcvGbwBc%7DHff%40shB~Isp%40nQu%7DB%60UsuCbBok%40l%40%7DzAhIwbA~OuaAnYwp%40rYwe%40%7CNke%40zc%40%7BhBrOwRdo%40sf%40xNaTb_%40uy%40ta%40k~%40xTap%40hl%40uiCre%40unHlIi~AlFsc%40rEkk%40aAce%40mL%7DlAwPcyB_GohBzDsqAtMqtA~h%40weDtFkd%40Bi%60%40_XwfEdAag%40dEkM%60%40zAqApJef%40%7BP_o%40sYys%40ai%40yf%40_j%40y_%40oi%40mVi%5EmFqSwAiPtDuQbc%40_nAtZyaAlEkc%40r%40eq%40%7CAo%5BrTwcAtVuz%40vQ%7Dd%40%7CPmb%40xT%7B%5CzZyd%40jG%7BRzL%7Dh%40jr%40ov%40rFiImFqPiD%7BJ&key=\(AppInfo.Google_API_Key)"

               print(staticMapUrl)
        
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
       
        tblLocations.register(UINib(nibName: "PickUpDropOffCell", bundle: nil), forCellReuseIdentifier: "PickUpDropOffCell")
      
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Search and Book Loads", leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.notification.value,NavItemsRight.chat.value], isTranslucent: true, ShowShadow: false)
     
        calender.accessibilityIdentifier = "calender"
        configureCalendar()
        TextFieldSearch.delegate = self
        DispatchQueue.main.async {
            self.tblLocations.layoutIfNeeded()
            self.tblLocations.reloadData()
        }
        
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = RefreshControlColor
        self.tblLocations.refreshControl = refreshControl
        
        CallWebSerive()
        // Do any additional setup after loading the view.
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        PageNumber = 0
        CallWebSerive()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.showTabBar()
    }
    
       override func viewWillDisappear(_ animated: Bool) {
           
           super.viewWillDisappear(true)
       }

    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool   {
        if textField == TextFieldSearch {
            
            let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: SearchOptionViewController.storyboardID) as! SearchOptionViewController
                        controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
            
//
//
            return false
        }
        return true
        
    }
    
//    {
//
//
//    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnSortClick(_ sender: themeButton) {
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: SortPopupViewController.storyboardID) as! SortPopupViewController
                    controller.hidesBottomBarWhenPushed = true
        controller.arrayForSort = [  SortModel(Title: "Deadheading", IsSelect: true),
                                     SortModel(Title: "Price (Lowest First)", IsSelect: false),
                                     SortModel(Title: "Price (Highest First)", IsSelect: false),
                                     SortModel(Title: "Total Distance", IsSelect: false),
                                     SortModel(Title: "Rating", IsSelect: false)]
        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat((5 * 50) + 110))])
                self.present(sheetController, animated: true, completion: nil)
        
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    func CallWebSerive() {
        PageNumber = PageNumber + 1
        self.homeViewModel.homeViewController =  self
        
        let ReqModelForGetShipment = ShipmentListReqModel()
        ReqModelForGetShipment.page = "\(PageNumber)"
        ReqModelForGetShipment.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
//        ReqModelForGetShipment.driver_id = "271"
        
     

        self.homeViewModel.GetShipmentList(ReqModel: ReqModelForGetShipment)
        
    }
    
    // ----------------------------------------------------
      //MARK:- ======== Calender Setup =======
    // ----------------------------------------------------
    func configureCalendar() {
        
        calender.delegate = self
        calender.dataSource = self
        
        view.layoutIfNeeded()
    }
    
    @IBAction func nextTapped(_ sender:UIButton) {
        calender.setCurrentPage(getNextMonth(date: calender.currentPage), animated: true)
    }

    @IBAction  func previousTapped(_ sender:UIButton) {
        calender.setCurrentPage(getPreviousMonth(date: calender.currentPage), animated: true)
    }

    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .day, value: 7, to:date)!
    }

    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .day, value: -7, to:date)!
    }
    
}
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
       
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.conHeightOfCalender.constant = bounds.height
        self.view.layoutIfNeeded()
    }
   
    
}
class CalenderUI : FSCalendar {
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}


extension HomeViewController : UITableViewDataSource , UITableViewDelegate {
    
 
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading {
            return 1
        }
        var numOfSections: Int = 0
        if arrHomeData?.count != 0
           {
               //tableView.separatorStyle = .singleLine
            numOfSections            = arrHomeData?.count ?? 0
               tableView.backgroundView = nil
           }
           else
           {
               let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
               noDataLabel.text          = "No Records Found"
               noDataLabel.font = CustomFont.PoppinsRegular.returnFont(14)
               noDataLabel.textColor     = #colorLiteral(red: 0.6978102326, green: 0.6971696019, blue: 0.7468633652, alpha: 1)
               noDataLabel.textAlignment = .center
               tableView.backgroundView  = noDataLabel
               tableView.separatorStyle  = .none
           }
           return numOfSections
        
       // return arrHomeData?.count ?? 0// arrSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 5
        }
        return arrHomeData?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "PickUpDropOffCell", for: indexPath) as! PickUpDropOffCell
        cell.isLoading = self.isLoading
        if !isLoading {
            cell.PickUpDropOffData = arrHomeData?[indexPath.section][indexPath.row].trucks?.locations
            
            cell.BookingDetails = arrHomeData?[indexPath.section][indexPath.row]
            
            cell.tblHeight = { (heightTBl) in
                self.tblLocations.layoutIfNeeded()
                self.tblLocations.layoutSubviews()
            }
            cell.tblMultipleLocation.reloadData()
            cell.tblMultipleLocation.layoutIfNeeded()
            cell.tblMultipleLocation.layoutSubviews()
        }
       

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoading {
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: LoadDetailsVC.storyboardID) as! LoadDetailsVC
            controller.hidesBottomBarWhenPushed = true
            controller.LoadDetails = arrHomeData?[indexPath.section][indexPath.row]
            UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isLoading {
            return ""
        }
        return arrHomeData?[section].first?.date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: "dd MMMM, yyyy")
        
        
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isLoading {
            return UIView()
        }
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = UIColor(hexString: "#FAFAFA")
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 5, width: headerView.frame.width, height: headerView.frame.height-10)
        label.center = CGPoint(x: headerView.frame.size.width / 2, y: headerView.frame.size.height / 2)
        label.text = arrHomeData?[section].first?.date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: "dd MMMM, yyyy")
        label.textAlignment = .center
        label.font = CustomFont.PoppinsMedium.returnFont(FontSize.size15.rawValue)
        label.textColor = UIColor(hexString: "#292929")
        label.drawLineOnBothSides(labelWidth: label.frame.size.width, color: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1))
        headerView.addSubview(label)
        
        return headerView
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        
        
       
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
        
        if tableView == tblLocations {
            if indexPath.section == ((arrHomeData?.count ?? 0) - 1) {
                if indexPath.row == ((arrHomeData?[indexPath.section].count ?? 0) - 1) && isNeedToReload == true
                    {
                        let spinner = UIActivityIndicatorView(style: .medium)
                        spinner.tintColor = RefreshControlColor
                        spinner.startAnimating()
                        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblLocations.bounds.width, height: CGFloat(44))
                        
                        self.tblLocations.tableFooterView = spinner
                        self.tblLocations.tableFooterView?.isHidden = false
                        CallWebSerive()
                    }
            }
            
            
            
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isLoading {
            return 0
        }
         return 40
    }
}

extension HomeViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.lblStatus.text = arrStatus[indexPath.row]
        cell.lblStatus.textColor =  selectedIndex == indexPath.row ? UIColor(hexString: "#9B51E0") : UIColor(hexString: "#9A9AA9")
        cell.viewBG.backgroundColor = selectedIndex == indexPath.row ? UIColor(hexString: "#9B51E0") : UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((arrStatus[indexPath.row].capitalized).sizeOfString(usingFont: CustomFont.PoppinsRegular.returnFont(14)).width) + 30
                      , height: collectionOfHistory.frame.size.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collectionOfHistory.reloadData()
        tblLocations.reloadData()
    }
}
enum NotificationKeys : CaseIterable{
    
    static let KGetTblHeight = "TblHeight"
    static let KUpdateHomeScreenArray = "UpdateHomeScreenArray"
    
}

extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
}
