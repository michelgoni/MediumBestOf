//: [Previous](@previous)

import Foundation

/*:
 ## How to use Dependy Injection using the Cake Pattern [by Peter-John Welcome](https://medium.com/swift-programming/dependency-injection-with-the-cake-pattern-3cf87f9e97af)
 
 - One should only inject via an interface (protocol), not concrete class.
 
 */

protocol NewsRepository {
    func fetchNews() -> [News]
}

struct News {
    
    var title: String
    var url: String
    var picture: String
}

struct NewsRepositoryImplementation: NewsRepository {
    
    func fetchNews() -> [News] {
        
        return [News(title: "First title", url: "Forst url", picture: "First picture"),
                News(title: "Second title", url: "Second url", picture: "Second picture")]
    }
}

protocol NewsRepositoryInjectable {
    
    var news: NewsRepository {get}
}
extension NewsRepositoryInjectable {
    
    var news: NewsRepository {
        return NewsRepositoryImplementation()
    }
}

struct NewViewModel:NewsRepositoryInjectable {
    
    init() {
        self.news.fetchNews().forEach {
            print("Title is \($0.title), the url should be \($0.url) and the picture is : \($0.picture)")
        }
    }
}
NewViewModel()


//: [Next](@next)
