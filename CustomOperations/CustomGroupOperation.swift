//
//  CustomGroupOperation.swift
//  CustomOperations
//
//  Created by Jatin Garg on 25/11/17.
//  Copyright © 2017 Jatin Garg. All rights reserved.
//

import Foundation

class CustomGroupOperation: GroupOperation{
    let operation1: Operation1
    let operation2: Operation2
    
    let privateQueue: OperationQueue
    
    let context = CustomGroupOperationContext()
    
    let iteration: Int
    
    init(q: OperationQueue, iteration: Int){
        operation1 = Operation1(iteration: iteration,context: context)
        operation2 = Operation2(iteration: iteration,context: context)
        
        privateQueue = q
        operation2.addDependency(operation1)
        self.iteration = iteration
        super.init(operations: [operation1,operation2], queue: OperationQueue())
    }
    
    func begin(){
        privateQueue.addOperation(self)
    }
    
    
}

class CustomGroupOperationContext{
    var imageData: NSData?
}
