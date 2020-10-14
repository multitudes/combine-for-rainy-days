import UIKit
import Combine

// ex Functional Reactive Programming framework
[1,2,3].map { $0 * 2 }

let myUrl = URL(string: "https://www.donnywals.com")!
//func requestData(_ completion: @escaping (Result<Data, Error>) -> Void) {
//    URLSession.shared.dataTask(with: myUrl) { data, response, error in if let error = error {
//    completion(.failure(error))
//    return }
//
//     guard let data = data else {
//     preconditionFailure("If there is no error, data should be present...")
//
//    }
//    completion(.success(data)) }.resume()
//    }
//

//func requestData() -> AnyPublisher<Data, URLError> {
//URLSession.shared.dataTaskPublisher(for: myUrl) .map(\.data)
//.eraseToAnyPublisher()
//}
//print(requestData())
//let publisher = [1, 2, 3].publisher


//[1, 2, 3].publisher.sink(receiveCompletion: { completion in print("publisher completed: \(completion)")
//}, receiveValue: { value in
//  print("received a value: \(value)")
//})

//class User {
//    var email = "default"
//}
//var user = User()
//["test@email.com"].publisher.assign(to: \.email, on: user)
//print(user.email)
//
//
struct WeatherData: Codable {
	let name: String
	let cod: Int
}
// this will not work because http anyway!
let myURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Berlin&appid= 7d6ef6c6937943cd3a4d366a27dfc0cf")!
func requestData() -> AnyPublisher<Data, URLError>{
	URLSession.shared.dataTaskPublisher(for: myURL)
		.map(\.data)
		.eraseToAnyPublisher()
}

requestData()
	.decode(type: WeatherData.self, decoder: JSONDecoder())
	.map {$0.name }
	.sink (receiveCompletion: {_ in },
				 receiveValue: {print($0)})
