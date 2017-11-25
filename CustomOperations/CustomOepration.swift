//
//  CustomOepration.swift
//  CustomOperations
//
//  Created by Jatin Garg on 25/11/17.
//  Copyright © 2017 Jatin Garg. All rights reserved.
//

import Foundation

class Operation1: AsyncOperation{
    let iteration:Int
    let context: CustomGroupOperationContext
    
    var imageData: NSData?
    init(iteration: Int, context: CustomGroupOperationContext){
        self.iteration = iteration
        self.context = context
    }
    
    
    override func main() {
        super.main()
        
        print("Starting operation 1 of iteration: \(iteration)")
        
        getImage{
            print("Operation 1 completed of iteration: \(self.iteration)")
            self.context.imageData = $0
            
            self.state = .finished
        }
//        let url = Bundle.main.url(forResource: "img", withExtension: ".jpg")
//        imageData = NSData(contentsOf: url!)!
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//
//            self.executing(false)
//            self.finished(true)
//        }
    }
    
    
}

private func getImage(_ completion: @escaping (NSData)->Void){
    DispatchQueue.global().async {
        let url = Bundle.main.url(forResource: "img", withExtension: ".jpg")
        let imageData = NSData(contentsOf: url!)!
        completion(imageData)
    }
}

class Operation2: AsyncOperation{
    let iteration: Int
    var imageData: NSData?
    let context: CustomGroupOperationContext
    
    init(iteration: Int, context: CustomGroupOperationContext){
        self.iteration = iteration
        self.context = context
    }
    
    override func main() {
        super.main()
        
        print("Starting operation 2 of iteration: \(iteration)")
        
        
        getImage { _ in
            self.state = .finished
            print("Operation 2 completed of iteration: \(self.iteration)")
            print(self.context.imageData!.bytes)
        }
    }
}


class AsyncOperation: Operation {
    override var isAsynchronous: Bool { return true }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }
    
    override func start() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .ready
            main()
        }
    }
    
    override func main() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .executing
        }
    }
}

//class AsyncOperation: Operation{
//    private var _executing: Bool = false{
//        willSet{
//            willChangeValue(forKey: "isExecuting")
//        }didSet{
//            didChangeValue(forKey: "isExecuting")
//        }
//    }
//
//    override var isExecuting: Bool{
//        return _executing
//    }
//
//    private var _finished: Bool = false {
//        willSet{
//            willChangeValue(forKey: "isFinished")
//        }didSet{
//            didChangeValue(forKey: "isFinished")
//        }
//    }
//
//    override var isFinished: Bool{
//        return _finished
//    }
//
//    func executing(_ executing: Bool){
//        _executing = executing
//    }
//
//    func finished(_ finished: Bool){
//        _finished = finished
//    }
//
//    func setFinished(){
//        executing(false)
//        finished(true)
//    }
//
//    func reportCommencement(){
//        executing(true)
//        finished(false)
//    }
//}

class GroupOperation: AsyncOperation{
    private let privateQueue: OperationQueue?
    private var childOperations: [Operation] = []
    
    private var startingOperation: Operation?
    private var endingOperation: Operation?
    
    init(operations: [Operation], queue: OperationQueue?){
        childOperations = operations
        privateQueue = queue ?? OperationQueue()
        
        super.init()
    }
    
    override func main() {
        super.main()
        
        guard childOperations.count > 0 else{
            state = .finished
            return
        }
        
        
        for (index,operation) in childOperations.enumerated(){
            if index == childOperations.count - 1{
                //this is the last operation being added
                operation.completionBlock = {
                    //report my completion
                    self.state = .finished
                    operation.completionBlock = nil
                }
            }
            
            privateQueue?.addOperation(operation)
        }
        
        
    }
    override func cancel() {
        privateQueue?.cancelAllOperations()
        super.cancel()
    }
    
    
}
