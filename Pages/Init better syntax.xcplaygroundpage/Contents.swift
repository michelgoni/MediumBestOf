//: [Previous](@previous)

import UIKit

/*:
 ## A A better syntax for configurable initializations (https://mackarous.com/dev/2019/1/23/a-better-syntax-for-configurable-initializations)
 
 -  Builder Pattern in Swift.
 
 */

protocol InitConfigurable {
    init()
}
extension InitConfigurable {
    init(configure: (Self) -> Void) {
        self.init()
        configure(self)
    }
}
extension NSObject: InitConfigurable { }

class SomeView: UIView {
    var something: Int = 0
}

let someView = SomeView {
    $0.something = 1
    $0.backgroundColor = .green
}
debugPrint(someView)


class SomeLabel: UILabel {
    var someLabel = "some label"
}

let someLabel = SomeLabel {
    $0.someLabel = "Changed some label"
    $0.numberOfLines = 1
}
debugPrint(someLabel.someLabel)

//: [Next](@next)
