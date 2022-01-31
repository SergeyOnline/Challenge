//
//  NetworkService.swift
//  Challenge
//
//  Created by Сергей on 28.01.2022.
//

import Foundation

enum NetworkError: Error {
	case badURL
	case dataError
	case badStatusCode
	
	var localizedDescription: String {
		switch self {
		case .badURL:
			return "Bad URL address"
		case .dataError:
			return "Error loading data"
		case .badStatusCode:
			return "Invalid server response status code"
		}
	}

}

protocol NetworkServiceProtocol {
	func getTwits(completion: @escaping (Result<Twits?, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
	func getTwits(completion: @escaping (Result<Twits?, Error>) -> Void) {
		guard let url = URL(string: "https://\(Bundle.main.apiURL)") else {
			completion(.failure(NetworkError.badURL))
			return
		}
		
		let request = URLRequest(url: url)
		let session = URLSession.shared
		let task = session.dataTask(with: request) { data, response, error in
			if let error = error {
				completion(.failure(error))
			}
			if let response = response as? HTTPURLResponse {
				if response.statusCode != 200 {
					completion(.failure(NetworkError.badStatusCode))
				}
			}

			guard let data = data else {
				completion(.failure(NetworkError.dataError))
				return
			}

			do {
				let json = try JSONDecoder().decode(Twits.self, from: data)
				completion(.success(json))
			} catch {
				completion(.failure(error))
			}

		}
		task.resume()
	}
	
}
