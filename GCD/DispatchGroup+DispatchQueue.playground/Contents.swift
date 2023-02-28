import Foundation

let queue = DispatchQueue(label: "Name of dispatch queue", attributes: .concurrent)
let group = DispatchGroup()

queue.async(group: group) {
    asyncBlock(id: 1)
}

queue.async(group: group) {
    asyncBlock(id: 2)
}

group.notify(queue: queue) {
    asyncBlock(id: 3)
}

func asyncBlock(id: Int) {
    print("#\(id) async block START")
    Thread.sleep(forTimeInterval: 3)
    print("#\(id) async block END")
}
