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
    var timer = Timer()
    var scrollViewHeight = CGFloat(0.0)
    var count = 0

    @IBOutlet weak var play: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustImage()
        self.title = name
        isShowed()
        scrollView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
    }
    
    private func adjustImage() {
        for (_, image) in newImageList.enumerated() {
            let imageView = UIImageView(image: image)
            let scale = image.size.height / image.size.width
            scrollView.addSubview(imageView)
            imageView.frame = CGRect(x: 0, y: scrollViewHeight, width: view.frame.size.width, height: scale * view.frame.size.width)
            scrollViewHeight += scale * view.frame.size.width
        }
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: scrollViewHeight)
    }
    
    private func isShowed() {
        if scrollViewHeight < self.view.frame.height {
            self.play.isEnabled = true
        }
    }
    
    @IBAction func playButton(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.scrollDocument), userInfo: nil, repeats: true)
        }
    }
    
    @objc func scrollDocument() {
        if count < Int(scrollViewHeight / scrollView.bounds.size.height) {
            let scroll = CGPoint(x: 0, y: scrollView.bounds.size.height * CGFloat(count))
            UIView.animate(withDuration: 3) {
                self.scrollView.setContentOffset(scroll, animated: false)
            }
            count += 1
        } else {
            let y = scrollViewHeight - scrollView.bounds.size.height * CGFloat(count) + scrollView.bounds.size.height * CGFloat(count - 1)
            let bottomOffset = CGPoint(x: 0, y: y)
            UIView.animate(withDuration: 3) {
                self.scrollView.setContentOffset(bottomOffset, animated: false)
            }
            count = 0
        }
    }
    
    func removeTimer() {
        timer.invalidate()
    }
}

extension ScrollPageViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
}



