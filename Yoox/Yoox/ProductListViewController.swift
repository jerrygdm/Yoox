//
//  ViewController.swift
//  Yoox
//
//  Created by Gianmaria Dal Maistro on 20/02/17.
//  Copyright © 2017 it.whiteworld.yoox. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class ProductListViewController: UIViewController
{
    var productListViewModel = ProductListViewModel()
    let disposeBag = DisposeBag()
    
    var items = [Product]()
    var numCellsPerRow = 3
    
    @IBOutlet weak var collectionView : UICollectionView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.collectionView?.rx_nextPageTrigger.map{ offset  in
            return offset
            }.scan(0){ lastCount, newValue in
                return lastCount + 1
            }.flatMapLatest{ page in
                return self.productListViewModel.getProducts(String(page))
            }.subscribeNext{ response in
                if let products = response?.items
                {
                    let range = NSMakeRange(self.items.count, products.count)
                    let newIndexes : NSIndexSet = NSIndexSet(indexesInRange: range)
                    
                    var newIndexPath = [NSIndexPath]()
                    
                    newIndexes.enumerateIndexesUsingBlock({ (idx, stop) in
                        newIndexPath.append((NSIndexPath(forRow: idx, inSection: 0)))
                    })
                    
                    self.items.appendContentsOf(products)
                    
                    self.collectionView?.performBatchUpdates({
                        self.collectionView?.insertItemsAtIndexPaths(newIndexPath)
                        }, completion: { (completion) in
                    })
                }
            }.addDisposableTo(disposeBag)
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
