//
//  Product.swift
//  Yoox
//
//  Created by Gianmaria Dal Maistro on 17/02/17.
//  Copyright © 2017 it.whiteworld.test. All rights reserved.
//

import Foundation
import Mapper
import AnyObjectConvertible

struct Product : Mappable
{
    let title : String?
    let priceString : String?
    var imageUrlString = ""

    private var thumbnail : Thumbnail?

    init(map: Mapper) throws
    {
        title = map.optionalFrom("Brand")
        priceString = map.optionalFrom("FormattedFullPrice")
        
        if let code = map.optionalFrom("Cod10") as String?
        {
            self.thumbnail = Thumbnail(code: code, type: .portraitSmall)

            if let imageUrl = self.thumbnail?.imagePath
            {
                self.imageUrlString = imageUrl
            }
        }
    }
}

