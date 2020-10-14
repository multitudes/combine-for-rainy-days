//: [Previous](@previous)

//: [Next](@next)

import Foundation
import Combine

[1,2,3].publisher
	.map({ int in
				return "it is sinking \(int)" })
	.sink(receiveValue: { str in
		print(str)

	})

["one", "2", "three", "4", "5"].publisher
	.compactMap({Int($0)})
	.sink { (int) in
		print(int)
	}

["one", "2", "three", "4", "5"].publisher
	.map({Int($0)})
	.sink { (int) in
		print(int)
	}

["one", "2", "three", "4", "5"].publisher
	.map({Int($0)})
	.replaceNil(with: 0)
	.sink { (int) in
		print(int)
	}


["one", "2", "three", "4", "5"].publisher
	.map({Int($0)})
	.replaceNil(with: 0)
	.compactMap {$0}
	.sink { (int) in
		print(int)
	}


// flatmap

let numberss = [1, 2, 3, 4]
let mapped = numberss.map { Array(repeating: $0, count: $0)}
//print(mapped)
//let flatMapped = numberss.flatMap { Array(repeating: $0, count: $0)}


let result = ["one", "2", "three", "4", "5"].compactMap({ Int($0) })
print(result) // [2, 4, 5]

["one", "2", "three", "4", "5"].publisher
	.compactMap({ Int($0) })
	.sink(receiveValue: { int in
					print(int) })

["one", "2", "three", "4", "5"].publisher
	.map({ Int($0) })
	.replaceNil(with: 0)
	.compactMap({Int($0)})
	.sink(receiveValue: { int in
					print(int) })

//let numbers = [1, 2, 3, 4]
//
//let mapped = numbers.map { Array(repeating: $0, count: $0) }
////[[1],[2,2],[3,3,3],[4,4,4,4]]
//let flatMapped = numbers.flatMap { Array(repeating: $0, count: $0) }
// //[1,2,2,3,3,3,4,4,4,4]


//var baseURL = URL(string: "https://www.donnywals.com")!
//["/", "/the-blog", "/speaking", "/newsletter"].publisher
//	.map({ path in
//				let url = baseURL.appendingPathComponent(path)
//				return URLSession.shared.dataTaskPublisher(for: url) })
//	.sink(receiveCompletion: { completion in
//		print("Completed with: \(completion)")
//	}, receiveValue: { result in
//		print(result)  })
//
//var cancellables = Set<AnyCancellable>()
//["/", "/the-blog", "/speaking", "/newsletter"].publisher
//	.setFailureType(to: URLError.self)
//	.flatMap({ path -> URLSession.DataTaskPublisher in
//		let url = baseURL.appendingPathComponent(path)
//		return URLSession.shared.dataTaskPublisher(for: url)
//	})
//	.sink(receiveCompletion: { completion in
//		print("Completed with .. : \(completion)")
//	}, receiveValue: { result in
//		print(result)
//	}).store(in: &cancellables)


[1, 2, 3].publisher
	.print()
	.flatMap(maxPublishers: .max(1), { int in
		return Array(repeating: int, count: 2).publisher
	})
	.sink(receiveValue: { value in
		print("got: \(value)")
	})

enum MyError: Error {
	case outOfBounds
}

[1, 2, 3].publisher.tryMap({ int -> Int in
						guard int < 3 else {
							throw MyError.outOfBounds
						}
						return int * 2
	}).sink(receiveCompletion: {completion in
	print(completion)
}, receiveValue: { value in
print(value)
})
