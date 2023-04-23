import UIKit
import Combine


// MARK: 1
/// What is the printed result of the following code?

//1/ 1, 2, 3, 4
//2/ 1, 2
//3/ 1, 2, 4, 3
//4/ 1,4, 2, 3
//5/ The code does not compile
 
/// 2/
print("=========================")
let queue = DispatchQueue (label: "queue")
queue.async {
    print("1")
    queue.async {
        print("2")
        queue.sync {
            print("3")
        }
        queue.async {
            print("4")
        }
    }
}



