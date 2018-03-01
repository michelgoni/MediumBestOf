//: [Previous](@previous)

import Foundation
import UIKit

/*:
 ## Handling empty optional strings in Swift [by Nathan Chan](https://medium.com/ios-os-x-development/handling-empty-optional-strings-in-swift-ba77ef627d74)
 
 - String? has two “invalid” values: nil and "". Neat way of handling it: returning a nil String in case we´re daling with a empty string
 
 */


extension Optional where Wrapped: Collection {
    var nilIfEmpty: Wrapped? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf.isEmpty ? nil : strongSelf
    }
}

let stringsArray = ["rain", "", nil, "water", nil, "tranquility"]
let arrayOfThings = [[123], nil, [], ["water"]]
print(stringsArray.flatMap { $0.nilIfEmpty })
print(arrayOfThings.flatMap{ $0.nilIfEmpty})

//: [Next](@next)
