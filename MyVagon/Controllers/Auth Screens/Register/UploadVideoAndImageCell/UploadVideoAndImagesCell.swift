//
//  UploadVideoAndImagesCell.swift
//  Cluttrfly
//
//  Created by Harsh Sharma on 26/04/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class UploadVideoAndImagesCell: UICollectionViewCell {

    //MARK: - Propertise
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var lblAdd: UILabel!
    @IBOutlet weak var btnAddImg: UIButton!
    
    var isForImage : Bool = false
    var btnUploadImg : (() -> ())?
    
    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
        vwBackground.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        self.lblAdd.text = "".localized
    }
    
    //MARK: - IBAction method
    @IBAction func btnAddImgAction(_ sender: Any) {
        if let click = self.btnUploadImg{
            click()
        }
    }
}
