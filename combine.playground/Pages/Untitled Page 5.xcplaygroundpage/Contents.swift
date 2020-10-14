//: [Previous](@previous)

import Foundation
import Combine

//: [Next](@next)


[1, 2, 3].publisher.print()
    .flatMap({ int in
                return Array(repeating: int, count: 2).publisher })
    .sink(receiveValue: {
        value in
        print("received value \(value)")
    })

[1, 2, 3].publisher.print()
    .flatMap(maxPublishers: .max(1),{ int in
                return Array(repeating: int, count: 2).publisher })
    .sink(receiveValue: {
        value in
        print("received value \(value)")
    })
