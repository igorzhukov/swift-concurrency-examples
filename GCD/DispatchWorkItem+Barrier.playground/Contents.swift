import Foundation

let queue = DispatchQueue(label: "Name of dispatch queue", attributes: .concurrent)

queue.async {
    asyncBlock(id: 1)
}

queue.async {
    asyncBlock(id: 2)
}

let dispatchWorkItem = DispatchWorkItem(qos: .default, flags: .barrier) {
    asyncBlock(id: 3)
}

let dispatchWorkItem2 = DispatchWorkItem(qos: .default, flags: .barrier) {
    asyncBlock(id: 4)
}

queue.async(execute: dispatchWorkItem)
queue.async(execute: dispatchWorkItem)

func asyncBlock(id: Int) {
    print("#\(id) async block START")
    Thread.sleep(forTimeInterval: 2)
    print("#\(id) async block END")
}
