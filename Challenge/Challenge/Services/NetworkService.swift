//
//  NetworkService.swift
//  Challenge
//
//  Created by Сергей on 28.01.2022.
//

import UIKit

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
	func getImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void)
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
	
	func getImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {

		let request = URLRequest(url: url)
		let session = URLSession.shared
		let task = session.dataTask(with: request) { data, response, error in
			if error != nil {
				completion(nil)
			}

			if let response = response as? HTTPURLResponse {
				if response.statusCode != 200 {
					completion(nil)
				}
			}

			guard let data = data else {
				completion(nil)
				return
			}

			if let image = UIImage(data: data) {
				completion(image)
			} else {
				completion(nil)
			}
		}
		task.resume()
	}
	
}
