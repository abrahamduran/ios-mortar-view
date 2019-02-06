//
//  ViewController.swift
//  Mortar
//
//  Created by Abraham Isaac Durán on 2/6/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit

let MORTAR_CELLS_HEIGHT: CGFloat = 120

class MortarViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewWidth: CGFloat {
        return collectionView.frame.width
    }
    
    var images = [UIImage]()
    var sizes = [CGSize]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var index = 1
        while let image = UIImage(named: "\(index)") {
            images.append(image)
            
            let aspectRatio = CGFloat(image.size.height) / CGFloat(image.size.width)
            let width = round(MORTAR_CELLS_HEIGHT * aspectRatio)
            let size = CGSize(width: width, height: MORTAR_CELLS_HEIGHT)
            sizes.append(size)
            index += 1
        }
        
        normalizeSizes()
//        collectionView.reloadData()
    }
    
    private func normalizeSizes() {
        var index = 0
        while index < sizes.count {
            var maxWidth = collectionViewWidth // the width of the UICollectionView
            var rowWidth: CGFloat = 0.0
            var rowIndex = index
            while rowWidth < maxWidth, rowIndex < sizes.count {
                let belowThreshold = sizes[rowIndex].width < (maxWidth - rowWidth) * 1.30
                let remainsEnough = (maxWidth - rowWidth) / maxWidth > 0.3 && belowThreshold
                if belowThreshold || remainsEnough {
                    rowWidth += sizes[rowIndex].width
                    rowIndex += 1
                } else { break }
            }
            
            let spacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? CGFloat(2)
            let totalSpacing = CGFloat(rowIndex - index - 1) * spacing
            maxWidth -= totalSpacing
            var newRowWidth: CGFloat = 0
            for i in index..<rowIndex {
                let x = (sizes[i].width * maxWidth) / rowWidth
                sizes[i].width = x.rounded(to: 3)
                newRowWidth += sizes[i].width
            }
            
            if newRowWidth >= maxWidth {
                let previousIndex = rowIndex - 1
                let width = sizes[previousIndex].width - (newRowWidth - maxWidth).rounded(to: 3)
                sizes[previousIndex].width = width.rounded(to: 3)
            }
            
            index = rowIndex
        }
    }
}

// MARK: - Collection view's delegate & data source
extension MortarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mortar-cell", for: indexPath) as! MortarViewCell
        
        cell.pictureImageView.image = images[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizes[indexPath.row]
    }
}
