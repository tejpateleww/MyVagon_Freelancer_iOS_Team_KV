//
//  RegisterTruckListVC.swift
//  MyVagon
//
//  Created by Tej P on 02/03/22.
//

import UIKit
import FittedSheets

class RegisterTruckListVC: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var tblTruckList: UITableView!
    @IBOutlet weak var btnAddTruck: UIButton!
    @IBOutlet weak var btnContinue: themeButton!
    
    var arrtruckData : [RegTruckDetailModel] = []
    var defaultTruckData : [RegTruckDetailModel] = []
    var editTruckDetailViewModel = EditTruckViewModel()
    var removeTruckViewmModel = RemoveTruckDetailViewModel()
    var makeAsDefaultTruckViewModel = MakeAsDefaultTruckViewModel()
    var truckType : String = ""
    var isFromEdit = false
    var isEditEnable = true
    var selectedIndex = 0
    var isEdit = true
    var defaultTruckIndex = 0
    var dataEdited = false
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLocalization()
    }
    
    //MARK: - Custome methods
    @objc func changeLanguage(){
        self.setLocalization()
        self.tblTruckList.reloadData()
    }
    
    func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    func setLocalization(){
        self.btnAddTruck.setTitle("Add Truck".localized, for: .normal)
        self.btnAddTruck.titleLabel?.numberOfLines = 0
        if isFromEdit{
            if UserDefault.string(forKey: UserDefaultsKey.LoginUserType.rawValue) == LoginType.dispatcher_driver.rawValue{
                self.btnContinue.isHidden = true
                self.btnAddTruck.isHidden = true
            }else{
                self.btnContinue.isHidden = false
            }
            self.btnContinue.setTitle("Save".localized, for: .normal)
        }else{
            self.btnContinue.setTitle("Continue".localized, for: .normal)
        }
    }
    
    func setupUI(){
        self.btnAddTruck.titleLabel?.numberOfLines = 0
        self.tblTruckList.delegate = self
        self.tblTruckList.dataSource = self
        self.tblTruckList.separatorStyle = .none
        self.tblTruckList.showsHorizontalScrollIndicator = false
        self.tblTruckList.showsVerticalScrollIndicator = false
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Truck List".localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        self.registerNib()
        self.addNotificationObs()
    }
    
    func setupData(){
        if isFromEdit{
            for (count,truck) in (SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckDetails ?? []).enumerated(){
                var pallats = [TruckCapacityType]()
                for i in truck.vehicleCapacity ?? []{
                        let item = TruckCapacityType(Capacity: i.value ?? "", Type: i.packageTypeId?.id ?? 0)
                    pallats.append(item)
                }
                let urlImg = getUrlArray(arr: truck.images ?? [])
                let newTruck = RegTruckDetailModel(id: "\(truck.id ?? 0)",truck_type: "\(truck.truckType?.id ?? 0)", truck_sub_category: "\(truck.truckSubCategory?.id ?? 0)", weight: "\(truck.weight ?? "")" , weight_unit: "\(truck.weightUnit?.id ?? 0)", capacity: "\(truck.loadCapacity ?? "")", capacity_unit: "\(truck.loadCapacityUnit?.id ?? 0)", pallets: pallats, plate_number: truck.plateNumber ?? "", images: truck.images?.map({$0}).joined(separator: ",") ?? "",imageWithUrl: urlImg, truck_features: truck.truckFeatures ?? "", default_truck: "\(truck.defaultTruck ?? 0)")
                self.arrtruckData.append(newTruck)
                if truck.defaultTruck == 1{
                    defaultTruckIndex = count
                }
            }
            self.defaultTruckData = self.arrtruckData
        }else{
            self.arrtruckData = SingletonClass.sharedInstance.RegisterData.Reg_truck_data
            self.checkContinue()
        }
        self.tblTruckList.reloadData()
    }
    
    func getUrlArray(arr:[String]) -> String{
        let url = isFromEdit ? "\(APIEnvironment.DriverImageURL)" : "\(APIEnvironment.tempURL)"
        var array = [String]()
        for i in arr{
            array.append("\(url)\(i)")
        }
        return array.map({$0}).joined(separator: ",")
    }
    
    func addNotificationObs(){
        NotificationCenter.default.removeObserver(self, name: .reloadRegTruckListScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadScreen), name: .reloadRegTruckListScreen, object: nil)
    }
    
    func checkContinue(){
        if self.arrtruckData.count > 0 {
            self.btnContinue.isHidden = UserDefault.string(forKey: UserDefaultsKey.LoginUserType.rawValue) == LoginType.dispatcher_driver.rawValue ? true : false
        }else{
            self.btnContinue.isHidden = true
        }
    }
    
    @objc func reloadScreen() {
        self.arrtruckData = SingletonClass.sharedInstance.RegisterData.Reg_truck_data
        self.tblTruckList.reloadData()
        self.checkContinue()
    }
    
    func registerNib(){
        let nib = UINib(nibName: RegisterTruckCell.className, bundle: nil)
        self.tblTruckList.register(nib, forCellReuseIdentifier: RegisterTruckCell.className)
        let nib3 = UINib(nibName: NoDataTableViewCell.className, bundle: nil)
        self.tblTruckList.register(nib3, forCellReuseIdentifier: NoDataTableViewCell.className)
    }
    
    private func popBack(){
        self.navigationController?.popViewController(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            Utilities.ShowAlertOfSuccess(OfMessage: "profileUpdateSucces".localized)
        })
    }
    
    //MARK: - UIButton action methods
    @IBAction func btnAddTruckAction(_ sender: Any) {
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: AddTruckVC.storyboardID) as! AddTruckVC
        if isFromEdit{
            controller.isToAdd = true
        }
        self.isEdit = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        if isFromEdit{
            if arrtruckData.count > 0{
                if checkChanges(){
                    self.callWebService()
                }else{
                    self.popBack()
                }
            }
        }else{
            SingletonClass.sharedInstance.RegisterData.Reg_truck_data = self.arrtruckData
            UserDefault.setValue(2, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
            UserDefault.SetRegiterData()
            UserDefault.synchronize()
            let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
            let x = self.view.frame.size.width * 3
            RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
            RegisterMainVC.viewDidLayoutSubviews()
        }
    }
}

