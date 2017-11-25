//
//  ViewController.swift
//  CustomOperations
//
//  Created by Jatin Garg on 25/11/17.
//  Copyright © 2017 Jatin Garg. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let privateQueue = OperationQueue()
    var images: [UIImage] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        privateQueue.maxConcurrentOperationCount = 4
        // Do any additional setup after loading the view, typically from a nib.
        
//        for i in 0...2000{
//            let op = CustomGroupOperation(q: privateQueue, iteration: i)
//            op.completionBlock = {
//                print("completed gropu operation with iteration: \(op.iteration)")
//                op.completionBlock = nil
//            }
//            op.begin()
//        }
        
        let baseURL: String = "https://dummyimage.com/"
        
        for i in 100...2500{
            let imageProcessor = ImageProcessOperation(url: baseURL + "\(i)" + "/09f/fff.png", context: ImageProcessingContext(), queue: privateQueue)
            
            imageProcessor.completionBlock = {
                print("completed processing image with size: \(i) with \(imageProcessor.context.errors.count) errors")
                if let image = imageProcessor.context.croppedImage{
                    self.images.append(image)
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                imageProcessor.completionBlock = nil
            }
            imageProcessor.begin()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = images[indexPath.item]
        return cell
    }
}

