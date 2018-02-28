//: [Previous](@previous)
import Foundation
import UIKit
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

loadfromJson: do {
    
    let decoder = JSONDecoder()
    guard let url = Bundle.main.url(forResource: "document", withExtension: "json") else { break loadfromJson}
    guard let contents = try? Data(contentsOf: url) else {break loadfromJson}
    guard let decoded = try? decoder.decode(Results.self, from: contents) else { break loadfromJson}
    var arrayTitle = [String]()
    
    for new in decoded.results {
       
        arrayTitle.append(new.title)
    }
    defer {
        reloadUI(arrayTitle)
    }
}

//: [Next](@next)
