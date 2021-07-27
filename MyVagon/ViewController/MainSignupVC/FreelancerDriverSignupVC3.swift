//
//  FreelancerDriverSignupVC3.swift
//  MyVagon
//
//  Created by Admin on 26/07/21.
//

import UIKit

class FreelancerDriverSignupVC3: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnActionEmailVerify(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
       
        
    }
    
    @IBAction func btnActionMobileVerify(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
      
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
