//: [Previous](@previous)

import Foundation
import UIKit

/*:
 ## A Collection of Swift Design Patterns [by Oktawian Chojnacki](https://github.com/ochococo/Design-Patterns-In-Swift)
 
 -  Builder Pattern in Swift.
 
 */

class RestaurantBuilder {
    
    var latitude: Float?
    var longitude: Float?
    var name: String?
    
    typealias BuilderClosure = (RestaurantBuilder) -> ()
    
    init(builderClosure: BuilderClosure) {
        builderClosure(self)
    }
}
struct Restaurant: CustomStringConvertible {
    var latitude: Float
    var longitude: Float
    var name: String
    
    init?(builder: RestaurantBuilder) {
        if let latitude = builder.latitude, let longitude = builder.longitude, let name = builder.name {
            self.latitude = latitude
            self.longitude = longitude
            self.name = name
        }else{
            return nil
        }
    }
    
    var description: String {
        return "\(name) restataurant is located at \(latitude) latitude and \(longitude) longitude"
    }
}

let favouriteRestaurantBuilder = RestaurantBuilder { restaurant in
    restaurant.name = "Toto and peppino"
    restaurant.latitude = 78.909
    restaurant.longitude = 90.90
}


if let restaurant = Restaurant(builder: favouriteRestaurantBuilder) {
    print(restaurant.description)
}

//: [Next](@next)
