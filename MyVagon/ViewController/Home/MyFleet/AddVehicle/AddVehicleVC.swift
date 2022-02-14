//
//  AddVehicleVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/01/22.
//

import UIKit

//MARK: - ==== Kinjalllllllllll =====
class AddVehicleVC: BaseViewController {

    //MARK: ===== Outlets ======
    @IBOutlet weak var txtTruckType: MyProfileTextField!
    @IBOutlet weak var txtTruckWeight: MyProfileTextField!
    @IBOutlet weak var txtCargoLoadCapacity: MyProfileTextField!
    @IBOutlet weak var txtTrailerPlate: MyProfileTextField!
    @IBOutlet weak var txtTruckPlate: MyProfileTextField!
    @IBOutlet weak var txtCapacity: MyProfileTextField!
    @IBOutlet weak var txtBrand: MyProfileTextField!
    @IBOutlet weak var btnHydraulicDoor: UIButton!
    @IBOutlet weak var imgVehicle: UIImageView!
    
    //MARK: ===== Variables ======
    private var imagePicker : ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self, allowsEditing: true)
        //self.imagePicker.checkCameraAccess()
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Add Vehicle", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
    }
    
    //MARK: ===== btn Action hydraulic door ======
    @IBAction func btnActionHydraulicDoor(_ sender: UIButton) {
        btnHydraulicDoor.isSelected = !btnHydraulicDoor.isSelected
    }
    
    //MARK: ===== btn Action Add Vehicle ======
    @IBAction func btnActionAddVehicle(_ sender: UIButton) {
    }
    
    //MARK: ===== btn Action Vehicle Photo ======
    @IBAction func btnActionVehiclePhoto(_ sender: UIButton) {
        self.imagePicker.present(from: imgVehicle, viewPresented: self.view, isRemove: false)
    }
}

//MARK: - image picker Delegate method
extension AddVehicleVC: ImagePickerDelegate {
    func didSelect(image: UIImage?, SelectedTag: Int) {
        if image != nil {
            imgVehicle.image = image
        }
    }
}
