import UIKit

let queue = DispatchQueue(label: "Name of dispatch queue", attributes: .concurrent)
let group = DispatchGroup()

queue.async {
    asyncBlock(id: 1)
}

queue.async {
    asyncBlock(id: 2)
}

queue.async(flags: .barrier) {
    asyncBlock(id: 3)
}

queue.async(flags: .barrier) {
    asyncBlock(id: 4)
}

func asyncBlock(id: Int) {
    print("#\(id) async block START")
    Thread.sleep(forTimeInterval: 3)
    print("#\(id) async block END")
}
