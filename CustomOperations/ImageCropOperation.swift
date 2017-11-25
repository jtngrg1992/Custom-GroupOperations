//
//  ImageCropOperation.swift
//  CustomOperations
//
//  Created by Jatin Garg on 25/11/17.
//  Copyright © 2017 Jatin Garg. All rights reserved.
//

import UIKit

class ImageCropOperation: Operation{
    let context: ImageProcessingContext
    fileprivate let maxImageSize = CGSize(width: 800, height: 800)
    
    init(context: ImageProcessingContext){
        self.context = context
    }
    
    override func main() {
        super.main()
        
        guard let imageData = context.imageData else {
            context.errors.append("Failed to download image")
            return
        }
        
        guard let image = UIImage(data: imageData) else {
            context.errors.append("Invalid image data")
            return
        }
        
        let size = image.size
        
        let widthRatio = maxImageSize.width/size.width
        let heightRatio = maxImageSize.height/size.height
        
        var newSize: CGSize
        
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        }else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: CGSize(width: newSize.width, height: newSize.height))
        
        UIGraphicsBeginImageContext(newSize)
        
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        context.croppedImage = newImage
        
    }
}
