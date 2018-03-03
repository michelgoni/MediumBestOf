//: [Previous](@previous)

import UIKit
import PlaygroundSupport

/*:
 ## How to display UI COmponents and animations in playground [by Charles Nysztor](https://cur.at/aVkR2ZL?m=email&sid=XcayBmE)
 
 - Want to display user interface components in a playground? Nice tutotial about using the live preview feature
 
 */

let view = UIView(frame: CGRect(x: 128, y: 128, width: 256, height: 256))
view.backgroundColor = .red
let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 512, height: 512))
containerView.backgroundColor = .white
PlaygroundPage.current.liveView = containerView
containerView.addSubview(view)

//MARK: - Animate
UIView.animate(withDuration: 3, animations: {
    view.alpha = 0
}) { _ in
    UIView.animate(withDuration: 3, animations: {
        view.alpha = 1
    })
}


//: [Next](@next)
