//: [Previous](@previous)
import Foundation
import UIKit
import PlaygroundSupport
/*:
 ## GCD with steroids [from Swift by Sundell](https://www.swiftbysundell.com/posts/a-deep-dive-into-grand-central-dispatch-in-swift)
 
 - DispatchWorkItem: perform a request once the user hasn’t typed for 0.25 seconds
 
 */
class SearchViewController: UIViewController {
    
    private var pendingRequestWorkItem: DispatchWorkItem?
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        pendingRequestWorkItem?.cancel()
        
        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem {
            //self?.resultsLoader.loadResults(forQuery: searchText)
        }
        //execute task after 250 ms
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                      execute: requestWorkItem)
    }
}
/*:
 - Defer instead DispatchGroup: Perform a group of operations before moving on with some task
 
*/
struct Results: Decodable {
    
    var results: [News]
}

struct News: Decodable {
    
    var url: String
    var title: String
    var abstract: String
}

func reloadUI (_ titles: [String]) {
    
    for title in titles {
        print("reloading my UI with title: \(title)")
    }
}

var arrayTitle = [String]()
loadfromJson: do {
    
    defer {
        reloadUI(arrayTitle)
    }
    
    let decoder = JSONDecoder()
    guard let url = Bundle.main.url(forResource: "document", withExtension: "json") else { break loadfromJson}
    guard let contents = try? Data(contentsOf: url) else {break loadfromJson}
    guard let decoded = try? decoder.decode(Results.self, from: contents) else { break loadfromJson}
    
    
    for new in decoded.results {
       
        arrayTitle.append(new.title)
    }
}

/*:
 - Using a DispatchSemaphore based on this article by [Federico Zanetello](https://medium.com/swiftly-swift/a-quick-look-at-semaphores-6b7b85233ddb)
 
*/

let higherPriority = DispatchQueue.global(qos: .userInitiated)
let lowerPriority = DispatchQueue.global(qos: .utility)
let semaphore = DispatchSemaphore(value: 1)

func asyncPrint(queue: DispatchQueue, symbol: String) {

    queue.async {
        print("\(symbol) waiting to bring some titles from queue with\(queue.qos.qosClass) identifier")
        semaphore.wait()
        for title in arrayTitle {
            print(symbol,title)
        }
        print("\(symbol) checking out!")
        semaphore.signal() // releasing the resource
    }
}
PlaygroundPage.current.needsIndefiniteExecution = true
asyncPrint(queue: higherPriority, symbol: "🔴")
asyncPrint(queue: lowerPriority, symbol: "🔵")
//: [Next](@next)
