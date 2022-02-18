//
//  ViewController.swift
//  MyVagon
//
//  Created by iMac on 15/07/21.
//

import UIKit

enum AuthenticationToken:Int{
    
    case user
    
    static var mapper: [AuthenticationToken: String] = [
        .user: ""
    ]
    var string: String {
        return AuthenticationToken.mapper[self]!
    }
    
}
import Alamofire

enum ParaEncoding :Int{
    case urlDefault
    case urlQueryString
    case jsonDefault
    
    static var mapper: [ParaEncoding: ParameterEncoding] = [
        .urlDefault: URLEncoding.default,
        .urlQueryString: URLEncoding.queryString,
        .jsonDefault: JSONEncoding.default
    ]
    
    var value: ParameterEncoding {
        return ParaEncoding.mapper[self]!
    }
}
