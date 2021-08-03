//
//  ImageUploadReqModel.swift
//  MyVagon
//
//  Created by Apple on 03/08/21.
//

import Foundation
class ImageUploadReqModel : Encodable {
    var images : [String]?
    
    enum CodingKeys: String, CodingKey {
        case images = "images"
    }
}
