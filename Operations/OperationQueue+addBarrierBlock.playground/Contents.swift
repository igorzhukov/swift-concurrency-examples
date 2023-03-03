import Foundation

let operationQueue = OperationQueue()
let block1 = BlockOperation {
    asyncBlock(id: 1)
}

let block2 = BlockOperation {
    asyncBlock(id: 2)
}

let block4 = BlockOperation {
    asyncBlock(id: 4)
}

let block5 = BlockOperation {
    asyncBlock(id: 5)
}


operationQueue.addOperations([block1, block2], waitUntilFinished: false)

operationQueue.addBarrierBlock {
    asyncBlock(id: 3)
}

operationQueue.addOperations([block4], waitUntilFinished: false)

operationQueue.addOperations([block5], waitUntilFinished: false)


func asyncBlock(id: Int) {
    print("#\(id) async block START" + " \(Date())")
    Thread.sleep(forTimeInterval: 2)
    print("#\(id) async block END" + " \(Date())")
}
