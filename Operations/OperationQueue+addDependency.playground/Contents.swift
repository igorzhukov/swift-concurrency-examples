import Foundation

let operationQueue = OperationQueue()
let block1 = BlockOperation {
    asyncBlock(id: 1)
}

let block2 = BlockOperation {
    asyncBlock(id: 2)
}

let block3 = BlockOperation {
    asyncBlock(id: 3)
}

block3.addDependency(block1)
block3.addDependency(block2)

let block4 = BlockOperation {
    asyncBlock(id: 4)
}

block4.addDependency(block3)

operationQueue.addOperations([block1, block2, block3, block4], waitUntilFinished: false)

func asyncBlock(id: Int) {
    print("#\(id) async block START" + " \(Date())")
    Thread.sleep(forTimeInterval: 2)
    print("#\(id) async block END" + " \(Date())")
}
