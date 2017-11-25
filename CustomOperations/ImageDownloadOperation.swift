//
//  ImageDownloadOperation.swift
//  CustomOperations
//
//  Created by Jatin Garg on 25/11/17.
//  Copyright © 2017 Jatin Garg. All rights reserved.
//

import Foundation



class ImageDownloadOperation: AsyncOperation{
    let url: String
    let context: ImageProcessingContext
    
    init(imageURL: String, context: ImageProcessingContext){
        url = imageURL
        self.context = context
    }
    
    override func main() {
        super.main()
        
        guard let converted = URL(string: url) else {
            self.state = .finished
            
            context.errors.append("Invalid URI")
            return
        }
        
        downloadImage(converted) { (data) in
            self.context.imageData = data
            self.state = .finished
        }
        
        
    }
    
    typealias completion = (Data?) -> Void
    
    private func downloadImage(_ url: URL,_ completion: completion?){
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if error != nil {
                    self.context.errors.append(error!.localizedDescription)
            }
            
            completion?(data)
        }.resume()
    }
}
