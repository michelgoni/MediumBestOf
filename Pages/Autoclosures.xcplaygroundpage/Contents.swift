import UIKit
/*:
 ## Nice uses case for Autoclosures [from Swift by Sundell](https://www.swiftbysundell.com/posts/using-autoclosure-when-designing-swift-apis?utm_campaign=This%2BWeek%2Bin%2BSwift&utm_medium=email&utm_source=This_Week_in_Swift_133)

 - Using autoclosure in order to defer an execution
 
 */
func assert(_ expression: @autoclosure () -> Bool, _ message: @autoclosure () -> String) {
    
    if !expression() {
        assertionFailure(message())
    }
}
func gimmeSomeBoolean() -> Bool {
    return true
}

assert(gimmeSomeBoolean(), "Seems something was wrong")

/*:
 - Avoid {} syntax
*/

func animate(_ animation: @autoclosure @escaping () -> Void, duration: TimeInterval = 0.25) {
    UIView.animate(withDuration: duration, animations: animation)
}
animate(UIView().frame.origin.y = 100)


/*:
 - Type inference using default values avoiding casting and ?? operator
 */

let dictionary : [String: Any?] = ["someValue" : nil ]

extension Dictionary where Value == Any? {
    
    func value<T>(forKey key: Key, defaultValue: @autoclosure () -> T) -> T {
        guard let value = self[key] as? T else {
            return defaultValue()
        }
        
        return value
    }
}

let value = dictionary.value(forKey: "someValue", defaultValue: 100)

//: [Next](@next)
