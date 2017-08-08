//
//  ImageViewerViewController.swift
//  DisneyCodeTest
//
//  Created by Jonathan Duty on 8/8/17.
//  Copyright © 2017 Class Extension. All rights reserved.
//

import Foundation
import UIKit

class ImageViewerViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var urls =  [URL]()
    var currentIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshImage()
    }
    
    func refreshImage() {
        if urls.count > currentIndex {
            imageView.pin_setImage(from: urls[currentIndex])
        }
    }
    
    @IBAction func closePressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func swipeRight() {
    
        if currentIndex > 0 {
            currentIndex = currentIndex - 1
        }
        refreshImage()
        
    }
    
    @IBAction func swipeLeft() {
        if currentIndex < urls.count - 1 {
            currentIndex = currentIndex + 1
        }
        refreshImage()
    }
    
}
