import UIKit
/*:
 ## Nice uses case for Autoclusoures

 - Using autoclosure in order to defer an execution
 
 
 */
func assert(_ expression: @autoclosure () -> Bool,
            _ message: @autoclosure () -> String) {
    
    // Inside assert we can refer to expression as a normal closure
    if !expression() {
        assertionFailure(message())
    }
}
func gimmeSomeBoolean() -> Bool {
    return false
}

assert(gimmeSomeBoolean(), "Seems something was wrong")
