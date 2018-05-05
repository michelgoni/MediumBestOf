//: [Previous](@previous)

import Foundation
import UIKit

/*:
 ## Alway much better Protocol extension [by Yayoc(http://blog.yayoc.com/swift/2016/09/24/protocol-extensions-where-clause.html)
 
 -  Instead of using a class, start with a protocol.
 
 */

protocol Shareable {
    func share(url: String)
    func showAlert(message: String)
}

extension Shareable where Self: UIViewController {
    func share(url: String) {
        if let url = URL(string: url) {
            print(url)
        }
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "error".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dialogconfirm", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

class ViewController: UIViewController, Shareable {
    func shareButtonPressed() {
        let url = "http://yayoc.com"
        share(url: url)
    }
    
    func showAlertFmMainVC(){
        showAlert(message: "This is a cutom mesage")
    }
}

let myVC = ViewController()
myVC.shareButtonPressed()
myVC.showAlertFmMainVC()


//: [Next](@next)
