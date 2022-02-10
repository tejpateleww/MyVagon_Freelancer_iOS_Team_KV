//
//  CustomeMapVC.swift
//  MyVagon
//
//  Created by Tej P on 07/02/22.
//

import UIKit
import GoogleMaps

class CustomeMapVC: BaseViewController,GMSMapViewDelegate {
    
    @IBOutlet weak var MapVw: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarInViewController(controller: self, naviColor: .white, naviTitle: "My Map", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        
        MapVw.camera = GMSCameraPosition.camera(withLatitude: 18.514043, longitude: 57.377796, zoom: 6.0)
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: 18.514043, longitude: 57.377796))
        marker.title = "Lokaci Pvt. Ltd."
        marker.snippet = "Sec 132 Noida India"
        marker.map = MapVw
    }
    


    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = "Hi there!"
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = "I am a custom info window."
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl2)
        
        return view
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    
}
