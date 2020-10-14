//: [Previous](@previous)

import UIKit
import Combine
import PlaygroundSupport
import SwiftUI

//: [Next](@next)

//PassthroughSubject
var cancellables = Set<AnyCancellable>()
let notificationSubject = PassthroughSubject<Notification, Never>()
let notificationName = UIResponder.keyboardWillShowNotification
let notificationCenter = NotificationCenter.default

notificationCenter.addObserver(forName: notificationName, object: nil,
															 queue: nil) { notification in
	notificationSubject.send(notification) }
notificationSubject
	.sink(receiveValue: { notification in
		print(notification)
	}).store(in: &cancellables)

notificationCenter.post(Notification(name: notificationName))


// ex CurrentValueSubject

class Fridge {
	var milkAmountChanged: ((Double) -> Void)?
	var milkInFridge = 2.0 {
		didSet {
			milkAmountChanged?(milkInFridge)
		}
	}
	let milkConsumedPerDay = 1.0

	func drink(amount: Double) {
		let milkNeeded = amount * milkConsumedPerDay
		milkInFridge -= milkNeeded
	}
}

let fridge = Fridge()
var fridgeMagnet = "The Fridge now has \(fridge.milkInFridge)"
fridge.milkAmountChanged = { newAmount in
	fridgeMagnet =	"The Fridge now has \(newAmount)"
}
fridge.drink(amount: 0.2)
print(fridgeMagnet)

// with combine
var subscription: AnyCancellable?

class FridgeCombine {
	var milkInFridge = CurrentValueSubject<Double,Never>(2.0)
	let milkConsumedPerDay = 1.0

	func drink(amount: Double) {
		let milkNeeded = amount * milkConsumedPerDay
		milkInFridge.value -= milkNeeded
	}
}

let fridge2 = FridgeCombine()
var fridgeMagnet2 = ""
fridge2.milkInFridge
	.sink(receiveValue: { newAmount in
		fridgeMagnet2 =	"The Fridge2 now has \(newAmount)"
	})

fridge2.drink(amount: 0.2)
print(fridgeMagnet2)

// @published
class FridgePublished {
	@Published var milkInFridge = 2.0
	let milkConsumedPerDay = 1.0

	func drink(amount: Double) {
		let milkNeeded = amount * milkConsumedPerDay
		milkInFridge -= milkNeeded
	}
}

let fridge3 = FridgePublished()
var fridgeMagnet3 = ""
fridge3.$milkInFridge
	.sink(receiveValue: { newAmount in
		fridgeMagnet3 =	"The Fridge3 now has \(newAmount) liter milk"
	})

fridge3.drink(amount: 0.2)
print(fridgeMagnet3)
//The Fridge3 now has 1.8 liter milk

class FridgeModel {
	@Published var milkInFridge : Double = 2.0
	let milkConsumedPerDay = 1.0
}

struct FridgeViewModel {
	var fridge : FridgeModel = FridgeModel()

	lazy var milkSubject: AnyPublisher<String?, Never> = {
		return fridge.$milkInFridge.map( {
			newAmount in
			return "The fridge has now \(newAmount) liter left"
		}).eraseToAnyPublisher()
	}()

	mutating func drink(milkNeeded: Double) {
		fridge.milkInFridge -= milkNeeded
	}
}

class FridgeView : UIViewController {
	var label = UILabel()
	var button = UIButton()
	var viewModel = FridgeViewModel()
	var cancellables = Set<AnyCancellable>()

	func setUpLabel (){
		viewModel.milkSubject
			.assign(to: \.text, on: label)
			.store(in: &cancellables)
	}
	@objc func drink() {
		viewModel.drink(milkNeeded: 0.2)
	}

	override func viewDidLoad() {
		setUpLabel()
	//	label.font = UIFont.preferredFont(forTextStyle: .title1)

		label.center = CGPoint(x: 50, y: 100 )
						label.sizeToFit()
						view.addSubview(label)
		button.setTitle("Drink", for: .normal)
		button.addTarget(self, action: #selector(drink), for: .touchUpInside)
		button.center = CGPoint(x: 50, y: 150 )
		button.sizeToFit()
		button.setTitleColor(.blue, for: .normal)
		view.addSubview(button)
	}
}
let master = FridgeView()
let nav = UINavigationController(rootViewController: master)


//struct ContentView: View {
//	var fridgeDoor = FridgeView(viewModel: FridgeViewModel(fridge: FridgeMVVM()))
//	//fridgeDoor.drink()
//	//fridgeDoor.setUpLabel()
//    var body: some View {
//			Text(fridgeDoor.label.text!)
//				.onAppear() {
//					fridgeDoor.drink()
//				}
//		}
//
//}
//
//// Make a UIHostingController
//let viewController = UIHostingController(rootView: ContentView())


// Assign it to the playground's liveView
PlaygroundPage.current.liveView = nav


PlaygroundPage.current.needsIndefiniteExecution = true
