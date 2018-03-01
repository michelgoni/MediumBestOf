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

/*:
 - Using OperationQueue based on this article by [Adam Sharp](https://robots.thoughtbot.com/a-simple-approach-to-thread-safe-networking-in-ios-apps?utm_campaign=iOS%2BDev%2BWeekly&utm_medium=email&utm_source=iOS%2BDev%2BWeekly%2BIssue%2B321) in order to perform two request in parallel.
 */
typealias tupleDataTask = (URLSessionDataTask, URLSessionDataTask)
typealias tupleUrlResult = (URLResult, URLResult) -> Void
typealias urlResult = (URLResult) -> Void
typealias getUrlResult = (firstRequest: URLResult?, secondRequest: URLResult?)

struct ChuckQuote: Codable {
    
    var value: String?
}

enum URLResult {
    case response(Data, URLResponse)
    case error(Error, Data?, URLResponse?)
}

extension URLSession {
    
    func getQuote(_ url: URL, completionHandler: @escaping urlResult) -> URLSessionDataTask {
        let task = dataTask(with: url) { data, response, error in
            switch (data, response, error) {
            case let (data, response, error?):
                completionHandler(.error(error, data, response))
            case let (data?, response?, nil):
                completionHandler(.response(data, response))
            default:
                preconditionFailure("missin´ data & response or at least some error")
            }
        }
        task.resume()
        return task
    }
    
    func get(_ firstRequest: URL, _ secondRequest: URL, completionHandler: @escaping tupleUrlResult) -> tupleDataTask {
        precondition(delegateQueue.maxConcurrentOperationCount == 1,
                     "More info about thie neat use of URLSession here: https://developer.apple.com/documentation/foundation/urlsession/1411597-init. BTW, maxConcurrentOperationCount should not be more than one")
        
        var results: getUrlResult = (nil, nil)
        
        func continuation() {
            guard case let (firstRequest?, secondRequest?) = results else { return }
            completionHandler(firstRequest, secondRequest)
        }
        
        let firstRequest = getQuote(firstRequest) { result in
            results.firstRequest = result
            continuation()
        }
        
        let secondRequest = getQuote(secondRequest) { result in
            results.secondRequest = result
            continuation()
        }
        
        return (firstRequest, secondRequest)
    }
}

extension URLResult {
    var string: String? {
        
        guard case let .response(data, _) = self, let decodedData = try? JSONDecoder().decode(ChuckQuote.self, from: data),  let string = decodedData.value else {return nil}
        
        return string
    }
}

let url = URL(string: "https://api.chucknorris.io/jokes/random")!

URLSession.shared.get(url, url) { firstQuote, secondQuote in
    
    
    guard case let (quote1?, quote2?) = (firstQuote.string, secondQuote.string)
        else { return }
    
    print(quote1, quote2, separator: "\n")
    
}


//: [Next](@next)
