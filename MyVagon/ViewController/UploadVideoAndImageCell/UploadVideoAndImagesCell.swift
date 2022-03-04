//
//  UploadVideoAndImagesCell.swift
//  Cluttrfly
//
//  Created by Harsh Sharma on 26/04/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class UploadVideoAndImagesCell: UICollectionViewCell {

    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var btnAddImg: UIButton!
    
    var isForImage : Bool = false
    var btnUploadImg : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vwBackground.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
    }

    @IBAction func btnAddImgAction(_ sender: Any) {
        if let click = self.btnUploadImg{
            click()
        }
    }
    
}
