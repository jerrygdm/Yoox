//
//  ProductListViewModel.swift
//  Yoox
//
//  Created by Gianmaria Dal Maistro on 17/02/17.
//  Copyright © 2017 it.whiteworld.test. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional

struct ProductListViewModel
{
    let thumbType = ThumbnailType.portraitSmall
    let provider = RxMoyaProvider<APIProvider>()

    func getProducts(page : String = "1") -> Observable<BaseResponse?>
    {
        return self.provider
            .request(APIProvider.ProductList(page: page))
            .debug()
            .mapObjectOptional(BaseResponse.self)
    }
}
