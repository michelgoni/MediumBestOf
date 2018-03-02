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

let fernandez = FernandezFamily(familyMembers: ["Yo", "Luis", 90.9, 2])
fernandez.familyMembers

//: [Next](@next)
