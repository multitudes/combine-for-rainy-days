//: [Previous](@previous)

import Foundation
import Combine

//: [Next](@next)

enum MyError: Error { case outOfBounds }

[1, 2, 3].publisher
    .tryMap({ int in
        guard int < 3 else {
            print("error")
            throw MyError.outOfBounds
        }
        print("op")
        return int * 2
    })
    .sink(receiveCompletion: { completion in print(completion)
    }, receiveValue: { val in
        print(val)})
