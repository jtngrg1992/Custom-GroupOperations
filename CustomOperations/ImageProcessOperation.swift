//
//  ImageProcessOperation.swift
//  CustomOperations
//
//  Created by Jatin Garg on 25/11/17.
//  Copyright © 2017 Jatin Garg. All rights reserved.
//

import Foundation

class ImageProcessOperation: GroupOperation {
    let downloader: ImageDownloadOperation
    let cropper: ImageCropOperation
    
    let downloadURL: String
    let context: ImageProcessingContext
    let privateQueue: OperationQueue
    
    init(url: String, context: ImageProcessingContext, queue: OperationQueue?){
        downloadURL = url
        
        downloader = ImageDownloadOperation(imageURL: url, context: context)
        cropper = ImageCropOperation(context: context)
        
        cropper.addDependency(downloader)
        privateQueue = queue ?? OperationQueue()
        self.context = context
        
        super.init(operations: [downloader,cropper], queue: OperationQueue())
    }
    
    func begin(){
        privateQueue.addOperation(self)
    }
}
