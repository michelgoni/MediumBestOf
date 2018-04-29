//: [Previous](@previous)

import Foundation
import UIKit

/*:
 ## Generics [by Bob Lee](https://blog.bobthedeveloper.io/intro-to-generics-in-swift-with-bob-df58118a5001)
 
 - Generic code enables you to write flexible, reusable functions and types that can work with any type, subject to requirements that you define. You can write code that avoids duplication and expresses its intent in a clear, abstracted manner
 
 */

func printGenericElement<T>(value: [T]) {
    for element in value {
        print(element)
    }
}

struct Members<T> {
    
    var arrayOfMembers: [T] = []
    mutating func insertAGenericMember(member: T) {
        arrayOfMembers.append(member)
    }
}

var genericMembersOne = Members(arrayOfMembers: [1,90,87, "lio"])
genericMembersOne.insertAGenericMember(member: 12)
printGenericElement(value: genericMembersOne.arrayOfMembers)

/*:
 
 - How about using an extension on this generic struct
 
 */

/*:
 
 - Generic type constrains [by Swift by Sundell](https://www.swiftbysundell.com/posts/using-generic-type-constraints-in-swift-4)
 
 */

extension Array where Element: Numeric {
    func sum() -> Element {
        return reduce(0, +)
    }
}

extension Members {
    
    var firstElement: T? {
        
        switch arrayOfMembers.isEmpty {
        case true:
           return nil
        case false:
            return arrayOfMembers.first
        }
    }
}
genericMembersOne.firstElement

let arr: [Any] = [1,2,3,"String"]
protocol constrictor{ }
extension String: constrictor{ }
extension Int: constrictor{ }

 func firstIn<T>(_ array: [Any], ofType: T.Type) -> T? where T: constrictor {
    return return array.lazy.flatMap({ $0 as? T }).first
}
print(firstIn(arr, ofType: Int.self))

/*:
 
 - Generic protocols
 
 */

protocol FamilyProtocol {
    
    associatedtype familyType
    var familyMembers: [familyType] {get set}
}

struct FernandezFamily<T>: FamilyProtocol {
    
    var familyMembers: [T] = []
}

struct GonzalezFamily: FamilyProtocol {
    
   typealias familyType = String
    var familyMembers: [String]
}

let fernandez = FernandezFamily(familyMembers: ["Yo", "Luis", 90.9, 2])
let gonzalez = GonzalezFamily(familyMembers: ["Luis", "luisa"])

//: [Next](@next)
