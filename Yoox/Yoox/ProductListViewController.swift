//
//  ViewController.swift
//  Yoox
//
//  Created by Gianmaria Dal Maistro on 17/02/17.
//  Copyright © 2017 it.whiteworld.test. All rights reserved.
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

extension ProductListViewController : UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductCellID", forIndexPath: indexPath)
        
        if let cell = cell as? ProductListCell
        {
            let model = self.items[indexPath.row]
            
            cell.titleLabel?.text = model.title
            cell.priceLabel?.text = model.priceString
            cell.imageView?.sd_setImageWithURL(NSURL(string: model.imageUrlString))
        }

        return cell
    }
}

extension ProductListViewController : UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        guard let flowLayout : UICollectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSizeMake(100, 100)}

        let availableWidthForCells = CGFloat(CGRectGetWidth(collectionView.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right) - CGFloat(flowLayout.minimumInteritemSpacing) * CGFloat(numCellsPerRow - 1);
        let cellWidth = availableWidthForCells / CGFloat(numCellsPerRow)
        
        return CGSizeMake(cellWidth, flowLayout.itemSize.height);
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
