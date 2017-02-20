//
//  ViewController.swift
//  Yoox
//
//  Created by Gianmaria Dal Maistro on 20/02/17.
//  Copyright © 2017 it.whiteworld.yoox. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}

extension UICollectionView
{
    var rx_nextPageTrigger:Observable<Void>
    {
        // Can start load at the last page when scrolling
        return self
            .rx_contentOffset
            .flatMapLatest { [unowned self] (offset) -> Observable<Void> in
                let shouldTrigger = offset.y + (self.frame.size.height * 2) > self.contentSize.height
                return shouldTrigger ? Observable.just() : Observable.empty()
        }
    }
}