extension RegisterTruckListVC{
    
    func callWebService(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonString = try! encoder.encode(getReqModel())
        print(String(data: jsonString, encoding: .utf8)!)
        let finalJson = String(data: jsonString, encoding: .utf8)!
        let reqModel = EditTruckReqModel()
        reqModel.truck_details = finalJson
        self.editTruckDetailViewModel.registerTruckListVC = self
        self.editTruckDetailViewModel.callWebserviceForEditTruck(reqModel: reqModel)
    }
    
    func getReqModel() -> [TruckEditReqModel] {
        var array = [TruckEditReqModel]()
        for i in arrtruckData{
            let temp = TruckEditReqModel()
            temp.truck_type = Int(i.truck_type)
            temp.id = Int(i.id)
            temp.plate_number = i.plate_number
            temp.truck_sub_category = Int(i.truck_sub_category)
            temp.truck_features = i.truck_features
            temp.weight = i.weight
            temp.weight_unit = Int(i.weight_unit)
            temp.capacity = i.capacity
            temp.capacity_unit = Int(i.capacity_unit)
            temp.images = i.images
            temp.default_truck = Int(i.default_truck)
            var arrPallet = [Pallets]()
            for pallet in i.pallets {
                let newPallet = Pallets()
                newPallet.id = pallet.type
                newPallet.value = pallet.capacity
                arrPallet.append(newPallet)
            }
            temp.pallets = arrPallet
            array.append(temp)
        }
        return array
    }
    func checkChanges() -> Bool{

        for i in 0...arrtruckData.count - 1{
            if !(arrtruckData[i] == defaultTruckData[i]){
                return true
            }
        }
        return false
    }
    
    func callwebServiceForRemoveTruck(truckId : String,index:Int){
        let reqest = RemoveTruckDetailReqModel()
        reqest.truckDetailId = truckId
        removeTruckViewmModel.registerTruckListVC = self
        removeTruckViewmModel.callWebServiceToRemoveTruckDetail(req: reqest, index: index)
    }
    
}

