//: [Previous](@previous)

import UIKit
import Foundation

/*:
 ## How to use improve Swift expressions [by Nathan Gitter](https://medium.com/@nathangitter/local-reasoning-in-swift-6782e459d)
 
 - Swift’s language features that can make your code easier to read.
 
 */

class MyButton: UIButton {
    
    var action: (() -> ())?
 
    required init() {
        super.init(frame: .zero)
         sharedInit()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func sharedInit() {
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
    @objc private func touchUpInside() {
        action?()
    }
    
}

 let button = MyButton()
button.action = {print("Button pressed")}
//: [Next](@next)
