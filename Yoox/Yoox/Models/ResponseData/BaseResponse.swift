//
//  ChangePwResponse.swift
//  ClickIren
//
//  Created by Gianmaria Dal Maistro on 17/08/16.
//  Copyright © 2016 Ennova S.r.l. All rights reserved.
//

import Mapper
import AnyObjectConvertible

struct BaseResponse : Mappable
{
    var result : Int
    var items : [Product]
    
    init(map: Mapper) throws
    {
        try result = map.from("ErrorCode")
        try items = map.from("Items")
    }
}
