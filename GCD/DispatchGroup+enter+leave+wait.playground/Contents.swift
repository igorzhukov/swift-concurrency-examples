import Foundation

let queue = DispatchQueue(label: "Name of dispatch queue", attributes: .concurrent)
let group = DispatchGroup()

group.enter()
queue.async {
    asyncBlock(id: 1)
    group.leave()
}

group.enter()
queue.async {
    asyncBlock(id: 2)
    group.leave()
}

queue.async {
    group.wait()
    asyncBlock(id: 3)
}

func asyncBlock(id: Int) {
    print("#\(id) async block START")
    Thread.sleep(forTimeInterval: 3)
    print("#\(id) async block END")
}
