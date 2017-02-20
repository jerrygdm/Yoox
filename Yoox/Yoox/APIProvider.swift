//
//  APIProvider.swift
//  Yoox
//
//  Created by Gianmaria Dal Maistro on 17/02/17.
//  Copyright © 2017 it.whiteworld.test. All rights reserved.
//

import Foundation

import Moya

private extension String
{
    var URLEscapedString: String
    {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

enum APIProvider
{
    case ProductList(page: (String))
}

extension APIProvider : TargetType
{
    var baseURL: NSURL { return NSURL(string: "http://api.yoox.biz/YooxCore.API/1.0/YOOX_US")! }
    
    var path: String {
        switch self {
        case .ProductList:
            return "/SearchResults"
        }
    }
    
    var method: Moya.Method
    {
        return .GET
    }
    
    var parameters: [String: AnyObject]?
    {
        switch self {
        case .ProductList(let page):
            return ["dept" : "women", "Gender" : "D", "noitems" : "0", "noRef" : "0" , "page" : page]
        }
    }
    
    var sampleData: NSData
    {
        switch self
        {
            case .ProductList(_):
                return "".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
    
    var multipartBody: [MultipartFormData]? { return [] }
}
