//
//  Thumbnail.swift
//  Yoox
//
//  Created by Gianmaria Dal Maistro on 17/02/17.
//  Copyright © 2017 it.whiteworld.test. All rights reserved.
//

import Foundation

enum PathErrorType : ErrorType
{
    case NotValidPath
}

struct Thumbnail
{
    let basePath = "http://cdn.yoox.biz"
    var code : String?
    var type : ThumbnailType
    let imageExtension = "jpg"
    var imagePath : String {
        return pathForType(type)
    }

    init(code : String, type : ThumbnailType)
    {
        self.code = code
        self.type = type
    }
    
    func pathForType(type:ThumbnailType) -> String
    {
        guard let code = code else { return "" }
        
        let prefix = (code as NSString).substringToIndex(2)
        return basePath + "/" + prefix + "/" + code + type.rawValue + "." + imageExtension
    }
}

enum ThumbnailType:String
{
    case portraitSmall = "_11_f"
    case portraitHiRes = "_14_f"
}
