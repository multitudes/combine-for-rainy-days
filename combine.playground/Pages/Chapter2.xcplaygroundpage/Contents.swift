
// Chapter2


//: [Previous](@previous)
//: [Next](@next)


import Foundation
import Combine

//The assign method requires that the key path that we want to assign values to is a ReferenceWriteableKeyPath. This pretty much means that the key path must belong to a class.

// has to be a class
class User {
	var name: String = "me"
}

var user = User()

["laurent"].publisher.assign(to: \.name, on: user)

[1,2,3].publisher.sink(receiveCompletion: {completion in
	print("publisher complete \(completion)")
}, receiveValue: { value in
	print("publisher receive \(value)")
})

[1,2,3].publisher.sink(receiveValue: { value in
	print("publisher receive \(value)")
})



let myNotification = Notification.Name("com.laurent.customNotification")
//

var subscription: AnyCancellable?
// or
var cancellables = Set<AnyCancellable>()
func listenToNotifications() {
	subscription = NotificationCenter.default.publisher(for: myNotification) .sink(receiveValue: { notification in
		print("Received a notification! \(notification)")
	})
	NotificationCenter.default.post(Notification(name: myNotification))
}
//
listenToNotifications()
NotificationCenter.default.post(Notification(name: myNotification))
//
//

let myUrl = URL(string: "https://www.apple.com")!
let publisher = URLSession.shared.dataTaskPublisher(for: myUrl)
publisher.sink(receiveCompletion: { completion in
	switch completion {
		case .finished:
			print("finished succesfully")
		case .failure(let error):
			print(error)
	}
}, receiveValue: { value in
	print("received a value: \(value)")
})
