# Some Combine for rainy days
Practicing some Combine and jotting down some notes!

### Introducing FRP

Combine is a Functional Reactive Programming framework 

Example of FRP 

```swift
[1,2,3].map{$0*2} 
```
A function that takes another function or closure as its parameter is called a higher-order function. A function that only operates on the arguments it receives is called a pure function.  
The reactive part of FRP means that we don’t operate on objects synchronously.   
Similar to how we can map over an array of known values, we can map over an array of unknown values. Consider a scenario where values or events are emitted over time. We can take each new value as it’s emitted, and we can transform it using a map until we have a result.  

We call these events a stream. Everything in FRP is considered a stream.  

#### RxSwift 
RxSwift is a framework that implements the cross-platform ReactiveX API


### 2
Combine’s fundamental building blocks are publishers, subscribers and operators.  
Publishers in Combine emit values and we call this a stream. Objects that receive these values are called subscribers. A subscriber, as the name suggests, subscribes to the output of a publisher. Combine provides us with two very convenient general-purpose subscribers out of the box. I will show them one by one, starting with the sink subscriber:
Sink!
```swift
[1,2,3].publisher.sink(receiveCompletion: {completion in
	print("publisher complete \(completion)")
}, receiveValue: { value in
	print("publisher receive \(value)")
})
```
sink comes with a special flavor for publishers that have Never as their Failure type. It allows us to omit the receiveCompletion closure: 
```swift
[1,2,3].publisher.sink(receiveValue: { value in
	print("publisher receive \(value)")
})
```
The second very convenient built-in subscriber is assign. The assign subscriber is also defined on Publisher and it allows us to directly assign publisher values to a property on an object.  
The assign method requires that the key path that we want to assign values to is a ReferenceWriteableKeyPath. This pretty much means that the key path must belong to a class. 
```swift
class User {
	var name: String = "me"
}
var user = User()

["laurent"].publisher.assign(to: \.name, on: user)
```
In Combine, a publisher that doesn’t have a subscriber will not emit any values!   

Both sink and assign create subscribers and return a very important object.  
This object is an `AnyCancellable` type.

holding on to the AnyCancellable outside of the function body. One way to do is by assigning the AnyCancellable to a property outside of the function scope: 
```swift
var subscription: AnyCancellable?
```

Or
```swift
var cancellables = Set<AnyCancellable>()  
```
Every AnyCancellable has a `store(in:)` method 
When a publisher completes and you have a subscription (AnyCancellable) for that publisher stored in a set or property, the AnyCancellable is not deallocated automatically. Typically, you don’t need to worry about this. The publisher and subscription will usually do enough cleanup to prevent any major memory leaks, and the objects that hold on to the AnyCancellable objects are typically not around for the entire lifetime of your application. Regardless, it’s good to be aware of this, 
Combine has many built-in publishers Each of these publishers takes a publisher as input and transforms its output so it can be used as an output for that specific publisher.A function like map that wraps a publisher into another publisher is called an operator 

When you call compactMap on a Collection in Swift it works a lot like a normal map, except all nil results are filtered. Let’s look at an example: In Swift:
```swift
let result = ["one", "2", "three", "4", "5"].compactMap({ Int($0) })
print(result) // [2, 4, 5]
```
in Combine 
```swift
["one", "2", "three", "4", "5"].publisher
.compactMap({ Int($0) })
.sink(receiveValue: { int in
print(int) })
```
If you want to convert nil values to a default value, you can use a regular map, and apply the replaceNil operator on the resulting publisher: 

```swift
["one", "2", "three", "4", "5"].publisher
.map({ Int($0) })
	.replaceNil(with: 0)
	.compactMap({Int($0)})
.sink(receiveValue: { int in
print(int) })
```
Flatmap:
```swift
let numbers = [1, 2, 3, 4]

let mapped = numbers.map { Array(repeating: $0, count: $0) }
//[[1],[2,2],[3,3,3],[4,4,4,4]]
let flatMapped = numbers.flatMap { Array(repeating: $0, count: $0) }
 //[1,2,2,3,3,3,4,4,4,4]
 ```
Using flatMap on an array is equivalent to using map and then calling joined() on the resulting collection.
Lets display the response !
```swift
var baseURL = URL(string: "https://www.donnywals.com")!
var cancellables = Set<AnyCancellable>()
["/", "/the-blog", "/speaking", "/newsletter"].publisher
	.setFailureType(to: URLError.self)
	.flatMap({ path -> URLSession.DataTaskPublisher in
		let url = baseURL.appendingPathComponent(path)
		return URLSession.shared.dataTaskPublisher(for: url)
	})
	.sink(receiveCompletion: { completion in
	print("Completed with .. : \(completion)")
}, receiveValue: { result in
	print(result)
}).store(in: &cancellables)
```
Using print to debug the upstream publisher Limiting the number of active publishers that are produced by flatMap
```swift
[1, 2, 3].publisher
	.print()
	.flatMap(maxPublishers: .max(1), { int in
		return Array(repeating: int, count: 2).publisher
	})
	.sink(receiveValue: { value in
		print("got: \(value)")
	})
```
throwing an error from an operator 
```swift
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
```

### 4 

### Updating the User Interface

SwiftUI is so tightly integrated with Combine that it can be really difficult to understand where Combine ends and SwiftUI begins.

