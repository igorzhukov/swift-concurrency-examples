import Foundation

let queue = DispatchQueue(label: "Name of dispatch queue", attributes: .concurrent)

let semaphore = DispatchSemaphore(value: 2)

queue.async {
    semaphore.wait()
    asyncBlock(id: 1)
    semaphore.signal()
}

queue.async {
    semaphore.wait()
    asyncBlock(id: 2)
    semaphore.signal()
}

queue.async {
    semaphore.wait()
    asyncBlock(id: 3)
    semaphore.signal()
}

queue.async {
    semaphore.wait()
    asyncBlock(id: 4)
    semaphore.signal()
}

queue.async {
    semaphore.wait()
    asyncBlock(id: 5)
    semaphore.signal()
}

func asyncBlock(id: Int) {
    print("#\(id) async block START" + " \(Date())")
    Thread.sleep(forTimeInterval: 2)
    print("#\(id) async block END" + " \(Date())")
}