//MARK: - UITableView Delegate and Data Sourse Methods
extension RegisterTruckListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return (self.arrtruckData.count > 0) ? self.arrtruckData.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(self.arrtruckData.count > 0){
            let cell = tblTruckList.dequeueReusableCell(withIdentifier: RegisterTruckCell.className) as! RegisterTruckCell
            cell.selectionStyle = .none
            cell.lbltruckType.text = ""
                for truck in SingletonClass.sharedInstance.TruckTypeList ?? []{
                    if(truck.id ?? 0 == Int(self.arrtruckData[indexPath.row].truck_type)){
                        cell.lbltruckType.text = truck.getName()
                        break
                    }
                }
            if cell.lbltruckType.text == ""{
                cell.lbltruckType.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckDetails?[indexPath.row].truckType?.getName()
            }
                cell.lblTruckNumber.text = self.arrtruckData[indexPath.row].plate_number
            cell.imgDefault.image = self.arrtruckData[indexPath.row].default_truck == "0" ? UIImage(named: "ic_radio_unselected") : UIImage(named: "check")
            cell.btnDeleteClick = {
                if self.arrtruckData[indexPath.row].default_truck != "1"{
                    if self.isFromEdit{
                        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: DeleteConfirmPopupVC.storyboardID) as! DeleteConfirmPopupVC
                        controller.hidesBottomBarWhenPushed = true
                        controller.titleText = "Are you sure you want to delete it?".localized
                        let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(150) + appDel.GetSafeAreaHeightFromBottom())])
                        sheetController.allowPullingPastMaxHeight = false
                        self.present(sheetController, animated: true, completion: nil)
                        controller.btnPositiveAction = {
                            self.callwebServiceForRemoveTruck(truckId: self.arrtruckData[indexPath.row].id, index: indexPath.row)
                        }
                    }else{
                        self.arrtruckData.remove(at: indexPath.row)
                        SingletonClass.sharedInstance.RegisterData.Reg_truck_data = self.arrtruckData
                        UserDefault.setValue(2, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
                        UserDefault.SetRegiterData()
                        UserDefault.synchronize()
                        self.checkContinue()
                        self.tblTruckList.reloadData()
                    }
                }else{
                    Utilities.ShowAlertOfInfo(OfMessage: "Default truck can’t be deleted".localized)
                }
            }
            cell.btnDefaultAction = {
                if self.arrtruckData[indexPath.row].default_truck != "1"{
                    if self.isFromEdit{
                        let req = MakeAsDefaultTruckReqModel()
                        req.truckDetailId = self.arrtruckData[indexPath.row].id
                        self.makeAsDefaultTruckViewModel.registerTruckListVC = self
                        self.makeAsDefaultTruckViewModel.callWebServiceToMakeDefaultTruck(req: req,index: indexPath.row)
                    }else{
                        self.arrtruckData[indexPath.row].default_truck = "1"
                        self.arrtruckData[self.defaultTruckIndex].default_truck = "0"
                        SingletonClass.sharedInstance.RegisterData.Reg_truck_data = self.arrtruckData
                        UserDefault.setValue(2, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
                        UserDefault.SetRegiterData()
                        UserDefault.synchronize()
                        self.defaultTruckIndex = indexPath.row
                        self.tblTruckList.reloadData()
                    }
                }
            }
            return cell
        }else{
            let NoDatacell = self.tblTruckList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
            NoDatacell.lblNoDataTitle.text = "No Trucks Found".localized
            return NoDatacell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (isFromEdit && arrtruckData.count > 0){
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: AddTruckVC.storyboardID) as! AddTruckVC
        controller.isFromEdit = true
        controller.isEditEnable = false
        controller.truckIndex = indexPath.row
        self.selectedIndex = indexPath.row
        self.isEdit = true
        controller.editeData = { (data) in
            self.dataEdited = true
            if self.isEdit{
                self.arrtruckData.remove(at: self.selectedIndex)
                self.arrtruckData.insert(data, at: self.selectedIndex)
            }else{
                self.arrtruckData.append(data)
            }
            self.tblTruckList.reloadData()
        }
        controller.tructData = arrtruckData[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.arrtruckData.count > 0){
            return UITableView.automaticDimension
        }else{
            return tableView.frame.height
        }
        
    }
}
