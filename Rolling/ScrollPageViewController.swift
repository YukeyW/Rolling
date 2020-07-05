//
//  ScrollPageViewController.swift
//  Rolling
//
//  Created by yukey on 3/7/20.
//  Copyright © 2020 Yukey. All rights reserved.
//

import UIKit

class ScrollPageViewController: UIViewController {
    var newImageList = [UIImage]()
    var name: String?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var scrollViewHeight = CGFloat(0.0)
        for (_, image) in newImageList.enumerated() {
            let imageView = UIImageView(image: image)
            let scale = image.size.height / image.size.width
            scrollView.addSubview(imageView)
            imageView.frame = CGRect(x: 0, y: scrollViewHeight, width: view.frame.size.width, height: scale * view.frame.size.width)
            scrollViewHeight += scale * view.frame.size.width
        }
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: scrollViewHeight)
        scrollView.delegate = self
        self.title = name
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension ScrollPageViewController: UIScrollViewDelegate {
    
}
