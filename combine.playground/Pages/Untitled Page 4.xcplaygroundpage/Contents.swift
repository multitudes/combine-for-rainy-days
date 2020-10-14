//: [Previous](@previous)

import Foundation
import Combine


//: [Next](@next)
let baseURL = URL(string: "https://www.donnywals.com")!
var cancellable = Set<AnyCancellable>()

["/", "/the-blog", "/speaking", "/newsletter"].publisher
    .setFailureType(to: URLError.self)
    .flatMap({path -> URLSession.DataTaskPublisher in
        let url = baseURL.appendingPathComponent(path)
        return URLSession.shared.dataTaskPublisher(for: url)
    })
    .sink(receiveCompletion: { completion in
        print("completion \(completion)")
    }, receiveValue: {result in
        print(result)
    }).store(in: &cancellable)
