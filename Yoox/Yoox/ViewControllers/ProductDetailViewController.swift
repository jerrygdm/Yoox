//
//  ProductDetailViewController.swift
//  Yoox
//
//  Created by Gianmaria Dal Maistro on 20/02/17.
//  Copyright © 2017 it.whiteworld.test. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ProductDetailViewController: UIViewController, PassingDataProtocol
{
    var data : Any?
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!

    var detailImage : UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        if let data = data as? Product
        {
            self.detailImage = UIImageView(frame: self.scrollView.bounds)
            self.detailImage.contentMode = UIViewContentMode.ScaleAspectFit;
            self.scrollView.addSubview(self.detailImage)
            
            self.activityIndicator.startAnimating()
            
            self.detailImage.sd_setImageWithURL(NSURL(string: data.imageUrlString), completed: { (image, errro, _, _) in
                self.scrollView.contentSize = image.size
                self.activityIndicator.stopAnimating()
            })
        }
    }
    
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer)
    {
        guard let view =  recognizer.view else { return }
        
        view.transform = CGAffineTransformScale(view.transform, recognizer.scale, recognizer.scale)
        recognizer.scale = 1
    }
}
