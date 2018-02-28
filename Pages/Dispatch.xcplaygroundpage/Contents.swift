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


//: [Next](@next)
