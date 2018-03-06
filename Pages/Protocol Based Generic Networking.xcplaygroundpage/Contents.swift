//: [Previous](@previous)

import Foundation
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

/*:
 ## Protocol Based Generic Networking using JSONDecoder and Decodable [by James Rochabrun](https://medium.com/@jamesrochabrun/protocol-based-generic-networking-using-jsondecoder-and-decodable-in-swift-4-fc9e889e8081)
 
 - Using Codable and protocols in order to create a generic API.
 
 */

struct Results: Decodable {
    
    var results: [News]
}

struct News: Decodable {
    
    var url: String
    var title: String
    var abstract: String
    var byline: String
    var newId: Int
    var media: [Media]?
    
    enum CodingKeys: String, CodingKey {
        
        case media = "media"
        case newId = "asset_id"
        case url, title, abstract, byline
        
    }
    enum MyError: Error {
        case FoundNil(String)
    }
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decode(String.self, forKey: .url)
        title = try values.decode(String.self, forKey: .title)
        abstract = try values.decode(String.self, forKey: .abstract)
        byline = try values.decode(String.self, forKey: .byline)
        newId = try values.decode(Int.self, forKey: .newId)
        
        if let mediaUnwrapped = try? values.decodeIfPresent([Media].self, forKey: .media) {
            self.media = mediaUnwrapped
            
        }else{
            print("no media")
            media = nil
        }
    }
}

struct Media: Decodable {
    
    
    var mediametadata: [MediaMetadata]
    var copyright: String
    
    enum CodingKeys: String, CodingKey {
        
        case mediametadata = "media-metadata"
        case copyright = "copyright"
    }
    
}

struct MediaMetadata: Decodable  {
    var url: String
    var format: String
    
}

enum Result<T,U> where U: Error {
    
    case success(T)
    case failure(U)
}

protocol Endpoint {
    var base: String { get }
    var path: String { get }
}

extension Endpoint {
    var apiKey: String {
        return "api-key=32534511931e4dc1b5627b6918ca0d6b"
    }
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.query = apiKey
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}
enum NewsFeed {
    
    case mostShared, mostEmailed, mostViewed
}

extension NewsFeed: Endpoint {
    
    var base: String {
        return "https://api.nytimes.com"
    }
    
    var path: String {
        
        switch self {
        case .mostShared:
            return "/svc/mostpopular/v2/mostshared/all-sections/30.json"
        case .mostEmailed:
            return "svc/mostpopular/v2/mostemailed/all-sections/30.json"
        case .mostViewed:
            return "/svc/mostpopular/v2/mostviewed/all-sections/30.json"
        }
    }
}

enum ApiError: Error {
    
    case requestFailed
    case jsonParsingFailure
    case invalidData
    case responseUnsuccessful
    
    var localizedDescription: String {
        
        switch  self {
        case .requestFailed: return "Request failed"
        case .jsonParsingFailure: return "JSON Parsing failure"
        case .invalidData: return "Invalid data from server"
        case .responseUnsuccessful: return "Reponse was not what we expected uh?"
        }
    }
}

protocol ApiClient {
    var session: URLSession {get}
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, ApiError>) -> Void)
}

extension ApiClient {
    
    typealias JSONTaskCompletion = (Decodable?, ApiError?) -> Void
    
    func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletion) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        
                        
                        let genericModel = try JSONDecoder().decode(decodingType, from: data)
                        completion(genericModel, nil)
                    } catch {
                        print(error)
                        completion(nil, .jsonParsingFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, ApiError>) -> Void) {
        
        let task = decodingTask(with: request, decodingType: T.self) { (json , error) in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                if let value = decode(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
    
}

class NewsApiClient {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
}

extension NewsApiClient: ApiClient {
    
    func getFeed(from newsFeedType: NewsFeed, completion: @escaping (Result<Results?, ApiError>) -> Void) {
        
        let endpoint = newsFeedType
        let request = endpoint.request
        
        
        fetch(with: request, decode: { json -> Results? in
            guard let newsResult = json as? Results else { return  nil }
            
            return newsResult
        }, completion: completion)
        
    }
}

let client = NewsApiClient()
client.getFeed(from: .mostViewed) { result  in
    
    switch result {
    case .success(let newsFeedResult):
        print(newsFeedResult!)
        
    case .failure(let error):
        print(error)
        
        
    }
   
}


//: [Next](@next)
