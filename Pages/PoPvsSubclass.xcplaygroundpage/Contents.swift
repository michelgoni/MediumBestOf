//: [Previous](@previous)

import Foundation
import UIKit

/*:
 ## Alway much better Protocol extension [by Yayoc(http://blog.yayoc.com/swift/2016/09/24/protocol-extensions-where-clause.html)
 
 -  Instead of using a class, start with a protocol.
 
 */

protocol Shareable {
    func share(url: String)
}

extension Shareable where Self: UIViewController {
    func share(url: String) {
        if let url = URL(string: url) {
            print(url)
        }
    }
}

class ViewController: UIViewController, Shareable {
    func shareButtonPressed() {
        let url = "http://yayoc.com"
        share(url: url)
        
    }
}

let myVC = ViewController()
myVC.shareButtonPressed()


//: [Next](@next)
