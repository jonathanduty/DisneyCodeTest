//
//  ViewController.swift
//  DisneyCodeTest
//
//  Created by Jonathan Duty on 8/8/17.
//  Copyright © 2017 Class Extension. All rights reserved.
//

import UIKit
import PINRemoteImage

class ImageCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    
    
}

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    
    var urls = [URL]()
    
    var loading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        automaticallyAdjustsScrollViewInsets = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent

        if ( urls.count == 0) {
            loadMoreData()
        }
    }
    
    
    func loadMoreData() {
        guard loading == false else {
            return
        }
        loading = true
        API.instance.getImageURLs { [weak self] (result) in
            self?.loading = false
            switch result {
            case .success(let urls):
                print (urls)
                self?.urls.append(contentsOf: urls)
                
                self?.collectionView.reloadData()
            case .failure(let error):
                self?.presentAlertWithTitle(title: "Oops!", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
        if (gestureRecognizer.state != UIGestureRecognizerState.ended){
            return
        }
        
        let p = gestureRecognizer.location(in: self.collectionView)
        
        if let path = self.collectionView.indexPathForItem(at: p), let cell = self.collectionView.cellForItem(at: path) as? ImageCell {
            
            UIPasteboard.general.image = cell.imageView.image
            
            presentAlertWithTitle(title: "Got it!", message: "Image Copied to your clipboard!")
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                                for: indexPath) as? ImageCell else {
                                                                    
                                                                    
                                                                    return UICollectionViewCell()
                                                                    
        }
        cell.imageView.pin_setImage(from: urls[indexPath.row])
        
        return cell
    }
    
    
    
}

extension ViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = UIStoryboard.init(name: "ImageViewer", bundle: nil).instantiateInitialViewController() as? ImageViewerViewController else {
            return
        }
        
        vc.urls = self.urls
        vc.currentIndex = indexPath.row
        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let width = UIScreen.main.bounds.width / 4
        
        return CGSize(width: width, height: width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold = CGFloat(100.0)
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        if (maximumOffset - contentOffset <= threshold) && (maximumOffset - contentOffset != -5.0) {
            
            loadMoreData()
        }
    }
    
}
