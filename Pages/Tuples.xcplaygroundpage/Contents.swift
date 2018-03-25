//: [Previous](@previous)

import Foundation
import UIKit

/*:
 ## Using tuples as lightweight types in Swift [by Swift by Sundell](https://www.swiftbysundell.com/posts/using-tuples-as-lightweight-types-in-swift)
 
 -  Lightweight type definition for a tuple.
 
 */

class TextView: UIView {
    typealias Texts = (title: String, subtitle: String, description: String)
    var titleLabel : String!
    var subtitleLabel: String!
    var descriptionLabel: String!
    
    func render(_ texts: Texts) {
        titleLabel = texts.title
        subtitleLabel = texts.subtitle
        descriptionLabel = texts.description
    }
}

